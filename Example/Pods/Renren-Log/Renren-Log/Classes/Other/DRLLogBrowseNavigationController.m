//
//  DRLLogBrowseNavigationController.m
//  Renren-Log
//
//  Created by Ming on 2020/1/14.
//

#import "DRLLogBrowseNavigationController.h"

#import "DNBrowseDismissAnimator.h"
#import "DNBrowsePresentAnimator.h"

@interface DRLLogBrowseNavigationController ()<UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate>

@end

@implementation DRLLogBrowseNavigationController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;                          // 设置自己为转场代理
        self.modalPresentationStyle = UIModalPresentationCustom;    // 自定义转场模式
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

            self.view.clipsToBounds = YES;
            self.view.layer.cornerRadius = 10;
}

#pragma mark - UIViewControllerTransitioningDelegate Methods
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    DNBrowsePresentAnimator *customAlertPresentAnimator = [DNBrowsePresentAnimator new];
    return customAlertPresentAnimator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    DNBrowseDismissAnimator *customAlertDismissAnimator = [DNBrowseDismissAnimator new];
    return customAlertDismissAnimator;
    
}

@end
