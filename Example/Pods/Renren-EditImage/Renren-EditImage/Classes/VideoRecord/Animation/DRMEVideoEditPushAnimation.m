//
//  DRMEVideoEditPushAnimation.m
//  Pods
//
//  Created by 张健康 on 2019/11/28.
//

#import "DRMEVideoEditPushAnimation.h"
#define ANIMATION_DURATION .3f
@implementation DRMEVideoEditPushAnimation

//设置转场动画的时长
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return ANIMATION_DURATION;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    CGRect fromRect, toRect;
    if (self.operation == UINavigationControllerOperationPush) {
        fromRect = self.fromRect;toRect = self.toRect;
    }else if (self.operation == UINavigationControllerOperationPop)
    {
        fromRect = self.toRect;toRect = self.fromRect;
    }else
    {
        return;
    }
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];
    
    //ToVC
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [containerView addSubview:toViewController.view];
    
    //FromVC
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // 黑色背景
    UIView *bgView = [[UIView alloc] initWithFrame:containerView.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    [containerView addSubview:bgView];
    
    UIImageView *transitionImgView = [[UIImageView alloc] initWithImage:self.animatImage];
    transitionImgView.layer.masksToBounds = YES;
    transitionImgView.contentMode = UIViewContentModeScaleAspectFit;
    transitionImgView.frame = fromRect;
    [containerView addSubview:transitionImgView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        transitionImgView.frame = toRect;
        
    } completion:^(BOOL finished) {
        
        [bgView removeFromSuperview];
        [transitionImgView removeFromSuperview];
        
        // 设置transitionContext通知系统动画执行完毕
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}
@end
