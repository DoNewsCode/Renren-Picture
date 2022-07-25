

#import "DRPSetUserNameViewAction.h"


@implementation DRPSetUserNameViewAction


+ (instancetype)actionWith:(NSString *)account
            clickSureBlock:(void(^)(NSString *userName))clickSureBlock
            clickBackBlock:(void(^)(void))clickBackBlock
{
    DRPSetUserNameViewAction *customAlertAction = [[DRPSetUserNameViewAction alloc] init];
    
    DRPSetUserNameView *realNameView = [[DRPSetUserNameView alloc] initWith:account clickSureBlock:clickSureBlock clickBackBlock:clickBackBlock];
    
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = realNameView;
    
    return customAlertAction;
}

// 设置是否显示 errorLabel 及文字
- (void)errorLabel:(BOOL)hidden text:(NSString *)text
{
    DRPSetUserNameView *view = (DRPSetUserNameView *)self.item;
    [view errorLabel:hidden text:text];
}

@end
