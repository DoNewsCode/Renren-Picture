//
//  DRMEDrawTouchPointView.h
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DRMEDrawTouchPointView : UIView
/** 清屏 */
- (void)clearScreen;
/** 撤消操作 */
- (void)revokeScreen;
/** 是否还有画笔，即是否还能撤销 */
- (BOOL)hasRevoke;
/** 擦除 */
- (void)eraseSreen;
/** 设置画笔颜色 */
- (void)setStrokeColor:(UIColor *)lineColor;
/** 设置画笔大小 */
- (void)setStrokeWidth:(CGFloat)lineWidth;

@property(nonatomic,copy) void(^touchesEndedBlock)(void);

@end
