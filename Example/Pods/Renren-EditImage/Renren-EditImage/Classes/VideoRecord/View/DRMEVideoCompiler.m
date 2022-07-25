//
//  DRMEVideoCompiler.m
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/13.
//

#import "DRMEVideoCompiler.h"
#import <UIKit/UIDevice.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <OpenGLES/EAGL.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface DRMEVideoCompiler ()

@property int recomposeFrameCount;
@property int lostFrameCount;
@property int fetchFrameCount;
@property CVPixelBufferRef tempPixelBuffer;

@end

@implementation DRMEVideoCompiler

- (void)dealloc{
    self.delegate = nil;
    self.imageGenerator = nil;
}

- (id)initWithAVAsset:(AVAsset*)videoAVAsset delegate:(id)delegate{
    if (self = [super init]) {
        self.imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:videoAVAsset];
        self.imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
        self.imageGenerator.appliesPreferredTrackTransform = YES;
        self.imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
        self.imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
        self.videoAsset = videoAVAsset;
        self.delegate = delegate;
        self.isRecomposing = NO;
    }
    return self;
}

- (UIImage *)getVideoPreviewImage:(AVAsset *)videoAsset imageSize:(CGSize)size{
    _imageGenerator.maximumSize = CGSizeMake(1080, 1080);
    unsigned int tryTimes = 0;
    UIImage *image = [self generateCGImages2:videoAsset frameSlot:3*24 frameRate:24];//获取第三秒的那一帧图片
    while (image == nil){
        tryTimes ++;
        image = [self generateCGImages2:videoAsset frameSlot:tryTimes frameRate:24];
        if (tryTimes > 20) {
            break;
        }
        usleep(300000);
    }
    NSLog(@"visionUtility try get previewImageTimes is %d",tryTimes);
    
    if (image) {
        CGSize newSize = CGSizeZero;
        CGSize imgSize = image.size;
        if ((imgSize.width / imgSize.height < 1.0) && (size.width / size.height > 1.0)) {
            newSize.width = imgSize.width;
            newSize.height = newSize.width * 9 / 16;
            
            CGFloat clipImageLeft = 0;
            CGFloat clipImageTop = (imgSize.height - newSize.height) * 0.5;
            
            CGImageRef newImageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(clipImageLeft, clipImageTop, newSize.width, newSize.height));
            UIImage *img = [UIImage imageWithCGImage:newImageRef];
            return img;
        }else{
            return image;
        }
    }
    return image;
}

- (UIImage *)getVideoCoverImage:(AVAsset *)videoAsset withTime:(CFTimeInterval)time{
    _imageGenerator.maximumSize = CGSizeMake(1080, 1080);
    unsigned int tryTimes = 0;
    UIImage *image = [self generateCGImages3:videoAsset frameSlot:time frameRate:24];
    while (image == nil){
        tryTimes ++;
        image = [self generateCGImages3:videoAsset frameSlot:tryTimes frameRate:24];
        if (tryTimes > 20) {
            break;
        }
        usleep(300000);
    }
    NSLog(@"visionUtility try get previewImageTimes is %d",tryTimes);
    
    return image;
}

- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey, nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, (size_t)size.width, (size_t)size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options, &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, (size_t)size.width, (size_t)size.height, 8, 4*(size_t)size.width, rgbColorSpace, (uint32_t)kCGImageAlphaPremultipliedFirst);
    NSParameterAssert(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

- (void)generateCGImages:(AVAsset*)videoAsset frameRate:(int)frameRate{
    AVAssetImageGenerator * mImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:videoAsset];
    mImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    mImageGenerator.appliesPreferredTrackTransform = YES;
    [mImageGenerator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:CMTimeMakeWithSeconds(1, NSEC_PER_SEC)]] completionHandler:
     ^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error)
     {
     NSLog(@"========111====actual got image at time:%f", CMTimeGetSeconds(actualTime));
     if (image)
         {
         [CATransaction begin];
         [CATransaction setDisableActions:YES];
         [CATransaction commit];
         }
     }];
}

