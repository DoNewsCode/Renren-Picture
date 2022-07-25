//
//  NSString+DRRResourceKit.h
//  Pods-Renren-ResourceKit_Example
//
//  Created by Ming on 2019/4/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DRRResourceKit)

//根据当前返回对应的本地化文字
+ (NSString *)ct_localizedStringForKey:(NSString *)key;

//根据语言类型返回对应的本地化文字
+ (NSString *)ct_localizedStringWithLanguage:(NSString *)language ForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
