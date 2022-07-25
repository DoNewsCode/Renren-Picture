//
//  DRMEVideoCompression.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/1/2.
//

#import "DRMEVideoCompression.h"

@implementation DRMECompressionModel
@end

@interface DRMEVideoCompression ()

@property(nonatomic, strong) NSOperationQueue *compressionOperationQueue;

@property(nonatomic, strong) AVAssetReaderTrackOutput *audioOutput;

@property (nonatomic, strong) NSLock *lock;

@end

@implementation DRMEVideoCompression

static DRMEVideoCompression *_instance = nil;

// 单例
+ (instancetype)sharedVideoCompression
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        
    });
    return _instance;
}

- (NSOperationQueue *)compressionOperationQueue
{
    if (!_compressionOperationQueue) {
        _compressionOperationQueue = [[NSOperationQueue alloc] init];
        _compressionOperationQueue.name = @"VideoCompressionOperationQueue";
        _compressionOperationQueue.maxConcurrentOperationCount = 1; // 串行队列
    }
    return _compressionOperationQueue;
}

- (NSLock *)lock {
    if (!_lock) {
        _lock = [[NSLock alloc] init];
    }
    return _lock;
}

- (void)compressVideoWithOriginFilePath:(NSURL *)videoUrl
                              outputUrl:(NSString *)outputPath
                          completeBlock:(void(^)(DRMECompressionModel *model))completeBlock
{
    if (!videoUrl) {
        return;
    }
    
    if (!completeBlock) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf startCompressWithOriginFilePath:videoUrl outputUrl:outputPath completeBlock:^(DRMECompressionModel *model) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"yyyyyyyyyyyyyyy2 end");
                [strongSelf.lock unlock];
                completeBlock(model);
            }];
        }];
        
    }];
    [self.compressionOperationQueue addOperation:operation];
}

- (void)startCompressWithOriginFilePath:(NSURL *)videoUrl
                              outputUrl:(NSString *)outputPath
                          completeBlock:(void(^)(DRMECompressionModel *model))completeBlock
{
    // 因为这里是异步，所以需要加锁
    [self.lock lock];
    NSLog(@"yyyyyyyyyyyyyyy1 being\n url=%@ \n path=%@ \n______end", videoUrl, outputPath);
    
    // 单例中可能存在旧的音轨，先清空
    self.audioOutput = nil;
    
    DRMECompressionModel *model = [DRMECompressionModel new];
    model.outputPath = videoUrl.path;
    
    //取出原视频详细资料
    AVURLAsset *asset = [AVURLAsset assetWithURL:videoUrl];
    //视频时长 S
//    CMTime time = [asset duration];
//    NSInteger seconds = ceil(time.value/time.timescale);
//    if (seconds < 3) {
//        NSLog(@"视频不超过3秒，就不压缩了吧");
//        completeBlock(dic);
//        return;
//    }
    //压缩前原视频大小MB
    unsigned long long fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:videoUrl.path error:nil].fileSize;
    float fileSizeMB = fileSize / (1024.0 * 1024.0);
    //取出asset中的视频文件
    AVAssetTrack *videoTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    //压缩前原视频宽高
    NSInteger videoWidth = videoTrack.naturalSize.width;
    NSInteger videoHeight = videoTrack.naturalSize.height;
    //压缩前原视频比特率
    NSInteger kbps = videoTrack.estimatedDataRate / 1024;
    //压缩前原视频帧率
    NSInteger frameRate = [videoTrack nominalFrameRate];
    NSLog(@"原视频属性如下：\n fileSize = %.2f MB,\n videoWidth = %zd,\n videoHeight = %zd,\n video bitRate = %zd, \n video frameRate = %zd", fileSizeMB, videoWidth, videoHeight, kbps, frameRate);
    
    
    // 如果视频体积小于10M，不压缩
//    if (fileSizeMB < 10) {
//        completeBlock(dic);
//        return;
//    }
    
//    CGFloat originWidth = videoSize.width;
//    CGFloat originHeight = videoSize.height;

    CGFloat targetWidth = videoWidth;
    CGFloat targetHeight = videoHeight;
    CGFloat maxWH = 640;
    
    BOOL isCompress = NO;
    
//    视频压缩采用视频质量、帧、视频尺寸混合压缩的方式，
//    若视频尺寸未超出视频尺寸限定
//    视频时长：10min以内，超出时长限制传输；
//    压缩后帧：20帧；
//    视频像素窄边 > 640  宽高进行等比例缩放到 640。窄边<=640 不进行缩放处理。缩放后长边取4的整数倍值。
    
    if ((videoWidth > videoHeight) && (videoHeight > maxWH)) {
        // 按宽压缩
        // 等比设置高度
        targetWidth = maxWH;
        targetHeight = maxWH / videoWidth * videoHeight;
        
        isCompress = YES;
        
    } else if ((videoHeight > videoWidth) && (videoWidth > maxWH)){
        // 按高压缩
        // 等比设置宽度
        targetHeight = maxWH;
        targetWidth = maxWH / videoHeight * videoWidth;
        
        isCompress = YES;
    }
    