- (void)extractAudioFile:(AVAsset*)mAsset handler:(void (^)(void))handler{
    AVAssetExportSession *exportSession=[AVAssetExportSession exportSessionWithAsset:mAsset presetName:AVAssetExportPresetAppleM4A];
    
    NSString *videoName = [NSString stringWithFormat:@"audio_temp.m4a"];
    NSString *outputPath = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), videoName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];
    }
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    [fileMgr removeItemAtPath:outputPath error:nil];
    NSURL *url = [NSURL fileURLWithPath:outputPath];
    
    exportSession.outputURL=url;
    exportSession.outputFileType=AVFileTypeAppleM4A;
    exportSession.timeRange=CMTimeRangeMake(kCMTimeZero, mAsset.duration);
    
    __weak typeof(self) weakSelf = self;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if (exportSession.status == AVAssetExportSessionStatusFailed) {
            if (handler) {
                handler();
            }
            NSLog(@"extract audio failed!");
        } else if(exportSession.status == AVAssetExportSessionStatusCompleted) {
            
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            
            NSString *videoTempName1 = [NSString stringWithFormat:@"audio_temp.wav"];
            NSString *outputTempPath1 = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), videoTempName1];
            if ([fileMgr fileExistsAtPath:outputTempPath1]) {
                [fileMgr removeItemAtPath:outputTempPath1 error:nil];
            }
            
            NSString *videoTempName2 = [NSString stringWithFormat:@"audio_temp_reverse.wav"];
            NSString *outputTempPath2 = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), videoTempName2];
            if ([fileMgr fileExistsAtPath:outputTempPath2]) {
                [fileMgr removeItemAtPath:outputTempPath2 error:nil];
            }
            NSString *videoTempName3 = [NSString stringWithFormat:@"audio_temp_reverse.aac"];
            NSString *outputTempPath3 = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), videoTempName3];
            if ([fileMgr fileExistsAtPath:outputTempPath3]) {
                [fileMgr removeItemAtPath:outputTempPath3 error:nil];
            }
            [weakSelf callFaadMain:outputPath outFile:outputTempPath1];
            if ([fileMgr fileExistsAtPath:outputTempPath1]) {
                [weakSelf callAudioReverse:outputTempPath1 outFile:outputTempPath2];
            } else {
            }
            if ([fileMgr fileExistsAtPath:outputTempPath2]) {
                [weakSelf callFaacMain:outputTempPath2 outFile:outputTempPath3];
            } else {
            }
            NSLog(@"extract audio successed!");
            if (handler) {
                handler();
            }
        }
    }];
}

- (void)stopRecomposeVideoFrames{
    self.isRecomposing = NO;
    [self.imageGenerator cancelAllCGImageGeneration];
    self.recomposeFrameCount = 0;
    self.lostFrameCount = 0;
}

