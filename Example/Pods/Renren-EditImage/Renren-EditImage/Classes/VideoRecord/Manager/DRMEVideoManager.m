//
//  DRMEVideoManager.m
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/8.
//  视频操作管理

#import "DRMEVideoManager.h"
#import "DRMEVideoEditManager.h"
#import "DRPPop.h"

@interface DRMEVideoManager ()

@property (nonatomic , strong) DRMEVideoEditManager *videoEditManager;

@end

static DRMEVideoManager *videoManager = NULL;

@implementation DRMEVideoManager

+ (DRMEVideoManager *)shareVideoManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        videoManager = [[DRMEVideoManager alloc] init];
    });
    return videoManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化视频编辑管理类
        [self configVideoEditManager];
    }
    return self;
}

- (void)configVideoEditManager
{
    self.videoEditManager = [DRMEVideoEditManager new];
    self.videoEditManager.ratio = DRMEVideoExportRatioHighQuality;
}

- (void)asyncOriginVideoPath:(NSString *)videoPath RangeVideosBystartTime:(CMTime)startTime endTime:(CMTime)endTime progress:(void (^)(float progress))progress complete:(void (^)(NSString *finishVideoPath))complete
{
    [self.videoEditManager clean];
    NSString *filePath = [self buildFilePath];
    
    
    [self.videoEditManager appendVideoByPath:videoPath];
    CMTime duration = CMTimeSubtract(endTime, startTime);
    CMTimeRange timeRange = CMTimeRangeMake(startTime, duration);
    [self.videoEditManager rangeVideoByTimeRange:timeRange];
    [self.videoEditManager asyncFinishEditByFilePath:filePath progress:progress complete:^(NSError * _Nonnull error) {
        if (!error) {
            complete(filePath);
        }else{
            ///提示出错
            [DRPPop showErrorHUDWithMessage:error.description completion:nil];
        }
    }];
}

- (void)asynchandleVideosWithVideoPathArr:(NSArray<NSString *> *)videoPathArray progress:(void (^)(float progress))progress complete:(void (^)(NSString *finishVideoPath))complete
{
    if (videoPathArray.count == 0 ||
        videoPathArray == nil) {
        NSLog(@"没有可处理的视频");
        return;
    }
    if (!self.videoEditManager) {
        [self configVideoEditManager];
    }
    [self.videoEditManager clean];
    NSString *filePath = [self buildFilePath];
    //遍历&拼接视频
    @weakify(self)
    [videoPathArray enumerateObjectsUsingBlock:^(NSString * _Nonnull pathStr, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        [self.videoEditManager appendVideoByPath:pathStr];
    }];
    
    [self.videoEditManager asyncFinishEditByFilePath:filePath progress:progress complete:^(NSError * _Nonnull error) {
        if (!error) {
            complete(filePath);
        }else{
            ///提示出错
            [DRPPop showErrorHUDWithMessage:error.description completion:nil];
        }
    }];
    
    
}

- (NSUInteger)getVideoDegress:(AVAssetTrack *)videoTrack{
    NSUInteger degress = 0;
    CGAffineTransform t = videoTrack.preferredTransform;
    if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
        // Portrait
        degress = 90;
    }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
        // PortraitUpsideDown
        degress = 270;
    }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
        // LandscapeRight
        degress = 0;
    }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
        // LandscapeLeft
        degress = 180;
    }
    return degress;
}

- (UIImage *)getImageViewWithView:(UIView *)view{
    UIGraphicsBeginImageContext(view.frame.size);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (NSString *)buildFilePath
{
    return [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"%f.mp4", [[NSDate date] timeIntervalSinceReferenceDate]]];
}

@end
