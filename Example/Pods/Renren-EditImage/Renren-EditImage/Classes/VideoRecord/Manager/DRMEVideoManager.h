//
//  DRMEVideoManager.h
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/8.
//  视频编辑统一控制管理器

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define kDRMEVideoManager [DRMEVideoManager shareVideoManager]

#define finalVideoPath   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"finalVideo.mp4"]

NS_ASSUME_NONNULL_BEGIN

@interface DRMEVideoManager : NSObject

+ (DRMEVideoManager *)shareVideoManager;

/// 异步多段视频合成处理
- (void)asynchandleVideosWithVideoPathArr:(NSArray<NSString *> *)videoPathArray progress:(void (^)(float progress))progress complete:(void (^)(NSString *finishVideoPath))complete;

/// 指定时间视频截取
- (void)asyncOriginVideoPath:(NSString *)videoPath RangeVideosBystartTime:(CMTime)startTime endTime:(CMTime)endTime progress:(void (^)(float progress))progress complete:(void (^)(NSString *finishVideoPath))complete;

//
- (NSUInteger)getVideoDegress:(AVAssetTrack *)videoTrack;

//视频截图
- (UIImage *)getImageViewWithView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
