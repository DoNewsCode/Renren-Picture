//
//  DRSSafe.h
//  Renren-SafeKit
//
//  Created by 陈金铭 on 2019/7/8.
//  安全管理类

#import <Foundation/Foundation.h>

#import "DRSAppInfo.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DRSSafeType) {
    DRSSafeTypeRelease,//发布模式
    DRSSafeTypeDebug//测试模式
};

// 貌似这里不需要知道是什么策略，只是调用方给我一个字符串，我加密后返回给调用方即可

////加密策略
//typedef NS_ENUM(NSInteger, DRSSafeEncryptionStrategy) {
//    DRSSafeEncryptionStrategyNormal,//常规策略
//    DRSSafeEncryptionStrategyQRCode//二维码策略
//};
//
////解密策略
//typedef NS_ENUM(NSInteger, DRSSafeDecryptionStrategy) {
//    DRSSafeDecryptionStrategyNormal,//常规策略
//    DRSSafeDecryptionStrategyQRCode//二维码策略
//};

@interface DRSSafe : NSObject

/** App相关信息 */
@property(nonatomic, strong) DRSAppInfo *appInfo;
@property(nonatomic, assign, readonly) DRSSafeType type;


+ (instancetype)sharedSafe;


/**
 对原始数据进行加密
 
 @param encryptedString 原始数据
 @return 加密后的数据0.1.2.14
 */
- (NSString *)processingEncryptionWithEncryptedString:(NSString *)encryptedString;

/**
 对加密数据进行解密

 @param decryptString 加密数据
 @return 解密后的数据
 */
- (NSString *)processingEncryptionWithDecryptString:(NSString *)decryptString;


@end

NS_ASSUME_NONNULL_END