//    else {
//        completeBlock(dic);
//        return;
//    }
    
    // 默认使用 1500 计算码率
    NSInteger bit = 1500;
    
    // 原视频大于25M时，使用1000计算码率
    if (fileSizeMB > 25) {
        bit = 1000;
    }
    // 配合 比特率 *  1024  可调整码率
    NSInteger compressBiteRate = bit * 1024;
    // 帧率 高度无反应
    NSInteger compressFrameRate = 20;
    
    // 压缩宽度跟业务相关
    NSInteger compressWidth = targetWidth;
    NSInteger compressHeight = targetHeight;
    
    // 原视频比特率小于指定比特率 不压缩 返回原视频
    if (kbps <= (compressBiteRate / 1024) && !isCompress) {
        model.code = 0;
        model.message = @"不需要压缩";
        completeBlock(model);
        return;
    }
    
    NSLog(@"===压缩视频存放的指定路径%@===", outputPath);
    //如果指定路径下已存在其他文件 先移除指定文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputPath]) {
        BOOL removeSuccess =  [[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];
        if (removeSuccess) {
            NSLog(@"存在同名文件，删除成功");
        }
    }
    //创建视频文件读取者
    AVAssetReader *reader = [AVAssetReader assetReaderWithAsset:asset error:nil];
    //从指定文件读取视频
    AVAssetReaderTrackOutput *videoOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:videoTrack outputSettings:[self configVideoOutput]];
    //取出原视频中音频详细资料
    NSLog(@" ----- %@", [asset tracksWithMediaType:AVMediaTypeAudio]);
    AVAssetTrack *audioTrack = [asset tracksWithMediaType:AVMediaTypeAudio].firstObject;
    //从音频资料中读取音频
    if (audioTrack) {
        self.audioOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:audioTrack outputSettings:[self configAudioOutput]];
    }
    //将读取到的视频信息添加到读者队列中
    if ([reader canAddOutput:videoOutput]) {
        [reader addOutput:videoOutput];
    }
    //将读取到的音频信息添加到读者队列中
    if (self.audioOutput) {
        if ([reader canAddOutput:self.audioOutput]) {
            [reader addOutput:self.audioOutput];
        }
    }
    //视频文件写入者
    AVAssetWriter *writer = [AVAssetWriter assetWriterWithURL:[NSURL fileURLWithPath:outputPath] fileType:AVFileTypeMPEG4 error:nil];
    //根据指定配置创建写入的视频文件
    int degress = [self degressFromVideoFileWithAsset:asset];
    if (degress == 90 || degress == 270) {

//        NSInteger temp = compressHeight;
//        compressHeight = compressWidth;
//        compressWidth = temp;
        compressWidth = compressWidth*1.78;
        compressHeight = compressHeight*1.78;
    }
    AVAssetWriterInput *videoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:[self videoCompressSettingsWithBitRate:compressBiteRate withFrameRate:compressFrameRate withWidth:compressWidth WithHeight:compressHeight withOriginalWidth:videoWidth withOriginalHeight:videoHeight]];
    videoInput.transform = [self fixedCompositionWithAsset:asset];
    //根据指定配置创建写入的音频文件
    AVAssetWriterInput *audioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:[self audioCompressSettings]];
    if ([writer canAddInput:videoInput]) {
        [writer addInput:videoInput];
//        NSLog(@"videoInput==========videoInput");
    }
    if ([writer canAddInput:audioInput]) {
        [writer addInput:audioInput];
//        NSLog(@"audioInput==========audioInput");
    }
    NSLog(@"视频压缩开始！！！！！！");
    [reader startReading];
    [writer startWriting];
    [writer startSessionAtSourceTime:kCMTimeZero];
    //创建视频写入队列
    dispatch_queue_t videoQueue = dispatch_queue_create("Video Queue", DISPATCH_QUEUE_SERIAL);
    //创建音频写入队列
    dispatch_queue_t audioQueue = dispatch_queue_create("Audio Queue", DISPATCH_QUEUE_SERIAL);
    //创建一个线程组
    dispatch_group_t group = dispatch_group_create();
    //进入线程组
    dispatch_group_enter(group);
    //队列准备好后 usingBlock
    [videoInput requestMediaDataWhenReadyOnQueue:videoQueue usingBlock:^{
        BOOL completedOrFailed = NO;
        while ([videoInput isReadyForMoreMediaData] && !completedOrFailed) {
            CMSampleBufferRef sampleBuffer = [videoOutput copyNextSampleBuffer];
            if (sampleBuffer != NULL) {
                [videoInput appendSampleBuffer:sampleBuffer];
//                NSLog(@"===%@===", sampleBuffer);
                CFRelease(sampleBuffer);
            } else {
                completedOrFailed = YES;
                [videoInput markAsFinished];
                dispatch_group_leave(group);
            }
        }
    }];
    
    dispatch_group_enter(group);
    //队列准备好后 usingBlock
    [audioInput requestMediaDataWhenReadyOnQueue:audioQueue usingBlock:^{
        
        BOOL completedOrFailed = NO;
        if (self.audioOutput) {
            while ([audioInput isReadyForMoreMediaData] && !completedOrFailed) {
                CMSampleBufferRef sampleBuffer = [self.audioOutput copyNextSampleBuffer];
                if (sampleBuffer != NULL) {
                    BOOL success = [audioInput appendSampleBuffer:sampleBuffer];
                    //                NSLog(@"===%@===", sampleBuffer);
                    CFRelease(sampleBuffer);
                    completedOrFailed = !success;
                } else {
                    completedOrFailed = YES;
                }
            }
        } else {
            completedOrFailed = YES;
        }
        if (completedOrFailed) {
            [audioInput markAsFinished];
            dispatch_group_leave(group);
        }
    }];
    
    //完成压缩
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if ([reader status] == AVAssetReaderStatusReading) {
            [reader cancelReading];
        }
        switch (writer.status) {
            case AVAssetWriterStatusWriting:
            {
                NSLog(@"视频压缩完成");
                [writer finishWritingWithCompletionHandler:^{
                    model.code = 0;
                    model.outputPath = outputPath;
                    model.message = @"压缩完成";
                    completeBlock(model);
                }];
                break;
            }
            case AVAssetWriterStatusCancelled:
            {
                NSLog(@"取消压缩");
                model.code = 1;
                model.message = @"取消压缩";
                completeBlock(model);
                break;
            }
            case AVAssetWriterStatusFailed:
            {
                NSLog(@"压缩失败：%@", writer.error);
                model.code = 2;
                model.message = writer.error.description;
                completeBlock(model);
                break;
            }
            case AVAssetWriterStatusCompleted:
            {
                NSLog(@"视频压缩完成");
                [writer finishWritingWithCompletionHandler:^{
                    model.code = 0;
                    model.outputPath = outputPath;
                    model.message = @"压缩完成";
                    completeBlock(model);
                }];
                break;
            }
            default:
                break;
        }
    });
}

