//
//  DNPopDismissBaseAnimator.h
//  DNPop
//
//  Created by 陈金铭 on 2019/7/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** dismiss style */
typedef NS_ENUM(NSInteger, DNPopDismissStyle) {
    DNPopDismissStyleFadeOut,             // 渐出
    DNPopDismissStyleContractHorizontal,  // 水平收起
    DNPopDismissStyleContractVertical,    // 垂直收起
    DNPopDismissStyleSlideDown,           // 向下划出
    DNPopDismissStyleSlideUp,             // 向上划出
    DNPopDismissStyleSlideLeft,           // 向左划出
    DNPopDismissStyleSlideRight,          // 向右划出
};


@interface DNPopDismissBaseAnimator : NSObject<UIViewControllerAnimatedTransitioning>
/** 背景透明度 */
@property (nonatomic, assign) CGFloat transitionBackgroundAlpha;

@property (assign, nonatomic) DNPopDismissStyle style;

@end

NS_ASSUME_NONNULL_END
