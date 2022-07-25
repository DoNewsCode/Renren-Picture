//
//  NSString+CTVerification.h
//  DNCommonKit
//
//  Created by Ming on 2020/7/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CTVerification)

/// 校验 - 字符串格式是否符合中国手机号格式
/// @param mobileString 中国手机号
+ (BOOL)ct_ValidateChinaMobileString:(NSString *)mobileString;

/// 校验 - 字符串格式是否符合中国居民身份证号码格式
/// @param cardNumberString 中国居民身份证号码
+ (BOOL)ct_ValidateChinaIDCardNumberString:(NSString *)cardNumberString;

/// 校验 - 字符串格式是否符合中国手机号格式
- (BOOL)ct_ValidateChinaMobile;

/// 校验 - 字符串格式是否符合中国居民身份证号码格式
- (BOOL)ct_ValidateChinaIDCardNumber;

@end

NS_ASSUME_NONNULL_END
