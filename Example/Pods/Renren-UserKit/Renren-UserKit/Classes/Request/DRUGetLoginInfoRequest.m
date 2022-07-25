//
//  DRUGetLoginInfoRequest.m
//  Renren-UserKit
//
//  Created by 李晓越 on 2020/4/22.
//

#import "DRUGetLoginInfoRequest.h"
#import <YYCategories/YYCategories.h>
#import "NSString+SafeKit.h"
#import "NSString+DRNNetwork.h"
#import "NSString+CTDate.h"
#import "DRSAppInfo.h"

@implementation DRUGetLoginInfoRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        DRSAppInfo *appInfo = [DRSAppInfo sharedInstance];
        self.app_id = appInfo.companyAppID;
        self.api_key = appInfo.companyOpApiKey;
        
        
        self.client_info = [NSString ct_parameterClientInfo];
        self.version = [UIApplication sharedApplication].appVersion;
        self.v = @"1.0";
    }
    return self;
}

- (NSString *)call_id
{
    return [NSString ct_timeStampForNow];
}


//  重写了 DNRequest 的 parametersDictionary，为了增加 sig 参数
- (NSDictionary *)parametersDictionary
{
    NSMutableDictionary *parmas = [self yy_modelToJSONObject];
    
    /// 删除 secret_key
    [parmas removeObjectForKey:@"secret_key"];
    
    /// 这个是 用户登录后保存的 secret_key
    NSString *secret_key = self.secret_key;
    
    [parmas setObject:@"json" forKey:@"ajax-type"];
    
    NSString *sig = [NSString signatureWithQuery:parmas opSecretKey:secret_key];
    if ([sig isNotBlank]) {
        [parmas setObject:sig forKey:@"sig"];
    }
    
    return parmas;
}

- (NSString *)requestUrl
{
    return MCS_HOST(@"/client/getLoginInfo");
}

@end
