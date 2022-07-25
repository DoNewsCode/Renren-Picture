//
//  DRPICPictureBrowserViewController.h
//  Renren-Picture
//
//  Created by 陈金铭 on 2019/9/24.
//  图像浏览控制器

#import "DRBBaseViewController.h"

#import "DRPICPictureView.h"

NS_ASSUME_NONNULL_BEGIN

@class DRPICPictureBrowserViewController;

@protocol DRPictureBrowserViewControllerDelegate <NSObject>

@optional
///长按事件
- (void)pictureBrowser:(DRPICPictureBrowserViewController *)pictureBrowser longPressWithIndex:(NSInteger)index;

- (void)pictureBrowser:(DRPICPictureBrowserViewController *)pictureBrowser willAppearRowAtIndex:(NSInteger)index;
- (void)pictureBrowser:(DRPICPictureBrowserViewController *)pictureBrowser didAppearRowAtIndex:(NSInteger)index;
- (void)pictureBrowser:(DRPICPictureBrowserViewController *)pictureBrowser didTagEventRowAtIndex:(NSInteger)index tag:(DRPICPictureTag *)tag;

@end

@interface DRPICPictureBrowserViewController : DRBBaseViewController

/// 滚动视图
@property(nonatomic, strong) UIScrollView *scrollView;
/// 初始移动点
@property (nonatomic, assign) CGPoint   firstMovePoint;
/// 开始位置（点）
@property (nonatomic, assign) CGPoint   startLocation;
/// 开始的Frame
@property (nonatomic, assign) CGRect    startFrame;

@property (nonatomic, assign) CGFloat orginImageViewHeight;

/// 图片视图数组
@property(nonatomic, strong)  NSMutableArray<DRPICPictureView *> *pictureViews;

/// 来源控制器
@property(nonatomic, strong) UIViewController *fromViewController;
/// 模型数组
@property(nonatomic, strong) NSMutableArray<DRPICPicture *> *pictures;
/// 当前图像视图
@property(nonatomic, strong) DRPICPictureView *currentPictureView;
/// 当前序列
@property(nonatomic, assign) NSUInteger currentIndex;
/// 背景视图
@property(nonatomic, strong) UIView *backgroundView;
///顶部容器视图
@property(nonatomic, strong) UIView *topContainerView;
///底部容器视图
@property(nonatomic, strong) UIView *bottomContainerView;
///代理
@property(nonatomic, weak)id<DRPictureBrowserViewControllerDelegate>delegate;

/// 可开始展示标签
@property (nonatomic, getter=isTransitionFinished) BOOL transitionFinished;

/// 处理顶部及底部容器视图的隐藏（若要进行额外控制可重写此方法）
/// @param hidden hidden
/// @param animation animation
- (void)processTopAndBottomContainerViewHidden:(BOOL)hidden animation:(BOOL)animation;

/// 处理追加照片
/// @param pictures 照片模型数组
- (void)processAddPictures:(NSArray<DRPICPicture *> *)pictures;

@end

NS_ASSUME_NONNULL_END
