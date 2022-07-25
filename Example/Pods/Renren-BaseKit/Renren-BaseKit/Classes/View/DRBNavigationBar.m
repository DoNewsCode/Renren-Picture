//
//  DRBNavigationBar.m
//  Renren-BaseKit
//
//  Created by 陈金铭 on 2019/7/26.
//

#import "DRBNavigationBar.h"

@implementation DRBNavigationBarButton
- (void)layoutSubviews {
    [super layoutSubviews];
    switch (self.contentAlignment) {
        case DRBNavigationBarButtonContentAlignmentLeft:
            self.imageView.ct_x = 0;
            break;
            case DRBNavigationBarButtonContentAlignmentCenter:
            self.imageView.ct_x = (self.ct_width - self.imageView.ct_width) * 0.5;
            break;
            case DRBNavigationBarButtonContentAlignmentRight:
            self.imageView.ct_x = self.ct_width - self.imageView.ct_width;
            break;
            
        default:
            break;
    }
}

@end

@interface DRBNavigationBar ()

@end

@implementation DRBNavigationBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.center = self.center;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [UILabel new];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

@end
