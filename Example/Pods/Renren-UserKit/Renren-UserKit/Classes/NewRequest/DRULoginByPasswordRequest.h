//
//  DRULoginByPasswordRequest.h
//  Renren-UserKit
//
//  Created by 李晓越 on 2020/6/5.
//  UserKit中只提供最简单的登录方法，目的是给其它组件提供登录服务

#import "DRUUserBaseGlobalRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRULoginByPasswordRequest : DRUUserBaseGlobalRequest

/** 账号 */
@property(nonatomic,copy) NSString *user;

/** 密码 */
@property(nonatomic,copy) NSString *password;

@end

NS_ASSUME_NONNULL_END
