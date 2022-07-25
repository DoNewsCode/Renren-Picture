//
//  DRMEVideoEditManager.m
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/8.
//

#import "DRMEVideoEditManager.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <pthread.h>

#import "DRMEAVSEExportCommand.h"
#import "DRMEAVSEVideoMixCommand.h"
#import "DRMEAVSEImageMixCommand.h"
#import "DRMEAVSEReplaceSoundCommand.h"
#import "DRMEAVSEGearboxCommand.h"
#import "DRMEAVSERangeCommand.h"
#import "DRMEAVSERotateCommand.h"
#import "DRMEAVSEDubbedCommand.h"
#import "DRMEAVSEExtractSoundCommand.h"


@interface DRMEVideoEditManager (){
    CADisplayLink *_progressLink;
}

@property (nonatomic , strong) DRMEAVSEComposition *cacheComposition;

@property (nonatomic , weak) DRMEAVSEExportCommand *exportCommand;

@property (nonatomic , strong) NSMutableArray <DRMEAVSEComposition *>*workSpace;

@property (nonatomic , strong) NSMutableArray <DRMEAVSEComposition *>*composeSpace;

@property (nonatomic , strong) NSMutableArray <NSString *>*tmpVideoSpace; //临时视频文件

@property (nonatomic , assign) NSInteger directCompostionIndex;

@property (nonatomic , copy) NSString *filePath;

@property (nonatomic , copy) NSString *tmpPath; //当前临时合成的文件位置

@property (nonatomic , copy) void (^editorComplete)(NSError *error);

@property (nonatomic , copy) void (^progress)(float progress);

@property (nonatomic , copy) NSString *presetName;

@property (nonatomic , assign) NSInteger composeCount; // 一共需要几次compose操作，用于记录进度

@property (nonatomic , assign ,getter=isSuspend) BOOL suspend; //线程 挂起

@property (nonatomic , assign ,getter=isCancel) BOOL cancel; //用户取消操作

@end

dispatch_queue_t _videoBoxContextQueue;
static void *videoBoxContextQueueKey = &videoBoxContextQueueKey;

dispatch_queue_t _videoBoxProcessQueue;
static void *videoBoxProcessQueueKey = &videoBoxProcessQueueKey;

NSString *_tmpDirectory;


void runSynchronouslyOnVideoBoxProcessingQueue(void (^block)(void))
{
    if (dispatch_get_specific(videoBoxProcessQueueKey)){
        block();
    }else{
        dispatch_sync(_videoBoxProcessQueue, block);
    }
}

void runAsynchronouslyOnVideoBoxProcessingQueue(void (^block)(void))
{
    
    if (dispatch_get_specific(videoBoxProcessQueueKey)){
        block();
    }else{
        dispatch_async(_videoBoxProcessQueue, block);
    }
}

void runSynchronouslyOnVideoBoxContextQueue(void (^block)(void))
{
    if (dispatch_get_specific(videoBoxContextQueueKey)){
        block();
    }else{
        dispatch_sync(_videoBoxContextQueue, block);
    }
}

void runAsynchronouslyOnVideoBoxContextQueue(void (^block)(void))
{
    if (dispatch_get_specific(videoBoxContextQueueKey)){
        block();
    }else{
        dispatch_async(_videoBoxContextQueue, block);
    }
}


@implementation DRMEVideoEditManager

+ (void)initialize{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tmpDirectory = [NSTemporaryDirectory() stringByAppendingPathComponent:@"DRMEVideoBoxTmp"];
      
        
        _videoBoxContextQueue = dispatch_queue_create("VideoBoxContextQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_queue_set_specific(_videoBoxContextQueue, videoBoxContextQueueKey, &videoBoxContextQueueKey, NULL);
        
        _videoBoxProcessQueue = dispatch_queue_create("VideoBoxProcessQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_queue_set_specific(_videoBoxProcessQueue, videoBoxProcessQueueKey, &videoBoxProcessQueueKey, NULL);
    
        if (![[NSFileManager defaultManager] fileExistsAtPath:_tmpDirectory]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_tmpDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    });
}

#pragma mark life cycle
- (instancetype)init
{
    self = [super init];
    
    self.videoQuality = 0;
    self.ratio = DRMEVideoExportRatio960x540; //默认960x540
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AVEditorNotification:) name:DRMEAVSEExportCommandCompletionNotification object:nil];
    
    return self;
}

