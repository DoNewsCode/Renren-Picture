
#import <UIKit/UIKit.h>
#import "DRPPopConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRPSetUserNameView : UIView

- (instancetype)initWith:(NSString *)account
          clickSureBlock:(void(^)(NSString *userName))clickSureBlock
          clickBackBlock:(void(^)(void))clickBackBlock;

// 设置是否显示 errorLabel 及文字
- (void)errorLabel:(BOOL)hidden text:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
