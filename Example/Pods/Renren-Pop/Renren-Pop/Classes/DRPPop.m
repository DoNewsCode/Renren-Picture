//
//  DRPPop.m
//  Renren-Pop
//
//  Created by 陈金铭 on 2019/7/4.
//

#import "DRPPop.h"
#import "DNBottomShareView.h"
#import <DNPop/DNPopAction.h>
#import <YYCategories/YYCategories.h>
#import "DNBottomShareViewAction.h"
#import "DRPPickerViewAction.h"
#import "DRPActionSheetViewAction.h"
#import "DRPRealNameViewAction.h"
#import "DRPJobDatePickerViewAction.h"
#import "DNVertifyAlertViewAction.h"
#import "DRPVertionTipViewAction.h"
#import "DRPNowExperienceAction.h"
#import "DRPScoreViewAction.h"
#import "DRPBirthdayViewAction.h"
#import "DRPCitiesSheetAction.h"    // 旧
#import "DRPCitysSheetAction.h"
#import "DRPPositionViewAction.h"   // 旧
#import "DRPNewPositionViewAction.h"
#import "DRPPrivateSetingViewAction.h"
#import "DRPAbnormalAction.h"
#import "DRPActivityViewAction.h"
#import "UIImage+pop.h"
#import "DRPSetPwdOneViewAction.h"
#import "DRPSetPwdTwoViewAction.h"
#import "DRPUserInfoCheckViewAction.h"
#import "DRPSetNickNameViewAction.h"
#import "DRPSetUserNameViewAction.h"
#import "DRPUpdateSuccessViewAction.h"
#import "DRPJoinGroupAction.h"
#import "DRPPerfectInformationAction.h"

#import "IQKeyboardManager.h"

@implementation DRPPop

+ (void)showTipWithTitle:(NSString *)title message:(NSString *)message enterBlock:(void (^ __nullable)(void))enterBlock {
    DNPopStyle *alertStyle = [DNPopStyle new];
    alertStyle.dividingLine = NO;
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:title message:message preferredStyle:DNPopViewControllerStyleAlert];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSystem;
    customAlertController.dismissStyle = DNPopDismissStyleFadeOut;
    customAlertController.backgroundCancel = NO;
    
    DNPopAction *alertAction2 = [DNPopAction actionWithTitle:@"好的" style:DNPopActionStyleDefault handler:^{
        customAlertController.handler(customAlertController);
        
        if (enterBlock) {
            enterBlock();
        }
    }];
    [customAlertController addAction:alertAction2];
    [DNPop insertAlertController:customAlertController];
}

+ (void)showTipWithTitle:(NSString *)title
                 message:(NSString *)message
               btnString:(NSString *)btnString
             showBackBtn:(BOOL)showBackBtn
              enterBlock:(void (^ __nullable)(void))enterBlock
{
    
    DNPopStyle *alertStyle = [DNPopStyle new];
    
    alertStyle.alertWidth = [UIScreen mainScreen].bounds.size.width - 66;
    alertStyle.dividingLine = NO;
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleAlert];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSystem;
    customAlertController.dismissStyle = DNPopDismissStyleFadeOut;
    customAlertController.backgroundCancel = NO;
    
    DRPAbnormalAction *realNameAction = [DRPAbnormalAction actionWithTitle:title message:message btnString:btnString showBackBtn:showBackBtn clickBtnBlock:^{
        customAlertController.handler(customAlertController);
        if (enterBlock) {
            enterBlock();
        }
    } closeBlock:^{
        customAlertController.handler(customAlertController);
    }];
        
    
    realNameAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:realNameAction];
    
    [DNPop insertAlertController:customAlertController];
}

+ (void)showBottomTipViewWithMessage:(NSString *)message
                           doneTitle:(NSString *)doneTitle
{
    DNPopStyle *alertStyle = [DNPopStyle new];
    alertStyle.messageTextColor = [UIColor colorWithHexString:@"#333333"];
    alertStyle.messageFont = [UIFont systemFontOfSize:16];
    alertStyle.verticalVSpacing = 40;
    alertStyle.dividingLineColor = [UIColor colorWithHexString:@"#F5F5F5"];
    alertStyle.headerLineRightMargin = 0;
    alertStyle.headerLineLeftMargin = 0;
    alertStyle.headerLineHeight = 5;
    alertStyle.cancelTextColor = [UIColor colorWithHexString:@"#007CED"];
    alertStyle.cancelFont = [UIFont systemFontOfSize:16];
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil
                                                       message:message
                                                       preferredStyle:DNPopViewControllerStyleActionSheet];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSlideUpLinear;
    customAlertController.dismissStyle = DNPopDismissStyleSlideDown;
    
    DNPopAction *alertAction3 = [DNPopAction actionWithTitle:doneTitle style:DNPopActionStyleCancel handler:^{
        customAlertController.handler(customAlertController);
    }];
    [customAlertController addAction:alertAction3];
    [DNPop insertAlertController:customAlertController];
}


+ (void)showBottomTipViewWithTitle:(NSString *)title
                           message:(NSString *)message
                         doneTitle:(NSString *)doneTitle
                       cancelTitle:(NSString *)cancelTitle
                       handleBlock:(void(^)(NSString *title))handleBlock
{
    
    DNPopStyle *alertStyle = [DNPopStyle new];
    alertStyle.messageTextColor = [UIColor colorWithHexString:@"#333333"];
    alertStyle.messageFont = [UIFont systemFontOfSize:16];
    
    alertStyle.dividingLineColor = [UIColor colorWithHexString:@"#F5F5F5"];
    alertStyle.dividingLineHeight = 5;
    
    alertStyle.dividingLineRightMargin = 0;
    alertStyle.dividingLineLeftMargin = 0;
    
    alertStyle.headerLineRightMargin = 0;
    alertStyle.headerLineLeftMargin = 0;
    
    alertStyle.cancelTextColor = [UIColor colorWithHexString:@"#007CED"];
    alertStyle.cancelFont = [UIFont systemFontOfSize:16];
    
    alertStyle.defaultTextColor = [UIColor colorWithHexString:@"#333333"];
    alertStyle.defaultFont = [UIFont systemFontOfSize:16];
    
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:title
                                                                                       message:message preferredStyle:DNPopViewControllerStyleActionSheet];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSlideUpLinear;
    customAlertController.dismissStyle = DNPopDismissStyleSlideDown;
    
    DNPopAction *doneAction = [DNPopAction actionWithTitle:doneTitle style:DNPopActionStyleDefault handler:^{
        customAlertController.handler(customAlertController);
        if (handleBlock) {
            handleBlock(doneTitle);
        }
    }];
    [customAlertController addAction:doneAction];
    
    DNPopAction *cancelAction = [DNPopAction actionWithTitle:cancelTitle style:DNPopActionStyleCancel handler:^{
        customAlertController.handler(customAlertController);
        if (handleBlock) {
            handleBlock(cancelTitle);
        }
    }];
    [customAlertController addAction:cancelAction];
    
    [DNPop insertAlertController:customAlertController];
}


