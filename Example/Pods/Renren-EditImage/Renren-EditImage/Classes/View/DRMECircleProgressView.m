//
//  DRMECircleProgressView.m
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/5.
//

#import "DRMECircleProgressView.h"

@implementation DRMECircleProgressView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initData];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder   {
    self = [super initWithCoder:aDecoder] ;
    if(self) {
        [self initData];
    }
    return self;
}

/** 初始化数据*/
- (void)initData
{
    self.progressWidth = 3.0;
    self.progressColor = [UIColor redColor];
    self.progressBackgroundColor = [UIColor grayColor];
    self.percent = 0.0;
    self.clockwise =0;
    
    self.labelbackgroundColor = [UIColor clearColor];
    self.textColor = [UIColor blackColor];
    self.textFont = [UIFont systemFontOfSize:15];
}

- (void)layoutSubviews
{
    [super addSubview:self.centerLabel];
    self.centerLabel.backgroundColor = self.labelbackgroundColor;
    self.centerLabel.textColor = self.textColor;
    self.centerLabel.font = self.textFont;
    [self addSubview:self.centerLabel];
}

#pragma mark -- 画进度条

- (void)drawRect:(CGRect)rect
{
    //获取当前画布
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetShouldAntialias(context, YES);
    CGContextAddArc(context, self.width/2, self.height/2, (self.width-self.progressWidth)/2, 0, M_PI*2, 0);
    [self.progressBackgroundColor setStroke];//设置圆描边背景的颜色
    //画线的宽度
    CGContextSetLineWidth(context, self.progressWidth);
    //绘制路径
    CGContextStrokePath(context);
    
    if(self.percent)
    {
        CGFloat angle = 2 * self.percent * M_PI - M_PI_2;
        if(self.clockwise) {//反方向
            CGContextAddArc(context, self.width/2, self.height/2, (self.width-self.progressWidth)/2, ((int)self.percent == 1 ? -M_PI_2 : angle), -M_PI_2, 0);
        }
        else {//正方向
            CGContextAddArc(context, self.width/2, self.height/2, (self.width-self.progressWidth)/2, -M_PI_2, angle, 0);
        }
        [self.progressColor setStroke];//设置圆描边的颜色
        CGContextSetLineWidth(context, self.progressWidth);
        CGContextStrokePath(context);
    }
}

- (void)setPercent:(float)percent
{
    if(self.percent < 0) return;
    
    _percent = percent;
    
    [self setNeedsDisplay];
}

- (UILabel *)centerLabel
{
    if(!_centerLabel)
    {
        _centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height/2)];
        _centerLabel.center = CGPointMake(self.width/2, self.height/2);
        _centerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _centerLabel;
}



@end
