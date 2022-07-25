//
//  DRPJobDatePickerViewAction.h
//  Pods
//
//  Created by 李晓越 on 2019/7/19.
//

#import <DNPop/DNPopAction.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPJobDatePickerViewAction : DNPopAction

+ (instancetype)actionWithTitle:(NSString *)title
                    cancelTitle:(NSString *)cancelTitle
                      doneTitle:(NSString *)doneTitle
                      isEndTime:(BOOL)isEndTime
                      startYear:(NSInteger)startYear
                   handlerBlock:(void (^)(NSString *resultTitle))handlerBlock
                    cancelBlock:(void (^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
