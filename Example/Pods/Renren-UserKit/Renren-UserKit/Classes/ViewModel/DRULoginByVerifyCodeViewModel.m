//
//  DRULoginByVerifyCodeViewModel.m
//  Renren-Personal
//
//  Created by 李晓越 on 2019/9/11.
//

#import "DRULoginByVerifyCodeViewModel.h"
#import "DRULoginByVerifyCodeRequest.h"
#import "DRUClientLoginModel.h"
#import <YYCategories.h>

@interface DRULoginByVerifyCodeViewModel ()

@property(nonatomic,strong) DRUClientLoginModel *clientLoginModel;
@property(nonatomic,strong) DRULoginByVerifyCodeRequest *loginByVerifyCodeRequest;

@end

@implementation DRULoginByVerifyCodeViewModel

- (DRULoginByVerifyCodeRequest *)loginByVerifyCodeRequest
{
    if (!_loginByVerifyCodeRequest) {
        _loginByVerifyCodeRequest = [[DRULoginByVerifyCodeRequest alloc] init];
    }
    return _loginByVerifyCodeRequest;
}

- (void)loginByVerfyCodeWithUser:(NSString *)user
                 sms_verify_code:(NSString *)sms_verify_code
                      verifycode:(NSString *)verifycode
                       ickCookie:(NSString *)ickCookie
             is_confirm_unfreeze:(NSString *)is_confirm_unfreeze
                         is_mine:(NSInteger)is_mine
                    successBlock:(void(^)(NSInteger errorCode,
                                          NSString *error_msg,
                                          id response))successBlock
                    failureBlock:(void(^)(NSString *errorStr))failureBlock
{
    self.loginByVerifyCodeRequest.user = user;
    self.loginByVerifyCodeRequest.sms_verify_code = sms_verify_code;
    self.loginByVerifyCodeRequest.ick = ickCookie;
    self.loginByVerifyCodeRequest.verifycode = verifycode;
    self.loginByVerifyCodeRequest.is_confirm_unfreeze = is_confirm_unfreeze;
    self.loginByVerifyCodeRequest.is_mine = is_mine;
    
    [self.loginByVerifyCodeRequest lodaDataWithSuccessBlock:^(id  _Nonnull response) {
        
        // 为了保存CookieInfo，在内存中保留了下信息
        self.clientLoginModel = [DRUClientLoginModel yy_modelWithJSON:response];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:response];
        NSString *uuidString = self.loginByVerifyCodeRequest.UUIDString;
        [dict setObject:uuidString forKey:@"uniq_id"];
        
        if (successBlock) {
            successBlock(0, @"", dict);
        }
        
    } faileBlock:^(NSString * _Nonnull error_msg, id  _Nonnull response) {
        
        NSInteger error_code = [[response objectForKey:@"error_code"] integerValue];
        NSDictionary *extraMsg = [response objectForKey:@"extraMsg"];
        
        // BOOL isFreeze, NSString *imageCodeUrl,
        // BOOL isOldUser, NSString *error_msg, id response
        if (error_code == 10001) {
            // 新用户、未注册过
            if (successBlock) {
                successBlock(error_code, @"新用户注册", nil);
            }
        } else if (error_code == 10003) {
            if (successBlock) {
                successBlock(error_code, @"用户已经被冻结", nil);
            }
        } else if (error_code == 10004) {
            if (failureBlock) {
                successBlock(error_code, @"用户已经被封禁", extraMsg);
            }
        } else if (error_code == 10005) {
            if (failureBlock) {
                successBlock(error_code, @"用户已经被注销", extraMsg);
            }
        } else if (error_code == 10021) {
            // 老用户登陆//时间节点小于A
            // 老用户 好久没有登录过了
            if (successBlock) {
                successBlock(error_code, @"老用户登录", response);
            }
        } else if (error_code == 100011) {
            if (successBlock) {
                successBlock(error_code, @"用户已被冻结", extraMsg);
            }
        } else {
            if (failureBlock) {
                failureBlock(error_msg);
            }
        }
    }];
}

@end
