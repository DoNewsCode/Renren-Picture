//
//  DRIPictureBrowseInteractiveAnimatedTransition.m
//  LYCustomTransitionDemo
//
//  Created by liyang on 2017/12/5.
//  Copyright © 2017年 liyang. All rights reserved.
//

#import "DRIPictureBrowseInteractiveAnimatedTransition.h"

@interface DRIPictureBrowseInteractiveAnimatedTransition ()


@end

@implementation DRIPictureBrowseInteractiveAnimatedTransition

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        return self.customPush;
        
    }else if (operation == UINavigationControllerOperationPop){
        return self.customPop;
    }
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(nonnull id<UIViewControllerAnimatedTransitioning>)animationController{
    if (self.transitionParameter.gestureRecognizer)
        return self.percentIntractive;
    else
        return nil;
    
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self.customPush;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return self.customPop;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{

    return nil;//push时不加手势交互
}
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    if (self.transitionParameter.gestureRecognizer)
        return self.percentIntractive;
    else
        return nil;

}

-(DRIPictureBrowsePushAnimator *)customPush
{
    if (_customPush == nil) {
        _customPush = [[DRIPictureBrowsePushAnimator alloc]init];
    }
    return _customPush;
}

- (DRIPictureBrowsePopAnimator *)customPop {
    if (!_customPop) {
        _customPop = [[DRIPictureBrowsePopAnimator alloc] init];
    }
    return _customPop;
}
- (DRIPictureBrowsePercentDrivenInteractive *)percentIntractive{
    if (!_percentIntractive) {
        _percentIntractive = [[DRIPictureBrowsePercentDrivenInteractive alloc] initWithTransitionParameter:self.transitionParameter];
    }
    return _percentIntractive;
}

-(void)setTransitionParameter:(DRIPictureBrowseTransitionParameter *)transitionParameter{
    _transitionParameter = transitionParameter;

    self.customPush.transitionParameter = transitionParameter;
    self.customPop.transitionParameter = transitionParameter;
}

//- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
//    return 0.4;
//}
//
//- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
//    
//    //转场过渡的容器view
//    UIView *containerView = [transitionContext containerView];
//    
//    //ToVC
//    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    toViewController.view.hidden = YES;
//    [containerView addSubview:toViewController.view];
//    
//    //FromVC
//    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    
//    //图片背景白色的空白view
//    UIView *imgBgWhiteView = [[UIView alloc] initWithFrame:[self.transitionParameter.firstVCImgFrames[self.transitionParameter.transitionImgIndex] CGRectValue]];
//    imgBgWhiteView.backgroundColor =[UIColor whiteColor];
//    [containerView addSubview:imgBgWhiteView];
//    
//    //有渐变的黑色背景
//    UIView *bgView = [[UIView alloc] initWithFrame:containerView.bounds];
//    bgView.backgroundColor = [UIColor blackColor];
//    bgView.alpha = 0;
//    [containerView addSubview:bgView];
//    
//    //过渡的图片
//    UIImageView *transitionImgView = [[UIImageView alloc] initWithImage:self.transitionParameter.transitionImage];
//    transitionImgView.layer.masksToBounds = YES;
//    transitionImgView.contentMode = UIViewContentModeScaleAspectFill;
//    transitionImgView.frame = [self.transitionParameter.firstVCImgFrames[self.transitionParameter.transitionImgIndex] CGRectValue];
//    [transitionContext.containerView addSubview:transitionImgView];
//    
//    
//    //这就是动画啦啦啦
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//        
//        transitionImgView.frame = self.transitionParameter.secondVCImgFrame;
//        bgView.alpha = 1;
//        
//    } completion:^(BOOL finished) {
//        
//        toViewController.view.hidden = NO;
//        
//        [imgBgWhiteView removeFromSuperview];
//        [bgView removeFromSuperview];
//        [transitionImgView removeFromSuperview];
//        
//        //        设置transitionContext通知系统动画执行完毕
//        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//    }];
//}
@end


