//
//  DRNPublicRequest.m
//  AFNetworking
//
//  Created by Ming on 2020/6/3.
//

#import "DRNPublicRequest.h"

#import "DRNPublicParameter.h"

#import "DRNNetwork.h"
#import "DRSSafe.h"

#import "NSString+CTDate.h"
#import "NSString+SafeKit.h"
#import "NSString+CTAdd.h"

@interface DRNPublicRequest ()

/** gz */
@property(nonatomic,copy, readwrite) NSString *gz;
/** format */
@property(nonatomic,copy, readwrite) NSString *format;
/** clientInfo */
@property(nonatomic,copy, readwrite) NSString *clientInfo;
/** uniqKey */
@property(nonatomic,copy, readwrite) NSString *uniqKey;

@end

@implementation DRNPublicRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        DRNPublicParameter *publicParameter = [DRNNetwork sharedNetwork].publicParameter;
        if (publicParameter.type == DRNPublicParameterTypeUnique) {// Unique模式
            _uniqKey = publicParameter.uniqKey;
            _sessionKey = publicParameter.sessionKey;
        } else {
            _clientInfo = publicParameter.clientInfo;
        }
        
        DRSAppInfo *appInfo = [DRSAppInfo sharedInstance];
        _appKey = appInfo.companyOpApiKey;
    }
    return self;
}

- (void)startWithSuccess:(DNRequestSuccessBlock)success failure:(DNRequestFailureBlock)failure {
    
    [super startWithSuccess:success failure:failure];
}

- (NSDictionary *)parametersDictionary {
    NSMutableDictionary *parmas = [self yy_modelToJSONObject];
    [parmas setObject:@"json" forKey:@"ajax-type"];
    DRNPublicParameter *publicParameter = [DRNNetwork sharedNetwork].publicParameter;
    NSString *sig = [NSString ct_signatureWithQuery:parmas opSecretKey:publicParameter.secretKey];
    if ([sig ct_blank]) {
        [parmas setObject:sig forKey:@"sig"];
    }
    
    return parmas;
}

- (NSString *)callId {
    
    NSString *callId = [NSString ct_timeStampForNow];;
    _callId = callId;
    return _callId;
}

@end