- (void)recomposeVideoFrames:(NSArray*)timeSlotArray frameRate:(int)rate outPath:(NSString*)moviePath videoRect:(CGRect)rect onComplete:(void(^)(void))complete{
    BOOL needAudio = YES;
    self.recomposeFrameCount = 0;
    self.lostFrameCount = 0;
    CGSize size = CGSizeMake(480,480);//定义视频的大小
    NSError *error = nil;
    unlink([moviePath UTF8String]);
    _isRecomposing = YES;
    
    //—-initialize compression engine
    NSString *reverseTempName = nil;
    NSString *reverseTempPath = nil;
    
    needAudio = ([_videoAsset tracksWithMediaType:AVMediaTypeAudio].count > 0) ? YES : NO;
    if (needAudio) {
        reverseTempName = [NSString stringWithFormat:@"reverse_temp.mp4"];
        reverseTempPath = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), reverseTempName];
    } else {
        reverseTempPath = moviePath;
    }
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    [fileMgr removeItemAtPath:reverseTempPath error:nil];
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:reverseTempPath]
                                                           fileType:AVFileTypeQuickTimeMovie
                                                              error:&error];
    NSParameterAssert(videoWriter);
    if(error)
        NSLog(@"error = %@",[error localizedDescription]);
    
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264, AVVideoCodecKey,
                                   AVVideoScalingModeResizeAspectFill,AVVideoScalingModeKey,
                                   [NSNumber numberWithInt:(int)size.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:(int)size.height], AVVideoHeightKey, nil];
    
    AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    
    NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                     assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    
    if ([videoWriter canAddInput:writerInput])
        NSLog(@"");
    else
        NSLog(@"");
    
    [videoWriter addInput:writerInput];
    
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    
    _imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    _imageGenerator.appliesPreferredTrackTransform = YES;
    [_imageGenerator generateCGImagesAsynchronouslyForTimes:timeSlotArray completionHandler:
     ^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError* errorInfo)
     {
     NSLog(@"===============222=====actual got image at time:%f", CMTimeGetSeconds(actualTime));
     if (_isRecomposing == NO) {
         if ((writerInput.readyForMoreMediaData)) {
             [writerInput markAsFinished];
         }
         return;
     }
     
     if (image)
         {
         NSValue *time = [timeSlotArray lastObject];
         CMTime cmTime;
         [time getValue:&cmTime];
         
         if (self.recomposeFrameCount != timeSlotArray.count -1 - self.lostFrameCount &&
             CMTimeGetSeconds(actualTime) != 0.) {
             if(_isRecomposing == NO) {
                 return;
             }
             CVPixelBufferRef buffer = NULL;
             NSUInteger idx = (NSUInteger)self.recomposeFrameCount;
             buffer = (CVPixelBufferRef)[self pixelBufferFromCGImage:image size:size];
             if (buffer)
                 {
                 if (_tempPixelBuffer != nil) {
                     CFRelease(_tempPixelBuffer);
                     _tempPixelBuffer = nil;
                 }
                 _tempPixelBuffer = buffer;
                 CFRetain(_tempPixelBuffer);
                 self.recomposeFrameCount ++;
                 if (writerInput.readyForMoreMediaData) {
                     if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(idx, rate)]) {
                         NSLog(@"FAIL");
                         CFRelease(buffer);
                     }
                     else {
                         CFRelease(buffer);
                     }
                 } else {
                     CFRelease(buffer);
                 }
                 }
         } else {
             self.recomposeFrameCount = 0;
             self.lostFrameCount = 0;
             [writerInput markAsFinished];
             void (^finishWritingCompletionHandler)(void) = ^{
                 NSLog(@"Video reverse completed !!!!");
             };
             
#if (!defined(__IPHONE_6_0) || (__IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_6_0))
             [videoWriter finishWriting];
             NSLog(@"Video reverse completed !!!!");
#else
             if ([videoWriter respondsToSelector:@selector(finishWritingWithCompletionHandler:)]) {
                 [videoWriter finishWritingWithCompletionHandler:finishWritingCompletionHandler];
             } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                 [videoWriter finishWriting];
#pragma clang diagnostic pop
                 NSLog(@"Video reverse completed !!!!");
             }