- (void)dealloc{
    if (self.isSuspend) {
        dispatch_resume(_videoBoxContextQueue);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark pubilc method
#pragma mark 资源
- (BOOL)appendVideoByPath:(NSString *)videoPath{
    
    if (videoPath.length == 0 ) {
        return NO;
    }
    
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
    return [self appendVideoByAsset:asset];
    
}

- (BOOL)appendVideoByAsset:(AVAsset *)videoAsset{
    
    if (!videoAsset || !videoAsset.playable) {
        return NO;
    }
    
    runSynchronouslyOnVideoBoxProcessingQueue(^{ // 取消指令
        self.cancel = NO;
    });
    
    runAsynchronouslyOnVideoBoxContextQueue(^{
        // 清空工作区
        [self commitCompostionToComposespace];
        
        if (!self.cacheComposition) {
            self.cacheComposition = [DRMEAVSEComposition new];
            self.cacheComposition.presetName = self.presetName;
            self.cacheComposition.videoQuality = self.videoQuality;
            DRMEAVSECommand *command = [[DRMEAVSECommand alloc] initWithComposition:self.cacheComposition];
            [command performWithAsset:videoAsset];
        }else{
            DRMEAVSEVideoMixCommand *mixcommand = [[DRMEAVSEVideoMixCommand alloc] initWithComposition:self.cacheComposition];
            [mixcommand performWithAsset:self.cacheComposition.mutableComposition mixAsset:videoAsset];
        }
        
    });
    return YES;
}

- (void)commit{
    
    runAsynchronouslyOnVideoBoxContextQueue(^{
  
        [self.workSpace insertObjects:self.composeSpace atIndexes:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, self.composeSpace.count)]];
        
        [self.composeSpace removeAllObjects];
        
        [self commitCompostionToWorkspace];
        
    });
    
}

#pragma mark 裁剪

- (BOOL)rangeVideoByBeganPoint:(CGFloat)beganPoint endPoint:(CGFloat)endPoint{
    runAsynchronouslyOnVideoBoxContextQueue(^{
        
        [self commitCompostionToWorkspace];
        for (DRMEAVSEComposition *composition in self.workSpace) {
            double duration  = CMTimeGetSeconds(composition.duration);
            CMTime timeFrom = CMTimeMake(beganPoint / duration  * composition.duration.value, composition.duration.timescale);
            CMTime timeTo = CMTimeMake((endPoint  - beganPoint)/ duration * composition.duration.value, composition.duration.timescale);
            [self rangeVideoByTimeRange:CMTimeRangeMake(timeFrom, timeTo)];
        }
    });
    
    return YES;
}

- (BOOL)rangeVideoByTimeRange:(CMTimeRange)range{
    
    runAsynchronouslyOnVideoBoxContextQueue(^{

        [self commitCompostionToWorkspace];
        
        for (DRMEAVSEComposition *composition in self.workSpace) {
            DRMEAVSERangeCommand *rangeCommand = [[DRMEAVSERangeCommand alloc] initWithComposition:composition];
            [rangeCommand performWithAsset:composition.mutableComposition timeRange:range];
        }
    });
  
    return YES;
}

- (BOOL)rotateVideoByDegress:(NSInteger)degress{
    
    if (!degress % 360) {
        return NO;
    }
    
    runAsynchronouslyOnVideoBoxContextQueue(^{

        [self commitCompostionToWorkspace];
        
        for (DRMEAVSEComposition *composition in self.workSpace) {
            DRMEAVSERotateCommand *rotateCommand = [[DRMEAVSERotateCommand alloc] initWithComposition:composition];
            [rotateCommand performWithAsset:composition.mutableComposition degress:degress];
        }
 
    });
    
    return YES;
    
}

