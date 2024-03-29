//
//  NSString+CTAdd.h
//  DNCommonKit
//
//  Created by Ming on 2019/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CTAdd)

/// 评论数超过1000 返回字符串  10001->1万
+ (instancetype)ct_formatCountStringWithCount:(NSUInteger)count;
/// 评论数超过999 返回字符串 1000->1k 1001->1万 1100->1.1k 1200->1.2k...
+ (instancetype)ct_commentCountStringWithCount:(NSUInteger)count;

- (instancetype)ct_substringWithRange:(NSRange)range;

/// nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
- (BOOL)ct_blank;

@end

NS_ASSUME_NONNULL_END
