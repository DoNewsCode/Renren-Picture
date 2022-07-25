//
//  DRNPublicParameter.m
//  AFNetworking
//
//  Created by Ming on 2020/6/3.
//

#import "DRNPublicParameter.h"

#import "DRRFile.h"
#import "DRSSafe.h"

#import "NSString+DRNNetwork.h"

@interface DRNPublicParameter ()

/// GlobalParameterType
@property(nonatomic, assign, readwrite) DRNPublicParameterType type;
/// 客户端信息 clientInfo
@property(nonatomic,copy, readwrite) NSString *clientInfo;
/// appID
@property(nonatomic,copy, readwrite) NSString *appID;

@end

@implementation DRNPublicParameter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _clientInfo = [NSString ct_parameterClientInfo];
        _secretKey = [DRSSafe sharedSafe].appInfo.companyOpSecretKey;
    }
    return self;
}

- (void)setUniqKey:(NSString *)uniqKey {
    _uniqKey = uniqKey;
    if (uniqKey && _sessionKey) {
        _type = DRNPublicParameterTypeUnique;
    }
}

- (void)setSessionKey:(NSString *)sessionKey {
    _sessionKey = sessionKey;
    if (sessionKey && _uniqKey) {
        _type = DRNPublicParameterTypeUnique;
    }
}

@end
