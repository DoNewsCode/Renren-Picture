//
//  DRPActionSheetViewAction.m
//  Pods
//
//  Created by 李晓越 on 2019/8/2.
//

#import "DRPActionSheetViewAction.h"
#import "DRPActionSheetView.h"

@implementation DRPActionSheetViewAction

+ (instancetype)actionWithTitleArray:(NSArray *)titleArray
                      lastBtnShowRedFont:(BOOL)lastBtnShowRedFont
                             handleBlock:(void(^)(NSString *title))handleBlock
{
    DRPActionSheetViewAction *customAlertAction = [[DRPActionSheetViewAction alloc] init];
    
    //    customAlertAction.customHandler = handler;
    
    DRPActionSheetView *pickerView = [[DRPActionSheetView alloc] initWithTitleArray:titleArray lastBtnShowRedFont:lastBtnShowRedFont handleBlock:handleBlock];
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = pickerView;
    
    return customAlertAction;
}


+ (instancetype)actionWithTitle:(NSString *)title
                        message:(NSString *)message
                  numberOfLines:(NSInteger)numberOfLines
                     titleArray:(NSArray *)titleArray
             lastBtnShowRedFont:(BOOL)lastBtnShowRedFont
                    handleBlock:(void(^)(NSString *title))handleBlock
{
    DRPActionSheetViewAction *customAlertAction = [[DRPActionSheetViewAction alloc] init];
    
    
    DRPActionSheetView *pickerView = [[DRPActionSheetView alloc] initWithTitle:title message:message numberOfLines:numberOfLines titleArray:titleArray lastBtnShowRedFont:lastBtnShowRedFont handleBlock:handleBlock];
    
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = pickerView;
    
    return customAlertAction;
}

+ (instancetype)actionWithTitleArray:(NSArray *)titleArray
                     firstBtnShowRedFont:(BOOL)firstBtnShowRedFont
                             handleBlock:(void(^)(NSString *title))handleBlock
{
    DRPActionSheetViewAction *customAlertAction = [[DRPActionSheetViewAction alloc] init];
    
    //    customAlertAction.customHandler = handler;
    
    DRPActionSheetView *pickerView = [[DRPActionSheetView alloc] initWithTitleArray:titleArray firstBtnShowRedFont:firstBtnShowRedFont handleBlock:handleBlock];
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = pickerView;
    
    return customAlertAction;
}

@end
