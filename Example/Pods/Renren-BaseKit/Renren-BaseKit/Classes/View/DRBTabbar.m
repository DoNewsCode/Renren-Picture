//
//  DRBTabbar.m
//  Renren-BaseKit
//
//  Created by 陈金铭 on 2019/7/24.
//

#import "DRBTabbar.h"

@implementation DRBTabbar

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.customLayout) {
        return;
    }
    CGFloat margin = 20.;
    CGFloat itemWidth = (self.ct_width - 2 * margin) / self.tabbarItems.count;
    
    for (NSInteger i = 0; i < self.tabbarItems.count; i++) {
        DRBTabbarItem *tabbatItem = self.tabbarItems[i];
        tabbatItem.frame = (CGRect){margin + (i * itemWidth),0,itemWidth,self.ct_height};
        [self addSubview:tabbatItem];
    }
//    self.de
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    
}

- (NSMutableArray<DRBTabbarItem *> *)tabbarItems {
    if (!_tabbarItems) {
        NSMutableArray<DRBTabbarItem *> *tabbarItems = [NSMutableArray<DRBTabbarItem *> array];
        _tabbarItems = tabbarItems;
    }
    return _tabbarItems;
}

@end
