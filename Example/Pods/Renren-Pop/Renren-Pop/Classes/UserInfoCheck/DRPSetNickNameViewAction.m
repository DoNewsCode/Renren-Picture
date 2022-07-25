

#import "DRPSetNickNameViewAction.h"


@implementation DRPSetNickNameViewAction


+ (instancetype)actionWithClickSureBlock:(void(^)(NSString *nickName))clickSureBlock
                          clickBackBlock:(void(^)(void))clickBackBlock
{
    DRPSetNickNameViewAction *customAlertAction = [[DRPSetNickNameViewAction alloc] init];
    
    DRPSetNickNameView *realNameView = [[DRPSetNickNameView alloc] initWithClickSureBlock:clickSureBlock clickBackBlock:clickBackBlock];
    
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = realNameView;
    
    return customAlertAction;
}

// 设置是否显示 errorLabel 及文字
- (void)errorLabel:(BOOL)hidden text:(NSString *)text
{
    DRPSetNickNameView *realNameView = (DRPSetNickNameView*)self.item;
    [realNameView errorLabel:hidden text:text];
}

@end
