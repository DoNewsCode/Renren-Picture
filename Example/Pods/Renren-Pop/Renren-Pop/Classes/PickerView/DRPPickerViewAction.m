//
//  DRPPickerViewAction.m
//  Pods
//
//  Created by 李晓越 on 2019/7/19.
//

#import "DRPPickerViewAction.h"
#import "DRPPickerView.h"

@implementation DRPPickerViewAction

+ (instancetype)actionWithTitle:(NSString *)title
                    cancelTitle:(NSString *)cancelTitle
                      doneTitle:(NSString *)doneTitle
                      listArray:(NSArray *)listArray
                   handlerBlock:(void (^)(NSInteger index, NSString *title))handlerBlock
                    cancelBlock:(void (^)(void))cancelBlock
{
    DRPPickerViewAction *customAlertAction = [[DRPPickerViewAction alloc] init];
    
    DRPPickerView *pickerView = [[DRPPickerView alloc] initWithTitle:title
                                                         cancelTitle:cancelTitle
                                                           doneTitle:doneTitle
                                                           listArray:listArray
                                                        handlerBlock:handlerBlock
                                                         cancelBlock:cancelBlock];
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = pickerView;
    
    return customAlertAction;
}

@end