- (BOOL)appendWaterMark:(UIImage *)waterImg relativeRect:(CGRect)relativeRect{
    
    if (!waterImg) {
        return NO;
    }
    
    runAsynchronouslyOnVideoBoxContextQueue(^{
        
        [self commitCompostionToWorkspace];
        
        for (DRMEAVSEComposition *composition in self.workSpace) {
            DRMEAVSEImageMixCommand *command = [[DRMEAVSEImageMixCommand alloc] initWithComposition:composition];
            command.imageBg = NO;
            command.image = waterImg;
           
           
            [command imageLayerRectWithVideoSize:^CGRect(CGSize videoSize) {
                
                CGFloat height = 0;
                if (relativeRect.size.height) {
                    height = videoSize.height * relativeRect.size.height;
                }else{
                    height = videoSize.width * relativeRect.size.width * waterImg.size.height / waterImg.size.width;
                }
                return CGRectMake(videoSize.width * relativeRect.origin.x,videoSize.height * relativeRect.origin.y,videoSize.width * relativeRect.size.width, height);
            }];
            [command performWithAsset:composition.mutableComposition];
        }
 
    });
    
    return YES;
}

- (BOOL)appendImages:(NSURL *)imagesUrl relativeRect:(CGRect)relativeRect{
    
    if (!imagesUrl) {
        return NO;
    }
    
    runAsynchronouslyOnVideoBoxContextQueue(^{
        
        [self commitCompostionToWorkspace];
        
        CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)imagesUrl, NULL);
        CGFloat gifWidth;
        CGFloat gifHeight;
        
        NSDictionary *dict = (NSDictionary*)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(gifSource, 0, NULL));
        gifWidth = [[dict valueForKey:(NSString*)kCGImagePropertyPixelWidth] floatValue];
        gifHeight = [[dict valueForKey:(NSString*)kCGImagePropertyPixelHeight] floatValue];
        
        if (gifSource) {
            CFRelease(gifSource);
        }
        
        for (DRMEAVSEComposition *composition in self.workSpace) {
            DRMEAVSEImageMixCommand *command = [[DRMEAVSEImageMixCommand alloc] initWithComposition:composition];
            command.imageBg = NO;
            command.fileUrl = imagesUrl;
            
            
            [command imageLayerRectWithVideoSize:^CGRect(CGSize videoSize) {
                
                CGFloat height = 0;
                if (relativeRect.size.height) {
                    height = videoSize.height * relativeRect.size.height;
                }else{
                    height = videoSize.width * relativeRect.size.width * gifHeight / gifWidth;
                }
                return CGRectMake(videoSize.width * relativeRect.origin.x,videoSize.height * relativeRect.origin.y,videoSize.width * relativeRect.size.width, height);
            }];
            [command performWithAsset:composition.mutableComposition];
        }
        
    });
    
    return YES;
    
}

#pragma mark 变速
- (BOOL)gearBoxWithScale:(CGFloat)scale{
    
    runAsynchronouslyOnVideoBoxContextQueue(^{
        [self commitCompostionToWorkspace];
        
        for (DRMEAVSEComposition *composition in self.workSpace) {
            DRMEAVSEGearboxCommand *gearBox =  [[DRMEAVSEGearboxCommand alloc] initWithComposition:composition];
            [gearBox performWithAsset:composition.mutableComposition scale:scale];
        }
    });
    return YES;
}

- (BOOL)gearBoxTimeByScaleArray:(NSArray<DRMEAVSEGearboxCommandModel *> *)scaleArray{
    
    if (!scaleArray.count) {
        return NO;
    }
    

    runAsynchronouslyOnVideoBoxContextQueue(^{
       
        [self commitCompostionToWorkspace];
        
        
        for (DRMEAVSEComposition *composition in self.workSpace) {
           
            DRMEAVSEGearboxCommand *gearBox =  [[DRMEAVSEGearboxCommand alloc] initWithComposition:composition];
            [gearBox performWithAsset:composition.mutableComposition models:scaleArray];
        }
    });
    
    return YES;
}

#pragma mark 换音
- (BOOL)replaceSoundBySoundPath:(NSString *)soundPath{
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:soundPath]) {
        return NO;
    }
    
    AVAsset *soundAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:soundPath] options:nil];
    if (!soundAsset.playable) {
        return NO;
    }
    runAsynchronouslyOnVideoBoxContextQueue(^{
        [self commitCompostionToWorkspace];
        
        for (DRMEAVSEComposition *composition in self.workSpace) {
            DRMEAVSEReplaceSoundCommand *replaceCommand = [[DRMEAVSEReplaceSoundCommand alloc] initWithComposition:composition];
            [replaceCommand performWithAsset:composition.mutableComposition replaceAsset:soundAsset];
        }
    });
    
    
    return YES;
}