+ (void)showBottomTipViewWithTitle:(NSString *)title
                           message:(NSString *)message
                         doneTitle:(NSString *)doneTitle
                       cancelTitle:(NSString *)cancelTitle
                fromViewController:(UIViewController *)fromViewController
                       handleBlock:(void(^)(NSString *title))handleBlock
{
    
    DNPopStyle *alertStyle = [DNPopStyle new];
    alertStyle.messageTextColor = [UIColor colorWithHexString:@"#333333"];
    alertStyle.messageFont = [UIFont systemFontOfSize:16];
    
    alertStyle.dividingLineColor = [UIColor colorWithHexString:@"#F5F5F5"];
    alertStyle.dividingLineHeight = 5;
    
    alertStyle.dividingLineRightMargin = 0;
    alertStyle.dividingLineLeftMargin = 0;
    
    alertStyle.headerLineRightMargin = 0;
    alertStyle.headerLineLeftMargin = 0;
    
    alertStyle.cancelTextColor = [UIColor colorWithHexString:@"#007CED"];
    alertStyle.cancelFont = [UIFont systemFontOfSize:16];
    
    alertStyle.defaultTextColor = [UIColor colorWithHexString:@"#333333"];
    alertStyle.defaultFont = [UIFont systemFontOfSize:16];
    
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:title
                                                                                       message:message preferredStyle:DNPopViewControllerStyleActionSheet];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSlideUpLinear;
    customAlertController.dismissStyle = DNPopDismissStyleSlideDown;
    
    DNPopAction *doneAction = [DNPopAction actionWithTitle:doneTitle style:DNPopActionStyleDefault handler:^{
        customAlertController.handler(customAlertController);
        if (handleBlock) {
            handleBlock(doneTitle);
        }
    }];
    [customAlertController addAction:doneAction];
    
    DNPopAction *cancelAction = [DNPopAction actionWithTitle:cancelTitle style:DNPopActionStyleCancel handler:^{
        customAlertController.handler(customAlertController);
        if (handleBlock) {
            handleBlock(cancelTitle);
        }
    }];
    [customAlertController addAction:cancelAction];
    
    [DNPop insertFromViewController:fromViewController alertController:customAlertController];
}

+ (void)showBottomActionSheetWithTitle:(nullable NSString *)title
                               message:(NSString *)message
                            titleArray:(NSArray *)titleArray
                    lastBtnShowRedFont:(BOOL)lastBtnShowRedFont
                           handleBlock:(void(^)(NSString *title))handleBlock
{
    
    DNPopStyle *alertStyle = [DNPopStyle new];
    
    alertStyle.titleFont = [UIFont systemFontOfSize:16];
    alertStyle.titleTextColor = [UIColor colorWithHexString:@"#333333"];
    
    alertStyle.messageTextColor = [UIColor colorWithHexString:@"#333333"];
    alertStyle.messageFont = [UIFont systemFontOfSize:12];
    
    alertStyle.dividingLineColor = [UIColor colorWithHexString:@"#F5F5F5"];
    alertStyle.dividingLineHeight = 5;
    
    alertStyle.dividingLineRightMargin = 0;
    alertStyle.dividingLineLeftMargin = 0;
    
    alertStyle.headerLineRightMargin = 0;
    alertStyle.headerLineLeftMargin = 0;
    
    alertStyle.cancelTextColor = [UIColor colorWithHexString:@"#007CED"];
    alertStyle.cancelFont = [UIFont systemFontOfSize:16];
    
    alertStyle.defaultTextColor = [UIColor colorWithHexString:@"#FC3B3B"];
    alertStyle.defaultFont = [UIFont systemFontOfSize:16];
    
    DNPopViewController *customAlertController = [DNPopViewController
                                                  alertControllerWithTitle:title message:message
                                                  preferredStyle:DNPopViewControllerStyleActionSheet];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSlideUpLinear;
    customAlertController.dismissStyle = DNPopDismissStyleSlideDown;
    
    DRPActionSheetViewAction *actionSheetViewAction = [DRPActionSheetViewAction actionWithTitleArray:titleArray lastBtnShowRedFont:lastBtnShowRedFont handleBlock:^(NSString * _Nonnull title) {
        
        customAlertController.handler(customAlertController);
        
        if (handleBlock) {
            handleBlock(title);
        }
        
    }];
    
    actionSheetViewAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:actionSheetViewAction];
    
    DNPopAction *cancelAction = [DNPopAction actionWithTitle:@"取消" style:DNPopActionStyleCancel handler:^{
        customAlertController.handler(customAlertController);
    }];
    [customAlertController addAction:cancelAction];
    
    [DNPop insertAlertController:customAlertController];
}

+ (void)showBottomActionSheetWithTitle:(NSString *)title
                               message:(NSString *)message
                            titleArray:(NSArray *)titleArray
                   firstBtnShowRedFont:(BOOL)firstBtnShowRedFont
                           handleBlock:(void(^)(NSString *title))handleBlock
{
    
    DNPopStyle *alertStyle = [DNPopStyle new];
    
    alertStyle.titleFont = [UIFont systemFontOfSize:16];
    alertStyle.titleTextColor = [UIColor colorWithHexString:@"#333333"];
    
    alertStyle.messageTextColor = [UIColor colorWithHexString:@"#333333"];
    alertStyle.messageFont = [UIFont systemFontOfSize:12];
    
    alertStyle.dividingLineColor = [UIColor colorWithHexString:@"#F5F5F5"];
    alertStyle.dividingLineHeight = 5;
    
    alertStyle.dividingLineRightMargin = 0;
    alertStyle.dividingLineLeftMargin = 0;
    
    alertStyle.headerLineRightMargin = 0;
    alertStyle.headerLineLeftMargin = 0;
    
    alertStyle.cancelTextColor = [UIColor colorWithHexString:@"#007CED"];
    alertStyle.cancelFont = [UIFont systemFontOfSize:16];
    
    alertStyle.defaultTextColor = [UIColor colorWithHexString:@"#FC3B3B"];
    alertStyle.defaultFont = [UIFont systemFontOfSize:16];
    
    DNPopViewController *customAlertController = [DNPopViewController
                                                  alertControllerWithTitle:title message:message
                                                  preferredStyle:DNPopViewControllerStyleActionSheet];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSlideUpLinear;
    customAlertController.dismissStyle = DNPopDismissStyleSlideDown;
    
    DRPActionSheetViewAction *actionSheetViewAction = [DRPActionSheetViewAction actionWithTitleArray:titleArray firstBtnShowRedFont:firstBtnShowRedFont handleBlock:^(NSString * _Nonnull title) {
        
        customAlertController.handler(customAlertController);
        
        if (handleBlock) {
            handleBlock(title);
        }
        
    }];
    
    actionSheetViewAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:actionSheetViewAction];
    
    DNPopAction *cancelAction = [DNPopAction actionWithTitle:@"取消" style:DNPopActionStyleCancel handler:^{
        customAlertController.handler(customAlertController);
    }];
    [customAlertController addAction:cancelAction];
    
    [DNPop insertAlertController:customAlertController];
}


