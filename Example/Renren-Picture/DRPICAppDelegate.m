//
//  DRPICAppDelegate.m
//  Renren-Picture
//
//  Created by 418589912@qq.com on 08/26/2019.
//  Copyright (c) 2019 418589912@qq.com. All rights reserved.
//

#import "DRPICAppDelegate.h"

#import "DRPICViewController.h"
#import "DRPICTestPickerViewController.h"

@implementation DRPICAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    UITabBarController *mainTabBarController = [UITabBarController new];
    DRPICViewController *viewController = [DRPICViewController new];
    UIColor *color = nil;
    if (@available(iOS 13.0, *)) {
        color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            switch (traitCollection.userInterfaceStyle) {
                case UIUserInterfaceStyleLight:
                    return [UIColor whiteColor];
                    case UIUserInterfaceStyleDark:
                    return [UIColor darkGrayColor];
                default:
                    return [UIColor whiteColor];
            }
            
        }];
        
    } else {
         color = [UIColor whiteColor];
    }
    mainTabBarController.view.backgroundColor = color;
    viewController.view.backgroundColor = color;
    UINavigationController *navigationController = [UINavigationController new];
    [navigationController addChildViewController:viewController];
    
    DRPICTestPickerViewController *testPickerController = [DRPICTestPickerViewController new];
    UINavigationController *pickerNavigationController = [UINavigationController new];
    [pickerNavigationController addChildViewController:testPickerController];


    [mainTabBarController addChildViewController:navigationController];
    [mainTabBarController addChildViewController:pickerNavigationController];
    navigationController.title = @"图片浏览组件";
    pickerNavigationController.title = @"图片选择器";
    self.window.rootViewController = mainTabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
