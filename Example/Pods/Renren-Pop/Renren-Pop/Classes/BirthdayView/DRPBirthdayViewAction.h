//
//  DRPBirthdayViewAction.h
//  Renren-Pop
//
//  Created by 李晓越 on 2019/8/23.
//

#import <DNPop/DNPop.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPBirthdayViewAction : DNPopAction

+ (instancetype)actionWithCancelTitle:(NSString *)cancelTitle
                            doneTitle:(NSString *)doneTitle
                        selectDateStr:(NSString *)selectDateStr
                         handlerBlock:(void (^)(NSString *dateString))handlerBlock
                          cancelBlock:(void (^)(void))cancelBlock;

+ (instancetype)actionWithCancelTitle:(NSString *)cancelTitle
                            doneTitle:(NSString *)doneTitle
                         startDateStr:(NSString *)startDateStr
                        selectDateStr:(NSString *)selectDateStr
                         handlerBlock:(void (^)(NSString *dateString))handlerBlock
                          cancelBlock:(void (^)(void))cancelBlock;
@end

NS_ASSUME_NONNULL_END