#pragma mark 混音
- (BOOL)dubbedSoundBySoundPath:(NSString *)soundPath{
    
    return [self dubbedSoundBySoundPath:soundPath volume:0.5 mixVolume:0.5 insertTime:0];
}

- (BOOL)dubbedSoundBySoundPath:(NSString *)soundPath volume:(CGFloat)volume mixVolume:(CGFloat)mixVolume insertTime:(CGFloat)insetDuration{
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:soundPath]) {
        return NO;
    }
    
    AVAsset *soundAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:soundPath] options:nil];
    if (!soundAsset.playable) {
        return NO;
    }
    
    runAsynchronouslyOnVideoBoxContextQueue(^{
        [self commitCompostionToWorkspace];
        for (DRMEAVSEComposition *composition in self.workSpace) {
            DRMEAVSEDubbedCommand *command = [[DRMEAVSEDubbedCommand alloc] initWithComposition:composition];
            command.insertTime = CMTimeMakeWithSeconds(insetDuration, composition.mutableComposition.duration.timescale);
            command.audioVolume = volume;
            command.mixVolume = mixVolume;
            [command performWithAsset:composition.mutableComposition mixAsset:soundAsset];
        }
    });
    
    return YES;
}

- (BOOL)extractVideoSound{
    
    runAsynchronouslyOnVideoBoxContextQueue(^{
        [self commitCompostionToWorkspace];
        for (DRMEAVSEComposition *composition in self.workSpace) {
            DRMEAVSEExtractSoundCommand *command = [[DRMEAVSEExtractSoundCommand alloc] initWithComposition:composition];
            [command performWithAsset:composition.mutableComposition];
        }
    });
    
    return YES;
}

#pragma mark video edit

- (void)syncFinishEditByFilePath:(NSString *)filePath complete:(void (^)(NSError *))complete{
    [self syncFinishEditByFilePath:filePath progress:nil complete:complete];
}

- (void)asyncFinishEditByFilePath:(NSString *)filePath complete:(void (^)(NSError *))complete{
    [self asyncFinishEditByFilePath:filePath progress:nil complete:complete];
}

- (void)syncFinishEditByFilePath:(NSString *)filePath progress:(void (^)(float))progress complete:(void (^)(NSError *))complete{
    
    if ([[NSThread currentThread] isMainThread]) {
        NSAssert(NO, @"You shouldn't make it in main thread!");
    }
    
    runSynchronouslyOnVideoBoxContextQueue(^{
        [self finishEditByFilePath:filePath progress:progress complete:complete];
    });
}

- (void)asyncFinishEditByFilePath:(NSString *)filePath progress:(void (^)(float))progress complete:(void (^)(NSError *))complete{
    runAsynchronouslyOnVideoBoxContextQueue(^{
        [self finishEditByFilePath:filePath progress:progress complete:complete];
    });
}

- (void)cancelEdit{
    runSynchronouslyOnVideoBoxProcessingQueue(^{
        self.cancel = YES;
        if (self.exportCommand.exportSession.status == AVAssetExportSessionStatusExporting) {
            [self.exportCommand.exportSession cancelExport];
            NSLog(@"%s",__func__);
        }
    });
}

- (void)clean{
    
    runAsynchronouslyOnVideoBoxContextQueue(^{
        [self __internalClean];
    });

}

- (void)__internalClean{
    
    for (NSString *tmpPath in self.tmpVideoSpace) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:tmpPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
        }
    }
    
    self.cacheComposition = nil;
    [self.tmpVideoSpace removeAllObjects];
    [self.workSpace removeAllObjects];
    [self.composeSpace removeAllObjects];
    self.composeCount = 0;
    self.progress = nil;
    self.editorComplete = nil;
    if (_progressLink) {
        [_progressLink invalidate];
         _progressLink = nil;
    }
    self.filePath = nil;
    self.tmpPath = nil;
    self.directCompostionIndex = 0;
}

#pragma mark private
- (void)commitCompostionToWorkspace{
    if (self.cacheComposition) {
        [self.workSpace addObject:self.cacheComposition];
        self.cacheComposition = nil;
    }
}

