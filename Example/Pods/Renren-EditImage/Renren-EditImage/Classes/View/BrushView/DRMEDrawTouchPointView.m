//
//  DRMEDrawTouchPointView.m
//

#import "DRMEDrawTouchPointView.h"
#import "DRMEStroke.h"

@interface DRMEDrawTouchPointView () {
     CGMutablePathRef currentPath;//路径
}
//是否擦除
@property (nonatomic, assign) BOOL isEarse;
//存储所有的路径
@property (nonatomic, strong) NSMutableArray *stroks;
//画笔颜色
@property (nonatomic, strong) UIColor *lineColor;
//线条宽度
@property (nonatomic, assign) CGFloat lineWidth;
@end

@implementation DRMEDrawTouchPointView


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    currentPath = CGPathCreateMutable();
    DRMEStroke *stroke = [[DRMEStroke alloc] init];
    stroke.path = currentPath;
    stroke.blendMode = _isEarse ? kCGBlendModeDestinationIn : kCGBlendModeNormal;
    stroke.strokeWidth = _isEarse ? 20.0 : _lineWidth;
    stroke.lineColor = _isEarse ? [UIColor clearColor] : _lineColor;
    [_stroks addObject:stroke];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
//    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 0);
//    CGPathAddArc(currentPath, &transform, point.x, point.y, 0.1, 0, 2*M_PI, 1);
    CGPathMoveToPoint(currentPath, NULL, point.x, point.y);
//    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPathAddLineToPoint(currentPath, NULL, point.x, point.y);
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.touchesEndedBlock) {
        self.touchesEndedBlock();
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _stroks = [[NSMutableArray alloc] initWithCapacity:1];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (DRMEStroke *stroke in _stroks) {
        [stroke strokeWithContext:context];
    }
    
}


- (void)dealloc {
    CGPathRelease(currentPath);
}

/** 清屏 */
- (void)clearScreen {
    _isEarse = NO;
    [_stroks removeAllObjects];
    [self setNeedsDisplay];
}

/** 撤消操作 */
- (void)revokeScreen {
    _isEarse = NO;
    [_stroks removeLastObject];
    [self setNeedsDisplay];
}

/** 是否还有画笔，即是否还能撤销 */
- (BOOL)hasRevoke
{
    return _stroks.count ? YES : NO;
}

/** 擦除 */
- (void)eraseSreen {
    self.isEarse = YES;
}
/** 设置画笔颜色 */
- (void)setStrokeColor:(UIColor *)lineColor {
    _isEarse = NO;
    self.lineColor = lineColor;
//    [self setNeedsDisplay];
}
/** 设置画笔大小 */
- (void)setStrokeWidth:(CGFloat)lineWidth {
    _isEarse = NO;
    self.lineWidth = lineWidth;
}




@end
