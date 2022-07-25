//
//  DRSAppInfo.m
//  Renren-SafeKit
//
//  Created by Ming on 2019/5/13.
//

#import "DRSAppInfo.h"

@interface DRSAppInfo ()

/** App在Appstore中的id */
@property(nonatomic, copy, readwrite) NSString *appID;
/** App的bundle identifier */
@property(nonatomic, copy, readwrite) NSString *bundleIdentifier;

#pragma - mark Company
/** App在公司内部中的活动SecrectKey */
@property(nonatomic, copy, readwrite) NSString *companyAcSecrectKey;
/** App在公司内部中的id */
@property(nonatomic, copy, readwrite) NSString *companyAppID;
/** App在公司内部中的名称 */
@property(nonatomic, copy, readwrite) NSString *companyAppName;
/** App在公司内部中的PushID */
@property(nonatomic, copy, readwrite) NSString *companyPushID;
/** App在公司内部中的渠道标识 */
@property(nonatomic, copy, readwrite) NSString *companyChannelID;
/** App在公司内部中的ApiKey */
@property(nonatomic, copy, readwrite) NSString *companyOpApiKey;
/** App在公司内部中的SecretKey */
@property(nonatomic, copy, readwrite) NSString *companyOpSecretKey;
/** App在公司内部中的 */
@property(nonatomic, copy, readwrite) NSString *companyClientCode;

/** 微信 AppID */
@property(nonatomic, copy, readwrite) NSString *wxAppID;
/** 微信 AppSecret */
@property(nonatomic, copy, readwrite) NSString *wxAppSecret;
/** 微博 AppID */
@property(nonatomic, copy, readwrite) NSString *wbAppID;
/** 微博 AppSecret */
@property(nonatomic, copy, readwrite) NSString *wbAppSecret;
/** QQ AppID */
@property(nonatomic, copy, readwrite) NSString *qqAppID;
/** QQ AppKey */
@property(nonatomic, copy, readwrite) NSString *qqAppKey;
/** 高德地图 ApiKey */
@property(nonatomic, copy, readwrite) NSString *aMapApiKey;
/** 百度地图 ApiKey */
@property(nonatomic, copy, readwrite) NSString *baiduMapApiKey;
/** bugly AppId */
@property(nonatomic, copy, readwrite) NSString *buglyAppID;
/** bugly AppKey */
@property(nonatomic, copy, readwrite) NSString *buglyAppKey;



/** InfoType */
@property(nonatomic, assign, readwrite) DRSAppInfoType type;

@end

@implementation DRSAppInfo
#pragma mark - Intial Methods
static DRSAppInfo *_instance = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [_instance initialization];
    });
    return _instance;
}

+ (instancetype)sharedInstanceWithType:(DRSAppInfoType)type {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance.type = type;
        [_instance initialization];
    });
    return _instance;
}

+ (void)changeType:(DRSAppInfoType)type {
    _instance.type = type;
}

- (void)initialization {
    self.bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
    [self createParameter];
}

- (void)createParameter {
    if ([self.bundleIdentifier isEqualToString:@"com.donews.renrenNet.ios"]) {
        [self createRenrenParameter];
        
    } else if ([self.bundleIdentifier isEqualToString:@"com.donews.renren.iose"]) {
        [self createRenrenEnterpriseParameter];
        
    } else if ([self.bundleIdentifier isEqualToString:@"com.donews.renrenpro.ios"]) {
        [self createRenrenProParameter];
        
    } else {
        [self createNoneParameter];
        
    }
}

- (void)createRenrenParameter {
    // 公司、正式版
    self.appID = @"1449940645";
    self.companyAcSecrectKey = @"k*0nSkaVLMh%!";
    self.companyAppID = @"2080896";
    self.companyOpApiKey = @"8d706654a9ce4ba7303470d77c4b82a4";
    self.companyOpSecretKey = @"c624481310ba1637badf990ebd5b255a";
    self.companyClientCode = @"RenReniPhone2015";
    self.companyAppName = @"人人网";
    self.companyPushID = @"39";
}

- (void)createRenrenEnterpriseParameter {
    // 企业
    self.companyAcSecrectKey = @"k*0nSkaVLMh%!";
    self.companyAppID = @"2080896";
    self.companyOpApiKey = @"8d706654a9ce4ba7303470d77c4b82a4";
    self.companyOpSecretKey = @"c624481310ba1637badf990ebd5b255a";
    self.companyClientCode = @"RenReniPhone2015";
    self.companyAppName = @"人人网-企业";
    self.companyPushID = @"40";
}

- (void)createRenrenProParameter {
    // 公测 ？
    self.companyAppID = @"2080896";
    self.companyOpApiKey = @"8d706654a9ce4ba7303470d77c4b82a4";
    self.companyOpSecretKey = @"c624481310ba1637badf990ebd5b255a";
    self.companyClientCode = @"RenReniPhone2015";
    self.companyAppName = @"人人网-公测";
    self.companyPushID = @"39";
    
}

- (void)createNoneParameter {
    // 默认？
    self.appID = @"1449940645";
    self.companyAppID = @"2080896";
    self.companyOpApiKey = @"8d706654a9ce4ba7303470d77c4b82a4";
    self.companyOpSecretKey = @"c624481310ba1637badf990ebd5b255a";
    self.companyClientCode = @"RenReniPhone2015";
    self.companyAppName = @"人人网";
    self.companyPushID = @"39";
}

@end
