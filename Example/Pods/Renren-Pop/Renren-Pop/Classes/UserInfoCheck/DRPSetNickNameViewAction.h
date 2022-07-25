

#import <DNPop/DNPop.h>
#import "DRPSetNickNameView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRPSetNickNameViewAction : DNPopAction

+ (instancetype)actionWithClickSureBlock:(void(^)(NSString *nickName))clickSureBlock
                          clickBackBlock:(void(^)(void))clickBackBlock;
// 设置是否显示 errorLabel 及文字
- (void)errorLabel:(BOOL)hidden text:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