+ (void)showBottomActionSheetWithTitle:(NSString *)title
                               message:(NSString *)message
                            titleArray:(NSArray *)titleArray
                    lastBtnShowRedFont:(BOOL)lastBtnShowRedFont
                    fromViewController:(UIViewController *)fromViewController
                           handleBlock:(void(^)(NSString *title))handleBlock
{
    
    DNPopStyle *alertStyle = [DNPopStyle new];
    
    alertStyle.titleFont = [UIFont systemFontOfSize:16];
    alertStyle.titleTextColor = [UIColor colorWithHexString:@"#333333"];
    
    alertStyle.messageTextColor = [UIColor colorWithHexString:@"#333333"];
    alertStyle.messageFont = [UIFont systemFontOfSize:12];
    
    alertStyle.dividingLineColor = [UIColor colorWithHexString:@"#F5F5F5"];
    alertStyle.dividingLineHeight = 5;
    
    alertStyle.dividingLineRightMargin = 0;
    alertStyle.dividingLineLeftMargin = 0;
    
    alertStyle.headerLineRightMargin = 0;
    alertStyle.headerLineLeftMargin = 0;
    
    alertStyle.cancelTextColor = [UIColor colorWithHexString:@"#007CED"];
    alertStyle.cancelFont = [UIFont systemFontOfSize:16];
    
    alertStyle.defaultTextColor = [UIColor colorWithHexString:@"#FC3B3B"];
    alertStyle.defaultFont = [UIFont systemFontOfSize:16];
    
    DNPopViewController *customAlertController = [DNPopViewController
                                                  alertControllerWithTitle:title message:message
                                                  preferredStyle:DNPopViewControllerStyleActionSheet];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSlideUpLinear;
    customAlertController.dismissStyle = DNPopDismissStyleSlideDown;
    
    DRPActionSheetViewAction *actionSheetViewAction = [DRPActionSheetViewAction actionWithTitleArray:titleArray lastBtnShowRedFont:lastBtnShowRedFont handleBlock:^(NSString * _Nonnull title) {
        
        customAlertController.handler(customAlertController);
        
        if (handleBlock) {
            handleBlock(title);
        }
        
    }];
    
    actionSheetViewAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:actionSheetViewAction];
    
    DNPopAction *cancelAction = [DNPopAction actionWithTitle:@"取消" style:DNPopActionStyleCancel handler:^{
        customAlertController.handler(customAlertController);
    }];
    [customAlertController addAction:cancelAction];
    
    [DNPop insertFromViewController:fromViewController alertController:customAlertController];
}

+ (void)showBottomActionSheetWithTitle:(NSString *)title
                               message:(NSString *)message
                         numberOfLines:(NSInteger)numberOfLines
                            titleArray:(NSArray *)titleArray
                    lastBtnShowRedFont:(BOOL)lastBtnShowRedFont
                    fromViewController:(UIViewController *)fromViewController
                           handleBlock:(void(^)(NSString *title))handleBlock
{
    
    DNPopStyle *alertStyle = [DNPopStyle new];
    
    alertStyle.titleFont = [UIFont systemFontOfSize:16];
    alertStyle.titleTextColor = [UIColor colorWithHexString:@"#333333"];
    
    alertStyle.messageTextColor = [UIColor colorWithHexString:@"#333333"];
    alertStyle.messageFont = [UIFont systemFontOfSize:12];
    
    alertStyle.dividingLineColor = [UIColor colorWithHexString:@"#F5F5F5"];
    alertStyle.dividingLineHeight = 5;
    
    alertStyle.dividingLineRightMargin = 0;
    alertStyle.dividingLineLeftMargin = 0;
    
    alertStyle.headerLineRightMargin = 0;
    alertStyle.headerLineLeftMargin = 0;
    
    alertStyle.cancelTextColor = [UIColor colorWithHexString:@"#007CED"];
    alertStyle.cancelFont = [UIFont systemFontOfSize:16];
    
    alertStyle.defaultTextColor = [UIColor colorWithHexString:@"#FC3B3B"];
    alertStyle.defaultFont = [UIFont systemFontOfSize:16];
    
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleActionSheet];
    
//    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:title message:message numberOfLines:numberOfLines preferredStyle:DNPopViewControllerStyleActionSheet];
    
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSlideUpLinear;
    customAlertController.dismissStyle = DNPopDismissStyleSlideDown;
    
    DRPActionSheetViewAction *actionSheetViewAction = [DRPActionSheetViewAction actionWithTitle:title message:message numberOfLines:numberOfLines titleArray:titleArray lastBtnShowRedFont:lastBtnShowRedFont handleBlock:^(NSString * _Nonnull title) {
        customAlertController.handler(customAlertController);
        
        if (handleBlock) {
            handleBlock(title);
        }
    }];
    
    actionSheetViewAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:actionSheetViewAction];
    
    DNPopAction *cancelAction = [DNPopAction actionWithTitle:@"取消" style:DNPopActionStyleCancel handler:^{
        customAlertController.handler(customAlertController);
    }];
    [customAlertController addAction:cancelAction];
    
    [DNPop insertFromViewController:fromViewController alertController:customAlertController];
    
    // 外界控制 messageLabel 行数
//    UIView *alertView = [customAlertController valueForKeyPath:@"alertView"];
//    UILabel *messageLabel = [alertView valueForKeyPath:@"messageLabel"];
//    messageLabel.numberOfLines = numberOfLines;
}

+ (void)showBottomShareViewWithMoreActionType:(kMoreActionType)moreActionType
                                   shareTypes:(NSArray *)shareTypes
                                  optionTypes:(NSArray *)optionTypes
                                     popTitle:(NSString *)popTitle
                                  handleBlock:(void(^)(kMoreActionButtonType moreActionButtonType))handleBlock
{
    
    DNPopStyle *alertStyle = [DNPopStyle new];
    alertStyle.titleFont = [UIFont systemFontOfSize:16];
    alertStyle.titleTextColor = [UIColor colorWithHexString:@"333333"];
    alertStyle.headerLine = NO;
    alertStyle.dividingLineRightMargin = 0;
    alertStyle.dividingLineLeftMargin = 0;
    alertStyle.dividingLineHeight = 5;
    alertStyle.dividingLineColor = [UIColor colorWithHexString:@"F5F5F5"];
    alertStyle.cancelTextColor = [UIColor colorWithHexString:@"007CED"];
    alertStyle.cancelFont = [UIFont systemFontOfSize:16];
    
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleActionSheet];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSlideUpLinear;
    customAlertController.dismissStyle = DNPopDismissStyleSlideDown;
    

    DNBottomShareViewAction *shareViewAction = [DNBottomShareViewAction actionWithTitle:popTitle moreActionType:moreActionType shareTypes:shareTypes optionTypes:optionTypes handler:^(kMoreActionButtonType moreActionButtonType) {
        
        customAlertController.handler(customAlertController);
        if (handleBlock) {
            handleBlock(moreActionButtonType);
        }
    }];
    
    shareViewAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:shareViewAction];
    
    DNPopAction *cancelAction = [DNPopAction actionWithTitle:@"取消" style:DNPopActionStyleCancel handler:^{
        customAlertController.handler(customAlertController);
    }];
    [customAlertController addAction:cancelAction];
    
    [DNPop insertAlertController:customAlertController];
}

