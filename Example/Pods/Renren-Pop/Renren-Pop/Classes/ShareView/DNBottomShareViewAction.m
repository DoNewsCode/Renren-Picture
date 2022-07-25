//
//  DNBottomShareViewAction.m
//  Pods
//
//  Created by 李晓越 on 2019/7/10.
//

#import "DNBottomShareViewAction.h"
#import "DNBottomShareView.h"

@implementation DNBottomShareViewAction


+ (instancetype)actionWithTitle:(NSString *)title
                 moreActionType:(kMoreActionType)moreActionType
           moreActionButtonType:(kMoreActionButtonType)moreActionButtonType
                        handler:(void (^ __nullable)(kMoreActionButtonType moreActionButtonType))handler
{
    DNBottomShareViewAction *customAlertAction = [[DNBottomShareViewAction alloc] init];
    customAlertAction.customHandler = handler;
    
    DNBottomShareView *shareView = [[DNBottomShareView alloc] initWithMoreActionType:moreActionType moreActionButtonType:moreActionButtonType popTitle:title];
    
    shareView.clickButtonBlock = ^(kMoreActionButtonType moreActionButtonType) {
        if (handler) {
            handler(moreActionButtonType);
        }
    };
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = shareView;
    
    return customAlertAction;
}

+ (instancetype)actionWithTitle:(NSString *)title
                 moreActionType:(kMoreActionType)moreActionType
                     shareTypes:(NSArray *)shareTypes
                    optionTypes:(NSArray *)optionTypes
                        handler:(void (^ __nullable)(kMoreActionButtonType moreActionButtonType))handler
{
    DNBottomShareViewAction *customAlertAction = [[DNBottomShareViewAction alloc] init];
    customAlertAction.customHandler = handler;
    
    DNBottomShareView *shareView = [[DNBottomShareView alloc] initWithMoreActionType:moreActionType shareTypes:shareTypes optionTypes:optionTypes popTitle:title];
    
    shareView.clickButtonBlock = ^(kMoreActionButtonType moreActionButtonType) {
        if (handler) {
            handler(moreActionButtonType);
        }
    };
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = shareView;
    
    return customAlertAction;
}

@end
