//
//  DNRecallCountRequest.m
//  RenRenRecallModule
//
//  Created by donews on 2019/1/15.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DRMEBaseGlobalRequest.h"
#import "DRMEConfig.h"
#import "DRUAccountManager.h"
#import "DRMEBaseModel.h"
#import <YYCategories/YYCategories.h>
#import "DRSAppInfo.h"

#import "DRMERequestManger.h"
#import "NSString+DRNNetwork.h"
#import "NSString+SafeKit.h"

@interface DRMEBaseGlobalRequest()

@property(nonatomic,copy) NSString *session_key;

@end

@implementation DRMEBaseGlobalRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        DRSAppInfo *appInfo = [DRSAppInfo sharedInstance];
        self.app_id = appInfo.companyAppID;
        self.api_key = appInfo.companyOpApiKey;
        self.session_key = [DRUAccountManager sharedInstance].currentUser.userLoginInfo.session_key;
        
        self.version = [UIApplication sharedApplication].appVersion;
        self.uniq_id = [DRUAccountManager sharedInstance].currentUser.userLoginInfo.uniq_id;
        self.uniq_key = [DRUAccountManager sharedInstance].currentUser.userLoginInfo.uniq_key;
        
        self.client_info = [NSString ct_parameterClientInfo];

    }
    return self;
}

//  重写了 DNRequest 的 parametersDictionary，为了增加 sig 参数
- (NSDictionary *)parametersDictionary
{
    NSMutableDictionary *parmas = [self yy_modelToJSONObject];

    [parmas setObject:@"json" forKey:@"ajax-type"];
    
    /// 这个是 用户登录后保存的 secret_key
    NSString *userSecretKey = [DRUAccountManager sharedInstance].currentUser.userLoginInfo.secret_key;
    NSString *sig = [NSString signatureWithQuery:parmas opSecretKey:userSecretKey];
    if ([sig isNotBlank]) {
        [parmas setObject:sig forKey:@"sig"];
    }
    
    return parmas;
}


- (void)lodaDataWithSuccessBlock:(void(^)(id response))successBlock
                      faileBlock:(void(^)(NSString *error_msg,
                                          DRMEBaseModel *baseModel))failureBlock
{
    if ([[DRMERequestManger shareManager] hasRequestClass:self]) {
        return;
    } else {
        [[DRMERequestManger shareManager] addRequest:self];
    }

    [self startWithSuccess:^(DNResponse *response) {
        
        [[DRMERequestManger shareManager] removeRequest:self];
        DNLog(@"\n\n------------------------\n请求接口成功：%@ \n返回结果如下：\n%@------------------------\n\n", self, response.responseObject);
        /*
         MMP 有的接口返回的 responseObject 是 code、message、data，例如验证账号是否已注册
         MMP 有的接口返回的 responseObject 直接是个模型，例如登录
         */
        DRMEBaseModel *baseModel = [DRMEBaseModel yy_modelWithJSON:response.responseObject];
        
            // 返回值的 error_code 是否为0
            if (baseModel.error_code == 0) {
                
                // 如果data 为nil ,说明 responseObject 就是一个对象，直接返回给使用者
                if (baseModel.data == nil) {
                    if (successBlock) {
                        // 如果data「为」nil 返回 responseObject
                        successBlock(response.responseObject);
                    }
                } else {
                    if (successBlock) {
                        // 如果data「不为」nil 返回 data
                        successBlock(baseModel.data);
                    }
                }
                
            } else {
                if (failureBlock) {
                    // 将 error_msg 和 baseModel 返回给 viewModel
                    // 有的需要根据 根据 baseModel 中 error_code 来处理业务
                    if (baseModel.error_code == 102) {
                        // 不返回错误信息 // 防止黑色提示弹窗
                    } else {
                        failureBlock(baseModel.error_msg, baseModel);
                    }
                }
            }
        
    } failure:^(NSError *error) {
        
        [[DRMERequestManger shareManager] removeRequest:self];
        
        DNLog(@"\n\n------------------------\n请求接口失败：%@ \n 返回结果如下：\n %@\n------------------------\n\n", self, error);
        if (failureBlock) {
            
#if defined(DEBUG) && DEBUG
            failureBlock(error.description, nil);
#else
            NSString *errorStr = error.userInfo[@"NSLocalizedDescription"];
            failureBlock(errorStr, nil);
#endif
        }
    }];
}

- (NSString *)printUrlAndParmas
{
    NSString *url = self.completeUrl;
    NSDictionary *dict = self.parametersDictionary;
    
    NSString *paramStr = @"?";
    NSArray *keyArray = [self.parametersDictionary allKeys];
    
    for (NSString *key in keyArray) {
        
        paramStr = [paramStr stringByAppendingString:
                    [NSString stringWithFormat:@"%@=%@",
                     key, [dict objectForKey:key]]];
        
        if (![key isEqualToString:[keyArray lastObject]]) {
            paramStr = [paramStr stringByAppendingString:@"&"];
        }
    }
    paramStr = [paramStr stringByAppendingString:@"#"];
    
    return [NSString stringWithFormat:
            @"\n url ===== %@%@ \n", url, paramStr];
}

- (NSString *)description
{
    return [self printUrlAndParmas];
}

@end


