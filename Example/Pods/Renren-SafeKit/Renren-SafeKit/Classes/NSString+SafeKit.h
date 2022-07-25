//
//  NSString+SafeKit.h
//  Renren-SafeKit
//
//  Created by 陈金铭 on 2019/11/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SafeKit)

/// 生成sign方法
/// @param query 请求参数
/// @param opSecretKey opSecretKey
+ (NSString *)signatureWithQuery:(NSDictionary *)query opSecretKey:(NSString *)opSecretKey;


/// 重构后，生成sig的方法
/// @param query 请求参数
/// @param opSecretKey 原始opSecretKey或用户secretKey
+ (NSString *)ct_signatureWithQuery:(NSDictionary *)query opSecretKey:(NSString *)opSecretKey;

@end

NS_ASSUME_NONNULL_END
