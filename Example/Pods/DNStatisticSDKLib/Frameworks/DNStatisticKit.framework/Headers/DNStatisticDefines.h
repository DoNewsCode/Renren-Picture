//
//  DNStatisticModel.h
//  DNStatisticSDK
//
//  Created by donews on 2019/1/16.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// token过期时间
UIKIT_EXTERN CFTimeInterval TOKEN_INVALID_TIME;
@interface DNStatisticEventModel : NSObject
/// Event类型名称
@property (nonatomic, copy) NSString *event;
/// Event参数
@property (nonatomic, copy) NSDictionary *params;
/// Event唯一id
@property (nonatomic, copy) NSString *eventId;
/// 文件名
@property (nonatomic, copy) NSString *fileName;
/// 方法名
@property (nonatomic, copy) NSString *methodName;
/// 行号
@property (nonatomic, copy) NSString *lineNum;
/// Error描述
@property (nonatomic, copy) NSString *errorDetail;
/// 产生事件的时间戳
@property (nonatomic, copy) NSString *timestamp;

@end

@interface DNStatisticAppModel : NSObject

/// 必填 ⼤大数据平台分配的Appkey
@property (nonatomic, copy) NSString *appkey;
/// 缓存策略
@property (nonatomic, assign) NSInteger policy;

/** 获取用户注册App的天数 刚注册完记0天 */
+ (NSInteger)registerDays;

@end

@interface DNStatisticUser : NSObject

/// 用户在App中的账号
@property (nonatomic, copy) NSString *account;
/// 用户在App中的唯一标识
@property (nonatomic, copy) NSString *userId;
/// 用户性别
@property (nonatomic, assign) NSUInteger gender;
@property (nonatomic, copy) NSString *genderStr;
/// 用户年龄
@property (nonatomic, assign) NSUInteger age;
/// 用户的地理位置-经度
@property (nonatomic, copy) NSString *lat;
/// 用户的地理位置-纬度
@property (nonatomic, copy) NSString *lng;
@end

@interface DNStatisticCacheHelper : NSObject

/** 保存请求Token的url */
+ (void)saveTokenUrl:(NSString *)url;
/** 保存上报的url */
+ (void)saveReportUrl:(NSString *)url;
 /** 保存解密后的token */
+ (void)saveToken:(NSString *)token;
/** 保存获取到token时的时间戳 精确到秒 */
+ (void)saveTokenTimestamp;
/** 保存App的版本号 */
+ (void)saveAppVersion:(NSString *)version;
/** 保存系统版本号 */
+ (void)saveOSVersion:(NSString *)version;
/** 记录App当前退出时间 */
+ (void)saveAppExitTime;
/** 记录App本次启动的时间 */
+ (void)saveAppLunchTime;
/** 记录App首次安装的时间*/
+ (void)saveAppFirstLunchTime;
/** 创建缓存事件plist文件的时间*/
+ (void)saveCreateDataFileTime;

+ (NSString *)tokenUrl;
+ (NSString *)reportUrl;
+ (NSString *)token;
+ (NSString *)tokenTimestamp;
+ (NSString *)appVersion;
+ (NSString *)OSVersion;
+ (NSString *)appExitTime;
+ (NSString *)appLunchTime;
+ (NSString *)appFirstLunchTime;
+ (NSString *)createDataFileTime;

@end

@interface DNStatisticHelper : NSObject

///**
// 将字典转换成json字符串二进制格式的 (单条数据)
//
// @param dict 数据字典
// @return json字符串的二进制
// */
//+ (NSData *)jsonDataWithDict:(NSDictionary *)dict;

/**
 将字典转换成json字符串二进制格式的 （多条数据）

 @param dicts 字典数组
 @return 二进制数据
 */
+ (NSData *)jsonDataWithDicts:(NSArray<NSDictionary *> *)dicts;

/**
 Token是否失效
 */
+ (BOOL)isTokenInvalid;

@end

NS_ASSUME_NONNULL_END


