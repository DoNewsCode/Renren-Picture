//
//  DNStatisticSDK.h
//  DNStatisticSDK
//
//  Created by donews on 2019/1/15.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "DNStatisticBuilderDefines.h"

typedef NS_ENUM(NSInteger, DNStatisticSDKLogLevel) {
    DNStatisticSDKLogLevelNone,
    DNStatisticSDKLogLevelDebug
};

typedef NS_ENUM(NSUInteger,DNStatisticGender) {
    DNStatisticGenderUnknow = 0,  // 未知
    DNStatisticGenderMan, // 男
    DNStatisticGenderWoman // 女
};

typedef NS_ENUM(NSInteger,DNStatisticReportPolicy) { // 上报策略
    SEND_REALTIME,     // 实时发送(不论wifi还是非wifi下只要能上报就上报)
    SEND_REALTIME_WIFI // wifi情况下有事件则实时上报 如果此时非wifi情况 则隔600秒上报一次 (⚠️已取消)
};

NS_ASSUME_NONNULL_BEGIN

@interface DNStatisticSDK : NSObject

/// 用户在App中的账号 [可选]
+ (void)setAccount:(NSString *)account;

/// 用户在App中的唯一标识 [可选]
+ (void)setUserId:(NSString *)userId;

/// 用户性别 [可选]
+ (void)setGender:(DNStatisticGender)gender;

/// 用户的location [可选]
+ (void)setLocation:(CLLocation *)location;

/// 用户的年龄 [可选]
+ (void)setAge:(unsigned short)age;

/// 是否输出log (⚠️Debug模式下有效)
+ (void)setLogLevel:(DNStatisticSDKLogLevel)logLevel;

/// SDK版本号
+ (NSString *)SDKVersion;

/**
 @brief 注册SDK,Appkey是大数据平台提供,在AppDelegate的didFinishLaunchingWithOptions中调用
 初始化后会自动统计 App的启动和退出时间
 
 @param appKey 平台提供的appKey
 @param policy 上报策略 （默认实时发送）
 */
+ (void)registSDKWithAppKey:(NSString *)appKey policy:(DNStatisticReportPolicy)policy;

/**
 @brief 添加行为事件
 eventName -》事件的名称（必传）
 extParams -》扩展参数 （可选 以key-value字典形式传）

 @param builderBlock 事件构造器
 */
+ (void)eventWithBulider:(void (^)(DNStatisticEventBuilder *builder))builderBlock;

/**
 @brief 添加Error事件
 errorDetail -》Error描述  （必传）
 fileName    -》报错的文件名 （选传）
 methodName  -》报错的方法名 （选传）
 lineNum     -》报错的行号  （选传）
 
 @param builderBlock 事件构造器
 */
+ (void)errorWithBulider:(void (^)(DNStatisticErrorBuilder *builder))builderBlock;

@end

NS_ASSUME_NONNULL_END
