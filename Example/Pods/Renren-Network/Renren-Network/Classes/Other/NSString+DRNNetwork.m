//
//  NSString+DRNNetwork.m
//  Renren-Network
//
//  Created by 陈金铭 on 2019/11/21.
//

#import "NSString+DRNNetwork.h"

#import "UIDevice+DRNNetwork.h"

#import "YYModel.h"

static NSString * const kUUIDStringKey = @"com.renren-inc.UUIDString";

@implementation NSString (DRNNetwork)

+ (NSMutableDictionary *)keychainQueryDictForKey:(NSString *)key
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            //以密码的形式保存
            (id)kSecClassGenericPassword,(id)kSecClass,
            //账户名
            key, (id)kSecAttrAccount,
            //访问级别,一直可访问,并且用户备份时不进入备份
            (id)kSecAttrAccessibleAlwaysThisDeviceOnly,(id)kSecAttrAccessible,
            nil];
}

+ (void)saveData:(id)data forKey:(NSString *)key
{
    NSMutableDictionary *keychainQuery = [self keychainQueryDictForKey:key];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)dataForKey:(NSString *)key
{
    id returnValue = nil;
    NSMutableDictionary *keychainQuery = [self keychainQueryDictForKey:key];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData);
    if (status == noErr) {
        @try {
            returnValue = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *exception) {
            NSLog(@"Unarchive of %@ failed: %@", key, exception);
            SecItemDelete((CFDictionaryRef)keychainQuery);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return returnValue;
}

+ (NSString *)UUIDString
{

    NSString *UUIDString = [self dataForKey:kUUIDStringKey];
    if (!UUIDString) {
        UUIDString = [UIDevice currentDevice].identifierForVendor.UUIDString;
        [self saveData:UUIDString forKey:kUUIDStringKey];
    }
    return UUIDString;
}

+ (NSString *)ct_parameterClientInfo
{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    UIDevice *device = [UIDevice currentDevice];
    NSString *model = [UIDevice ct_machineModelName];
    
    NSString *UUIDString = [self UUIDString];
    
    UIScreen *screen = [UIScreen mainScreen];
    CGSize screenSize = screen.bounds.size;
    float screenResoltionHeight = screenSize.height;
    float screenResoltionWidth = screenSize.width;
    if( screen && screen.scale > 0.001)
    {
        screenResoltionHeight *= screen.scale;
        screenResoltionWidth *= screen.scale;
    }
    
    NSString *otherStr = @"";
    NSString *carrierCode = [UIDevice ct_carrierCode];
    if (carrierCode) {
        otherStr = [otherStr stringByAppendingString:carrierCode];
    }
    otherStr = [otherStr stringByAppendingString:@","];
    
    // 渠道标识
    NSString *fromID = @"2000505"; // 正式版 fromID
    // 应用版本
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSDictionary *clientInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                model, @"model",
                                UUIDString,@"uniqid",
                                @"02:00:00:00:00:00", @"mac",
                                [NSString stringWithFormat:@"%@%@", device.systemName, device.systemVersion], @"os" ,
                                [NSString stringWithFormat:@"%.0fX%.0f", screenResoltionHeight, screenResoltionWidth], @"screen",
                                fromID, @"from",
                                version, @"version",
                                otherStr, @"other",
                                nil];
    
    NSString *clientInfoString = clientInfo.yy_modelToJSONString;
    return clientInfoString;
    
}

@end
