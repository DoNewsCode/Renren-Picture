//
//  DRPICPictureBrowserDismissTransitionAnimation.m
//  Renren-Picture
//
//  Created by Ming on 2020/2/18.
//

#import "DRPICPictureBrowserDismissTransitionAnimation.h"

#import "DRPICPictureBrowserViewController.h"

@implementation DRPICPictureBrowserDismissTransitionAnimation

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.618;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
   
    //from
       UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
       //to
       UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
       if ([fromViewController isKindOfClass:[DRPICPictureBrowserViewController class]] == NO) {
           //        [self processCurrentCompleteTransition:NO];
           return;
       }
       DRPICPictureBrowserViewController *pictureBrowserViewController = (DRPICPictureBrowserViewController *)fromViewController;
       UIView* toView = nil;
       UIView* fromView = nil;
       
       if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
           fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
           toView = [transitionContext viewForKey:UITransitionContextToViewKey];
       } else {
           fromView = fromViewController.view;
           toView = toViewController.view;
       }
       //这个非常重要，将toView加入到containerView中
       [[transitionContext containerView]  addSubview:toView];
       [[transitionContext containerView]  addSubview:pictureBrowserViewController.view];
       toViewController = toViewController;
       fromViewController = fromViewController;
       pictureBrowserViewController = pictureBrowserViewController;
       
       UIImageView *currentImageView = pictureBrowserViewController.currentPictureView.contentView;
       UIImageView *sourceImageView = pictureBrowserViewController.currentPictureView.picture.source.sourceImageView;
       if ( currentImageView.ct_height > [UIScreen mainScreen].bounds.size.height) {
           currentImageView.ct_height = [UIScreen mainScreen].bounds.size.height;
       }
       pictureBrowserViewController.currentPictureView.scrollView.contentOffset = CGPointMake(0, 0);
       sourceImageView.hidden = YES;
       currentImageView.contentMode = sourceImageView.contentMode;
       currentImageView.clipsToBounds = sourceImageView.clipsToBounds;
       UIImage *image = currentImageView.image;
       CGFloat rect = currentImageView.image.size.width / currentImageView.image.size.height;
       if (rect < 0.5) {
           CGFloat rectimageView = currentImageView.frame.size.height / currentImageView.frame.size.width;
           currentImageView.layer.contentsRect = CGRectMake(0,0,1,rectimageView * rect);
       }
       currentImageView.image = image;
       
       NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
       [UIView animateWithDuration:transitionDuration
                             delay:0
            usingSpringWithDamping:0.9
             initialSpringVelocity:0
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
           currentImageView.frame = sourceImageView.frame;
           CGFloat rect = currentImageView.image.size.width / currentImageView.image.size.height;
           if (rect < 0.5) {
               CGFloat rectimageView = currentImageView.frame.size.height / currentImageView.frame.size.width;
               currentImageView.layer.contentsRect = CGRectMake(0,0,1,rectimageView * rect);
           }
           pictureBrowserViewController.backgroundView.alpha = 0;
       }completion:^(BOOL finished) {
           sourceImageView.hidden = NO;
           [transitionContext completeTransition:YES];
       }];
}

@end
