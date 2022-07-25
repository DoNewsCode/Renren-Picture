//
//  DRPJobDatePickerViewAction.m
//  Pods
//
//  Created by 李晓越 on 2019/7/19.
//

#import "DRPJobDatePickerViewAction.h"
#import "DRPJobDatePickerView.h"

@implementation DRPJobDatePickerViewAction

+ (instancetype)actionWithTitle:(NSString *)title
                    cancelTitle:(NSString *)cancelTitle
                      doneTitle:(NSString *)doneTitle
                      isEndTime:(BOOL)isEndTime
                      startYear:(NSInteger)startYear
                   handlerBlock:(void (^)(NSString *resultTitle))handlerBlock
                    cancelBlock:(void (^)(void))cancelBlock
{
    DRPJobDatePickerViewAction *customAlertAction = [[DRPJobDatePickerViewAction alloc] init];
    
    DRPJobDatePickerView *pickerView = [[DRPJobDatePickerView alloc] initWithTitle:title
                                                               cancelTitle:cancelTitle
                                                                 doneTitle:doneTitle
                                                                isEndTime:isEndTime
                                                                startYear:startYear
                                                              handlerBlock:handlerBlock
                                                               cancelBlock:cancelBlock];
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = pickerView;
    
    return customAlertAction;
}

@end