+ (void)showBottomShareViewWithMoreActionType:(kMoreActionType)moreActionType
                         moreActionButtonType:(kMoreActionButtonType)moreActionButtonType
                                     popTitle:(NSString *)popTitle
                                  handleBlock:(void(^)(kMoreActionButtonType moreActionButtonType))handleBlock
{
    
    DNPopStyle *alertStyle = [DNPopStyle new];
    alertStyle.titleFont = [UIFont systemFontOfSize:16];
    alertStyle.titleTextColor = [UIColor colorWithHexString:@"333333"];
    alertStyle.headerLine = NO;
//    alertStyle.verticalVSpacing = 50;
    alertStyle.dividingLineRightMargin = 0;
    alertStyle.dividingLineLeftMargin = 0;
    alertStyle.dividingLineHeight = 5;
    alertStyle.dividingLineColor = [UIColor colorWithHexString:@"F5F5F5"];
    alertStyle.cancelTextColor = [UIColor colorWithHexString:@"007CED"];
    alertStyle.cancelFont = [UIFont systemFontOfSize:16];
    
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleActionSheet];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSlideUpLinear;
    customAlertController.dismissStyle = DNPopDismissStyleSlideDown;
    

    DNBottomShareViewAction *shareViewAction = [DNBottomShareViewAction actionWithTitle:popTitle moreActionType:moreActionType moreActionButtonType:moreActionButtonType handler:^(kMoreActionButtonType moreActionButtonType) {
        
        customAlertController.handler(customAlertController);
        if (handleBlock) {
            handleBlock(moreActionButtonType);
        }
    }];
    
    shareViewAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:shareViewAction];
    
    DNPopAction *cancelAction = [DNPopAction actionWithTitle:@"取消" style:DNPopActionStyleCancel handler:^{
        customAlertController.handler(customAlertController);
    }];
    [customAlertController addAction:cancelAction];
    
    [DNPop insertAlertController:customAlertController];
}

+ (void)showBottomShareViewWithMoreActionType:(kMoreActionType)moreActionType
                         moreActionButtonType:(kMoreActionButtonType)moreActionButtonType
                                     popTitle:(NSString *)popTitle
                           fromViewController:(UIViewController *)fromViewController
                                  handleBlock:(void(^)(kMoreActionButtonType moreActionButtonType))handleBlock
{
    
    DNPopStyle *alertStyle = [DNPopStyle new];
    alertStyle.titleFont = [UIFont systemFontOfSize:16];
    alertStyle.titleTextColor = [UIColor colorWithHexString:@"333333"];
    alertStyle.headerLine = NO;
    //    alertStyle.verticalVSpacing = 50;
    alertStyle.dividingLineRightMargin = 0;
    alertStyle.dividingLineLeftMargin = 0;
    alertStyle.dividingLineHeight = 5;
    alertStyle.dividingLineColor = [UIColor colorWithHexString:@"F5F5F5"];
    alertStyle.cancelTextColor = [UIColor colorWithHexString:@"007CED"];
    alertStyle.cancelFont = [UIFont systemFontOfSize:16];
    
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleActionSheet];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSlideUpLinear;
    customAlertController.dismissStyle = DNPopDismissStyleSlideDown;
    
    
    DNBottomShareViewAction *shareViewAction = [DNBottomShareViewAction actionWithTitle:popTitle moreActionType:moreActionType moreActionButtonType:moreActionButtonType handler:^(kMoreActionButtonType moreActionButtonType) {
        
        customAlertController.handler(customAlertController);
        if (handleBlock) {
            handleBlock(moreActionButtonType);
        }
    }];
    
    shareViewAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:shareViewAction];
    
    DNPopAction *cancelAction = [DNPopAction actionWithTitle:@"取消" style:DNPopActionStyleCancel handler:^{
        customAlertController.handler(customAlertController);
    }];
    [customAlertController addAction:cancelAction];
    
    [DNPop insertFromViewController:fromViewController alertController:customAlertController];
}

+ (void)showBottomPickerViewWithTitle:(NSString *)title
                          cancelTitle:(NSString *)cancelTitle
                            doneTitle:(NSString *)doneTitle
                            listArray:(NSArray *)listArray
                         handlerBlock:(void(^)(NSInteger index, NSString * _Nonnull title))handlerBlock
{
    DNPopStyle *alertStyle = [DNPopStyle new];
    alertStyle.titleFont = [UIFont systemFontOfSize:16];
    alertStyle.titleTextColor = [UIColor colorWithHexString:@"333333"];
    alertStyle.headerLine = NO;
    //    alertStyle.verticalVSpacing = 50;
    alertStyle.dividingLineRightMargin = 0;
    alertStyle.dividingLineLeftMargin = 0;
    alertStyle.dividingLineHeight = 5;
    alertStyle.dividingLineColor = [UIColor colorWithHexString:@"F5F5F5"];
    alertStyle.cancelTextColor = [UIColor colorWithHexString:@"007CED"];
    alertStyle.cancelFont = [UIFont systemFontOfSize:16];
    
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleActionSheet];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSlideUpLinear;
    customAlertController.dismissStyle = DNPopDismissStyleSlideDown;

    
    DRPPickerViewAction *shareViewAction = [DRPPickerViewAction actionWithTitle:title cancelTitle:cancelTitle doneTitle:doneTitle listArray:listArray handlerBlock:^(NSInteger index, NSString * _Nonnull title) {
        customAlertController.handler(customAlertController);
        if (handlerBlock) {
            handlerBlock(index,title);
        }
    } cancelBlock:^{
        customAlertController.handler(customAlertController);
    }];

    shareViewAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:shareViewAction];
    [DNPop insertAlertController:customAlertController];
}


