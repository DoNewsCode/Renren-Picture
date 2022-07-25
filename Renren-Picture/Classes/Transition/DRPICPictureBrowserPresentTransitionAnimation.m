//
//  DRPICPictureBrowserPresentTransitionAnimation.m
//  Renren-Picture
//
//  Created by Ming on 2020/2/18.
//

#import "DRPICPictureBrowserPresentTransitionAnimation.h"

#import "DRPICPictureBrowserViewController.h"

@implementation DRPICPictureBrowserPresentTransitionAnimation

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.618;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
   
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if ([toViewController isKindOfClass:[DRPICPictureBrowserViewController class]] == NO) {
        //        [self processCurrentCompleteTransition:NO];
        return;
    }
    DRPICPictureBrowserViewController *pictureBrowserViewController = (DRPICPictureBrowserViewController *)toViewController;
    
    //这个非常重要，将toView加入到containerView中
    [[transitionContext containerView]  addSubview:pictureBrowserViewController.view];
    pictureBrowserViewController.backgroundView.alpha = 0;
    UIImageView *currentImageView = pictureBrowserViewController.currentPictureView.contentView;
    UIImageView *sourceImageView = pictureBrowserViewController.currentPictureView.picture.source.sourceImageView;
    CGRect imageViewFrame = currentImageView.frame;
    sourceImageView.hidden = YES;
    currentImageView.frame = sourceImageView.frame;
     NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:transitionDuration
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        currentImageView.frame = imageViewFrame;
        pictureBrowserViewController.backgroundView.alpha = 1;
    }completion:^(BOOL finished) {
        currentImageView.alpha = 1;
        sourceImageView.hidden = NO;
        [transitionContext completeTransition:YES];
        pictureBrowserViewController.transitionFinished = YES;
    }];
    
}

@end