- (void)commitCompostionToComposespace{
    
    if (!self.workSpace.count) {
        return;
    }
    
    // workspace的最后一个compostion可寻求合并
    for (int i = 0; i < self.workSpace.count - 1; i++) {
        [self.composeSpace addObject:self.workSpace[i]];
    }
    
    DRMEAVSEComposition *currentComposition = [self.workSpace lastObject];
    
    [self.workSpace removeAllObjects];
    
    if (!currentComposition.mutableVideoComposition && !currentComposition.mutableAudioMix && self.composeSpace.count == self.directCompostionIndex) { // 可以直接合并
        if (self.composeSpace.count > 0) {
            DRMEAVSEComposition *compositon = [self.composeSpace lastObject];
            
            DRMEAVSEVideoMixCommand *mixCommand = [[DRMEAVSEVideoMixCommand alloc] initWithComposition:compositon];
            [mixCommand performWithAsset:compositon.mutableComposition mixAsset:(AVAsset *)currentComposition.mutableComposition];
        }else{
            self.directCompostionIndex = self.composeSpace.count;
            [self.composeSpace addObject:currentComposition];
        }
    }else{
         [self.composeSpace addObject:currentComposition];
    }

}

- (void)processVideoByComposition:(DRMEAVSEComposition *)composition{
    
    NSString *filePath = self.filePath;
    if(self.composeSpace.count != 1 || self.tmpVideoSpace.count){
        self.tmpPath = filePath = [self tmpVideoFilePath];
    }
    
    
    // 这里需要逐帧扫描
    if (self.videoQuality && self.composeCount == 1 && self.tmpVideoSpace.count == 0 && !composition.mutableVideoComposition) {
        DRMEAVSECommand *command = [[DRMEAVSECommand alloc] initWithComposition:composition];
        [command performWithAsset:composition.mutableComposition];
        [command performVideoCompopsition];
    }
    
    DRMEAVSEExportCommand *exportCommand = [[DRMEAVSEExportCommand alloc] initWithComposition:composition];
    exportCommand.videoQuality = self.videoQuality;
    self.exportCommand = exportCommand;
    [exportCommand performSaveByPath:filePath];

    if (self.progress && !_progressLink) {
        
        _progressLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCallback:)];
        if (@available(iOS 10.0, *)) {
            _progressLink.preferredFramesPerSecond = 10;
        }else{
            _progressLink.frameInterval = 6;
        }
        [_progressLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)successToProcessCurrentCompostion{
    
    [self.composeSpace removeObjectAtIndex:0];
    [self.tmpVideoSpace addObject:self.tmpPath];
    
    if (self.composeSpace.count > 0) {
        [self processVideoByComposition:self.composeSpace.firstObject];
    }else{
        self.tmpPath = nil;
        
        DRMEAVSEVideoMixCommand *mixComand = [DRMEAVSEVideoMixCommand new];
        
        NSMutableArray *assetAry = [NSMutableArray array];
        for (NSString *filePath in self.tmpVideoSpace) {
            [assetAry addObject:[AVAsset assetWithURL:[NSURL fileURLWithPath:filePath]]];
        }
        [mixComand performWithAssets:assetAry];
        if (self.videoQuality) { // 需要逐帧对画面处理
            [mixComand performVideoCompopsition];
        }
        
        mixComand.composition.presetName = self.presetName;
        mixComand.composition.videoQuality = self.videoQuality;
        
        DRMEAVSEExportCommand *exportCommand = [[DRMEAVSEExportCommand alloc] initWithComposition:mixComand.composition];
        exportCommand.videoQuality = self.videoQuality;
        self.exportCommand = exportCommand;
        [exportCommand performSaveByPath:self.filePath];
       
    }
}

- (void)failToProcessVideo:(NSError *)error{
   
    // 清理失败文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:self.filePath error:nil];
    }
    
    if (self.editorComplete) {
        self.editorComplete(error);
    }
    
    [self __internalClean];
    
    if (self.suspend) {
        self.suspend = NO;
        dispatch_resume(_videoBoxContextQueue);
    }
    
}

- (void)successToProcessVideo{
    
    if (self.editorComplete) {
        void (^editorComplete)(NSError *error) = self.editorComplete;
        dispatch_async(dispatch_get_main_queue(), ^{
            editorComplete(nil);
        });
    }
    [self __internalClean];
    
    if (self.suspend) {
        self.suspend = NO;
        dispatch_resume(_videoBoxContextQueue);
    }
   
}

