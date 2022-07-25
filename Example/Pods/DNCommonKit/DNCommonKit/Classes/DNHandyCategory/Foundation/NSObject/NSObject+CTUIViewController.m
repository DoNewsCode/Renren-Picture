//
//  NSObject+UIViewController.m
//  ZZHandyCategory
//
//  Created by donews on 2018/7/20.
//  Copyright © 2018年 donews. All rights reserved.
//

#import "NSObject+CTUIViewController.h"

@implementation NSObject (UIViewController)

- (UIViewController *)ct_currentTopViewController {
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    // 修正获取顶部控制器的while逻辑
    while ([topController isKindOfClass:[UITabBarController class]] || [topController isKindOfClass:[UINavigationController class]]){
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([topController isKindOfClass:[UITabBarController class]]) {
            topController = ((UITabBarController*)topController).selectedViewController;
        }else if ([topController isKindOfClass:[UINavigationController class]]) {
            topController = ((UINavigationController*)topController).visibleViewController;
        }
        
        if (topController.presentedViewController) {
            topController = topController.presentedViewController;
        }
        
    }
    return topController;
}

- (UIView *)ct_currentRootView {
    UIViewController *topController = [self ct_currentTopViewController];
    return topController.view;
}

- (void)ct_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UINavigationController *navigationController = (UINavigationController *)[self ct_currentTopViewController];
    
    if ([navigationController isKindOfClass:[UINavigationController class]] == NO) {
        if ([navigationController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabbarController = (UITabBarController *)navigationController;
            navigationController = tabbarController.selectedViewController;
            if ([navigationController isKindOfClass:[UINavigationController class]] == NO) {
                navigationController = tabbarController.selectedViewController.navigationController;
            }
        } else {
            navigationController = navigationController.navigationController;
        }
    }
    
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        [navigationController pushViewController:viewController animated:animated];
    }
}

- (void)ct_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^)(void))completion {
    
    UIViewController *viewController = [self ct_currentTopViewController];
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        viewController = navigationController.topViewController;
    }
    
    if (viewController) {
        [viewController presentViewController:viewControllerToPresent animated:animated completion:completion];
    }
}

@end
