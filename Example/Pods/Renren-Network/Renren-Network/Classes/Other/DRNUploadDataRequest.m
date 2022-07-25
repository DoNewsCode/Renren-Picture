//
//  DRNUploadDataRequest.m
//  Renren-Network
//
//  Created by Ming on 2019/12/16.
//

#import "DRNUploadDataRequest.h"

#import "DRNNetwork.h"
#import "DRSSafe.h"
#import "YYModel.h"
#import "DRLLog.h"
#import "DNHttpClient.h"
#import "DRNMacro.h"

#import "NSString+CTDate.h"
#import "NSString+SafeKit.h"
#import "NSString+CTAdd.h"
#import "NSString+DRNNetwork.h"

@interface DRNUploadDataRequest ()

/** app id */
@property(nonatomic,copy, readwrite) NSString *app_id;
/** call id */
@property(nonatomic,copy, readwrite) NSString *call_id;
/** session_key */
@property(nonatomic,copy, readwrite) NSString *session_key;
/** uniq_id */
@property(nonatomic,copy, readwrite) NSString *uniq_id;
/** uniq_key */
@property(nonatomic,copy, readwrite) NSString *uniq_key;
/** client_info */
@property(nonatomic,copy, readwrite) NSString *client_info;
/** sig */
@property(nonatomic,copy, readwrite) NSString *sig;

@end


@implementation DRNUploadDataRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        DRNGlobalParameter *globalParameter = [DRNNetwork sharedNetwork].globalParameter;
        if (globalParameter.type == DRNGlobalParameterTypeUnique) {// Unique模式
            _uniq_id = globalParameter.uniqID;
            _uniq_key = globalParameter.uniqKey;
            _session_key = globalParameter.sessionKey;
        } else {
            _client_info = globalParameter.clientInfo;
        }
        _app_id = [DRSSafe sharedSafe].appInfo.companyAppID;
        
    }
    return self;
}

- (NSDictionary *)parametersDictionary {
    NSMutableDictionary *parmas = [self yy_modelToJSONObject];
    [parmas setObject:@"json" forKey:@"ajax-type"];
    DRNGlobalParameter *globalParameter = [DRNNetwork sharedNetwork].globalParameter;
    NSString *sig = [NSString signatureWithQuery:parmas opSecretKey:globalParameter.secretKey];
    if ([sig ct_blank]) {
        [parmas setObject:sig forKey:@"sig"];
    }
    
    return parmas;
}

- (NSString *)call_id {
    NSString *call_id = [NSString ct_timeStampForNow];;
    _call_id = call_id;
    return _call_id;
}

- (NSString *)requestUrl {
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
