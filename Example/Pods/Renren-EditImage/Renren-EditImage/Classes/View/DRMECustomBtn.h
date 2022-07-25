

#import <UIKit/UIKit.h>

@interface DRMECustomBtn : UIButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType
                     withTitle:(NSString *)title
               withImageNormal:(NSString *)normal
             withImageSelected:(NSString *)selected;



+ (instancetype)buttonWithType:(UIButtonType)buttonType
                     withTitle:(NSString *)title
               withImageNormal:(NSString *)normal
             withImageSelected:(NSString *)selected
              withImageDisable:(NSString *)disabled;

/// 按钮图片
@property (nonatomic, strong) UIButton *btnImageView;
/// 按钮文字
@property (nonatomic, strong) UILabel *btnLabel;
@end