- (NSDictionary *)videoCompressSettingsWithBitRate:(NSInteger)biteRate
                                     withFrameRate:(NSInteger)frameRate
                                         withWidth:(NSInteger)width
                                        WithHeight:(NSInteger)height
                                 withOriginalWidth:(NSInteger)originalWidth
                                withOriginalHeight:(NSInteger)originalHeight
{
    /*
     * AVVideoAverageBitRateKey： 比特率（码率）每秒传输的文件大小 kbps
     * AVVideoExpectedSourceFrameRateKey：帧率 每秒播放的帧数
     * AVVideoProfileLevelKey：画质水平
     BP-Baseline Profile：基本画质。支持I/P 帧，只支持无交错（Progressive）和CAVLC；
     EP-Extended profile：进阶画质。支持I/P/B/SP/SI 帧，只支持无交错（Progressive）和CAVLC；
     MP-Main profile：主流画质。提供I/P/B 帧，支持无交错（Progressive）和交错（Interlaced），也支持CAVLC 和CABAC 的支持；
     HP-High profile：高级画质。在main Profile 的基础上增加了8×8内部预测、自定义量化、 无损视频编码和更多的YUV 格式；
     **/
//    NSInteger returnWidth = originalWidth > originalHeight ? width : height;
//    NSInteger returnHeight = originalWidth > originalHeight ? height : width;
    
    NSDictionary *compressProperties = @{
                                         AVVideoAverageBitRateKey : @(biteRate),
                                         AVVideoExpectedSourceFrameRateKey : @(frameRate),
                                         AVVideoProfileLevelKey : AVVideoProfileLevelH264HighAutoLevel
                                         };
    if (@available(iOS 11.0, *)) {
        NSDictionary *compressSetting = @{
                                          AVVideoCodecKey : AVVideoCodecTypeH264,
                                          AVVideoWidthKey : @(width),
                                          AVVideoHeightKey : @(height),
                                          AVVideoCompressionPropertiesKey : compressProperties,
                                          AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill
                                          };
        return compressSetting;
    }else {
        NSDictionary *compressSetting = @{
                                          AVVideoCodecKey : AVVideoCodecH264,
                                          AVVideoWidthKey : @(width),
                                          AVVideoHeightKey : @(height),
                                          AVVideoCompressionPropertiesKey : compressProperties,
                                          AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill
                                          };
        return compressSetting;
    }
}

