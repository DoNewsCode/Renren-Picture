

#import "UIDevice+UserKit.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mount.h>
#import <mach/mach.h>
#import <arpa/inet.h>
//#import "NSDictionary_JSONExtensions.h"

@implementation UIDevice (UserKit)

// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
+ (NSString *)macAddress{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

+ (BOOL)isDeviceiPad{
    BOOL iPadDevice = NO;
    
    // Is userInterfaceIdiom available?
    if ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)])
    {
        // Is device an iPad?
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            iPadDevice = YES;
    }
    
    return iPadDevice;
}

+ (NSString *)machineModel {
    static dispatch_once_t one;
    static NSString *model;
    dispatch_once(&one, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return model;
}

+ (NSString *)dn_machineModelName {
    static dispatch_once_t one;
    static NSString *name;
    dispatch_once(&one, ^{
        NSString *model = [self machineModel];
        if (!model) return;
        NSDictionary *dic = @{
            @"Watch1,1" : @"Apple Watch 38mm",
            @"Watch1,2" : @"Apple Watch 42mm",
            @"Watch2,3" : @"Apple Watch Series 2 38mm",
            @"Watch2,4" : @"Apple Watch Series 2 42mm",
            @"Watch2,6" : @"Apple Watch Series 1 38mm",
            @"Watch1,7" : @"Apple Watch Series 1 42mm",
            
            @"iPod1,1" : @"iPod touch 1",
            @"iPod2,1" : @"iPod touch 2",
            @"iPod3,1" : @"iPod touch 3",
            @"iPod4,1" : @"iPod touch 4",
            @"iPod5,1" : @"iPod touch 5",
            @"iPod7,1" : @"iPod touch 6",
            
            @"iPhone1,1" : @"iPhone 1G",
            @"iPhone1,2" : @"iPhone 3G",
            @"iPhone2,1" : @"iPhone 3GS",
            @"iPhone3,1" : @"iPhone 4 (GSM)",
            @"iPhone3,2" : @"iPhone 4",
            @"iPhone3,3" : @"iPhone 4 (CDMA)",
            @"iPhone4,1" : @"iPhone 4S",
            @"iPhone5,1" : @"iPhone 5",
            @"iPhone5,2" : @"iPhone 5",
            @"iPhone5,3" : @"iPhone 5c",
            @"iPhone5,4" : @"iPhone 5c",
            @"iPhone6,1" : @"iPhone 5s",
            @"iPhone6,2" : @"iPhone 5s",
            @"iPhone7,1" : @"iPhone 6 Plus",
            @"iPhone7,2" : @"iPhone 6",
            @"iPhone8,1" : @"iPhone 6s",
            @"iPhone8,2" : @"iPhone 6s Plus",
            @"iPhone8,4" : @"iPhone SE",
            @"iPhone9,1" : @"iPhone 7",
            @"iPhone9,2" : @"iPhone 7 Plus",
            @"iPhone9,3" : @"iPhone 7",
            @"iPhone9,4" : @"iPhone 7 Plus",
            @"iPhone10,1" : @"iPhone 8",
            @"iPhone10,4" : @"iPhone 8",
            @"iPhone10,2" : @"iPhone 8 Plus",
            @"iPhone10,5" : @"iPhone 8 Plus",
            @"iPhone10,3" : @"iPhone X",
            @"iPhone10,6" : @"iPhone X",
            @"iPhone11,8" : @"iPhone XR",
            @"iPhone11,2" : @"iPhone XS",
            @"iPhone11,6" : @"iPhone XS Max",
            @"iPhone11,4" : @"iPhone XS Max",
            @"iPhone12,1" : @"iPhone 11",
            @"iPhone12,3" : @"iPhone 11 Pro",
            @"iPhone12,5" : @"iPhone 11 Pro Max",
            
            @"iPad1,1" : @"iPad 1",
            @"iPad2,1" : @"iPad 2 (WiFi)",
            @"iPad2,2" : @"iPad 2 (GSM)",
            @"iPad2,3" : @"iPad 2 (CDMA)",
            @"iPad2,4" : @"iPad 2",
            @"iPad2,5" : @"iPad mini 1",
            @"iPad2,6" : @"iPad mini 1",
            @"iPad2,7" : @"iPad mini 1",
            @"iPad3,1" : @"iPad 3 (WiFi)",
            @"iPad3,2" : @"iPad 3 (4G)",
            @"iPad3,3" : @"iPad 3 (4G)",
            @"iPad3,4" : @"iPad 4",
            @"iPad3,5" : @"iPad 4",
            @"iPad3,6" : @"iPad 4",
            @"iPad4,1" : @"iPad Air",
            @"iPad4,2" : @"iPad Air",
            @"iPad4,3" : @"iPad Air",
            @"iPad4,4" : @"iPad mini 2",
            @"iPad4,5" : @"iPad mini 2",
            @"iPad4,6" : @"iPad mini 2",
            @"iPad4,7" : @"iPad mini 3",
            @"iPad4,8" : @"iPad mini 3",
            @"iPad4,9" : @"iPad mini 3",
            @"iPad5,1" : @"iPad mini 4",
            @"iPad5,2" : @"iPad mini 4",
            @"iPad5,3" : @"iPad Air 2",
            @"iPad5,4" : @"iPad Air 2",
            @"iPad6,3" : @"iPad Pro (9.7 inch)",
            @"iPad6,4" : @"iPad Pro (9.7 inch)",
            @"iPad6,7" : @"iPad Pro (12.9 inch)",
            @"iPad6,8" : @"iPad Pro (12.9 inch)",
            
            @"i386" : @"Simulator x86",
            @"x86_64" : @"Simulator x64",
        };
        name = dic[model];
        if (!name) name = model;
    });
    return name;
}

+ (NSString *)prettyMachineModelName{
    NSString *machineModel = [UIDevice machineModel];

    // iPhone
    if ([machineModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([machineModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([machineModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([machineModel isEqualToString:@"iPhone3,1"]
        || [machineModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([machineModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([machineModel isEqualToString:@"iPhone5,1"]
        || [machineModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([machineModel isEqualToString:@"iPhone6,1"]
        || [machineModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    
    if ([machineModel hasPrefix:@"iPhone"]) {
        return @"iPhone";
    }
    
    // iPod
    if ([machineModel isEqualToString:@"iPod1,1"])      return @"iPod 1";
    if ([machineModel isEqualToString:@"iPod2,1"])      return @"iPod 2";
    if ([machineModel isEqualToString:@"iPod3,1"])      return @"iPod 3";
    if ([machineModel isEqualToString:@"iPod4,1"])      return @"iPod 4";
    if ([machineModel isEqualToString:@"iPod5,1"])      return @"iPod 5";
    
    if ([machineModel hasPrefix:@"iPod"]) {
        return @"iPod";
    }
    
    // iPad
    if ([machineModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([machineModel isEqualToString:@"iPad2,1"])      return @"iPad 2";
    if ([machineModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([machineModel isEqualToString:@"iPad2,3"])      return @"iPad 2";
    
    if ([machineModel isEqualToString:@"iPad3,1"])      return @"iPad 3";
    if ([machineModel isEqualToString:@"iPad3,2"])      return @"iPad 3";
    if ([machineModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([machineModel isEqualToString:@"iPad3,4"])      return @"iPad 4";
    
    return machineModel;
}

// 是否显示雾面效果
+ (BOOL)canShowBlurEffect{
    NSString *device = [[UIDevice machineModel] lowercaseString];
    // 4s
    //    if ([device rangeOfString:@"iphone4,1"].length > 0) {
    //        return YES;
    //    }
    if ([device rangeOfString:@"iphone5"].length > 0) {
        return YES;
    }
    if ([device rangeOfString:@"iphone6"].length > 0) {
        return YES;
    }
    if ([device rangeOfString:@"iphone5,2"].length > 0) {
        return YES;
    }
    //    if ([device rangeOfString:@"ipod4"].length > 0) {
    //        return 1;
    //    }
    if ([device rangeOfString:@"ipod5"].length > 0) {
        return YES;
    }
    return NO;
}

// 是否能发短信 不准确 清产品确认该问题
+ (BOOL) canDeviceSendMessage{
    NSString *machineModelName = [UIDevice dn_machineModelName];
    if ([machineModelName hasPrefix:@"iPhone"]) {
        return YES;
    }
    if ([machineModelName hasPrefix:@"iPod"] || [machineModelName hasPrefix:@"Simulator"]) {
        return NO;
    }
    if ([machineModelName hasPrefix:@"iPad"]) {
        if ([machineModelName rangeOfString:@"CDMA"].location != NSNotFound ||
            [machineModelName rangeOfString:@"GSM"].location != NSNotFound ||
            [machineModelName rangeOfString:@"3G"].location != NSNotFound ||
            [machineModelName rangeOfString:@"4G"].location != NSNotFound) {
            return YES;
        }else {
            return NO;
        }
    }
    return YES;
}
// 对低端机型的判断
+ (BOOL)isLowLevelMachine{
    NSString *machineModel = [UIDevice dn_machineModelName];
    
    NSArray *lowLevel = [NSArray arrayWithObjects:@"iPhone 1G", @"iPhone 3G", @"iPhone 3GS",
                         @"iPod Touch 1G", @"iPod Touch 2G", @"iPod Touch 3G",
                         @"iPad",
                         @"iPhone 4 (GSM)", @"iPhone 4 (CDMA)", @"iPhone 4S",
                         nil];
    
    for (NSString *lower in lowLevel) {
        if ([machineModel isEqualToString:lower]) {
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)isiPhone5SeriesMachine{
    NSString *machineModel = [UIDevice prettyMachineModelName];
    
    NSArray *lowLevel = [NSArray arrayWithObjects:@"iPhone 5", @"iPhone 5c", @"iPhone 5S", nil];
    
    for (NSString *lower in lowLevel) {
        if ([machineModel isEqualToString:lower]) {
            return YES;
        }
    }
    
    return NO;
}

+(NSNumber *)freeSpace{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/private/var", &buf) >= 0){
        freespace = (long long)buf.f_bsize * buf.f_bfree;
    }

    return [NSNumber numberWithLongLong:freespace];
}

+(NSNumber *)totalSpace{
	struct statfs buf;	
	long long totalspace = -1;
	if(statfs("/private/var", &buf) >= 0){
		totalspace = (long long)buf.f_bsize * buf.f_blocks;
	} 
	return [NSNumber numberWithLongLong:totalspace];
}

// 获取运营商信息
+ (NSString *)carrierName{
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    
    if (carrier == nil) {
        return nil;
    }
    NSString *carrierName = [carrier carrierName];
//    NSString *mcc = [carrier mobileCountryCode];
//    NSString *mnc = [carrier mobileNetworkCode];
//    DDLogInfo(@"Carrier Name: %@ mcc: %@ mnc: %@", carrierName, mcc, mnc);
    return carrierName;
}

+ (NSString *)carrierCode{
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    
    if (carrier == nil) {
        return nil;
    }
    NSString *mcc = [carrier mobileCountryCode];
    NSString *mnc = [carrier mobileNetworkCode];
    NSString *carrierCode = [NSString stringWithFormat:@"%@%@", mcc, mnc];
    return carrierCode;
}
+ (CGFloat) getBatteryValue{
    UIDevice* device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    return device.batteryLevel;
}
+ (NSInteger) getBatteryState{
    UIDevice* device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    return device.batteryState;
}

// 内存信息
+ (unsigned int)freeMemory{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pagesize);
    (void) host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    return vm_stat.free_count * pagesize;
}

+ (unsigned int)usedMemory{
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    return (kerr == KERN_SUCCESS) ? info.resident_size : 0;
}

+ (NSDictionary *)externalIPInfo:(NSString *)url{
    if (!url) {
        return nil;
    }
    // 1. 获取外网IP
    NSString *externUrl = [NSString stringWithFormat:@"http://%@/ip_json.php",url];
    NSURLRequest *IPRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:externUrl]];
    NSHTTPURLResponse *IPResponse = nil;
    NSError *IPError = nil;
    NSData *IPData = [NSURLConnection sendSynchronousRequest:IPRequest
                                           returningResponse:&IPResponse
                                                       error:&IPError];
    NSString *IPStr = [[NSString alloc] initWithData:IPData encoding:NSUTF8StringEncoding];
    NSLog(@"External IP Addr: %@", IPStr);
    
    // 解析 Sessid
    NSString *sessionID = nil;
    NSString *cookieValue = [IPResponse.allHeaderFields objectForKey:@"Set-Cookie"];
    //PHPSESSID=hepesbvoulnjqlsftjlvm2gv8q0odf07; path=/
    NSRange sessionIDRange = [cookieValue rangeOfString:@"(?<=PHPSESSID=)\\w+" options:NSRegularExpressionSearch];
    if (sessionIDRange.location > cookieValue.length ||
        sessionIDRange.location + sessionIDRange.length > cookieValue.length ||
        sessionIDRange.length > cookieValue.length) {
        return nil;
    }
    sessionID = [cookieValue substringWithRange:sessionIDRange];
    if (sessionID == nil || sessionID.length <= 0) {
        return nil;
    }
    
    // 2. 构造发起DNS查询接口
    NSString *DNSQueryHostname = [NSString stringWithFormat:@"%ld.%@-%@-%@.%@",
                                  (long)[[NSDate date] timeIntervalSince1970],
                                  @"111111",
                                  IPStr,
                                  sessionID
                                  ,url];
    NSArray *DNSArray = [UIDevice getDNSByHostname:DNSQueryHostname];
    if (DNSArray == nil || ![DNSArray containsObject:@"127.0.0.1"]) {
        // DNS 解析出错
        return nil;
    }
    
    // 3. 获取DNS地址及DNS是否用错等信息
    NSString *DNSQueryURL = [NSString stringWithFormat:@"http://%@/client_check_dns_json.php",url];
    NSURLRequest *DNSRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:DNSQueryURL]];
    NSHTTPURLResponse *DNSQueryResponse = nil;
    NSError *DNSQueryError = nil;
    NSData *DNSQueryData = [NSURLConnection sendSynchronousRequest:DNSRequest
                                                 returningResponse:&DNSQueryResponse
                                                             error:&DNSQueryError];
    NSString *DNSQueryStr = [[NSString alloc] initWithData:DNSQueryData encoding:NSUTF8StringEncoding];
    
    NSDictionary *DNSQueryResult = [NSJSONSerialization JSONObjectWithData:DNSQueryData options:0 error:nil];
    
//    NSDictionary *DNSQueryResult = [NSDictionary dictionaryWithJSONString:DNSQueryStr error:NULL];
    return DNSQueryResult;
}

+ (NSArray *)getDNSByHostname:(NSString *)hostname{
    if (hostname == nil || hostname.length <= 0) {
        hostname = @"apple.com";
    }
    
    Boolean result = FALSE;
    CFHostRef hostRef = NULL;
    CFArrayRef addresses = NULL;
    hostRef = CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)hostname);
    if (hostRef) {
        result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL);
        if (result == TRUE) {
            addresses = CFHostGetAddressing(hostRef, &result);
        }
    }
    
    NSMutableArray *DNSArray = [NSMutableArray arrayWithCapacity:3];
    if (result == TRUE) {
        for(int i = 0; i < CFArrayGetCount(addresses); i++){
            struct sockaddr_in* remoteAddr;
            CFDataRef saData = (CFDataRef)CFArrayGetValueAtIndex(addresses, i);
            remoteAddr = (struct sockaddr_in*)CFDataGetBytePtr(saData);
            
            if(remoteAddr != NULL){
                NSString *strDNS =[NSString stringWithCString:inet_ntoa(remoteAddr->sin_addr) encoding:NSASCIIStringEncoding];
              //  NSLog(@"RESOLVED %d:<%@>", i, strDNS);
                [DNSArray addObject:strDNS];
            }
        }
        
    } else {
        return nil;
    }
    
    return DNSArray;
}

+ (BOOL)isJailBroken
{
    struct stat s;
    
    int result = stat("/private/var/lib/apt/", &s);
    if (result == 0) {
        return YES;
    }
    
    result = stat("/Library/MobileSubstrate/MobileSubstrate.dylib", &s);
    if (result == 0) {
        return YES;
    }
    
    result = stat("/var/cache/apt", &s);
    if (result == 0) {
        return YES;
    }
    
    result = stat("/etc/apt", &s);
    if (result == 0) {
        return YES;
    }
    
    return NO;
}

+(BOOL)isLowMachine{
    BOOL isLowMachine = NO;
    NSString *machineModel = [UIDevice machineModel];
    
    if ([machineModel hasPrefix:@"iPhone"]) {
        NSString *version = [machineModel substringFromIndex:6];
        NSArray *versionInfo = [version componentsSeparatedByString:@","];
        NSString *model = [versionInfo firstObject];
        switch ([model integerValue]) {
            case 6:
                
                break;
            case 5:
                
                break;
            case 4:
            case 3:
            case 2:
            case 1:
                isLowMachine = YES;
                break;
            default:
                break;
        }
    }else if ([machineModel hasPrefix:@"iPod"]){
        NSString *version = [machineModel substringFromIndex:4];
        NSArray *versionInfo = [version componentsSeparatedByString:@","];
        NSString *model = [versionInfo firstObject];
        switch ([model integerValue]) {
            case 4:
            case 3:
            case 2:
            case 1:
                isLowMachine = YES;
                break;
            default:
                break;
        }
        
    }else if ([machineModel hasPrefix:@"iPad"]){
        NSString *version = [machineModel substringFromIndex:4];
        NSArray *versionInfo = [version componentsSeparatedByString:@","];
        NSString *model = [versionInfo firstObject];
        switch ([model integerValue]) {
            case 3:
            case 2:
            case 1:
                isLowMachine = YES;
                break;
            default:
                break;
        }
    }
    return isLowMachine;
}

+ (NSString *)generateUUID
{
    NSString *result = nil;
    
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    
    if (uuid) {
        result = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
        CFRelease(uuid);
    }
    
    return result;
}

static NSInteger supportBeauty = -1;

+(BOOL)isSupportBeautysDevice{
    if (supportBeauty >= 0) {
        return supportBeauty;
    }

    NSString *machineModel = [UIDevice machineModel];
    if ([machineModel hasPrefix:@"iPhone"]) {
        NSString *version = [machineModel substringFromIndex:6];
        NSArray *versionInfo = [version componentsSeparatedByString:@","];
        NSString *model = [versionInfo firstObject];
        if ([model integerValue] >= 6) {//从iphone5s开始以上机型
            supportBeauty = YES;
            return supportBeauty;
        }
    }

    supportBeauty = NO;
    return supportBeauty;
}

static NSInteger is4SAndLow = -1;
+(BOOL)is4SAndLowDevice{
    if (is4SAndLow >= 0) {
        return is4SAndLow;
    }

    NSString *machineModel = [UIDevice machineModel];
    if ([machineModel hasPrefix:@"iPhone"]) {
        NSString *version = [machineModel substringFromIndex:6];
        NSArray *versionInfo = [version componentsSeparatedByString:@","];
        NSString *model = [versionInfo firstObject];

        CGFloat systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
        if ([model integerValue] <= 4 && systemVersion < 8) {
            is4SAndLow = YES;
            return is4SAndLow;
        }
    }

    is4SAndLow = NO;
    return is4SAndLow;
}
@end
