//
//  UIView+DRIViewController.m
//  RenrenOfficial-iOS-Concept
//
//  Created by 张健康 on 2019/3/19.
//  Copyright © 2019 renren. All rights reserved.
//

#import "UIView+DRIViewController.h"

@implementation UIView (DRIViewController)

#pragma mark 获得当前view的控制器
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController
                                          class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
@end
