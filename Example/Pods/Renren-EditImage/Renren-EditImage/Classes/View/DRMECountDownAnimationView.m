//
//  DRMECountDownAnimationView.m
//  SDKDemo
//
//  Created by 刘东旭 on 2018/11/16.
//  Copyright © 2018年 meishe. All rights reserved.
//

#import "DRMECountDownAnimationView.h"

@interface DRMECountDownAnimationView ()

@property (nonatomic, strong) UILabel *numLable;

@end

@implementation DRMECountDownAnimationView

- (void)dealloc {
    NSLog(@"-- %s, %d", __func__, __LINE__);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.numLable = [[UILabel alloc] initWithFrame:self.bounds];
        self.numLable.textColor = UIColor.whiteColor;
        self.numLable.text = @"3";
        self.numLable.textAlignment = NSTextAlignmentCenter;
        
        self.numLable.font = kFontMediumSize(120);
//        self.numLable.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.numLable];
    }
    return self;
}

- (void)startAnimation {
    NSLog(@"开始动画！");
    self.numLable.text = @"3";
    self.numLable.frame = self.bounds;
    self.numLable.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.numLable.hidden = NO;
    [UIView animateWithDuration:1.0 animations:^{
        self.numLable.transform = CGAffineTransformScale(self.numLable.transform, 0.5, 0.5);
    } completion:^(BOOL finished) {
        self.numLable.transform = CGAffineTransformIdentity;
        self.numLable.text = @"2";
        [UIView animateWithDuration:1.0 animations:^{
            self.numLable.transform = CGAffineTransformScale(self.numLable.transform, 0.5, 0.5);
        } completion:^(BOOL finished) {
            NSLog(@"第二次结束动画！");
            self.numLable.text = @"1";
            self.numLable.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:1.0 animations:^{
                self.numLable.transform = CGAffineTransformScale(self.numLable.transform, 0.5, 0.5);
            } completion:^(BOOL finished) {
                NSLog(@"第三次结束动画！");
                self.numLable.hidden = YES;
                self.numLable.transform = CGAffineTransformIdentity;
                if ([self.delegate respondsToSelector:@selector(countDownAnimationStopAnimationView:)]) {
                    [self.delegate countDownAnimationStopAnimationView:self];
                }
            }];
        }];

    }];
}


@end