#endif
             
             NSURL *videoPath = [NSURL fileURLWithPath:reverseTempPath];
             AVURLAsset * videoAsset = [[AVURLAsset alloc]initWithURL:videoPath options:nil];
             if (needAudio) {
                 NSString *audioName = [NSString stringWithFormat:@"audio_temp_reverse.aac"];
                 NSString *outputPath = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), audioName];
                 NSURL *audioURL = [NSURL fileURLWithPath:outputPath];
                 AVURLAsset * audioAsset = [[AVURLAsset alloc]initWithURL:audioURL options:nil];
                 sleep(1);
                 [self mergeAudioAndSaved:videoAsset audioAsset:audioAsset outPutPath:moviePath onComplete:^{
                     NSLog(@"Video reverse finished!!!!");
                     if (complete) {
                         complete();
                     }
                 }];
             } else {
                 sleep(1);
                 NSString *audioName = [NSString stringWithFormat:@"audio_temp_reverse.aac"];
                 NSString *outputPath = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), audioName];
                 if ([fileMgr fileExistsAtPath:outputPath]) {
                     [fileMgr removeItemAtPath:outputPath error:nil];
                 }
                 NSURL *audioURL = [NSURL fileURLWithPath:outputPath];
                 AVURLAsset * audioAsset = [[AVURLAsset alloc]initWithURL:audioURL options:nil];
                 sleep(1);
                 [self mergeAudioAndSaved:videoAsset audioAsset:audioAsset outPutPath:moviePath onComplete:^{
                     NSLog(@"Video reverse finished!!!!");
                     if (complete) {
                         complete();
                     }
                 }];
             }
             _isRecomposing = NO;
         }
         } else {
             NSLog(@"one image capture failed!!!");
             if (self.recomposeFrameCount != timeSlotArray.count -1 - self.lostFrameCount &&
                 CMTimeGetSeconds(actualTime) != 0.) {
                 if(_isRecomposing == NO) {
                     return;
                 }
                 NSLog(@"insert last image here!!!");
                 if (_tempPixelBuffer != nil) {
                     NSUInteger idx = (NSUInteger)self.recomposeFrameCount;
                     self.recomposeFrameCount ++;
                     if(![adaptor appendPixelBuffer:_tempPixelBuffer withPresentationTime:CMTimeMake(idx, rate)]) {
                         NSLog(@"FAIL");
                     } else {
                         CFRelease(_tempPixelBuffer);
                         _tempPixelBuffer = nil;
                     }
                 } else {
                     self.lostFrameCount += 1;
                 }
             } else {
                 self.recomposeFrameCount = 0;
                 self.lostFrameCount = 0;
                 [writerInput markAsFinished];
                 void (^finishWritingCompletionHandler)(void) = ^{
                     NSLog(@"Video reverse completed !!!!");
                 };
#if (!defined(__IPHONE_6_0) || (__IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_6_0))
                 [videoWriter finishWriting];
                 NSLog(@"Video reverse completed !!!!");
#else
                 if ([videoWriter respondsToSelector:@selector(finishWritingWithCompletionHandler:)]) {
                     [videoWriter finishWritingWithCompletionHandler:finishWritingCompletionHandler];
                 } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                     [videoWriter finishWriting];
#pragma clang diagnostic pop
                     NSLog(@"Video reverse completed !!!!");
                 }
#endif
                 NSURL *videoPath = [NSURL fileURLWithPath:reverseTempPath];
                 AVURLAsset * videoAsset = [[AVURLAsset alloc]initWithURL:videoPath options:nil];
                 if (needAudio) {
                     NSString *audioName = [NSString stringWithFormat:@"audio_temp_reverse.aac"];
                     NSString *outputPath = [NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), audioName];
                     NSURL *audioURL = [NSURL fileURLWithPath:outputPath];
                     AVURLAsset * audioAsset = [[AVURLAsset alloc]initWithURL:audioURL options:nil];
                     sleep(1);
                     [self mergeAudioAndSaved:videoAsset audioAsset:audioAsset outPutPath:moviePath onComplete:^{
                         NSLog(@"Video reverse finished!!!!");
                         if (complete) {
                             complete();
                         }
                     }];
                 } else {
                     sleep(1);
                 }
                 _isRecomposing = NO;
                 
             }
         }
     }];
}

- (void)composeVideoMusic:(AVAsset *)videoAsset audioAsset:(AVAsset *)audioAsset outPutPath:(NSString*)outPutPath onComplete:(void (^)(NSString *videoPath))complete{
    if (!videoAsset || !audioAsset) return;
    
    AVMutableComposition *mutableComposition = [[AVMutableComposition alloc] init];
    AVAssetTrack *assetVideoTrack = nil;
    AVAssetTrack *assetAudioTrack = nil;
    AVAssetTrack *newAudioTrack = [audioAsset tracksWithMediaType:AVMediaTypeAudio][0];
    NSError *error = nil;
    
    if ([[videoAsset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        assetVideoTrack = [videoAsset tracksWithMediaType:AVMediaTypeVideo][0];
    }
    if ([[videoAsset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
        assetAudioTrack = [videoAsset tracksWithMediaType:AVMediaTypeAudio][0];
    }
    
    if (assetVideoTrack) {
        AVMutableCompositionTrack *compositionVideoTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [videoAsset duration]) ofTrack:assetVideoTrack atTime:kCMTimeZero error:&error];
    }
    if (assetAudioTrack) {
        AVMutableCompositionTrack *compositionAudioTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [videoAsset duration]) ofTrack:assetAudioTrack atTime:kCMTimeZero error:&error];
    }
    if (!newAudioTrack) {
        if (complete) {
            complete(nil);
        }
        return;
    }
    AVMutableCompositionTrack *customAudioTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [customAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [mutableComposition duration]) ofTrack:newAudioTrack atTime:kCMTimeZero error:&error];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:mutableComposition presetName:AVAssetExportPresetHighestQuality];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPutPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:outPutPath error:nil];
    }
    exportSession.outputURL = [NSURL fileURLWithPath:outPutPath];
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if (exportSession.status == AVAssetExportSessionStatusFailed) {
            NSLog(@"mergeAudioAndSaved failed!");
            if (complete) {
                complete(nil);
            }
        } else if(exportSession.status == AVAssetExportSessionStatusCompleted) {
            NSLog(@"mergeAudioAndSaved successed!");
            if (complete) {
                complete(outPutPath);
            }
        }
    }];
}

