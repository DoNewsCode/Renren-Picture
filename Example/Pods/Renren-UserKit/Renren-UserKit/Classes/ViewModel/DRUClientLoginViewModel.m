//
//  DRUClientLoginViewModel.m
//  RenRenRecallModule
//
//  Created by donews on 2019/1/18.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DRUClientLoginViewModel.h"
#import "DRUClientLoginRequest.h"
#import "DRUClientLoginModel.h"
//#import "DNImageVerificationCodeView.h"
//#import "DRUAccountManager.h"
//#import <YYCategories.h>
#import <YYCategories/YYCategories.h>

//#import <Crashlytics/Crashlytics.h>
//#import "RHCShortVideoDiskCacheManger.h"

@interface DRUClientLoginViewModel()

@property(nonatomic,strong) DRUClientLoginRequest *clientLoginRequest;
@property(nonatomic,copy) NSString *account;
@property(nonatomic,strong) DRUClientLoginModel *clientLoginModel;

@end

@implementation DRUClientLoginViewModel

#pragma mark - 懒加载
- (DRUClientLoginModel *)clientLoginModel
{
    if (!_clientLoginModel) {
        _clientLoginModel = [[DRUClientLoginModel alloc] init];
    }
    return _clientLoginModel;
}

- (DRUClientLoginRequest *)clientLoginRequest
{
    if (!_clientLoginRequest) {
        _clientLoginRequest = [[DRUClientLoginRequest alloc] init];
    }
    return _clientLoginRequest;
}

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
               failureBlock:(nonnull void (^)(NSString * _Nonnull))failureBlock
{
    
    // 记录 account
    self.account = account;
    
    self.clientLoginRequest.user = account;
    self.clientLoginRequest.password = [password md5String];
    self.clientLoginRequest.verifycode = verifycode;
    self.clientLoginRequest.ick = ickCookie;
    self.clientLoginRequest.isNeedH5Auth = 5;
    self.clientLoginRequest.isverify = isverify;
    
    self.clientLoginRequest.bind_phone_number = bind_phone_number;
    self.clientLoginRequest.bind_mobile_captcha = bind_mobile_captcha;
    
    self.clientLoginRequest.is_confirm_unfreeze = is_confirm_unfreeze;
    self.clientLoginRequest.is_mobile_still_use = is_mobile_still_use;
    self.clientLoginRequest.is_confirm_conflict = is_confirm_conflict;
    
    self.clientLoginRequest.verifycode7 = verifycode7;
    
    
    [self.clientLoginRequest lodaDataWithSuccessBlock:^(id  _Nonnull response) {
        
        // 为了保存CookieInfo，在内存中保留了下信息
        self.clientLoginModel = [DRUClientLoginModel yy_modelWithJSON:response];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:response];
        NSString *uuidString = self.clientLoginRequest.UUIDString;
        [dict setObject:uuidString forKey:@"uniq_id"];

        if (successBlock) {
            successBlock(0, @"", dict);
        }
        // 添加 cookie
        [self setCookieInfo];
        
    } faileBlock:^(NSString * _Nonnull error_msg, id  _Nonnull response) {
                
        NSInteger error_code = [[response objectForKey:@"error_code"] integerValue];
        NSDictionary *extraMsg = [response objectForKey:@"extraMsg"];
        
        // 判断是否需要 输入验证码
        if (error_code == 10001 || error_code == 10002) {
            if (successBlock) {
                successBlock(error_code, @"账号或密码错误", nil);
            }
        } else if (error_code == 10003) {
            if (successBlock) {
                successBlock(error_code, @"用户已经被冻结", nil);
            }
        } else if (error_code == 10004) {
            if (successBlock) {
                successBlock(error_code, @"用户已经被封禁", extraMsg);
            }
        } else if (error_code == 10005) {
            if (successBlock) {
                successBlock(error_code, @"用户已经注销", extraMsg);
            }
        } else if (error_code == 10006) {
            if (successBlock) {
                successBlock(error_code, @"请输入验证码", nil);
            }
        } else if (error_code == 10008) {
            if (successBlock) {
                successBlock(error_code, @"手机号过旧提示", extraMsg);
            }
        } else if (error_code == 10009) {
            if (successBlock) {
                successBlock(error_code, @"您的输入有误", nil);
            }
        } else if (error_code == 10101) {
            if (successBlock) {
                successBlock(error_code, @"请绑定手机号", extraMsg);
            }
        } else if (error_code == 100011) {
            if (successBlock) {
                successBlock(error_code, @"用户已被冻结", extraMsg);
            }
        } else if (error_code == 100012) {
            if (successBlock) {
                successBlock(error_code, @"用户已被冻结7", extraMsg);
            }
        } else {
            if (failureBlock) {
                failureBlock(error_msg);
            }
        }
    }];
}

- (void)setCookieInfo
{
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
   
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.clientLoginModel.t) {
        [dict setObject:self.clientLoginModel.t forKey:@"t"];
    }
    
    if (self.clientLoginModel._uij) {
        [dict setObject:self.clientLoginModel._uij forKey:@"_uij"];
    }
    
    if (self.clientLoginModel.Path) {
        [dict setObject:self.clientLoginModel.Path forKey:@"Path"];
    }
    
    if (self.clientLoginModel.Domain) {
        [dict setObject:self.clientLoginModel.Domain forKey:@"Domain"];
    }
    
    if (self.clientLoginModel.maxAge) {
        [dict setObject:@(self.clientLoginModel.maxAge) forKey:@"maxAge"];
    }
    
    if (self.clientLoginModel.renren_id) {
        [dict setObject:@(self.clientLoginModel.renren_id) forKey:@"id"];
    }
    
    if (self.clientLoginModel._rtk) {
        [dict setObject:self.clientLoginModel._rtk forKey:@"_rtk"];
    }
    
    NSHTTPCookie *ickCookie = [NSHTTPCookie cookieWithProperties:dict];
    
    [storage setCookie:ickCookie];
    
}

@end
