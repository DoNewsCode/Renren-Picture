//
//  DRPBirthdayViewAction.m
//  Renren-Pop
//
//  Created by 李晓越 on 2019/8/23.
//

#import "DRPBirthdayViewAction.h"
#import "DRPBirthdayView.h"

@implementation DRPBirthdayViewAction


+ (instancetype)actionWithCancelTitle:(NSString *)cancelTitle
                            doneTitle:(NSString *)doneTitle
                        selectDateStr:(NSString *)selectDateStr
                         handlerBlock:(void (^)(NSString *dateString))handlerBlock
                          cancelBlock:(void (^)(void))cancelBlock
{
    
    
    return [self actionWithCancelTitle:cancelTitle doneTitle:doneTitle startDateStr:nil selectDateStr:selectDateStr handlerBlock:handlerBlock cancelBlock:cancelBlock];
}

+ (instancetype)actionWithCancelTitle:(NSString *)cancelTitle
                            doneTitle:(NSString *)doneTitle
                         startDateStr:(NSString *)startDateStr
                        selectDateStr:(NSString *)selectDateStr
                         handlerBlock:(void (^)(NSString *dateString))handlerBlock
                          cancelBlock:(void (^)(void))cancelBlock
{
    DRPBirthdayViewAction *customAlertAction = [[DRPBirthdayViewAction alloc] init];
    
    DRPBirthdayView *pickerView = [[DRPBirthdayView alloc] initWithCancelTitle:cancelTitle doneTitle:doneTitle startDateStr:startDateStr selectDateStr:selectDateStr handlerBlock:handlerBlock cancelBlock:cancelBlock];
    
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = pickerView;
    
    return customAlertAction;
}

@end
