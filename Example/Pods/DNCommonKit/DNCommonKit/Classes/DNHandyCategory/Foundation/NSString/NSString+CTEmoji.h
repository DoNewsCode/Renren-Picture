//
//  NSString+CTEmoji.h
//  DNCommonKit
//
//  Created by Ming on 2020/7/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CTEmoji)

+ (BOOL)ct_stringContainsEmoji:(NSString *)string;

- (BOOL)ct_stringContainsEmoji;

@end

NS_ASSUME_NONNULL_END
