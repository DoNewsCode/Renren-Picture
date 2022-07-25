//
//  DRPNowExperienceAction.m
//  Pods
//
//  Created by 李晓越 on 2019/8/15.
//

#import "DRPUpdateSuccessViewAction.h"


@implementation DRPUpdateSuccessViewAction

+ (instancetype)actionWithClickSureBlock:(void(^)(void))clickSureBlock
{
    DRPUpdateSuccessViewAction *customAlertAction = [[DRPUpdateSuccessViewAction alloc] init];
    
    DRPUpdateSuccessView *realNameView = [[DRPUpdateSuccessView alloc] initWithClickSureBlock:clickSureBlock];
    
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = realNameView;
    
    return customAlertAction;
}

@end
