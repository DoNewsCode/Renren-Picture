//
//  UIFont+DRBFont.m
//  Renren-BaseKit
//
//  Created by 陈金铭 on 2019/7/10.
//

#import "UIFont+DRBFont.h"

#import "DRBBaseFont.h"

@implementation UIFont (DRBFont)

#pragma mark - 固定形态
/**
 获取固定Font（自定义字体）
 
 @param fontName 字体
 @param size 尺寸
 @return Font
 */
+ (UIFont *)fontWithFontName:(NSString *)fontName size:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:fontName size:size];
    if (font) {
        return font;
    }
    font = [UIFont systemFontOfSize:size];
    return font;
}

#pragma mark - 不定形态

/**
 获取可变Font（预设字体）
 
 @param initSize 初始尺寸
 @return Font
 */
+ (UIFont *)mutableFontWithInitSize:(CGFloat)initSize {
    return [UIFont systemFontOfSize:(initSize + [DRBBaseFont sharedInstance].coefficient)];
}

/**
 获取可变Font（预设字体）
 
 @param initSize 初始尺寸
 @param initWeight 初始weight
 @return Font
 */
+ (UIFont *)mutableFontWithInitSize:(CGFloat)initSize initWeight:(UIFontWeight)initWeight {
    return [UIFont systemFontOfSize:(initSize + [DRBBaseFont sharedInstance].coefficient) weight:initWeight];
}

/**
 获取可变Font（预设字体库中选取）
 
 @param fontName 初始字体
 @param initSize 初始尺寸
 @return Font
 */
+ (UIFont *)mutableFontWithFontName:(NSString *)fontName initSize:(CGFloat)initSize {
    return [self createFontWithMutableType:NO fontName:fontName mutableSize:YES initSize:initSize];
}

+ (UIFont *)createFontWithMutableType:(BOOL)mutableType fontName:(NSString *)fontName mutableSize:(BOOL)mutableSize  initSize:(CGFloat)initSize {
    CGFloat tempSize = mutableSize ? (initSize + [DRBBaseFont sharedInstance].coefficient) : initSize;
    
    return [self fontWithFontName:@"PingFangSC-Regular" size:tempSize];;
}


@end