+ (void)showJobPickerViewWithTitle:(NSString *)title
                       cancelTitle:(NSString *)cancelTitle
                         doneTitle:(NSString *)doneTitle
                         isEndTime:(BOOL)isEndTime
                         startYear:(NSInteger)startYear
                      handlerBlock:(void(^)(NSString * _Nonnull resultString))handlerBlock
{
    
    DNPopStyle *alertStyle = [DNPopStyle new];
    alertStyle.titleFont = [UIFont systemFontOfSize:16];
    alertStyle.titleTextColor = [UIColor colorWithHexString:@"333333"];
    alertStyle.headerLine = NO;
    //    alertStyle.verticalVSpacing = 50;
    alertStyle.dividingLineRightMargin = 0;
    alertStyle.dividingLineLeftMargin = 0;
    alertStyle.dividingLineHeight = 5;
    alertStyle.dividingLineColor = [UIColor colorWithHexString:@"F5F5F5"];
    alertStyle.cancelTextColor = [UIColor colorWithHexString:@"007CED"];
    alertStyle.cancelFont = [UIFont systemFontOfSize:16];
    
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleActionSheet];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSlideUpLinear;
    customAlertController.dismissStyle = DNPopDismissStyleSlideDown;
    
    DRPJobDatePickerViewAction *shareViewAction = [DRPJobDatePickerViewAction actionWithTitle:title cancelTitle:cancelTitle doneTitle:doneTitle isEndTime:isEndTime startYear:startYear handlerBlock:^(NSString * _Nonnull resultString) {
        customAlertController.handler(customAlertController);
        if (handlerBlock) {
            handlerBlock(resultString);
        }
    } cancelBlock:^{
        customAlertController.handler(customAlertController);
    }];
    
    shareViewAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:shareViewAction];
    [DNPop insertAlertController:customAlertController];
}

+ (void)showRealAuthViewWithTipString:(NSString *)tipString
                            doneBlock:(void(^)(void))doneBlock
                       afterDoneBlock:(void(^)(void))afterDoneBlock
{
    DNPopStyle *alertStyle = [DNPopStyle new];
    alertStyle.backgroundColor = [UIColor clearColor];
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil
                                                                                       message:nil preferredStyle:DNPopViewControllerStyleAlert];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSystem;
    customAlertController.dismissStyle = DNPopDismissStyleFadeOut;
    
    DRPRealNameViewAction *realNameAction = [DRPRealNameViewAction actionWithTipString:tipString doneBlock:^{
        customAlertController.handler(customAlertController);
        
        if (doneBlock) {
            doneBlock();
        }
    } afterBlock:^{
        customAlertController.handler(customAlertController);
        
        if (afterDoneBlock) {
            afterDoneBlock();
        }
    }];
    
    realNameAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:realNameAction];
    
    [DNPop insertAlertController:customAlertController];
}

+ (void)showAddFriendViewWithSendBlock:(void(^)(NSString *text))sendBlock
{
    DNPopStyle *alertStyle = [DNPopStyle new];
    alertStyle.messageTextColor = [UIColor colorWithHexString:@"#333333"];
    alertStyle.messageFont = [UIFont systemFontOfSize:16];
    alertStyle.dividingLineColor = [UIColor colorWithHexString:@"#F5F5F5"];
    alertStyle.headerLineRightMargin = 0;
    alertStyle.headerLineLeftMargin = 0;
    alertStyle.headerLineHeight = 5;
    alertStyle.cancelTextColor = [UIColor colorWithHexString:@"#007CED"];
    alertStyle.cancelFont = [UIFont systemFontOfSize:16];


    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil
                                                                                       message:nil
                                                                                preferredStyle:DNPopViewControllerStyleActionSheet];
    
    
    DNVertifyAlertViewAction *realNameAction = [DNVertifyAlertViewAction actionWithTipString:@"" sendBlock:^(NSString * _Nonnull text) {
        
        customAlertController.handler(customAlertController);
        if (sendBlock) {
            sendBlock(text);
        }
    } cancelBlock:^{
        customAlertController.handler(customAlertController);
    }];

    realNameAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:realNameAction];
    
    
    
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSlideUpLinear;
    customAlertController.dismissStyle = DNPopDismissStyleSlideDown;
    
    DNPopAction *alertAction3 = [DNPopAction actionWithTitle:@"取消" style:DNPopActionStyleCancel handler:^{
        customAlertController.handler(customAlertController);
    }];
    [customAlertController addAction:alertAction3];
    [DNPop insertAlertController:customAlertController];
}

+ (void)showVersionTipViewWithTitle:(NSString *)title
                          tipString:(NSString *)tipString
                    upgradeNowBlock:(void(^)(void))upgradeNowBlock
{
    
    DNPopStyle *alertStyle = [DNPopStyle new];
    
    alertStyle.alertWidth = [UIScreen mainScreen].bounds.size.width - 66;
    
    
    alertStyle.dividingLine = NO;
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleAlert];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSystem;
    customAlertController.dismissStyle = DNPopDismissStyleFadeOut;
    customAlertController.backgroundCancel = NO;
    
    DRPVertionTipViewAction *realNameAction = [DRPVertionTipViewAction actionWithTitle:title tipString:tipString upgradeNowBlock:^{
        
        customAlertController.handler(customAlertController);
        
        if (upgradeNowBlock) {
            upgradeNowBlock();
        }
        
    } noUpgradeBlock:^{
        customAlertController.handler(customAlertController);
    }];
    
    realNameAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:realNameAction];
//    DNPopOperation *alertOperation = [DNPopOperation new];
//    alertOperation.priority = DNPopOperationQueuePriorityHigh;
//    alertOperation.fromViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
//    alertOperation.toViewController = customAlertController;
//    [DNPop insertAlertOperation:alertOperation];
    
    [DNPop insertAlertController:customAlertController];
}

+ (void)showNowExperienceViewWithTitle:(NSString *)title
                             tipString:(NSString *)tipString
                    nowExperienceBlock:(void(^)(void))nowExperienceBlock
{
    
    
    DNPopStyle *alertStyle = [DNPopStyle new];
    
    alertStyle.alertWidth = [UIScreen mainScreen].bounds.size.width - 66;
    
    
    alertStyle.dividingLine = NO;
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleAlert];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSystem;
    customAlertController.dismissStyle = DNPopDismissStyleFadeOut;
    customAlertController.backgroundCancel = NO;
    
    DRPNowExperienceAction *realNameAction = [DRPNowExperienceAction actionWithTitle:title tipString:tipString nowExperienceBlock:^{
        
//        customAlertController.handler(customAlertController);
        if (nowExperienceBlock) {
            nowExperienceBlock();
        }
    } closeBlock:^{
        
//        customAlertController.handler(customAlertController);
    }];
    
    realNameAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:realNameAction];
    
//    DNPopOperation *alertOperation = [DNPopOperation new];
//    alertOperation.priority = DNPopOperationQueuePriorityHigh;
//    alertOperation.fromViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
//    alertOperation.toViewController = customAlertController;
//    [DNPop insertAlertOperation:alertOperation];
    [DNPop insertAlertController:customAlertController];
}


+ (void)showScoreViewWithGoScoreBlock:(void(^)(void))goScoreBlock
                        feedbackBlock:(void(^)(void))feedbackBlock
{
    
    DNPopStyle *alertStyle = [DNPopStyle new];
    
    alertStyle.alertWidth = [UIScreen mainScreen].bounds.size.width - 66;
    
    
    
    alertStyle.dividingLine = NO;
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleAlert];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSystem;
    customAlertController.dismissStyle = DNPopDismissStyleFadeOut;
    customAlertController.backgroundCancel = YES;
    
    DRPScoreViewAction *realNameAction = [DRPScoreViewAction actionWithGoScoreBlock:^{
        
        customAlertController.handler(customAlertController);
        
        if (goScoreBlock) {
            goScoreBlock();
        }
        
    } feedbackBlock:^{
        
        customAlertController.handler(customAlertController);
        
        if (feedbackBlock) {
            feedbackBlock();
        }
        
    } closeBlock:^{
        
        customAlertController.handler(customAlertController);
    }];
    
    realNameAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:realNameAction];
    
    [DNPop insertAlertController:customAlertController];
}

