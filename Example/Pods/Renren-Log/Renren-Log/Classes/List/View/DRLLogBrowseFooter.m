//
//  DRLLogBrowseFooter.m
//  Renren-Log
//
//  Created by Ming on 2020/1/15.
//

#import "DRLLogBrowseFooter.h"

@implementation DRLLogBrowseFooter

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [UILabel new];
        self.titleLabel = titleLabel;
        titleLabel.text = @"加载更多日志";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:titleLabel];
        titleLabel.frame = self.frame;
    }
    return self;
}


@end
