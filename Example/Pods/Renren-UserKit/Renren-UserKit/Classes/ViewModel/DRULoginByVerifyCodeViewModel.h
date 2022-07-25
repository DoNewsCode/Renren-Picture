//
//  DRULoginByVerifyCodeViewModel.h
//  Renren-Personal
//
//  Created by 李晓越 on 2019/9/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRULoginByVerifyCodeViewModel : NSObject

- (void)loginByVerfyCodeWithUser:(NSString *)user
                 sms_verify_code:(NSString *)sms_verify_code
                      verifycode:(NSString *)verifycode
                       ickCookie:(NSString *)ickCookie
             is_confirm_unfreeze:(NSString *)is_confirm_unfreeze
                         is_mine:(NSInteger)is_mine
                    successBlock:(void(^)(NSInteger errorCode,
                                          NSString *error_msg,
                                          id response))successBlock
                    failureBlock:(void(^)(NSString *errorStr))failureBlock;

@end

NS_ASSUME_NONNULL_END
