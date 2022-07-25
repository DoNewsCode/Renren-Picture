//
//  DRSAppInfo.h
//  Renren-SafeKit
//
//  Created by Ming on 2019/5/13.
//  App相关信息

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 正式 */
//static NSString *const RRChatChatList = @"RR://Chat/ChatList";

typedef NS_ENUM(NSInteger, DRSAppInfoType) {
    DRSAppInfoTypeRelease,//发布模式
    DRSAppInfoTypeDebug//测试模式
};

@interface DRSAppInfo : NSObject

/** App在Appstore中的id */
@property(nonatomic, copy, readonly) NSString *appID;
/** App的bundle identifier */
@property(nonatomic, copy, readonly) NSString *bundleIdentifier;

#pragma - mark Company
/** App在公司内部中的活动SecrectKey */
@property(nonatomic, copy, readonly) NSString *companyAcSecrectKey;
/** App在公司内部中的id */
@property(nonatomic, copy, readonly) NSString *companyAppID;
/** App在公司内部中的名称 */
@property(nonatomic, copy, readonly) NSString *companyAppName;
/** App在公司内部中的PushID */
@property(nonatomic, copy, readonly) NSString *companyPushID;
/** App在公司内部中的渠道标识 */
@property(nonatomic, copy, readonly) NSString *companyChannelID;
/** App在公司内部中的ApiKey */
@property(nonatomic, copy, readonly) NSString *companyOpApiKey;
/** App在公司内部中的SecretKey */
@property(nonatomic, copy, readonly) NSString *companyOpSecretKey;
/** App在公司内部中的 */
@property(nonatomic, copy, readonly) NSString *companyClientCode;

/** 微信 AppID */
@property(nonatomic, copy, readonly) NSString *wxAppID;
/** 微信 AppSecret */
@property(nonatomic, copy, readonly) NSString *wxAppSecret;
/** 微博 AppID */
@property(nonatomic, copy, readonly) NSString *wbAppID;
/** 微博 AppSecret */
@property(nonatomic, copy, readonly) NSString *wbAppSecret;
/** QQ AppID */
@property(nonatomic, copy, readonly) NSString *qqAppID;
/** QQ AppKey */
@property(nonatomic, copy, readonly) NSString *qqAppKey;
/** 高德地图 ApiKey */
@property(nonatomic, copy, readonly) NSString *aMapApiKey;
/** 百度地图 ApiKey */
@property(nonatomic, copy, readonly) NSString *baiduMapApiKey;
/** bugly AppId */
@property(nonatomic, copy, readonly) NSString *buglyAppID;
/** bugly AppKey */
@property(nonatomic, copy, readonly) NSString *buglyAppKey;

/** InfoType -暂时无效 */
@property(nonatomic, assign, readonly) DRSAppInfoType type;


+ (instancetype)sharedInstance;

//+ (instancetype)sharedInstanceWithType:(DRSAppInfoType)type;
//
//+ (void)changeType:(DRSAppInfoType)type;

@end

NS_ASSUME_NONNULL_END