- (void)mergeAudioAndSaved:(AVAsset *)videoAsset audioAsset:(AVAsset *)audioAsset outPutPath:(NSString*)outPutPath onComplete:(void (^)())complete{
    if (videoAsset !=nil && audioAsset!=nil) {
        
        AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
        
        AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                       preferredTrackID:kCMPersistentTrackID_Invalid];
        NSArray *videoTrackArray = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                       ofTrack:(videoTrackArray.count > 0)? [videoTrackArray objectAtIndex:0] : nil
                                        atTime:kCMTimeZero error:nil];
        
        AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
        
        NSArray *audioTrackArray = [audioAsset tracksWithMediaType:AVMediaTypeAudio];
        [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)
                                            ofTrack:(audioTrackArray.count > 0)? [audioTrackArray objectAtIndex:0] : nil
                                             atTime:kCMTimeZero error:nil];
        
        AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                              presetName:AVAssetExportPresetPassthrough];
        
        NSString *exportPath = outPutPath;
        NSURL *exportUrl = [NSURL fileURLWithPath:exportPath];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath])
            {
            [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
            }
        
        _assetExport.outputFileType = AVFileTypeQuickTimeMovie;
        _assetExport.outputURL = exportUrl;
        _assetExport.shouldOptimizeForNetworkUse = YES;
        _assetExport.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
        
        //下面是按照上面的要求合成视频的过程。
        [_assetExport exportAsynchronouslyWithCompletionHandler:
         ^(void ) {
             if (_assetExport.status == AVAssetExportSessionStatusFailed) {
                 NSLog(@"mergeAudioAndSaved failed!");
                 if (complete) {
                     complete();
                 }
             } else if(_assetExport.status == AVAssetExportSessionStatusCompleted) {
                 NSLog(@"mergeAudioAndSaved successed!");
                 if (complete) {
                     complete();
                 }
             }
         }
         ];
    }
}

- (void)removeTempleVideoFile:(NSString*)path{
    NSError *error = nil;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    [fileMgr removeItemAtPath:path error:&error];
}

- (BOOL)composeMuteVideo:(AVAsset*) sourceVideoAsset
         outputVideoName:(NSString*) outputVideoName
              onComplete:(VisionComposeCompleted)onComplete{
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, sourceVideoAsset.duration)
                                   ofTrack:[[sourceVideoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                    atTime:kCMTimeZero error:nil];
    
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                          presetName:AVAssetExportPresetPassthrough];
    
    NSString *exportPath = [NSTemporaryDirectory() stringByAppendingPathComponent:outputVideoName];
    NSURL    *exportUrl = [NSURL fileURLWithPath:exportPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath])
        {
        [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
        }
    
    _assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    NSLog(@"file type %@", _assetExport.outputFileType);
    _assetExport.outputURL = exportUrl;
    _assetExport.shouldOptimizeForNetworkUse = YES;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         // your completion code here
         dispatch_async(dispatch_get_main_queue(), ^{
             [self exportDidFinish:_assetExport
                         outputUrl:exportPath
                        onComplete:onComplete];
         });
     }
     ];
    return YES;
}

