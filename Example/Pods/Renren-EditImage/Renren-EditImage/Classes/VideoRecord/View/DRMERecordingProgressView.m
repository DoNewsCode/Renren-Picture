//
//  DRMERecordingProgressView.m
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/5.
//

#import "DRMERecordingProgressView.h"

@interface DRMERecordingProgressView ()
{
    CABasicAnimation *animation;
}
//存放动态创建的进度条
@property (strong, nonatomic) NSMutableArray *viewsArray;
//存放动态创建的闪烁图标
@property (strong, nonatomic) NSMutableArray *flickerArray;
//每段的末尾坐标
@property (strong, nonatomic) NSMutableArray *pointxNums;
@property (assign, nonatomic) int64_t value;
@property (assign, nonatomic) NSUInteger getCount;

@property(nonatomic,weak) UIView *bgView;
@property(nonatomic,weak) UILabel *progressLabel;

@end

@implementation DRMERecordingProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor clearColor];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 6)];
        bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.26];
        [self addSubview:bgView];
        self.bgView = bgView;
        
        // 进度条提示文字
        UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, 20, 14)];
        progressLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        progressLabel.textColor = [UIColor colorWithHexString:@"#FF0000"];
        progressLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:progressLabel];
        self.progressLabel = progressLabel;
                
        self.viewsArray = [NSMutableArray new];
        self.flickerArray = [NSMutableArray new];
        self.pointxNums = [NSMutableArray new];
        [self.pointxNums addObject:@(0)];
        self.status = End;
    }
    return self;
}

- (void)beginProgress
{
    if ((self.status != End) && (self.status != Prepare)) {
        return;
    }
    //每次开始移除上一个打点视图的动画
    UIView *lastflicker = [self.flickerArray lastObject];
    [lastflicker.layer removeAllAnimations];
    UIView *lastView = [self.viewsArray lastObject];
    lastView.backgroundColor = [UIColor colorWithHexString:@"#FF0000"];
    //[UIColor colorWithRed:248/255.0 green:231/255.0 blue:28/255.0 alpha:1/1.0];
    [lastView.layer removeAllAnimations];
    
    //创建视频进度视图
    UIView *view = [UIView new];
    view.backgroundColor =  [UIColor colorWithHexString:@"#FF0000"];
    [self.bgView addSubview:view];
    [self.bgView sendSubviewToBack:view];
    //创建视图，并加入数组中
    [self.viewsArray addObject:view];
    self.getCount = self.viewsArray.count;
    self.status = Start;
    
}
//动态改变view的宽度
- (void)currentValue:(int64_t)value {
    if (value > TotalTime) {
        value = TotalTime;
    }
    UIView *currentView = [self.viewsArray lastObject];
    int64_t lastPointx = [[self.pointxNums lastObject] longLongValue];
    float currentStart = (double)lastPointx/TotalTime*self.width;
    float valueScale = (double)value/TotalTime;
    currentView.frame = CGRectMake(currentStart, 0, self.width*valueScale-currentStart, self.bgView.height);
    
    int64_t seconds = (value/10000000);
    self.progressLabel.right = currentView.right + 1;
    self.progressLabel.text = [NSString stringWithFormat:@"%llds", seconds];
    
    self.value = value;
    self.status = Progressing;
}
//把currentStart改为上一次末尾的值，并创建闪动图标
- (void)endProgress {
    if (self.status != Progressing) {
        return;
    }
    //记录没次起始位置的坐标
    [self.pointxNums addObject:@(self.value)];
    //记录打点起始位置
    float currentStart = (double)self.value/TotalTime*self.width;
    //创建闪烁视图
    UIView *view= [UIView new];
    [self.bgView addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(currentStart-1, 0, 3, self.bgView.height);
    //开始闪烁
    [self.flickerArray addObject:view];
//    [self autoFlickView:view];
    self.status = End;
}

- (void)prepareDelete {
    if (self.status != End) {
        return;
    }
    self.status = Prepare;
    //打点视图停止闪烁
    UIView *lastflicker = [self.flickerArray lastObject];
    [lastflicker.layer removeAllAnimations];
    //视频片段开始闪烁
    UIView *lastView = [self.viewsArray lastObject];
//    [self autoFlickView:lastView];
    
}

- (void)deleteProgress {
    if (self.status != Prepare) {
        return;
    }
    
    UIView *lastflicker = [self.flickerArray lastObject];
    UIView *lastView = [self.viewsArray lastObject];
    
    //移除保存的数据
    [self.viewsArray removeLastObject];
    self.getCount = self.viewsArray.count;
    [self.flickerArray removeLastObject];
    [self.pointxNums removeLastObject];
    
    //移除视图
    [lastView removeFromSuperview];
    [lastflicker removeFromSuperview];
    
    self.value = [self.pointxNums.lastObject integerValue];
    
    //让上一个标记点闪动
//    [self autoFlickView:[self.flickerArray lastObject]];
    self.status = End;
    
}

//闪烁view
- (void)autoFlickView:(UIView *)view
{
    animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = 0.5;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:animation forKey:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];

//    self.redView.frame = CGRectMake(self.frame.size.width/5-1.5, 0, 3, self.frame.size.height);
//    [self bringSubviewToFront:self.redView];
    
}

- (int64_t)getValue {
    int64_t per = [[self.pointxNums lastObject] longLongValue];
    return per;
}

- (BOOL)singleRecordingOverFifteen {
    int64_t per = [[self.pointxNums lastObject] longLongValue];
    if (per == TotalTime && self.pointxNums.count == 2) {
        return YES;
    } else {
        return NO;
    }
}

- (void)dealloc {
    animation = nil;
}

- (int64_t)getMinRecordTime
{
    return MinRecordTime;
}


@end
