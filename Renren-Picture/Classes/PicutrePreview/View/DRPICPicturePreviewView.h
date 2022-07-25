//
//  DRPICPicturePreviewView.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/18.
//

#import <UIKit/UIKit.h>

#import "DRPICTagContainerView.h"
#import "DRPICScrollView.h"
#import "DRPICLoadingView.h"

#import "DRPICVideoView.h"
#import "FLAnimatedImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRPICPicturePreviewView : UIView

/// 滚动视图
@property (nonatomic, strong) DRPICScrollView *scrollView;
/// 加载视图
@property (nonatomic, strong) DRPICLoadingView *loadingView;
/// 标签视图
@property(nonatomic, strong) DRPICTagContainerView *__nullable tagContainerView;

/// 视频展示视图
@property (nonatomic, strong) DRPICVideoView *__nullable videoView;
/// 图片展示视图
@property (nonatomic, strong) UIImageView *__nullable imageView;
/// GIF/WEBP图片视图
@property(nonatomic, strong) FLAnimatedImageView *__nullable animatedImageView;
/// 当前内容视图（imageView/animatedImageView/videoView）
@property (nonatomic, strong) UIView *__nullable contentView;

@property (nonatomic, copy) void(^zoomEnded)(DRPICPicturePreviewView *pictureView, CGFloat scale);
@property (nonatomic, copy) void(^loadFailed)(DRPICPicturePreviewView *pictureView);
@property (nonatomic, copy) void(^loadProgressBlock)(DRPICPicturePreviewView *pictureView, float progress, BOOL isOriginImage);

- (void)processLoading:(BOOL)loading animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
