//
//  NSString+CTAdd.m
//  DNCommonKit
//
//  Created by Ming on 2019/4/11.
//

#import "NSString+CTAdd.h"

@implementation NSString (CTAdd)

/// 评论数超过1000 返回字符串  10001->1万
+ (instancetype)ct_formatCountStringWithCount:(NSUInteger)count {
    float temp = count / 10000.0;
    if (temp >= 1) {
        return [NSString stringWithFormat:@"%.1f万",temp];
    }
    return [NSString stringWithFormat:@"%lu",(unsigned long)count];
}

+ (instancetype)ct_commentCountStringWithCount:(NSUInteger)count {
    float temp = count / 1000.0;
    if (temp >= 1) {
        if (temp >= 10) {
            float tempW = count / 10000.0;
            return [NSString stringWithFormat:@"%.1fw",tempW];
        }
        return [NSString stringWithFormat:@"%.1fk",temp];
    }
    return [NSString stringWithFormat:@"%lu",(unsigned long)count];
}

- (instancetype)ct_substringWithRange:(NSRange)range{
#ifdef DEBUG
    if (self.length >=(range.location + range.length)) {
        
        return [self substringWithRange:range];
        
    }
    return nil;
#elif
    return [self substringWithRange:range];
#endif
    return nil;
}

- (BOOL)ct_blank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

@end
