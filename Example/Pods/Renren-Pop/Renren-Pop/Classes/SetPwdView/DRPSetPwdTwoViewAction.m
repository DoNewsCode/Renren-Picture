//
//  DRPSetPwdTwoViewAction.m
//  Pods
//
//  Created by 李晓越 on 2019/8/15.
//

#import "DRPSetPwdTwoViewAction.h"
#import "DRPSetPwdTwoView.h"

@implementation DRPSetPwdTwoViewAction

+ (instancetype)actionWithIknowBlock:(void(^)(void))iknowBlock
                          closeBlock:(void(^)(void))closeBlock
{
    DRPSetPwdTwoViewAction *customAlertAction = [[DRPSetPwdTwoViewAction alloc] init];
    
    DRPSetPwdTwoView *realNameView = [[DRPSetPwdTwoView alloc] initWithIknowBlock:iknowBlock closeBlock:closeBlock];
    
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = realNameView;
    
    return customAlertAction;
}

@end
