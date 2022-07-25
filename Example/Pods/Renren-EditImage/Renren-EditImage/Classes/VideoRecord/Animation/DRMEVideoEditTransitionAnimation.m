//
//  DRMEVideoEditTransitionAnimation.m
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/13.
//

#import "DRMEVideoEditTransitionAnimation.h"
#import "DRMECutVideoViewController.h"

@interface DRMEVideoEditTransitionAnimation ()<CAAnimationDelegate>

@property(nonatomic, assign) UINavigationControllerOperation operation;
@property(nonatomic, weak) DRMECutVideoViewController *pictureBrowserViewController;

@property(nonatomic, weak) UIViewController *toViewController;
@property(nonatomic, weak) UIViewController *fromViewController;
@property (nonatomic, assign) CGPoint   firstMovePoint;
@property (nonatomic, assign) CGPoint   startLocation;
@property (nonatomic, assign) CGRect    startFrame;


@end

@implementation DRMEVideoEditTransitionAnimation

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
//    if ([toVC isKindOfClass:[DRPICPictureBrowserViewController class]] || [fromVC isKindOfClass:[DRPICPictureBrowserViewController class]]) {
//    if (operation == UINavigationControllerOperationPush) {
//        return self.customPush;
//        
//    }else if (operation == UINavigationControllerOperationPop){
//        return self.customPop;
//    }
        self.operation = operation;
        return self;
//    }
//    return nil;
}
//
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController API_AVAILABLE(ios(7.0))
{
//    return nil;
    // 检查是否是我们的自定义过渡
//    if ([animationController isKindOfClass:[DRPICPictureBrowserTransitionAnimation class]] && self.operation == UINavigationControllerOperationPop && self.autoAnimation == NO) {
        return self.interactiveTransition;
//    } else {
//        return nil;
//    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    self.transitionContext = transitionContext;
    // 执行自定义的转场动画
    if (self.operation == UINavigationControllerOperationPush) {
        [self processPushAnimation:transitionContext];
    } else {
        [self processPopAnimation:transitionContext];
    }
    
}

- (void)processPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //from
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //to
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    if ([toViewController isKindOfClass:[DRPICPictureBrowserViewController class]] == NO) {
//        return;
//    }
    DRMECutVideoViewController *pictureBrowserViewController = (DRMECutVideoViewController *)toViewController;
    
    //这个非常重要，将toView加入到containerView中
    [[transitionContext containerView] addSubview:pictureBrowserViewController.view];
    pictureBrowserViewController.backgroundView.alpha = 0;
    UIView *currentImageView = pictureBrowserViewController.currentPlayerView;
    UIView *sourceImageView = pictureBrowserViewController.currentPlayerView;
    //.source.sourceImageView;
    CGRect imageViewFrame = currentImageView.frame;
    sourceImageView.hidden = YES;
    currentImageView.frame = sourceImageView.frame;
    
    self.animationing = YES;
    [UIView animateWithDuration:0.3
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
        self.animationing = NO;
            [self.transitionContext completeTransition:YES];
    }];
    
}

- (void)processPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    //from
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //to
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if ([fromViewController isKindOfClass:[DRMECutVideoViewController class]] == NO) {
//        [self processCurrentCompleteTransition:NO];
        return;
    }
    DRMECutVideoViewController *pictureBrowserViewController = (DRMECutVideoViewController *)fromViewController;
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
    self.toViewController = toViewController;
    self.fromViewController = fromViewController;
    self.pictureBrowserViewController = pictureBrowserViewController;
//    pictureBrowserViewController.currentPictureView.picture.source.sourceImageView.hidden = YES;
    pictureBrowserViewController.currentPlayerView.hidden = YES;
    
    
    [self eventPopAnimation];
}

/// 返回动画
- (void)eventPopAnimation {
    
//    UIImageView *currentImageView = self.pictureBrowserViewController.currentPictureView.imageView;
//    UIImageView *sourceImageView = self.pictureBrowserViewController.currentPictureView.picture.source.sourceImageView;
    
    UIView *currentImageView = self.pictureBrowserViewController.currentPlayerView;//.imageView;
    UIView *sourceImageView = self.pictureBrowserViewController.currentPlayerView;//.picture.source.sourceImageView;
    
    
    self.animationing = YES;
    [UIView animateWithDuration:3.3
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        currentImageView.frame = sourceImageView.frame;
        self.pictureBrowserViewController.backgroundView.alpha = 0;
    }completion:^(BOOL finished) {
        sourceImageView.hidden = NO;
        
        [self.transitionContext completeTransition:YES];
//        self.animationing = NO;
    }];
    
}


@end
