//
//  DRMEDrawBackgoupImageView.m
//

#import "DRMEDrawBackgoupImageView.h"
#import "DRMEDrawTouchPointView.h"

@interface DRMEDrawBackgoupImageView()
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) DRMEDrawTouchPointView *drawView;
@end

@implementation DRMEDrawBackgoupImageView

+ (DRMEDrawBackgoupImageView *)initWithImage:(UIImage *)image frame:(CGRect)frame lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor {
    DRMEDrawBackgoupImageView *backGourp = [[DRMEDrawBackgoupImageView alloc] initWithFrame:frame];
    backGourp.image = image;
    backGourp.lineColor = lineColor;
    backGourp.lineWidth = lineWidth;
    return backGourp;
}
//添加控件
- (void)addControl {
    _drawView = [[DRMEDrawTouchPointView alloc] initWithFrame:self.bounds];
    [self addSubview:_drawView];
    self.userInteractionEnabled = YES;
    
    self.lineColor = self.lineColor;
    self.lineWidth = self.lineWidth;
    
    WeakSelf(self)
    _drawView.touchesEndedBlock = ^{
        if (weakself.touchesEndedBlock) {
            weakself.touchesEndedBlock();
        }
    };
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self setStrokeColor:lineColor];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self setStrokeWidth:lineWidth];
}

/** 清屏 */
- (void)clearScreen {
    [_drawView clearScreen];
}

/** 撤消操作 */
- (void)revokeScreen {
    [_drawView revokeScreen];
}

/** 是否还有画笔，即是否还能撤销 */
- (BOOL)hasRevoke
{
    return [_drawView hasRevoke];
}

/** 擦除 */
- (void)eraseSreen {
    [_drawView eraseSreen];
}

/** 设置画笔颜色 */
- (void)setStrokeColor:(UIColor *)lineColor {
    [_drawView setStrokeColor:lineColor];
}

/** 设置画笔大小 */
- (void)setStrokeWidth:(CGFloat)lineWidth {
    [_drawView setStrokeWidth:lineWidth];
}

/** 获取图片 */
- (UIImage *)getImage {
    
    //1.开启一个位图上下文
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 1);
    //2.把画板上的内容渲染到上下文当中
    CGContextRef ctx =  UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    //3.从上下文当中取出一张图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //4.关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
