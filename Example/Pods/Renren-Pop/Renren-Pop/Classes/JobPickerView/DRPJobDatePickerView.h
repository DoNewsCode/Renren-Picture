//
//  DRPJobDatePickerView.h
//  Pods
//
//  Created by 李晓越 on 2019/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPJobDatePickerView : UIView


/**
 创建一个选择日期的pickerView，适用于选择 入职时间 和 结束时间
 @param title 标题
 @param cancelTitle 取消文字
 @param doneTitle 确定文字
 @param isEndTime 是否选择的是结束时间
 @param startYear 当时结束时间时，要传开始时间过来，要计算结束时间范围
 @param handlerBlock 成功回调
 @param cancelBlock 取消回调
 */
- (instancetype)initWithTitle:(NSString *)title
                  cancelTitle:(NSString *)cancelTitle
                    doneTitle:(NSString *)doneTitle
                    isEndTime:(BOOL)isEndTime
                    startYear:(NSInteger)startYear
                 handlerBlock:(void (^)(NSString *resulString))handlerBlock
                  cancelBlock:(void (^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
