//
//  DRMEDrawBackgoupImageView.h
//

#import <UIKit/UIKit.h>

@interface DRMEDrawBackgoupImageView : UIImageView
+ (DRMEDrawBackgoupImageView *)initWithImage:(UIImage *)image frame:(CGRect)frame lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor;

//添加控件
- (void)addControl;
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

- (UIImage *)getImage;

/// 为了更新撤销按钮状态
@property(nonatomic,copy) void(^touchesEndedBlock)(void);

@end
