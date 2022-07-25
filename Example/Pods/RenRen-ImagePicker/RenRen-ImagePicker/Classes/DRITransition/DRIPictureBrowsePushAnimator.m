//
//  DRIPictureBrowsePushAnimator.m
//  LYCustomTransitionDemo
//
//  Created by liyang on 2017/12/5.
//  Copyright © 2017年 liyang. All rights reserved.
//

#import "DRIPictureBrowsePushAnimator.h"
#import "DRIPictureBrowseTransitionParameter.h"

@implementation DRIPictureBrowsePushAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];
    
    //ToVC
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toViewController.view.hidden = YES;
    [containerView addSubview:toViewController.view];
    
    //FromVC
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    //图片背景白色的空白view
    UIView *imgBgWhiteView = [[UIView alloc] initWithFrame:[self.transitionParameter.firstVCImgFrames[self.transitionParameter.transitionImgIndex] CGRectValue]];
    imgBgWhiteView.backgroundColor =[UIColor whiteColor];
    [containerView addSubview:imgBgWhiteView];
    
    //有渐变的黑色背景
    UIView *bgView = [[UIView alloc] initWithFrame:containerView.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0;
    [containerView addSubview:bgView];
    
    //过渡的图片
    UIImageView *transitionImgView = [[UIImageView alloc] initWithImage:self.transitionParameter.transitionImage];
    transitionImgView.clipsToBounds = YES;
    CGSize imageSize = self.transitionParameter.secondVCImgFrame.size;
    transitionImgView.frame = [self.transitionParameter.firstVCImgFrames[self.transitionParameter.transitionImgIndex] CGRectValue];
    if (self.transitionParameter.imageViewFullScreen){
        transitionImgView.contentMode = UIViewContentModeScaleAspectFill;
    }else{
        transitionImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    [transitionContext.containerView addSubview:transitionImgView];
    
    
    //这就是动画啦啦啦
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        transitionImgView.frame = self.transitionParameter.secondVCImgFrame;
        bgView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        toViewController.view.hidden = NO;
        
        [imgBgWhiteView removeFromSuperview];
        [bgView removeFromSuperview];
        [transitionImgView removeFromSuperview];
        
        //        设置transitionContext通知系统动画执行完毕
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

@end

