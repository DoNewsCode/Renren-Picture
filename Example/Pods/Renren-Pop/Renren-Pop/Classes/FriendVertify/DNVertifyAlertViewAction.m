//
//  DNVertifyAlertViewAction.m
//  Pods
//
//  Created by 李晓越 on 2019/8/12.
//

#import "DNVertifyAlertViewAction.h"
#import "DNVertifyAlertView.h"

@implementation DNVertifyAlertViewAction

+ (instancetype)actionWithTipString:(NSString *)tipString
                          sendBlock:(void(^)(NSString *text))sendBlock
                        cancelBlock:(void(^)(void))cancelBlock
{
    DNVertifyAlertViewAction *customAlertAction = [[DNVertifyAlertViewAction alloc] init];
    
    DNVertifyAlertView *realNameView = [[DNVertifyAlertView alloc] initWithTitle:@"" desc:@"" placeholder:@"占位文字"];
    realNameView.clickSendEventBlock = sendBlock;
    realNameView.clickCancelEventBlock = cancelBlock;
    
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = realNameView;
    
    return customAlertAction;
}

@end