/// 音频设置
- (NSDictionary *)audioCompressSettings{
    AudioChannelLayout stereoChannelLayout = {
        .mChannelLayoutTag = kAudioChannelLayoutTag_Stereo,
        .mChannelBitmap = kAudioChannelBit_Left,
        .mNumberChannelDescriptions = 0,
    };
    NSData *channelLayoutAsData = [NSData dataWithBytes:&stereoChannelLayout length:offsetof(AudioChannelLayout, mChannelDescriptions)];
    NSDictionary *audioCompressSettings = @{
                                            AVFormatIDKey : @(kAudioFormatMPEG4AAC),
                                            AVEncoderBitRateKey : @(128000),
                                            AVSampleRateKey : @(44100),
                                            AVNumberOfChannelsKey : @(2),
                                            AVChannelLayoutKey : channelLayoutAsData
                                            };
    return audioCompressSettings;
}

/// 音频解码
- (NSDictionary *)configAudioOutput
{
    NSDictionary *audioOutputSetting = @{
                                         AVFormatIDKey: @(kAudioFormatLinearPCM)
                                         };
    return audioOutputSetting;
}

/// 视频解码
- (NSDictionary *)configVideoOutput
{
    NSDictionary *videoOutputSetting = @{
                                         (__bridge NSString *)kCVPixelBufferPixelFormatTypeKey:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_422YpCbCr8],
                                         (__bridge NSString *)kCVPixelBufferIOSurfacePropertiesKey:[NSDictionary dictionary]
                                         };
    
    return videoOutputSetting;
}

/// 获取优化后的视频转向信息
- (CGAffineTransform)fixedCompositionWithAsset:(AVAsset *)videoAsset {
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    // 视频转向
    int degrees = [self degressFromVideoFileWithAsset:videoAsset];
    CGAffineTransform translateToCenter;
    CGAffineTransform mixedTransform = CGAffineTransformIdentity;
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    NSArray *tracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
    if (degrees != 0) {
        if (degrees == 90) {
            // 顺时针旋转90°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, 0.0);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2);
        } else if(degrees == 180){
            // 顺时针旋转180°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.width, videoTrack.naturalSize.height);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI);
        } else if(degrees == 270){
            // 顺时针旋转270°
            translateToCenter = CGAffineTransformMakeTranslation(0.0, videoTrack.naturalSize.width);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2*3.0);
        }
    }
    return mixedTransform;
}

/// 获取视频角度
- (int)degressFromVideoFileWithAsset:(AVAsset *)asset {
    int degress = 0;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        } else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        } else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        } else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    return degress;
}


/// 视频压缩
/// @param originData 视频源数据
/// @param outputPath 压缩后的视频路径
/// @param completeBlock  见 DRMECompressionModel
- (void)compressVideoWithData:(NSData *)originData
                    outputUrl:(NSString *)outputPath
                completeBlock:(void(^)(DRMECompressionModel *model))completeBlock
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss-SSS"];
    NSString * fileName = [formater stringFromDate:[NSDate date]];
    NSString *path = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"temp-video-%@.mp4", fileName]];
    NSURL *videoUrl = [NSURL fileURLWithPath:path];
    BOOL success = [originData writeToURL:videoUrl atomically:YES];
    if (success) {
        [self compressVideoWithOriginFilePath:videoUrl outputUrl:outputPath completeBlock:completeBlock];
    }
}

- (void)compressVideoWithOriginFilePath:(NSURL *)originFilePath
                          completeBlock:(void(^)(DRMECompressionModel *model))completeBlock {
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss-SSS"];
    NSString * fileName = [formater stringFromDate:[NSDate date]];
    NSString * outputPath = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"camera_temp_movie-%@.mp4", fileName]];
    [self compressVideoWithOriginFilePath:originFilePath outputUrl:outputPath completeBlock:completeBlock];
}

- (void)compressVideoWithData:(NSData *)originData
                completeBlock:(void(^)(DRMECompressionModel *model))completeBlock {
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss-SSS"];
    NSString * fileName = [formater stringFromDate:[NSDate date]];
    NSString * outputPath = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"camera_temp_movie-%@.mp4", fileName]];
    [self compressVideoWithData:originData outputUrl:outputPath completeBlock:completeBlock];
}

- (void)removeTask {
    NSLog(@"yyyyyyyyyyyyy removeTask");
    if ([self.lock tryLock]) {//当前没有加锁，但是现在尝试加锁成功
        [self.lock unlock];
        return;
    }
    // 当前有加锁，那么解锁
    [self.lock unlock];
}
 
@end
