//
//  DRUClientLoginViewModel.h
//  RenRenRecallModule
//
//  Created by donews on 2019/1/18.
//  Copyright © 2019年 donews. All rights reserved.
//


@class DRUClientLoginModel;

NS_ASSUME_NONNULL_BEGIN

@interface DRUClientLoginViewModel : NSObject

/// 正常的登录接口
- (void)loadDataWithAccount:(NSString *)account
                   password:(NSString *)password
                 verifycode:(NSString *)verifycode
                  ickCookie:(NSString *)ickCookie
                   isverify:(NSInteger)isverify
          bind_phone_number:(NSString *)bind_phone_number
        bind_mobile_captcha:(NSString *)bind_mobile_captcha
        is_confirm_unfreeze:(NSString *)is_confirm_unfreeze
        is_mobile_still_use:(NSString *)is_mobile_still_use
        is_confirm_conflict:(NSInteger)is_confirm_conflict
                verifycode7:(NSString *)verifycode7
               successBlock:(void(^)(NSInteger errorCode,
                                     NSString *error_msg,
                                     id response))successBlock
               failureBlock:(void(^)(NSString *errorStr))failureBlock;
@end

NS_ASSUME_NONNULL_END
