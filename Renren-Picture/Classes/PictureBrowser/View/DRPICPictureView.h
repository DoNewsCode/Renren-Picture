//
//  DRPICPictureView.h
//  Renren-Picture
//
//  Created by 陈金铭 on 2019/9/24.
//

#import <UIKit/UIKit.h>

#import "DRPICTagContainerView.h"
#import "DRPICScrollView.h"
#import "DRPICLoadingView.h"

#import "DRPICVideoView.h"
#import "DRPICPicture.h"
#import "FLAnimatedImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRPICPictureView : UIView
/// 模型
@property(nonatomic, strong) DRPICPicture *picture;
/// 滚动视图（用于缩放）
@property(nonatomic, strong) DRPICScrollView *scrollView;
/// 加载视图
@property (nonatomic, strong) DRPICLoadingView *loadingView;
/// 内容视图（imageView/animatedImageView）
@property (nonatomic, strong) UIImageView *contentView;
/// 图片视图
@property(nonatomic, strong) UIImageView *imageView;
/// 视频视图
@property(nonatomic, strong) DRPICVideoView *videoView;
/// GIF/WEBP图片视图
@property(nonatomic, strong) FLAnimatedImageView *animatedImageView;
/// 标签视图
@property(nonatomic, strong) DRPICTagContainerView *tagContainerView;

/// 可开始展示标签
@property (nonatomic, getter=isShowTagsReady) BOOL showTagsReady;
/** 图片最大放大倍数 */
@property (nonatomic, assign) CGFloat maxZoomScale;

@property (nonatomic, copy) void(^zoomEnded)(DRPICPictureView *pictureView, CGFloat scale);
@property (nonatomic, copy) void(^loadFailed)(DRPICPictureView *pictureView);
@property (nonatomic, copy) void(^loadProgressBlock)(DRPICPictureView *pictureView, float progress, BOOL isOriginImage);

- (instancetype)initWithFrame:(CGRect)frame picture:(DRPICPicture *)picture;
// 重新布局
- (void)processResetFrame;
- (void)processLoadContent;
- (void)processTagContainerView;

/// 根据产品要求,判断是否是长图
/// @param image 图片数据
+ (BOOL)isLongImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
