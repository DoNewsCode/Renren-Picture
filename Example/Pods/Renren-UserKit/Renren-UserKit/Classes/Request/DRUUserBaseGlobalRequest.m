//
//  DRUUserBaseGlobalRequest.m
//  RenRenRecallModule
//
//  Created by donews on 2019/1/15.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DRUUserBaseGlobalRequest.h"
#import <YYModel/YYModel.h>
#import <YYCategories/YYCategories.h>
#import "DRUAccountManager.h"
#import "DRSAppInfo.h"
#import "NSString+SafeKit.h"
#import "NSString+DRNNetwork.h"

@interface DRUUserBaseGlobalRequest()

@end

@implementation DRUUserBaseGlobalRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        DRSAppInfo *appInfo = [DRSAppInfo sharedInstance];
//        self.app_id = appInfo.companyAppID;
//        self.api_key = appInfo.companyOpApiKey;
//
//        self.version = [UIApplication sharedApplication].appVersion;
//        self.uniq_id = [DRUAccountManager sharedInstance].currentUser.userLoginInfo.uniq_id;
//        self.uniq_key = [DRUAccountManager sharedInstance].currentUser.userLoginInfo.uniq_key;
//
//        self.client_info = [NSString ct_parameterClientInfo];
        
        
        // 重构
        DRSAppInfo *appInfo = [DRSAppInfo sharedInstance];
        self.appKey = appInfo.companyOpApiKey;
    }
    return self;
}

//  重写了 DNRequest 的 parametersDictionary，为了增加 sig 参数
//- (NSDictionary *)parametersDictionary
//{
//    NSMutableDictionary *parmas = [self yy_modelToJSONObject];
//    
//    /// 这个是 用户登录后保存的 secret_key
//    NSString *secret_key = [DRUAccountManager sharedInstance].currentUser.userLoginInfo.secret_key;
//    
//    [parmas setObject:@"json" forKey:@"ajax-type"];
//    
//    NSString *sig = [NSString signatureWithQuery:parmas opSecretKey:secret_key];
//    if ([sig isNotBlank]) {
//        [parmas setObject:sig forKey:@"sig"];
//    }
//    return parmas;
//}

// 把 请求参数 进行 签名， 生成 sig 参数
- (NSString *)user_signature:(NSDictionary *)query
                   opSecretKey:(NSString *)opSecretKey
                 valueLenLimit:(NSInteger)valueLenLimit
{
    if ( ( nil == query ) || ( nil == opSecretKey ) ) {
        return nil;
    }
    // 计算Signature.
    NSMutableArray* unsorted = [NSMutableArray arrayWithCapacity:query.count];
    for (id key in query) {
        NSString *value = [query objectForKey:key];
        NSString *value2 = value;
        if (valueLenLimit > 0) {
            if (value2
                && [value2 isKindOfClass:[NSString class]]
                && value2.length > valueLenLimit)
            {
                NSString* strTemp = [NSString stringWithUTF8String:[value2 UTF8String]];
                value2 = [strTemp substringToIndex:valueLenLimit];

                // 如果编码失败,修改内容值.
                if ( [value2 lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 0) {
                    //编码失败，暂时处理未nil
                    NSRange curStrRange = [strTemp rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, valueLenLimit)];

                    NSString *value4 = [strTemp substringWithRange:curStrRange];
                    NSInteger tempLen = valueLenLimit;
                    const char * value3 = [value4 UTF8String];
                    NSInteger len = strlen(value3);
                    while( len > valueLenLimit && tempLen > 1 )
                    {
                        tempLen--;
                        curStrRange = [strTemp rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, tempLen)];
                        value4 = [strTemp substringWithRange:curStrRange];
                        value3 = [value4 UTF8String];
                        len = strlen(value3);
                    }

                    value = value4;
                } else {
                    value = value2;
                }
            }
        }
        [unsorted addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }

    NSArray *sortedArray = [unsorted
                            sortedArrayUsingFunction:user_strCompare context:NULL];
    NSMutableString *buffer = [[NSMutableString alloc] initWithCapacity:0];
    NSEnumerator *i = [sortedArray objectEnumerator];
    id theObject;
    while (theObject = [i nextObject]) {
        [buffer appendString:theObject];
    }
    [buffer appendString:opSecretKey];
    NSString* signature = [buffer md5String]; // 签名.

    return signature;
}

/// 这个 c  函数，在当时合并代码的时候，与某个 .a 文件中的，重复定义了！！～～
NSInteger user_strCompare(id str1, id str2, void *context)
{
    return [((NSString*)str1) compare:str2 options:NSLiteralSearch];
}


- (void)lodaDataWithSuccessBlock:(void(^)(id response))successBlock
                      faileBlock:(void(^)(NSString *error_msg, id response))failureBlock
{
    
    [self startWithSuccess:^(DNResponse *response) {
        
        NSLog(@"\n\n------------------------\n请求接口成功：%@ \n返回结果如下：\n%@------------------------\n\n", self, response.responseObject);
        
        NSDictionary *responseObject = response.responseObject;
        
        if (successBlock) {
            successBlock(responseObject);
        }

        
    } failure:^(NSError *error) {
        
        NSLog(@"\n\n------------------------\n请求接口失败：%@ \n 返回结果如下：\n %@\n------------------------\n\n", self, error);
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
    NSDictionary *dict = self.yy_modelToJSONObject;
    
    NSString *paramStr = @"?";
    NSArray *keyArray = [self.yy_modelToJSONObject allKeys];
    
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
            @"url ===== %@%@", url, paramStr];
}

- (NSString *)description
{
    return [self printUrlAndParmas];
}


@end
