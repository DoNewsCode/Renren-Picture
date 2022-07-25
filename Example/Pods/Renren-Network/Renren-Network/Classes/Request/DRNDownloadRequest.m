//
//  DRNDownloadRequrst.m
//  Renren-Network
//
//  Created by Ming on 2019/12/26.
//

#import "DRNDownloadRequest.h"


#import "DRLLog.h"
#import "DNHttpClient.h"

@implementation DRNDownloadRequest

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
    NSDictionary *headerDict = [DNHttpClient HTTPRequestHeaders];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.obtainParameters
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&parseError];
    NSData *responseObjectJsonData = [NSJSONSerialization dataWithJSONObject:responseObject
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&parseError];
    
    NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (headerDict) {
        NSData *headerDictData = [NSJSONSerialization dataWithJSONObject:headerDict
        options:NSJSONWritingPrettyPrinted
          error:&parseError];
        NSString * headerDictStr = [[NSString alloc] initWithData:headerDictData encoding:NSUTF8StringEncoding];
        str = [NSString stringWithFormat:@"Header:\n%@\nParameters:\n%@",headerDictStr,str];
    }
    NSString * responseStr = [[NSString alloc] initWithData:responseObjectJsonData encoding:NSUTF8StringEncoding];
    [[DRLLog sharedLog] addLogWithType:DRLLogTypeAPINormal title:self.completeUrl desc:str content:responseStr remark:nil];
}

@end
