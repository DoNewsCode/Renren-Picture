//
//  DRNBaseRequest.m
//  Pods-Renren-Network_Example
//
//  Created by Ming on 2019/3/21.
//

#import "DRNBaseRequest.h"

#import <YYModel/YYModel.h>
#import "DRLLog.h"
#import "DNHttpClient.h"

@interface DRNBaseRequest ()

@end

@implementation DRNBaseRequest


- (NSDictionary *)parametersDictionary
{
    NSMutableDictionary *parmas = [self yy_modelToJSONObject];
    
    [parmas setObject:@"json" forKey:@"ajax-type"];
    
    return parmas;
}


- (NSString *)requestUrl{
    return @"";
}

- (void)startWithSuccess:(DNRequestSuccessBlock)success failure:(DNRequestFailureBlock)failure {
    [super startWithSuccess:success failure:failure];
    __weak typeof(self) weakSelf = self;
    
    NSError *parseError = [NSError new];
      NSDictionary *headerDict = [DNHttpClient HTTPRequestHeaders];
      
      NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.obtainParameters options:NSJSONWritingPrettyPrinted error:&parseError];
      NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
      if (headerDict) {
          NSData *headerDictData = [NSJSONSerialization dataWithJSONObject:headerDict options:NSJSONWritingPrettyPrinted error:&parseError];
          NSString * headerDictStr = [[NSString alloc] initWithData:headerDictData encoding:NSUTF8StringEncoding];
          str = [NSString stringWithFormat:@"Header:\n%@\nParameters:\n%@",headerDictStr,str];
      }
    
    [[DRLLog sharedLog] addLogWithType:DRLLogTypeAPIError title:self.completeUrl desc:str content:@"请求未结束（未接收到处理结果）" remark:@"null" completion:^(DRLLogMessage * _Nonnull message) {
        weakSelf.object = message;
    }];
}

- (void)requestSuccess:(id)responseObject {
    [super requestSuccess:responseObject];
    [self processPretreatment:responseObject];
}

- (void)requestFailed:(NSError *)error {
    [super requestFailed:error];
    if (self.object == nil) {
        return;
    }
    NSError *parseError = [NSError new];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.obtainParameters options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[DRLLog sharedLog] addLogWithType:DRLLogTypeAPIError title:self.completeUrl desc:str content:error.localizedDescription remark:error.localizedFailureReason];
    DRLLogMessage *logMessage = (DRLLogMessage *)self.object;
    logMessage.desc = str;
    logMessage.content = error.localizedDescription;
    logMessage.remark = error.localizedFailureReason;
    logMessage.modifiedTime = [NSDate date];
    [[DRLLog sharedLog] updateLogWith:logMessage];
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
    if (self.object == nil || !responseObject) {
        return;
    }
    NSError *parseError = [NSError new];
    NSData *responseObjectJsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString * responseStr = [[NSString alloc] initWithData:responseObjectJsonData encoding:NSUTF8StringEncoding];
    
    DRLLogMessage *logMessage = (DRLLogMessage *)self.object;
    logMessage.content = responseStr;
    logMessage.modifiedTime = [NSDate date];
    [[DRLLog sharedLog] updateLogWith:logMessage];
}



@end
