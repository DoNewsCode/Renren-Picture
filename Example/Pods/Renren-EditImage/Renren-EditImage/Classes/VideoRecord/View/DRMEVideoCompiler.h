//
//  DRMEVideoCompiler.h
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/13.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^VisionComposeCompleted)(NSString* videoPath);

@protocol DRMEVideoCompilerDelegate <NSObject>

@optional
-(void)fetchKeyFramesCompleted;
-(void)fetchKeyFramesWithKeyNum:(NSInteger)num;
-(void)videoFrameCaptured:(CGImageRef)imageRef;

@end


@interface DRMEVideoCompiler : NSObject

@property (nonatomic,weak) id <DRMEVideoCompilerDelegate> delegate;
@property (atomic, assign, readwrite) BOOL shouldShowWhiteEdge;
@property (nonatomic,strong) AVAssetImageGenerator * imageGenerator;
@property (nonatomic,strong) AVAsset * videoAsset;
@property (nonatomic,assign) BOOL isRecomposing;
@property (nonatomic,assign) int fetchedKeyFrames;


- (id)initWithAVAsset:(AVAsset*)videoAVAsset delegate:(id)delegate;

- (void)generateCGImages:(AVAsset*)videoAsset frameRate:(int)frameRate;

- (UIImage *)generateCGImages2:(AVAsset*)videoAsset frameSlot:(int)frameSlot frameRate:(int)frameRate;

- (UIImage *)generateCGImages3:(AVAsset*)videoAsset frameSlot:(int)frameSlot frameRate:(int)frameRate;

- (UIImage *)getVideoCoverImage:(AVAsset *)videoAsset withTime:(CFTimeInterval)time;
- (UIImage *)getVideoPreviewImage:(AVAsset *)videoAsset imageSize:(CGSize)size;

- (void)stopRecomposeVideoFrames;

- (void)recomposeVideoFrames:(NSArray*)timeSlotArray frameRate:(int)rate outPath:(NSString*)moviePath videoRect:(CGRect)rect onComplete:(void(^)())complete;

- (void)composeVideoMusic:(AVAsset *)videoAsset audioAsset:(AVAsset *)audioAsset outPutPath:(NSString*)outPutPath onComplete:(void (^)(NSString *videoPath))complete;

- (void)mergeAudioAndSaved:(AVAsset *)videoAsset audioAsset:(AVAsset *)audioAsset outPutPath:(NSString*)outPutPath onComplete:(void (^)())complete;

- (void)fetchKeyFramesFromVideo:(NSArray*)timeSlotArray keyFramesArray:(NSMutableArray*)frameArray savePath:(NSString*)savePath index:(int)index;

- (void)fetchKeyFramesFromVideo:(CMTime)time withComplete:(void(^)(UIImage*))complete;

- (void)extractAudioFile:(AVAsset*)mAsset
                 handler:(void (^)(void))handler;

- (BOOL)composeMuteVideo:(AVAsset*) sourceVideoAsset
         outputVideoName:(NSString*) outputVideoName
              onComplete:(VisionComposeCompleted)onComplete;

- (BOOL)composeCutVideo:(AVAsset*) sourceVideoAsset
        outputVideoName:(NSString*) outputVideoName
              startTime:(CGFloat)startTime
                endTime:(CGFloat)endTime
             finalFrame:(CGRect)finalFrame
             onComplete:(VisionComposeCompleted)onComplete;



@end

NS_ASSUME_NONNULL_END
