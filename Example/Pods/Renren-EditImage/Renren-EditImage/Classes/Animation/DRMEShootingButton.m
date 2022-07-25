//
//  DRMEShootingButton.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/3/25.
//

#import "DRMEShootingButton.h"

static const CGFloat BORDERLAYER_WIDTH = 80;
static const CGFloat CENTERLAYER_WIDTH = 60;
static const CGFloat BORDERWIDTH_FROM = 5;
static const CGFloat BORDERWIDTH_TO = 10;
static NSString *const BORDERWIDTH_ANIMATION_KEY = @"borderScaleAnimation";

@interface DRMEShootingButton ()

@property (nonatomic ,strong) CALayer *centerlayer;
@property (nonatomic, strong) CALayer *borderLayer;

@end

@implementation DRMEShootingButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}
#pragma mark - 私有方法
- (void)borderAnimaton{
    CABasicAnimation *animation = [CABasicAnimation animation];
//    animation.keyPath = @"borderWidth";
    animation.keyPath = @"transform.scale";
    animation.repeatCount = FLT_MAX;
    animation.removedOnCompletion = NO;
    animation.duration = 0.6;
    animation.fromValue = @(1);
    animation.toValue = @(1.37);
    animation.fillMode = kCAFillModeBackwards;
    animation.autoreverses = YES;
    [self.borderLayer addAnimation:animation forKey:BORDERWIDTH_ANIMATION_KEY];
}

#pragma mark - 公开方法
- (void)scaleAnimation{
        
    [UIView animateWithDuration:0.5 animations:^{
        self.centerlayer.transform = CATransform3DMakeScale(0.7, 0.7, 1);
        self.borderLayer.transform = CATransform3DMakeScale(1.37, 1.37, 1);
    } completion:^(BOOL finished) {
        [self borderAnimaton];
    }];
}
- (void)resetAnimation{
    
    [self.borderLayer removeAnimationForKey:BORDERWIDTH_ANIMATION_KEY];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.borderLayer.borderWidth = BORDERWIDTH_FROM;
        self.borderLayer.transform = CATransform3DIdentity;
        self.centerlayer.transform = CATransform3DIdentity;
    }];
}
#pragma mark - 初始化视图
- (void)setupUI{
    
    // 红色边框
    CALayer *borderLayer = [CALayer layer];
    borderLayer.backgroundColor = [UIColor clearColor].CGColor;
    borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    borderLayer.bounds = CGRectMake(0, 0, BORDERLAYER_WIDTH, BORDERLAYER_WIDTH);
    borderLayer.cornerRadius = BORDERLAYER_WIDTH / 2.0;
    borderLayer.masksToBounds = YES;

    // 原
    borderLayer.borderColor = [UIColor colorWithHexString:@"#FF64A0"].CGColor;
    borderLayer.borderWidth = BORDERWIDTH_FROM;
    [self.layer addSublayer:borderLayer];
    _borderLayer = borderLayer;

    
    CAGradientLayer *borderGradientLayer = [CAGradientLayer layer];
    borderGradientLayer.frame = borderLayer.bounds;
    borderGradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FF64A0"].CGColor,
                                   (__bridge id)[UIColor colorWithHexString:@"#FF8960"].CGColor];
   
    _borderLayer.mask = borderGradientLayer;
//    [_borderLayer addSublayer:borderGradientLayer];
    
    
    // 红色中心
    CALayer *centerlayer = [CALayer layer];
    centerlayer.backgroundColor = [UIColor colorWithHexString:@"#FF64A0"].CGColor;
    centerlayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    centerlayer.bounds = CGRectMake(0, 0, CENTERLAYER_WIDTH, CENTERLAYER_WIDTH);
    centerlayer.cornerRadius = CENTERLAYER_WIDTH / 2.0;
    centerlayer.masksToBounds = YES;
    [self.layer addSublayer:centerlayer];
    _centerlayer = centerlayer;

    // 中心渐变
    CAGradientLayer *centerGradientLayer = [CAGradientLayer layer];
    centerGradientLayer.frame = centerlayer.bounds;
    centerGradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FF64A0"].CGColor,
                                   (__bridge id)[UIColor colorWithHexString:@"#FF8960"].CGColor];
    [centerlayer addSublayer:centerGradientLayer];
    
}
@end
