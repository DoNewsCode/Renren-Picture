//
//  DRNBaseEarRequest.m
//  Renren-Network
//
//  Created by 陈金铭 on 2019/11/27.
//

#import "DRNBaseEarRequest.h"

#import <DNNetworking/DNHttpClient.h>

#import "DRSSafe.h"
#import "NSString+CTHash.h"
#import "NSString+CTAdd.h"
#import "NSString+CTDate.h"

@interface DRNBaseEarRequest ()

@property(nonatomic,copy) NSString *secrect_key;

@end

@implementation DRNBaseEarRequest

- (NSArray *)sortedDictionary:(NSDictionary *)dict
{
    //将所有的key放进数组
    NSArray *allKeyArray = [dict allKeys];
    
    //序列化器对数组进行排序的block 返回值为排序后的数组
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id _Nonnull obj2) {
        /**
          In the compare: methods, the range argument specifies the
          subrange, rather than the whole, of the receiver to use in the
          comparison. The range is not applied to the search string.  For
          example, [@"AB" compare:@"ABC" options:0 range:NSMakeRange(0,1)]
          compares "A" to "ABC", not "A" to "A", and will return
          NSOrderedAscending. It is an error to specify a range that is
          outside of the receiver's bounds, and an exception may be raised.
         
        - (NSComparisonResult)compare:(NSString *)string;
         
         compare方法的比较原理为,依次比较当前字符串的第一个字母:
         如果不同,按照输出排序结果
         如果相同,依次比较当前字符串的下一个字母(这里是第二个)
         以此类推
         
         排序结果
         NSComparisonResult resuest = [obj1 compare:obj2];为从小到大,即升序;
         NSComparisonResult resuest = [obj2 compare:obj1];为从大到小,即降序;
         
         注意:compare方法是区分大小写的,即按照ASCII排序
         */
        //排序操作
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    return afterSortKeyArray;
}

- (NSString *)tokenWithTimestamp:(NSString *)timestamp
{
    NSDictionary *params = [self parametersDictionary];
    
    NSString *paramStr = @"";
    /// 还需要对字典中的 key 进行首字母排序，这是啥操作呀。。。
    NSArray *keyArray = [self sortedDictionary:params];
    
    for (NSString *key in keyArray) {
        
        paramStr = [paramStr stringByAppendingString:
                    [NSString stringWithFormat:@"%@=%@",
                     key, [params objectForKey:key]]];
        
        if (![key isEqualToString:[keyArray lastObject]]) {
            paramStr = [paramStr stringByAppendingString:@"&"];
        }
    }
    NSString *secrect_key = [DRSSafe sharedSafe].appInfo.companyAcSecrectKey;
    NSString *sigValue = [NSString stringWithFormat:@"%@#%@@%@", paramStr, timestamp, secrect_key];
    NSLog(@"需要md5的待签名串 === %@", sigValue);
    NSString *token = [sigValue ct_MD5String];
    return token;
}

- (void)lodaDataWithSuccessBlock:(void(^)(id response))successBlock
                      faileBlock:(void(^)(NSString *error_msg))failureBlock
{
    NSString *timestamp = [NSString ct_timeStampForNow];
    [DNHttpClient setValue:timestamp forHTTPHeaderField:@"timestamp"];
    
    NSString *token = [self tokenWithTimestamp:timestamp];
    [DNHttpClient setValue:token forHTTPHeaderField:@"token"];
    
    [self startWithSuccess:^(DNResponse *response) {
        NSDictionary *dict = response.responseObject;
        NSInteger code = [[dict objectForKey:@"code"] integerValue];
        if (code == 1) {
            /// 成功
            if (successBlock) {
                successBlock(dict);
            }
        } else {
            /// 失败
            NSString *msg = [dict objectForKey:@"msg"];
            if (![msg ct_blank]) {
                msg = [dict objectForKey:@"error_msg"];
            }
            if (failureBlock) {
                failureBlock(msg);
            }
        }
        
    } failure:^(NSError *error) {
        if (failureBlock) {
                
        #if defined(DEBUG) && DEBUG
                failureBlock(error.description);
        #else
                NSString *errorStr = error.userInfo[@"NSLocalizedDescription"];
                failureBlock(errorStr);
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
