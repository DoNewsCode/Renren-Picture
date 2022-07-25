//
//  DRPNowExperienceAction.m
//  Pods
//
//  Created by 李晓越 on 2019/8/15.
//

#import "DRPUserInfoCheckViewAction.h"


@implementation DRPUserInfoCheckViewAction

+ (instancetype)actionWithCheckType:(DRPCheckType)checkType
                     checkTypeState:(DRPCheckTypeState)checkTypeState
                clickCheckTypeBlock:(void(^)(DRPCheckType checkType))clickCheckTypeBlock
                 clickContinueBlock:(void(^)(void))clickContinueBlock
{
    DRPUserInfoCheckViewAction *customAlertAction = [[DRPUserInfoCheckViewAction alloc] init];
    
    DRPUserInfoCheckView *realNameView = [[DRPUserInfoCheckView alloc] initWithCheckType:checkType checkTypeState:checkTypeState clickCheckTypeBlock:clickCheckTypeBlock clickContinueBlock:clickContinueBlock];
    
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = realNameView;
    
    return customAlertAction;
}

@end
