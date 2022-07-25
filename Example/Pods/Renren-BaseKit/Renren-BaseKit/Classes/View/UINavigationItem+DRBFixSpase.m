//
//  UINavigationItem+DRBFixSpase.m
//  Renren-BaseKit
//
//  Created by 陈金铭 on 2019/8/12.
//

#import "UINavigationItem+DRBFixSpase.h"

#import <objc/runtime.h>
#import "DRBNavigationBarView.h"

@implementation UINavigationItem (DRBFixSpase)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self swizzleMethod:@selector(setLeftBarButtonItem:) swizzledSelector:@selector(sx_setLeftBarButtonItem:)];
        [self swizzleMethod:@selector(setRightBarButtonItem:) swizzledSelector:@selector(sx_setRightBarButtonItem:)];
        
    });
    
    
}

- (void)sx_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem{
    if (leftBarButtonItem.customView) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11) {
            UIView *customView = leftBarButtonItem.customView;
            DRBNavigationBarView *barView = [[DRBNavigationBarView alloc]initWithFrame:customView.bounds];
            [barView addSubview:customView];
            customView.center = barView.center;
            [barView setPosition:DRBNavigationBarViewPositionLeft];
            [self setLeftBarButtonItem:nil];
            [self sx_setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:barView]];
        }else {
            [self sx_setLeftBarButtonItem:nil];
            [self setLeftBarButtonItems:@[[self fixedSpaceWithWidth:-6], leftBarButtonItem]];
        }
    }else {
        [self setLeftBarButtonItems:nil];
        [self sx_setLeftBarButtonItem:leftBarButtonItem];
    }
}

-(void)sx_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem{
    if (rightBarButtonItem.customView) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11) {
            UIView *customView = rightBarButtonItem.customView;
            DRBNavigationBarView *barView = [[DRBNavigationBarView alloc]initWithFrame:customView.bounds];
            [barView addSubview:customView];
            customView.center = barView.center;
            [barView setPosition:DRBNavigationBarViewPositionRight];
            [self setRightBarButtonItems:nil];
            [self sx_setRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:barView]];
        } else {
            [self sx_setRightBarButtonItem:nil];
            [self setRightBarButtonItems:@[[self fixedSpaceWithWidth:-6], rightBarButtonItem]];
        }
    }else {
        [self setRightBarButtonItems:nil];
        [self sx_setRightBarButtonItem:rightBarButtonItem];
    }
}

-(UIBarButtonItem *)fixedSpaceWithWidth:(CGFloat)width {
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    fixedSpace.width = width;
    return fixedSpace;
}

+ (void)swizzleMethod:(SEL)originSelector swizzledSelector:(SEL)newSelector {
    
    Method systemMethod = class_getInstanceMethod(self, originSelector);
    Method my_Method = class_getInstanceMethod(self, newSelector);
    method_exchangeImplementations(systemMethod, my_Method);
    
    
}


@end
