
#import <Foundation/Foundation.h>
#import <UIKit/UIKitDefines.h>

@interface UIDevice (UserKit)

// 获取MAC地址
+ (NSString *)macAddress;
// 设备是否是iPad
+ (BOOL)isDeviceiPad;
// 获取机器型号，原始型号
+ (NSString *)machineModel;
// 获取机器型号名称，不识别的设备返回 machineModel，如 iPhone 8,8 返回 iPhone 8,8
+ (NSString *)dn_machineModelName;
// 对机器型号做了结果过滤，不识别的设备返回设备类型，如 iPhone 8,8 返回 iPhone
+ (NSString *)prettyMachineModelName;
// 对低端机型的判断
+ (BOOL)isLowLevelMachine;
+ (BOOL)isiPhone5SeriesMachine;
// 设备可用空间
// freespace/1024/1024/1024 = B/KB/MB/14.02GB
+(NSNumber *)freeSpace;
// 设备总空间
+(NSNumber *)totalSpace;
// 获取运营商信息
+ (NSString *)carrierName;
// 获取运营商代码
+ (NSString *)carrierCode;
//获取电池电量
+ (CGFloat) getBatteryValue;
//获取电池状态
+ (NSInteger) getBatteryState;
// 是否能发短信 不准确
+ (BOOL) canDeviceSendMessage;
// 是否显示雾面效果
+ (BOOL)canShowBlurEffect;
// 内存信息
+ (unsigned int)freeMemory;
+ (unsigned int)usedMemory;
//判断手机是否越狱
+ (BOOL)isJailBroken;
+ (NSArray *)getDNSByHostname:(NSString *)hostname;
+ (NSDictionary *)externalIPInfo:(NSString *)url;
//获取设备的UUID
+ (NSString *)generateUUID;

+(BOOL)isLowMachine;

+(BOOL)isSupportBeautysDevice;
+(BOOL)is4SAndLowDevice;
@end
