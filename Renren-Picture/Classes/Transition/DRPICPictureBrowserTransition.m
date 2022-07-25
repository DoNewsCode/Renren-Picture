//
//  DRPICPictureBrowserTransition.m
//  Renren-Picture
//
//  Created by Ming on 2020/2/18.
//

#import "DRPICPictureBrowserTransition.h"

#import "DRPICPictureBrowserViewController.h"

#import "DRPICPictureBrowserPresentTransitionAnimation.h"
#import "DRPICPictureBrowserDismissTransitionAnimation.h"
#import "DRPICPictureBrowserDismissDrivenInteractiveTransitionAnimation.h"

#import "DRPICPictureBrowserPushTransitionAnimation.h"
#import "DRPICPictureBrowserPopTransitionAnimation.h"
#import "DRPICPictureBrowserPopDrivenInteractiveTransitionAnimation.h"

@interface DRPICPictureBrowserTransition ()


@end


@implementation DRPICPictureBrowserTransition

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - animationController
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
     return [DRPICPictureBrowserPresentTransitionAnimation new];
}

-  (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if (self.interaction == YES) {
        return [DRPICPictureBrowserDismissDrivenInteractiveTransitionAnimation new];
    }
    return [DRPICPictureBrowserDismissTransitionAnimation new];
}

#pragma mark - interactionController
/// 该方法决定交互方法是否为可交互的，nil为不可交互
/// @param animator animator
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {

    if ([animator isKindOfClass:[DRPICPictureBrowserPresentTransitionAnimation class]]) {
        return nil;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    if ([animator isKindOfClass:[DRPICPictureBrowserDismissDrivenInteractiveTransitionAnimation class]]) {
        return self.dismissInteractiveTransition;
    }
    return nil;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if ([toVC isKindOfClass:[DRPICPictureBrowserViewController class]]) {
        return [DRPICPictureBrowserPushTransitionAnimation new];
    }else if ([fromVC isKindOfClass:[DRPICPictureBrowserViewController class]] && [navigationController.viewControllers containsObject:fromVC]) {
        return nil;
    } else if ([fromVC isKindOfClass:[DRPICPictureBrowserViewController class]]) {
        if (self.interaction == NO) {
            return [DRPICPictureBrowserPopTransitionAnimation new];
        } else {
            return [DRPICPictureBrowserPopDrivenInteractiveTransitionAnimation new];
        }
    }else {
        
        return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if ([animationController isKindOfClass:[DRPICPictureBrowserPopDrivenInteractiveTransitionAnimation class]]) {
        return self.popInteractiveTransition;
    }
    return nil;
}



#pragma mark - Getter

- (DRPICPictureBrowserDismissDrivenInteractiveTransition *)dismissInteractiveTransition {
    if (!_dismissInteractiveTransition) {
        DRPICPictureBrowserDismissDrivenInteractiveTransition *dismissInteractiveTransition = [DRPICPictureBrowserDismissDrivenInteractiveTransition new];
        _dismissInteractiveTransition = dismissInteractiveTransition;
    }
    return _dismissInteractiveTransition;
}

- (DRPICPictureBrowserPopDrivenInteractiveTransition *)popInteractiveTransition {
    if (!_popInteractiveTransition) {
        DRPICPictureBrowserPopDrivenInteractiveTransition *popInteractiveTransition = [DRPICPictureBrowserPopDrivenInteractiveTransition new];
        _popInteractiveTransition = popInteractiveTransition;
    }
    return _popInteractiveTransition;
}

@end