- (BOOL)composeCutVideo:(AVAsset*)sourceVideoAsset
        outputVideoName:(NSString*)outputVideoName
              startTime:(CGFloat)startTime
                endTime:(CGFloat)endTime
             finalFrame:(CGRect)finalFrame
             onComplete:(VisionComposeCompleted)onComplete{
    if (endTime <= startTime) {
        return NO;
    }
    
    if ([sourceVideoAsset tracksWithMediaType:AVMediaTypeVideo].count <= 0) {
        NSLog(@"video medio not exist!!!!");
    }
    
    CMTime segStartTime = kCMTimeZero;
    AVAsset * segVideoAsset = sourceVideoAsset;
    AVAssetTrack *segAssetTrack = [[segVideoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *segVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    CMTimeRange insertTimeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(startTime, segVideoAsset.duration.timescale), CMTimeMakeWithSeconds(endTime-startTime, segVideoAsset.duration.timescale));
    
    [segVideoTrack insertTimeRange:insertTimeRange ofTrack:segAssetTrack atTime:segStartTime error:nil];
    if ([segVideoAsset tracksWithMediaType:AVMediaTypeAudio].count > 0) {
        [audioTrack insertTimeRange:insertTimeRange
                            ofTrack:[[segVideoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:segStartTime error:nil];
    }
    
    //FIXING ORIENTATION//
    CGFloat rotateDegree = 0;
    CGSize targetSize = CGSizeZero;
    UIImageOrientation FirstAssetOrientation_  = UIImageOrientationUp;
    CGAffineTransform firstTransform = segAssetTrack.preferredTransform;
    if(firstTransform.a == 0 && firstTransform.b == 1.0 && firstTransform.c == -1.0 && firstTransform.d == 0){
        rotateDegree = 90;
        FirstAssetOrientation_= UIImageOrientationRight;
        targetSize = CGSizeMake(segAssetTrack.naturalSize.height, segAssetTrack.naturalSize.width);
    }
    if(firstTransform.a == 0 && firstTransform.b == -1.0 && firstTransform.c == 1.0 && firstTransform.d == 0){
        rotateDegree = 270;
        FirstAssetOrientation_ =  UIImageOrientationLeft;
        targetSize = CGSizeMake(segAssetTrack.naturalSize.height, segAssetTrack.naturalSize.width);
    }
    if(firstTransform.a == 1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == 1.0)   {
        FirstAssetOrientation_ =  UIImageOrientationUp;
        targetSize = CGSizeMake(segAssetTrack.naturalSize.width, segAssetTrack.naturalSize.height);
    }
    if(firstTransform.a == -1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == -1.0) {
        rotateDegree = 180;
        FirstAssetOrientation_ = UIImageOrientationDown;
        targetSize = CGSizeMake(segAssetTrack.naturalSize.width, segAssetTrack.naturalSize.height);
    }
    NSLog(@"segAssetTrack.naturalSize.width is %f",segAssetTrack.naturalSize.width);
    NSLog(@"segAssetTrack.naturalSize.heigth is %f",segAssetTrack.naturalSize.height);
    
    CGFloat assetScaleToFitRatio= 1.0;
    CGFloat rotateAngle = rotateDegree * M_PI / 180;
    CGPoint originalCenter = CGPointMake(segAssetTrack.naturalSize.width / 2, segAssetTrack.naturalSize.height / 2);
    CGPoint rotatedCenter = CGPointMake(originalCenter.x * cos(rotateAngle) - originalCenter.y * sin(rotateAngle),
                                        originalCenter.x * sin(rotateAngle) + originalCenter.y * cos(rotateAngle));
    CGPoint targetCenter = CGPointMake(targetSize.width / 2, targetSize.height / 2);
    CGAffineTransform shiftTransform = CGAffineTransformMakeTranslation((targetCenter.x - rotatedCenter.x) * assetScaleToFitRatio,
                                                                        (targetCenter.y - rotatedCenter.y) * assetScaleToFitRatio);
    CGAffineTransform rotationScaleTransform = CGAffineTransformScale(CGAffineTransformMakeRotation(rotateAngle), assetScaleToFitRatio, assetScaleToFitRatio);
    CGAffineTransform assetRotationTransform = CGAffineTransformConcat(rotationScaleTransform, shiftTransform);
    
    
    
    
    
    
    AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:segVideoTrack];
    [layerInstruction setTransform:assetRotationTransform atTime:kCMTimeZero];
    
    NSMutableArray* layerInstructionsArray = [[NSMutableArray alloc] init];
    [layerInstructionsArray addObject:layerInstruction];
    
    segStartTime = CMTimeAdd(segStartTime, CMTimeMakeWithSeconds(endTime-startTime, segVideoAsset.duration.timescale));
    AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, segStartTime);
    MainInstruction.layerInstructions = layerInstructionsArray;
    
    AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
    MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
    MainCompositionInst.frameDuration = CMTimeMake(1, 24);
    MainCompositionInst.renderSize = targetSize;
    
    NSString *pathToMovie = [NSTemporaryDirectory() stringByAppendingPathComponent:outputVideoName];
    [self removeTempleVideoFile:pathToMovie];
    NSURL *url = [NSURL fileURLWithPath:pathToMovie];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.videoComposition = MainCompositionInst;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^
     {
         
     dispatch_async(dispatch_get_main_queue(), ^{
         [self exportDidFinish:exporter
                     outputUrl:pathToMovie
                    onComplete:onComplete];
     });
     }];
    
    return YES;
}

