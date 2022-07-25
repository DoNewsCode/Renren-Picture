//
//  DRPICPictureBrowserPopDrivenInteractiveTransitionAnimation.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/1.
//

#import "DRPICPictureBrowserPopDrivenInteractiveTransitionAnimation.h"

#import "DRPICPictureBrowserViewController.h"

@interface DRPICPictureBrowserPopDrivenInteractiveTransitionAnimation ()
@property (nonatomic, strong) DRPICPictureBrowserViewController *pictureBrowserViewController;

@property(nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation DRPICPictureBrowserPopDrivenInteractiveTransitionAnimation

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
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
    self.pictureBrowserViewController = pictureBrowserViewController;
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
    
    sourceImageView.hidden = YES;
    currentImageView.contentMode = sourceImageView.contentMode;
    currentImageView.clipsToBounds = sourceImageView.clipsToBounds;
    currentImageView.ct_height = [UIScreen mainScreen].bounds.size.height;
    UIImage *image = currentImageView.image;
    CGFloat rect = currentImageView.image.size.width / currentImageView.image.size.height;
    if (rect < 0.5 && [DRPICPictureView isLongImage:pictureBrowserViewController.currentPictureView.picture.source.showImage]) {
        CGFloat rectimageView = currentImageView.frame.size.height / currentImageView.frame.size.width;
        currentImageView.layer.contentsRect = CGRectMake(0,0,1,rectimageView * rect);
    }
    if (![currentImageView isKindOfClass:[FLAnimatedImageView class]]) {
        currentImageView.image = image;
    }
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:transitionDuration
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        pictureBrowserViewController.backgroundView.alpha = 0;
    }completion:^(BOOL finished) {
        if (transitionContext.transitionWasCancelled) {
            [self processCancelInteractiveTransitionAnimation];
        } else {
            [self processFinishInteractiveTransitionAnimation];
        }
    }];
}

- (void)processFinishInteractiveTransitionAnimation {
    UIImageView *currentImageView = self.pictureBrowserViewController.currentPictureView.contentView;
    UIImageView *sourceImageView = self.pictureBrowserViewController.currentPictureView.picture.source.sourceImageView;
    [UIView animateWithDuration:0.618
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        CGRect rectIdenty = [sourceImageView.superview convertRect:sourceImageView.frame toView:currentImageView.superview];
        currentImageView.frame = rectIdenty;
        CGFloat rect = currentImageView.image.size.width / currentImageView.image.size.height;
        if (rect < 0.5 && [DRPICPictureView isLongImage:self.pictureBrowserViewController.currentPictureView.picture.source.showImage]) {
            CGFloat rectimageView = currentImageView.frame.size.height / currentImageView.frame.size.width;
            currentImageView.layer.contentsRect = CGRectMake(0,0,1,rectimageView * rect);
        }
        self.pictureBrowserViewController.backgroundView.alpha = 0;
    }completion:^(BOOL finished) {
        sourceImageView.hidden = NO;
        [self.transitionContext completeTransition:YES];
    }];
    
}

- (void)processCancelInteractiveTransitionAnimation {
    DRPICPictureView *pictureView = self.pictureBrowserViewController.scrollView.subviews[self.pictureBrowserViewController.currentIndex];
    DRPICPicture *picture = self.pictureBrowserViewController.pictures[self.pictureBrowserViewController.currentIndex];
    picture.imageView.alpha = 1.0;
    
    [UIView animateWithDuration:0.25f animations:^{
        pictureView.contentView.frame = self.pictureBrowserViewController.startFrame;
    } completion:^(BOOL finished) {
        
        self.pictureBrowserViewController.currentPictureView.picture.source.sourceImageView.hidden = NO;
        [self.pictureBrowserViewController.currentPictureView.tagContainerView eventTagHidden:NO animation:YES];
        [self.transitionContext completeTransition:NO];
        pictureView.contentView.ct_height = self.pictureBrowserViewController.orginImageViewHeight;
        pictureView.contentView.contentMode = UIViewContentModeScaleToFill;
        pictureView.contentView.layer.contentsRect = CGRectMake(0,0,1,1);
    }];
}

@end
