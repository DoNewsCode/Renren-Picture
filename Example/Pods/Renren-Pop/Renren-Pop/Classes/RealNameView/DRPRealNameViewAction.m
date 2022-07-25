//
//  DRPRealNameViewAction.m
//  Pods
//
//  Created by 李晓越 on 2019/8/2.
//

#import "DRPRealNameViewAction.h"
#import "DRPRealNameView.h"

@implementation DRPRealNameViewAction

+ (instancetype)actionWithTipString:(NSString *)tipString doneBlock:(void(^)(void))doneBlock afterBlock:(void(^)(void))afterBlock
{
    DRPRealNameViewAction *customAlertAction = [[DRPRealNameViewAction alloc] init];
    
    DRPRealNameView *realNameView = [[DRPRealNameView alloc] initWithTipString:tipString doneBlock:doneBlock afterBlock:afterBlock];
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = realNameView;
    
    return customAlertAction;
}

@end
