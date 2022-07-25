//
//  DRPAbnormalAction.h
//  Renren-Pop
//
//  Created by 李晓越 on 2019/11/15.
//

#import <DNPop/DNPop.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPAbnormalAction : DNPopAction

+ (instancetype)actionWithTitle:(NSString *)title
                        message:(NSString *)message
                      btnString:(NSString *)btnString
                    showBackBtn:(BOOL)showBackBtn
                  clickBtnBlock:(void (^)(void))clickBtnBlock
                     closeBlock:(void(^)(void))closeBlock;
@end

NS_ASSUME_NONNULL_END