+ (void)showDatePickerViewWithCancelTitle:(NSString *)cancelTitle
                                doneTitle:(NSString *)doneTitle
                            selectDateStr:(NSString *)selectDateStr
                             handlerBlock:(void(^)(NSString * _Nonnull dateString))handlerBlock
{
    
    [self showDatePickerViewWithCancelTitle:cancelTitle doneTitle:doneTitle startDateStr:nil selectDateStr:selectDateStr handlerBlock:handlerBlock];
}

+ (void)showDatePickerViewWithCancelTitle:(NSString *)cancelTitle
                                doneTitle:(NSString *)doneTitle
                             startDateStr:(NSString *)startDateStr
                            selectDateStr:(NSString *)selectDateStr
                             handlerBlock:(void(^)(NSString * _Nonnull dateString))handlerBlock
{
    
    DNPopStyle *alertStyle = [DNPopStyle new];
    
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleActionSheet];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSlideUpLinear;
    customAlertController.dismissStyle = DNPopDismissStyleSlideDown;
    
    
    DRPBirthdayViewAction *shareViewAction = [DRPBirthdayViewAction actionWithCancelTitle:cancelTitle doneTitle:doneTitle startDateStr:startDateStr selectDateStr:selectDateStr handlerBlock:^(NSString * _Nonnull dateString) {
        customAlertController.handler(customAlertController);
        if (handlerBlock) {
            handlerBlock(dateString);
        }
    } cancelBlock:^{
        customAlertController.handler(customAlertController);
    }];
    
    shareViewAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:shareViewAction];
    [DNPop insertAlertController:customAlertController];
}


+ (void)showHomeTownViewWithSelectProvince:(NSString *)selectProvince
                                selectCity:(NSString *)selectCity
                                 doneBlock:(void(^)(NSString *province,
                                                    NSString *cityName,
                                                    NSString *cityId,
                                                    NSString *result))doneBlock
{
    DNPopStyle *alertStyle = [DNPopStyle new];
    
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleActionSheet];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSlideUpLinear;
    customAlertController.dismissStyle = DNPopDismissStyleSlideDown;
    
    DRPCitiesSheetAction *citySheetAction = [DRPCitiesSheetAction actionWithSelectProvince:selectProvince selectCity:selectCity doneBlock:^(NSString * _Nonnull province, NSString * _Nonnull cityName, NSString * _Nonnull cityId, NSString * _Nonnull result) {
        
        customAlertController.handler(customAlertController);
        
        if (doneBlock) {
            doneBlock(province, cityName, cityId, result);
        }
    } cancelBlock:^{
        customAlertController.handler(customAlertController);
    }];
    
    citySheetAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:citySheetAction];
    [DNPop insertAlertController:customAlertController];
}

+ (void)showCityListWith:(NSString *)selectProvince
              selectCity:(NSString *)selectCity
                cityList:(NSArray *)cityList
               doneBlock:(void(^)(NSString *provinceName,
                                  NSString *cityName,
                                  NSString *provinceId,
                                  NSString *cityId,
                                  NSString *result))doneBlock
{
    DNPopStyle *alertStyle = [DNPopStyle new];
    
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleActionSheet];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSlideUpLinear;
    customAlertController.dismissStyle = DNPopDismissStyleSlideDown;
    
    DRPCitysSheetAction *citySheetAction = [DRPCitysSheetAction actionWith:selectProvince selectCity:selectCity cityList:cityList doneBlock:^(NSString *provinceName,NSString *cityName,NSString *provinceId,NSString *cityId,NSString *result) {
        
        customAlertController.handler(customAlertController);
        
        if (doneBlock) {
            doneBlock(provinceName, cityName, provinceId, cityId, result);
        }
    } cancelBlock:^{
        customAlertController.handler(customAlertController);
    }];
    
    citySheetAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:citySheetAction];
    [DNPop insertAlertController:customAlertController];
}

+ (void)showPositionViewWithResultBlock:(void(^)(NSString *classification,
                                                 NSString *positionName,
                                                 NSString *positionId))resultBlock;
{
    DNPopStyle *alertStyle = [DNPopStyle new];
    
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleActionSheet];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSlideUpLinear;
    customAlertController.dismissStyle = DNPopDismissStyleSlideDown;
    
    DRPPositionViewAction *citySheetAction = [DRPPositionViewAction actionWithResultBlock:^(NSString * _Nonnull classification, NSString * _Nonnull positionName, NSString * _Nonnull positionId) {
      
        customAlertController.handler(customAlertController);
        if (resultBlock) {
            resultBlock(classification, positionName, positionId);
        }
        
    }  HandleBlock:^(NSString * _Nonnull title) {
        
        customAlertController.handler(customAlertController);
    }];
    
    citySheetAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:citySheetAction];
    [DNPop insertAlertController:customAlertController];
}


+ (void)showPositionList:(NSArray *)positionList
             resultBlock:(void(^)(NSString *classification,
                                  NSString *positionName,
                                  NSString *positionId))resultBlock
{
    DNPopStyle *alertStyle = [DNPopStyle new];
    
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleActionSheet];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSlideUpLinear;
    customAlertController.dismissStyle = DNPopDismissStyleSlideDown;
    
    
    DRPNewPositionViewAction *citySheetAction = [DRPNewPositionViewAction actionWithPositionList:positionList resultBlock:^(NSString * _Nonnull classification, NSString * _Nonnull positionName, NSString * _Nonnull positionId) {
        customAlertController.handler(customAlertController);
        if (resultBlock) {
            resultBlock(classification, positionName, positionId);
        }
    } handleBlock:^(NSString * _Nonnull title) {
        customAlertController.handler(customAlertController);
    }];
    
    citySheetAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:citySheetAction];
    [DNPop insertAlertController:customAlertController];
}

+ (void)showPrivateSetingViewWithTitle:(NSString *)title
                            attrString:(NSMutableAttributedString *)attrString
                             btnString:(NSString *)btnString
                          toSetUpBlock:(void(^)(void))toSetUpBlock
                        clickLinkBlock:(void(^)(NSURL *URL))clickLinkBlock
{
    DNPopStyle *alertStyle = [DNPopStyle new];
    
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleAlert];
    customAlertController.backgroundCancel = NO;
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSystem;
    customAlertController.dismissStyle = DNPopDismissStyleFadeOut;
    
    DRPPrivateSetingViewAction *citySheetAction = [DRPPrivateSetingViewAction actionWithTitle:title attrString:attrString btnString:btnString toSetUpBlock:^{
        
        customAlertController.handler(customAlertController);
        if (toSetUpBlock) {
            toSetUpBlock();
        }
        
    } clickLinkBlock:^(NSURL * _Nonnull URL) {
        
        customAlertController.handler(customAlertController);
        if (clickLinkBlock) {
            clickLinkBlock(URL);
        }
    } closeBlock:^{
        customAlertController.handler(customAlertController);
    }];
    
    citySheetAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:citySheetAction];
    [DNPop insertAlertController:customAlertController];
}


