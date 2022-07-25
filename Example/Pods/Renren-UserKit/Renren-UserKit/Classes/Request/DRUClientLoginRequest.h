//
//  DRUClientLoginRequest.h
//  RenRenRecallModule
//
//  Created by donews on 2019/1/18.
//  Copyright © 2019年 donews. All rights reserved.
//  登录接口

#import "DRUUserBaseGlobalRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRUClientLoginRequest : DRUUserBaseGlobalRequest

@property(nonatomic,copy) NSString *user;
@property(nonatomic,copy) NSString *password;
@property(nonatomic,copy) NSString *verifycode;
@property(nonatomic,copy) NSString *ick;
@property(nonatomic,assign) NSInteger isNeedH5Auth;

/// 是否需要注册和最后登录时间，传 1 表示需要
@property(nonatomic,assign) NSInteger needRegisterAndLoginTime;

/// 是否支持图形验证码，需要传 1
@property(nonatomic,assign) NSInteger isverify;

/// 重置密码后，再调用登录接口，需要传 keep_orig = 1  和 account
@property(nonatomic,assign) NSInteger keep_orig;

/// 登录接口传递此参数，其它接口传递登录接口返回的某个字段
@property(nonatomic,copy) NSString *client_info;

/// 1.0.5需求中新增的参数  绑定的手机和验证码
@property(nonatomic,copy) NSString *bind_phone_number;
@property(nonatomic,copy) NSString *bind_mobile_captcha;


/** 用户同意解冻并继续需要重新调登录并多传参数 is_confirm_unfreeze=1 表示同意解冻并继续 */
@property(nonatomic,copy) NSString *is_confirm_unfreeze;
/** 点击手机号仍在使用需要传1 */
@property(nonatomic,copy) NSString *is_mobile_still_use;
/// 强制解绑 传 1
@property(nonatomic,assign) NSInteger is_confirm_conflict;
/// 冻结7时，传此验证码
@property(nonatomic,copy) NSString *verifycode7;

- (NSString *)UUIDString;

@end

NS_ASSUME_NONNULL_END