- (void)exportDidFinish:(AVAssetExportSession*)session
              outputUrl:(NSString*)outputUrl
             onComplete:(VisionComposeCompleted)onComplete{
    int status = session.status;
    NSLog(@"status is %d",status);
    if (onComplete) {
        onComplete(session.status == AVAssetExportSessionStatusCompleted ? outputUrl : nil);
    }
}

- (void)fetchKeyFramesFromVideo:(NSArray*)timeSlotArray keyFramesArray:(NSMutableArray*)frameArray savePath:(NSString*)savePath index:(int)index{
    _imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    _imageGenerator.appliesPreferredTrackTransform = YES;
    _imageGenerator.maximumSize = CGSizeMake(80, 80);
    self.fetchFrameCount = index;
    _isRecomposing = YES;
    _fetchedKeyFrames = index;
    
    [_imageGenerator generateCGImagesAsynchronouslyForTimes:timeSlotArray completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        if (_isRecomposing == NO) {
            return;
        }
        if (error) {
            NSLog(@"===================error:%@",error);
            self.fetchedKeyFrames += 1;
        }else{
            @autoreleasepool {
                NSLog(@"*******111********actual got image at time:%f", CMTimeGetSeconds(actualTime));
                if (image){
                    UIImage *frame = [UIImage imageWithCGImage:image];
                    if (savePath != nil) {
                        NSString * jpgPath = [NSString stringWithFormat:@"%@/IMG%d.jpg",savePath,self.fetchFrameCount];
                        NSData *data = UIImageJPEGRepresentation(frame, 1.0);
                        [data writeToFile:jpgPath atomically:NO];
                    }
                    if (_delegate && [_delegate respondsToSelector:@selector(fetchKeyFramesWithKeyNum:)]) {
                        [_delegate fetchKeyFramesWithKeyNum:self.fetchFrameCount];
                    }
                    self.fetchFrameCount += 1;
                    self.fetchedKeyFrames += 1;
                }
                NSLog(@"================timeSlotArray.count IS %d , fetchFrameCount is %d, reslut = %d",timeSlotArray.count, self.fetchFrameCount, result);
            }
        }
        if (self.fetchedKeyFrames == timeSlotArray.count) {
            if (_delegate && [_delegate respondsToSelector:@selector(fetchKeyFramesCompleted)]) {
                [_delegate fetchKeyFramesCompleted];
            }
        }
    }];
}

- (void)fetchKeyFramesFromVideo:(CMTime)time withComplete:(void(^)(UIImage*))complete{
    _imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    _imageGenerator.appliesPreferredTrackTransform = YES;
    
    _imageGenerator.maximumSize = CGSizeMake(480, 480);
    _isRecomposing = YES;
    [_imageGenerator generateCGImagesAsynchronouslyForTimes:@[[NSValue valueWithCMTime:time]] completionHandler:
     ^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error)
     {
     if (_isRecomposing == NO) {
         return;
     }
     @autoreleasepool {
         NSLog(@"********222*******actual got image at time:%f", CMTimeGetSeconds(actualTime));
         if (image) {
             UIImage *frame = [UIImage imageWithCGImage:image];
             complete(frame);
         } else {
             complete(nil);
         }
     }
     }];
}

- (UIImage *)generateCGImages2:(AVAsset*)videoAsset frameSlot:(int)frameSlot frameRate:(int)frameRate{
    if (_imageGenerator == nil) {
        _imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:videoAsset];
        _imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
        _imageGenerator.appliesPreferredTrackTransform = YES;
        _imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
        _imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    }
    
    CGImageRef thumbnailImageRef = NULL;
    NSError *thumbnailImageGenerationError = nil;
    UIImage *thumbnailImage;
    
    CMTime actualTime;
    thumbnailImageRef = [_imageGenerator copyCGImageAtTime:CMTimeMake(frameSlot,frameRate)actualTime:&actualTime error:&thumbnailImageGenerationError];
    NSLog(@"============11111=========actual got image at time:%f", CMTimeGetSeconds(actualTime));
    if (!thumbnailImageRef) {
        //[timer invalidate]; //如果到头的话，停止 NSTimer
    }
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]  : nil;
    if (!thumbnailImage) {
        //[timer invalidate];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString  * path = [paths objectAtIndex:0];
    
    NSLog(@"%@",path);
    
    NSString * realPaht = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",1]];
    NSData * imgData = UIImagePNGRepresentation(thumbnailImage);
    [imgData writeToFile:realPaht atomically:YES];// 写入DOCUMENTS
    //[ALAssetsLibrary saveImage:thumbnailImage metadata:nil completionBlock:nil];
    return thumbnailImage;
}