+ (void)showActivityViewWith:(UIImage *)image
                handlerBlock:(void(^)(void))handlerBlock
{
    DNPopStyle *alertStyle = [DNPopStyle new];
    alertStyle.backgroundColor = [UIColor clearColor];
//    alertStyle.alertWidth = [UIScreen mainScreen].bounds.size.width;
    
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleAlert];
    customAlertController.backgroundCancel = NO;
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSystem;
    customAlertController.dismissStyle = DNPopDismissStyleFadeOut;
    
    DRPActivityViewAction *action = [DRPActivityViewAction actionWithImage:image handlerBlock:^{
        customAlertController.handler(customAlertController);
        if (handlerBlock) {
            handlerBlock();
        }
    } closeBlock:^{
        
        customAlertController.handler(customAlertController);
    }];
    
    [customAlertController addAction:action];
    [DNPop insertAlertController:customAlertController];
    
}


+ (void)showSetPwdViewWithToSetupBlock:(void(^)(void))toSetupBlock
                       laterSetupBlock:(void(^)(void))laterSetupBlock
                            closeBlock:(void(^)(void))closeBlock
{
    
    DNPopStyle *alertStyle = [DNPopStyle new];
    
    alertStyle.alertWidth = [UIScreen mainScreen].bounds.size.width - 66;
    
    alertStyle.dividingLine = NO;
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleAlert];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSystem;
    customAlertController.dismissStyle = DNPopDismissStyleFadeOut;
    customAlertController.backgroundCancel = NO;
    
    DRPSetPwdOneViewAction *setPwdAction = [DRPSetPwdOneViewAction actionWithToSetupBlock:^{
        
        customAlertController.handler(customAlertController);
        if (toSetupBlock) {
            toSetupBlock();
        }
        
    } laterSetupBlock:^{
        
        customAlertController.handler(customAlertController);
        if (laterSetupBlock) {
            laterSetupBlock();
        }
        
    } closeBlock:^{
        
        customAlertController.handler(customAlertController);
        if (closeBlock) {
            closeBlock();
        }
        
    }];
    
    setPwdAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:setPwdAction];
    
    [DNPop insertAlertController:customAlertController];
}


+ (void)showSetPwdViewWithIknowBlock:(void(^)(void))iknowBlock
{
    
    DNPopStyle *alertStyle = [DNPopStyle new];
    
    alertStyle.alertWidth = [UIScreen mainScreen].bounds.size.width - 66;
    
    alertStyle.dividingLine = NO;
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleAlert];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSystem;
    customAlertController.dismissStyle = DNPopDismissStyleFadeOut;
    customAlertController.backgroundCancel = NO;
    
    DRPSetPwdTwoViewAction *setPwdAction = [DRPSetPwdTwoViewAction actionWithIknowBlock:^{
        customAlertController.handler(customAlertController);
        if (iknowBlock) {
            iknowBlock();
        }
    } closeBlock:^{
        customAlertController.handler(customAlertController);
        if (iknowBlock) {
            iknowBlock();
        }
    }];
    
    setPwdAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:setPwdAction];
    
    [DNPop insertAlertController:customAlertController];
}

+ (void)showCheckInfoViewWithCheckType:(DRPCheckType)checkType
                        checkTypeState:(DRPCheckTypeState)checkTypeState
                   clickCheckTypeBlock:(void(^)(DRPCheckType checkType))clickCheckTypeBlock
                    clickContinueBlock:(void(^)(void))clickContinueBlock
{

    DNPopStyle *alertStyle = [DNPopStyle new];
    
    alertStyle.alertWidth = [UIScreen mainScreen].bounds.size.width - 66;
    
    alertStyle.dividingLine = NO;
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleAlert];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSystem;
    customAlertController.dismissStyle = DNPopDismissStyleFadeOut;
    customAlertController.backgroundCancel = NO;
    
    DRPUserInfoCheckViewAction *checkAction = [DRPUserInfoCheckViewAction actionWithCheckType:checkType checkTypeState:checkTypeState clickCheckTypeBlock:^(DRPCheckType checkType) {
        
        // 点了这个block，弹窗不要消失
        customAlertController.handler(customAlertController);
        if (clickCheckTypeBlock) {
            clickCheckTypeBlock(checkType);
        }
    } clickContinueBlock:^{
        customAlertController.handler(customAlertController);
        if (clickContinueBlock) {
            clickContinueBlock();
        }
        
    }];
    
    checkAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:checkAction];
    
    [DNPop insertAlertController:customAlertController];
}

+ (void)showSetNickNameWith:(void(^)(NSString *nickName,
                                     DNPopViewController *alertController))clickSureBlock
             clickBackBlock:(void(^)(void))clickBackBlock
{

    DNPopStyle *alertStyle = [DNPopStyle new];
    
    alertStyle.alertWidth = [UIScreen mainScreen].bounds.size.width - 66;
    
    alertStyle.dividingLine = NO;
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleAlert];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSystem;
    customAlertController.dismissStyle = DNPopDismissStyleFadeOut;
    customAlertController.backgroundCancel = NO;
    
    DRPSetNickNameViewAction *checkAction = [DRPSetNickNameViewAction actionWithClickSureBlock:^(NSString * _Nonnull nickName) {
        // 让外界控制消失
//        customAlertController.handler(customAlertController);
        if (clickSureBlock) {
            clickSureBlock(nickName, customAlertController);
        }
    } clickBackBlock:^{
        
        customAlertController.handler(customAlertController);
        if (clickBackBlock) {
            clickBackBlock();
        }
    }];
    
    checkAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:checkAction];
    
    [DNPop insertAlertController:customAlertController];
}

+ (void)showSetAccountWith:(NSString *)account
            clickSureBlock:(void(^)(NSString *userName,
                                    DNPopViewController *alertController))clickSureBlock
             clickBackBlock:(void(^)(void))clickBackBlock
{

    DNPopStyle *alertStyle = [DNPopStyle new];
    
    alertStyle.alertWidth = [UIScreen mainScreen].bounds.size.width - 66;
    
    alertStyle.dividingLine = NO;
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleAlert];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSystem;
    customAlertController.dismissStyle = DNPopDismissStyleFadeOut;
    customAlertController.backgroundCancel = NO;
    
    DRPSetUserNameViewAction *checkAction = [DRPSetUserNameViewAction actionWith:account clickSureBlock:^(NSString * _Nonnull userName) {
        // 让外界控制消失
//        customAlertController.handler(customAlertController);
        if (clickSureBlock) {
            clickSureBlock(userName, customAlertController);
        }
    } clickBackBlock:^{
        
        customAlertController.handler(customAlertController);
        if (clickBackBlock) {
            clickBackBlock();
        }
    }];
    
    checkAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:checkAction];
    
    [DNPop insertAlertController:customAlertController];
}

