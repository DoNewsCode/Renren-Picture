//
//  DRMEVideoEditViewController.h
//  Renren-EditImage
//
//  Created by 陈金铭 on 2019/10/17.
//  视频编辑

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRMEVideoEditViewController : UIViewController <UIViewControllerInteractiveTransitioning>

/* 本地视频路径 */
@property (nonatomic , strong) NSString *videoURLStr;

@property(nonatomic,copy) void(^videoEditComplete)(NSString *videoPath);

@end

NS_ASSUME_NONNULL_END
