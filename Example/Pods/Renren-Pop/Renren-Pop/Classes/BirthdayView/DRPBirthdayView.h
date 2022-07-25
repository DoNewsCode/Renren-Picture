//
//  DRPBirthdayView.h
//  Renren-Pop
//
//  Created by 李晓越 on 2019/8/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPBirthdayView : UIView


- (instancetype)initWithCancelTitle:(NSString *)cancelTitle
                          doneTitle:(NSString *)doneTitle
                      selectDateStr:(NSString *)selectDateStr
                       handlerBlock:(void (^)(NSString *dateString))handlerBlock
                        cancelBlock:(void (^)(void))cancelBlock;

- (instancetype)initWithCancelTitle:(NSString *)cancelTitle
                          doneTitle:(NSString *)doneTitle
                       startDateStr:( NSString *__nullable)startDateStr
                      selectDateStr:(NSString *)selectDateStr
                       handlerBlock:(void (^)(NSString *dateString))handlerBlock
                        cancelBlock:(void (^)(void))cancelBlock;


@end

NS_ASSUME_NONNULL_END
