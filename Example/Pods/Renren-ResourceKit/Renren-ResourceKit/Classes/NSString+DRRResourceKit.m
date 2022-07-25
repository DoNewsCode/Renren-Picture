//
//  NSString+DRRResourceKit.m
//  Pods-Renren-ResourceKit_Example
//
//  Created by Ming on 2019/4/17.
//

#import "NSString+DRRResourceKit.h"

#import "NSBundle+Renren_ResourceKitUtils.h"

@implementation NSString (DRRResourceKit)

+ (NSString *)ct_localizedStringForKey:(NSString *)key
{
    return [self ct_localizedStringForKey:key value:nil];
}

+ (NSString *)ct_localizedStringForKey:(NSString *)key value:(NSString *)value
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                language = @"zh-Hans"; // 简体中文
            } else { // zh-Hant\zh-HK\zh-TW
                language = @"zh-Hant"; // 繁體中文
            }
        } else {
            language = @"en";
        }
        
        // 从.bundle中查找资源
        NSBundle *localizationBundle = [NSBundle ct_localization_bundle];
        bundle = [NSBundle bundleWithPath:[localizationBundle pathForResource:language ofType:@"lproj"]];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    NSString *string =  [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
    return string;
}

+ (NSString *)ct_localizedStringWithLanguage:(NSString *)language ForKey:(NSString *)key {
    return [self ct_localizedStringWithLanguage:language ForKey:key value:nil];
}

+ (NSString *)ct_localizedStringWithLanguage:(NSString *)language ForKey:(NSString *)key value:(NSString *)value
{
    NSBundle *bundle = nil;
    // 从.bundle中查找资源
    NSBundle *localizationBundle = [NSBundle ct_localization_bundle];
    bundle = [NSBundle bundleWithPath:[localizationBundle pathForResource:language ofType:@"lproj"]];
    value = [bundle localizedStringForKey:key value:value table:nil];
    NSString *string =  [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
    return string;
}
@end
