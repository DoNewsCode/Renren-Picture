//
//  DRPSetPwdOneViewAction.m
//  Pods
//
//  Created by 李晓越 on 2019/8/15.
//

#import "DRPSetPwdOneViewAction.h"
#import "DRPSetPwdOneView.h"

@implementation DRPSetPwdOneViewAction

+ (instancetype)actionWithToSetupBlock:(void(^)(void))toSetupBlock
                       laterSetupBlock:(void(^)(void))laterSetupBlock
                            closeBlock:(void(^)(void))closeBlock
{
    DRPSetPwdOneViewAction *customAlertAction = [[DRPSetPwdOneViewAction alloc] init];
    
    DRPSetPwdOneView *realNameView = [[DRPSetPwdOneView alloc] initWithToSetupBlock:toSetupBlock laterSetupBlock:laterSetupBlock closeBlock:closeBlock];
    
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = realNameView;
    
    return customAlertAction;
}

@end
