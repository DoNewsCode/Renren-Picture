//
//  DRNBaseUploadDataRequest.m
//  Renren-Network
//
//  Created by 陈金铭 on 2019/11/8.
//

#import "DRNBaseUploadDataRequest.h"

#import "NSString+CTDate.h"
#import <YYModel/YYModel.h>
#import "DRLLog.h"

@implementation DRNBaseUploadDataRequest

- (NSDictionary *)parametersDictionary
{
    NSMutableDictionary *parmas = [self yy_modelToJSONObject];
    
    [parmas setObject:@"json" forKey:@"ajax-type"];
    
    return parmas;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.v = @"1.0";
    }
    return self;
}

- (NSString *)call_id
{
    return [NSString ct_timeStampForNow];
}

- (NSString *)requestUrl{
    return @"";
}


- (void)requestSuccess:(id)responseObject {
    [super requestSuccess:responseObject];
    [self processPretreatment:responseObject];
}

- (void)requestFailed:(NSError *)error {
    [super requestFailed:error];
    NSError *parseError = [NSError new];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.obtainParameters
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&parseError];
    
    NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[DRLLog sharedLog] addLogWithType:DRLLogTypeAPIError title:self.completeUrl desc:str content:error.localizedDescription remark:error.localizedFailureReason];
}

/// 请求数据预处理
- (void)processPretreatment:(id)responseObject {
    
    [self createLog:responseObject];
    NSNumber *code = responseObject[@"errorCode"];
    if (code == nil) {
        return;
    }
    NSInteger codeInteger = [code integerValue];
    if (codeInteger == DRNErrorTypeLoginSessionKeyError) {

        NSString *message = responseObject[@"errorMsg"];
        if (message == nil) {
            message = @"";
        }
        NSDictionary *dictionary = @{@"message" : message,
                                     @"responseCode" : code};
        [[NSNotificationCenter defaultCenter] postNotificationName:DRNNetworkRequestDeviantNotification object:message userInfo:dictionary];
    }
}

- (void)createLog:(id)responseObject {
    NSError *parseError = [NSError new];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.obtainParameters
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&parseError];
    NSData *responseObjectJsonData = [NSJSONSerialization dataWithJSONObject:responseObject
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&parseError];
    
    NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString * responseStr = [[NSString alloc] initWithData:responseObjectJsonData encoding:NSUTF8StringEncoding];
    [[DRLLog sharedLog] addLogWithType:DRLLogTypeAPINormal title:self.completeUrl desc:str content:responseStr remark:nil];
}


@end