- (UIImage *)generateCGImages3:(AVAsset*)videoAsset frameSlot:(int)frameSlot frameRate:(int)frameRate
{
    if (_imageGenerator == nil) {
        _imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:videoAsset];
        _imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
        _imageGenerator.appliesPreferredTrackTransform = YES;
        _imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
        _imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    }
    
    CGImageRef thumbnailImageRef = NULL;
    NSError *thumbnailImageGenerationError = nil;
    UIImage *thumbnailImage;
    
    CMTime actualTime;
    thumbnailImageRef = [_imageGenerator copyCGImageAtTime:CMTimeMakeWithSeconds(frameSlot, frameRate) actualTime:&actualTime error:&thumbnailImageGenerationError];
    NSLog(@"============444=========actual got image at time:%f", CMTimeGetSeconds(actualTime));
    if (!thumbnailImageRef) {
        //[timer invalidate]; //如果到头的话，停止 NSTimer
    }
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]  : nil;
    if (!thumbnailImage) {
        //[timer invalidate];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString  * path = [paths objectAtIndex:0];
    
    NSLog(@"%@",path);
    
    NSString * realPaht = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",1]];
    NSData * imgData = UIImagePNGRepresentation(thumbnailImage);
    [imgData writeToFile:realPaht atomically:YES];// 写入DOCUMENTS
    //[ALAssetsLibrary saveImage:thumbnailImage metadata:nil completionBlock:nil];
    return thumbnailImage;
}

- (void)callFaadMain:(NSString*)inFile outFile:(NSString*)outFile {
#if TARGET_IPHONE_SIMULATOR
    return;
#elif TARGET_OS_IPHONE
    int err = -2;
    // 获取Resources目录下的文件夹路径,  例如: Resources/FolderName
    //NSFileManager *fileMgr = [NSFileManager defaultManager];
    //[fileMgr removeItemAtPath:outFile error:nil];
    
    NSLog(@"inputfile = %@, outputFilePath = %@", inFile, outFile);
    char *argv1[] = {"faad", "-o", (char*)[outFile UTF8String], (char*)[inFile UTF8String]};
    NSLog(@"%s -- %s -- %s -- %s-----zhaodg", argv1[0], argv1[1], argv1[2], argv1[3]);
//    err = faad_main(4, argv1);
    if (err != 0) {
        NSLog(@"convert audio file failed!!!");
    }
#endif
}

- (void)callAudioReverse:(NSString*)inFile outFile:(NSString*)outFile {
    /*
     NSString *inputFilePath = [[NSBundle mainBundle] pathForResource:WAVFILENAME ofType:@"wav"];
     NSString *outputFileDic = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents"];
     NSString *outputFilePath = [outputFileDic stringByAppendingString:@"/wav_file_reverse_output.wav"];
     */
#if TARGET_IPHONE_SIMULATOR
    return;
#elif TARGET_OS_IPHONE
    int err = -2;
    //NSFileManager *fileMgr = [NSFileManager defaultManager];
    //[fileMgr removeItemAtPath:outFile error:nil];
    char *argv2[] = {"audio_reverse",(char*)[inFile UTF8String], (char*)[outFile UTF8String]};
//    err = WavReverse(argv2[1], argv2[2]);
    
#endif
}

- (void)callFaacMain:(NSString*)inFile outFile:(NSString*)outFile {
#if TARGET_IPHONE_SIMULATOR
    return;
#elif TARGET_OS_IPHONE
    int err = -2;
    //NSFileManager *fileMgr = [NSFileManager defaultManager];
    //[fileMgr removeItemAtPath:outFile error:nil];
    char *argv3[] = {"faac", "-o", (char*)[outFile UTF8String], (char*)[inFile UTF8String]};
    
//    err = faac_main(4, argv3);
#endif
}



@end
