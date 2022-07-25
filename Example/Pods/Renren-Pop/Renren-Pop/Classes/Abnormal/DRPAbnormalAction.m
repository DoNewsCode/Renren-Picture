//
//  DRPAbnormalAction.m
//  Renren-Pop
//
//  Created by 李晓越 on 2019/11/15.
//

#import "DRPAbnormalAction.h"
#import "DRPAbnormalView.h"

@implementation DRPAbnormalAction

+ (instancetype)actionWithTitle:(NSString *)title
                        message:(NSString *)message
                      btnString:(NSString *)btnString
                    showBackBtn:(BOOL)showBackBtn
                  clickBtnBlock:(void (^)(void))clickBtnBlock
                     closeBlock:(void(^)(void))closeBlock
{
    DRPAbnormalAction *customAlertAction = [[DRPAbnormalAction alloc] init];
       
    DRPAbnormalView *realNameView = [[DRPAbnormalView alloc] initWithTitle:title message:message btnString:btnString showBackBtn:showBackBtn clickBtnBlock:clickBtnBlock closeBlock:closeBlock];
       customAlertAction.style = DNPopActionStyleCustom;
       customAlertAction.item = realNameView;
       
       return customAlertAction;
}

@end
