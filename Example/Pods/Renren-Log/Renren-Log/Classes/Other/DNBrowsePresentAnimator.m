//
//  DNBrowsePresentAnimator.m
//  Renren-Library
//
//  Created by 陈金铭 on 2019/8/12.
//

#import "DNBrowsePresentAnimator.h"

#import "DRLLogBrowseViewController.h"
#import "DRLLogBrowseNavigationController.h"

@implementation DNBrowsePresentAnimator


#pragma mark - UIViewControllerAnimatedTransitioning  Methods
- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    DRLLogBrowseNavigationController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//
    UIView *containerView = [transitionContext containerView];
    containerView.userInteractionEnabled = NO;
    [containerView gestureRecognizerShouldBegin:NO];
//    containerView.gde
    [containerView addSubview:toVC.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                     animations:^{
//                         toVC.view.frame = (CGRect){0.,200.,300,300};
                         toVC.view.alpha = 0.5;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.2;
}

@end
