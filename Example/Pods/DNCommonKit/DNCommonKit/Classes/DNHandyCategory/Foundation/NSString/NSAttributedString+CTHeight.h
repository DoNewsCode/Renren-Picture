//
//  NSAttributedString+CTHeight.h
//  DNCommonKit
//
//  Created by Ming on 2020/5/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (CTHeight)

/// 计算富文本字体高度
/// @param lineSpeace 行高
/// @param font 字体
/// @param width 字体所占宽度
- (CGFloat)ct_heightParagraphSpeace:(CGFloat)lineSpeace withFont:(UIFont*)font width:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
