//
//  DRPICLoadingView.m
//  Renren-Picture
//
//  Created by 陈金铭 on 2019/9/24.
//

#import "DRPICLoadingView.h"

#import "UIView+CTLayout.h"

@interface DRPICLoadingView ()

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end

@implementation DRPICLoadingView

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.fillColor = [[UIColor clearColor] CGColor];
        UIColor *blueColor = [UIColor colorWithRed:58/255.0 green:131/255.0 blue:245/255.0 alpha:1];
        _progressLayer.strokeColor = [blueColor CGColor];
        _progressLayer.opacity = 1;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.lineWidth = 5;
        
        [_progressLayer setShadowColor:[UIColor blackColor].CGColor];
        [_progressLayer setShadowOffset:CGSizeMake(1, 1)];
        [_progressLayer setShadowOpacity:0.5];
        [_progressLayer setShadowRadius:2];
        
    }
    
    return self;
}

#pragma mark - Override Methods

#pragma mark - Intial Methods

#pragma mark - Create Methods

#pragma mark - Process Methods

#pragma mark - Event Methods

#pragma mark - Public Methods

#pragma mark - LazyLoad Methods

- (void)drawRect:(CGRect)rect {
    CGPoint center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    CGFloat radius = rect.size.width / 2;
    CGFloat startA = - M_PI_2;
    CGFloat endA = - M_PI_2 + M_PI * 2 * _progress;
    _progressLayer.frame = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    _progressLayer.path =[path CGPath];
    
    [_progressLayer removeFromSuperlayer];
    [self.layer addSublayer:_progressLayer];
}

- (void)setProgress:(double)progress {
    
    progress = progress > 0.02 ? progress : 0.02;
    
    _progress = progress;
    [self setNeedsDisplay];
}

@end
