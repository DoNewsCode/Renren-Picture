//
//  DNPopPresentBaseAnimator.h
//  DNPop
//
//  Created by 陈金铭 on 2019/7/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** present style */
typedef NS_ENUM(NSInteger, DNPopPresentStyle) {
    DNPopPresentStyleSystem,          // 系统样式
    DNPopPresentStyleFadeIn,          // 渐入
    DNPopPresentStyleBounce,          // 弹出
    DNPopPresentStyleExpandHorizontal,// 水平展开
    DNPopPresentStyleExpandVertical,  // 垂直展开
    DNPopPresentStyleSlideDown,       // 从上往下划入
    DNPopPresentStyleSlideUp,         // 从下往上划入
    DNPopPresentStyleSlideUpLinear,   // 从下往上划入，线性动画
    DNPopPresentStyleSlideLeft,       // 从右往左划入
    DNPopPresentStyleSlideRight,      // 从左往右划入
};

@interface DNPopPresentBaseAnimator : NSObject<UIViewControllerAnimatedTransitioning>
/** 背景透明度 */
@property (nonatomic, assign) CGFloat transitionBackgroundAlpha;

@property (assign, nonatomic) DNPopPresentStyle style;

@end

NS_ASSUME_NONNULL_END
