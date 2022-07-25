//
//  UIFont+DRBFont.h
//  Renren-BaseKit
//
//  Created by 陈金铭 on 2019/7/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (DRBFont)

#pragma mark - 固定形态
/**
 获取固定Font（自定义字体）
 
 @param fontName 字体
 @param size 尺寸
 @return Font
 */
+ (UIFont *)fontWithFontName:(NSString *)fontName size:(CGFloat)size;

#pragma mark - 不定形态

/**
 获取可变Font（预设字体）
 
 @param initSize 初始尺寸
 @return Font
 */
+ (UIFont *)mutableFontWithInitSize:(CGFloat)initSize;


/**
 获取可变Font（预设字体）
 
 @param initSize 初始尺寸
 @param initWeight 初始weight
 @return Font
 */
+ (UIFont *)mutableFontWithInitSize:(CGFloat)initSize initWeight:(UIFontWeight)initWeight;

/**
 获取可变Font（自定义字体）
 
 @param fontName 初始字体
 @param initSize 初始尺寸
 @return Font
 */
+ (UIFont *)mutableFontWithFontName:(NSString *)fontName initSize:(CGFloat)initSize;


@end

NS_ASSUME_NONNULL_END
