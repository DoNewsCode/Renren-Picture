//
//  DRMECutVideoViewController.h
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/12.
//

#import "DRMEVideoEditViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DRMEVideoEditPushAnimation.h"
NS_ASSUME_NONNULL_BEGIN

@interface DRMECutVideoViewController : UIViewController<UINavigationControllerDelegate>

@property (nonatomic, strong) DRMEVideoEditPushAnimation *animation;
@property (nonatomic , assign) CMTime curPlayTime;
/// 背景视图
@property (nonatomic , strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *currentPlayerView;

/* 本地视频路径 */
@property (nonatomic , strong) NSString *videoURLStr;

@property(nonatomic,copy) void(^cutVideoComplete)(NSString *videoPath);

@end

NS_ASSUME_NONNULL_END