- (void)finishEditByFilePath:(NSString *)filePath progress:(void (^)(float progress))progress complete:(void (^)(NSError *error))complete{
    
    [self commitCompostionToWorkspace];
    
    [self commitCompostionToComposespace];
    
    if (!self.composeSpace.count) {
        complete([NSError errorWithDomain:AVFoundationErrorDomain code:AVErrorNoDataCaptured userInfo:nil]);
        return;
    }
    
    self.filePath = filePath;
    self.editorComplete = complete;
    self.progress = progress;
    self.composeCount = self.composeSpace.count;
    
    if (self.composeCount != 1) { // 代表需要将compose里的视频生成后再合为一个
        self.composeCount ++;
    }
    
    runSynchronouslyOnVideoBoxProcessingQueue(^{
        
        self.suspend = YES;
        dispatch_suspend(_videoBoxContextQueue);
        
        if (self.cancel) {
            [self failToProcessVideo:[NSError errorWithDomain:AVFoundationErrorDomain code:-10000 userInfo:@{NSLocalizedFailureReasonErrorKey:@"User cancel process!"}]];
            return ;
        }else{
            [self processVideoByComposition:self.composeSpace.firstObject];
            return ;
        }
    });
    
}

- (NSString *)tmpVideoFilePath{
    return [_tmpDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.mp4",[NSDate timeIntervalSinceReferenceDate]]];
}

- (void)displayLinkCallback:(CADisplayLink *)link{
    if (self.progress && self.exportCommand) {
        if (self.composeCount == 1) {
            self.progress(1.0 / self.composeCount * (self.composeCount - self.composeSpace.count) + 1.0 / self.composeCount * self.exportCommand.exportSession.progress);
        }else{
            self.progress(1.0 / self.composeCount * (self.composeCount - self.composeSpace.count - 1) + 1.0 / self.composeCount * self.exportCommand.exportSession.progress);
        }
       
    }
}

#pragma mark notification
- (void)AVEditorNotification:(NSNotification *)notification{
    
    runAsynchronouslyOnVideoBoxProcessingQueue(^{
        if ([[notification name] isEqualToString:DRMEAVSEExportCommandCompletionNotification] && self.exportCommand == notification.object) {
            
            NSError *error = [notification.userInfo objectForKey:DRMEAVSEExportCommandError];
            
            if (self.cancel) {
                error = [NSError errorWithDomain:AVFoundationErrorDomain code:-10000 userInfo:@{NSLocalizedFailureReasonErrorKey:@"User cancel process!"}];
            }
            
            if (error) {
                [self failToProcessVideo:error];
            }else{
                if(!self.tmpPath){// 成功合成
                    [self successToProcessVideo];
                }else{
                    [self successToProcessCurrentCompostion];
                }
            }
            
        }
    });
    
}


#pragma mark getter and setter
- (void)setRatio:(DRMEVideoExportRatio)ratio{
    
    if (self.workSpace.count) {
        return;
    }
    
    _ratio = ratio;
    switch (self.ratio) {
        case DRMEVideoExportRatio640x480:
            self.presetName = AVAssetExportPreset640x480;
            break;
        case DRMEVideoExportRatio960x540:
            self.presetName = AVAssetExportPreset960x540;
            break;
        case DRMEVideoExportRatio1280x720:
            self.presetName = AVAssetExportPreset1280x720;
            break;
        case DRMEVideoExportRatioHighQuality:
            self.presetName = AVAssetExportPresetHighestQuality;
            break;
        case DRMEVideoExportRatioMediumQuality:
            self.presetName = AVAssetExportPresetMediumQuality;
            break;
        case DRMEVideoExportRatioLowQuality:
            self.presetName = AVAssetExportPresetLowQuality;
            break;
        default:
            break;
    }
}

#pragma mark getter
- (NSMutableArray *)composeSpace{
    if (!_composeSpace) {
        if (!_composeSpace) {
             _composeSpace = [NSMutableArray array];
        }
    }
    return _composeSpace;
}

- (NSMutableArray *)workSpace{
    if (!_workSpace) {
        if (!_workSpace) {
            _workSpace = [NSMutableArray array];
        }
    }
    return _workSpace;
}

- (NSMutableArray *)tmpVideoSpace{
    if (!_tmpVideoSpace) {
        if (!_tmpVideoSpace) {
            _tmpVideoSpace = [NSMutableArray array];
        }
    }
    return _tmpVideoSpace;
}



@end
