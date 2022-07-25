//
//  NSString+CTQRCode.h
//  DNCommonKit
//
//  Created by Ming on 2020/7/17.
//  扩展 - 字符串 - 二维码

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CTQRCode)

///  生成一个二维码
/// @param string 字符串
/// @param width 二维码宽度
+ (UIImage *)ct_codeImageWithString:(NSString *)string size:(CGFloat)width;

///  生成一个二维码
/// @param string 字符串
/// @param width 二维码宽度
/// @param color 二维码颜色
+ (UIImage *)ct_codeImageWithString:(NSString *)string size:(CGFloat)width color:(UIColor *)color;

/// 生成一个二维码
/// @param string 字符串
/// @param width 二维码宽度
/// @param color 二维码颜色
/// @param icon 头像
/// @param iconWidth 头像宽度，建议宽度小于二维码宽度的1/4
+ (UIImage *)ct_codeImageWithString:(NSString *)string size:(CGFloat)width color:(UIColor *)color icon:(UIImage *)icon iconWidth:(CGFloat)iconWidth;

@end

NS_ASSUME_NONNULL_END
