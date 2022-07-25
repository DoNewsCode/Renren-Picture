//
//  DRBBaseTabBarController.m
//  Pods
//
//  Created by Ming on 2019/4/16.
//

#import "DRBBaseTabBarController.h"

@interface DRBBaseTabBarControllerView : UIView
    
@end

@implementation DRBBaseTabBarControllerView

- (void)bringSubviewToFront:(UIView *)view {
    [super bringSubviewToFront:view];
}
    
    
@end

@interface DRBBaseTabBarController ()

@property(nonatomic, assign) BOOL onceCreate;
    
@end

@implementation DRBBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCustomTabbar];
    //1.KVO监听系统Tabbar隐藏
    //1.创建一个与系统tabbar一样大的tabbar；
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.onceCreate == YES) {
        return;
    }
    [self createCustomTabbarItem];
    
    [self createTabbarItemEvent];
    if (self.customTabbar.tabbarItems == nil || self.customTabbar.tabbarItems.count < 1) {
        return;
    }
    NSUInteger index = self.selectedIndex < self.customTabbar.tabbarItems.count ? self.selectedIndex : 0;
    DRBTabbarItem *tabbarItem = self.customTabbar.tabbarItems[index];
    tabbarItem.animationView.animationProgress = 1;
    [tabbarItem removeFromSuperview];
    [self.customTabbar addSubview:tabbarItem];
    self.onceCreate = YES;
    
    [self.tabBar bringSubviewToFront:self.customTabbar];
}

- (void)createCustomTabbar {
    self.customTabbar.frame = self.tabBar.bounds;
    [self.tabBar addSubview:self.customTabbar];
}

- (void)createCustomTabbarItem {
    
}

- (void)createTabbarItemEvent {
    for (NSInteger i = 0; i < self.customTabbar.tabbarItems.count; i++) {
        DRBTabbarItem *item = self.customTabbar.tabbarItems[i];
        UITapGestureRecognizer *customTabbarGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(eventCustomTabbarClick:)];
        [item addGestureRecognizer:customTabbarGestureRecognizer];
    }
}

#pragma mark - Private Methods
- (void)eventCustomTabbarClick:(UIGestureRecognizer*)gestureRecognizer {
    DRBTabbarItem *item = (DRBTabbarItem *)gestureRecognizer.view;
    if (self.customTabbar.delegate) {
        [self.customTabbar.delegate customTabBar:self.customTabbar didSelectItem:item];
    }
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
}

- (DRBTabbar *)customTabbar {
    if (!_customTabbar) {
        DRBTabbar *customTabbar = [DRBTabbar new];
        _customTabbar = customTabbar;
    }
    return _customTabbar;
}


@end



