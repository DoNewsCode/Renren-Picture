//
//  DRNGlobalRequest.m
//  Renren-Network
//
//  Created by Ming on 2019/12/16.
//

#import "DRNGlobalRequest.h"

#import "DRNNetwork.h"
#import "DRSSafe.h"

#import "NSString+CTDate.h"
#import "NSString+SafeKit.h"
#import "NSString+CTAdd.h"

@interface DRNGlobalRequest ()

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

@implementation DRNGlobalRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        _v = @"1.0";
        _app_id = [DRSSafe sharedSafe].appInfo.companyAppID;
        _api_key = [DRSSafe sharedSafe].appInfo.companyOpApiKey;
       DRNGlobalParameter *globalParameter = [DRNNetwork sharedNetwork].globalParameter;
                 if (globalParameter.type == DRNGlobalParameterTypeUnique) {// Unique模式
                     _uniq_id = globalParameter.uniqID;
                     _uniq_key = globalParameter.uniqKey;
                     _session_key = globalParameter.sessionKey;
                 } else {
                     _client_info = globalParameter.clientInfo;
                 }
        
    }
    return self;
}

- (void)startWithSuccess:(DNRequestSuccessBlock)success failure:(DNRequestFailureBlock)failure {
    
    [super startWithSuccess:success failure:failure];
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

@end
