//
//  DRNGlobalParameter.m
//  Renren-Network
//
//  Created by Ming on 2019/12/14.
//

#import "DRNGlobalParameter.h"

#import "DRRFile.h"
#import "DRSSafe.h"

#import "NSString+DRNNetwork.h"

@interface DRNGlobalParameter ()

/// GlobalParameterType
@property(nonatomic, assign, readwrite) DRNGlobalParameterType type;

@end

@implementation DRNGlobalParameter

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
        _type = DRNGlobalParameterTypeUnique;
    }
}

- (void)setSessionKey:(NSString *)sessionKey {
    _sessionKey = sessionKey;
    if (sessionKey && _uniqKey) {
        _type = DRNGlobalParameterTypeUnique;
    }
}

@end
