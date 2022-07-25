//
//  DRMEBaseViewController.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/4/2.
//

#import "DRMEBaseViewController.h"
#import <DNCommonKit/UINavigationController+FDFullscreenPopGesture.h>

@interface DRMEBaseViewController ()

@end

@implementation DRMEBaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // 禁止左滑返回
    self.fd_interactivePopDisabled = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
}

- (void)dealloc
{
    NSLog(@"-- %s, %d", __func__, __LINE__);
}

@end