+ (void)showUpdateSuccessViewClickSureBlock:(void(^)(void))clickSureBlock
{

    DNPopStyle *alertStyle = [DNPopStyle new];
    
    alertStyle.alertWidth = [UIScreen mainScreen].bounds.size.width - 66;
    
    alertStyle.dividingLine = NO;
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleAlert];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSystem;
    customAlertController.dismissStyle = DNPopDismissStyleFadeOut;
    customAlertController.backgroundCancel = NO;
    
    DRPUpdateSuccessViewAction *checkAction = [DRPUpdateSuccessViewAction actionWithClickSureBlock:^{
        customAlertController.handler(customAlertController);
        if (clickSureBlock) {
            clickSureBlock();
        }
    }];
    
    checkAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:checkAction];
    
    [DNPop insertAlertController:customAlertController];
}

+ (void)showJoinGroupViewWith:(NSString *)groupName
                    groupDesc:(NSString *)groupDesc
                 groupIconUrl:(NSString *)groupIconUrl
                  placeholder:(NSString *)placeholder
                    joinBlock:(void (^)(NSString *joinReason))joinBlock
{
    
    DNPopStyle *alertStyle = [DNPopStyle new];
    alertStyle.alertWidth = [UIScreen mainScreen].bounds.size.width - 66;
    alertStyle.dividingLine = NO;
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleAlert];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSystem;
    customAlertController.dismissStyle = DNPopDismissStyleFadeOut;
    customAlertController.backgroundCancel = NO;
    alertStyle.backgroundColor = [UIColor clearColor];
    
    DRPJoinGroupAction *joinAction = [DRPJoinGroupAction actionWith:groupName groupDesc:groupDesc groupIconUrl:groupIconUrl placeholder:placeholder joinBlock:^(NSString * _Nonnull joinReason) {
        
        if (joinReason.length == 0) {
            [DRPPop showTextHUDWithMessage:@"请输入申请理由!"];
            return;
        }
        
        customAlertController.handler(customAlertController);
        if (joinBlock) {
            joinBlock(joinReason);
        }
        // 恢复 keyborad
        [IQKeyboardManager sharedManager].enable = NO;
        [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10;
        
    } closeBlock:^{
        customAlertController.handler(customAlertController);
        // 恢复 keyborad
        [IQKeyboardManager sharedManager].enable = NO;
        [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10;
        
    }];
    joinAction.style = DNPopActionStyleCustom;
    [customAlertController addAction:joinAction];
    [DNPop insertAlertController:customAlertController];
}

+ (void)showCustomView:(UIView *)customView {
    
    DNPopStyle *alertStyle = [DNPopStyle new];
    
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleActionSheet];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSlideUpLinear;
    customAlertController.dismissStyle = DNPopDismissStyleSlideDown;
    
    DNPopAction *Action = [[DNPopAction alloc] init];
    Action.style = DNPopActionStyleCustom;
    Action.item = customView;
    
    [customAlertController addAction:Action];
    [DNPop insertAlertController:customAlertController];
    
}

+ (void)showCenterCustomView:(UIView *)customView {
    
    DNPopStyle *alertStyle = [DNPopStyle new];
    alertStyle.backgroundColor = [UIColor clearColor];
    
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleAlert];
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSystem;
    customAlertController.dismissStyle = DNPopDismissStyleFadeOut;
    
    DNPopAction *Action = [[DNPopAction alloc] init];
    Action.style = DNPopActionStyleCustom;
    Action.item = customView;
    
    [customAlertController addAction:Action];
    [DNPop insertAlertController:customAlertController];
    
}


+ (void)showPerfectInformationViewWithHandlerBlock:(void(^)(void))handlerBlock
                                       cancleBlock:(void(^)(void))cancleBlock
{
    DNPopStyle *alertStyle = [DNPopStyle new];
    alertStyle.backgroundColor = [UIColor clearColor];
//    alertStyle.alertWidth = [UIScreen mainScreen].bounds.size.width;
    
    DNPopViewController *customAlertController = [DNPopViewController alertControllerWithTitle:nil message:nil preferredStyle:DNPopViewControllerStyleAlert];
    customAlertController.backgroundCancel = NO;
    customAlertController.alertStyle = alertStyle;
    customAlertController.presentStyle = DNPopPresentStyleSystem;
    customAlertController.dismissStyle = DNPopDismissStyleFadeOut;
    
    DRPPerfectInformationAction *action = [DRPPerfectInformationAction actionWithHandlerBlock:^{
        customAlertController.handler(customAlertController);
        if (handlerBlock) {
            handlerBlock();
        }
    } closeBlock:^{
        
        customAlertController.handler(customAlertController);

        if (cancleBlock) {
            cancleBlock();
        }
    }];
    
    [customAlertController addAction:action];
    [DNPop insertAlertController:customAlertController];
    
}

#pragma mark - HUD
+ (void)showTextHUDWithMessage:(NSString *)message
{
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    
    [SVProgressHUD showImage:[UIImage imageNamed:@""] status:message];
    
    [SVProgressHUD dismissWithDelay:3];
}

+ (void)showTextHUDWithMessage:(NSString *)message completion:(HudCompleteAction)completion
{
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    
    [SVProgressHUD showImage:[UIImage imageNamed:@""] status:message];
    
    [SVProgressHUD dismissWithDelay:3];
    if (completion) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            completion();
        });
    }
}


+ (void)showLoadingHUDWithMessage:(NSString *)message
{
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    
    // 加载中的提示框一般不要不自动dismiss，比如在网络请求，要在网络请求成功后调用 hideLoadingHUD 方法即可
    if ([message isNotBlank]) {
        [SVProgressHUD showWithStatus:message];
    }else{
        [SVProgressHUD show];
    }
}

+ (void)showLoadingHUDWithMessage:(nullable NSString *)message
                          offsetY:(CGFloat)offsetY
{
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, offsetY)];
    [self showLoadingHUDWithMessage:message];
}


+ (void)showCompletionHUDWithMessage:(NSString *)message completion:(HudCompleteAction)completion
{
    
    [SVProgressHUD setSuccessImage:[UIImage pop_imageWithName:@"pop_hud_success"]];
                                   
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    
    [SVProgressHUD showSuccessWithStatus:message];
    
    [SVProgressHUD dismissWithDelay:3];
    if (completion) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            completion();
        });
    }
    
}

+ (void)showErrorHUDWithMessage:(NSString *)message completion:(HudCompleteAction)completion
{
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setCornerRadius:5];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    
    [SVProgressHUD showErrorWithStatus:message];
    
    [SVProgressHUD dismissWithDelay:3];
    if (completion) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            completion();
        });
    }
}

+ (void)hideLoadingHUD
{
    [SVProgressHUD resetOffsetFromCenter];
    [SVProgressHUD dismiss];
}

@end
