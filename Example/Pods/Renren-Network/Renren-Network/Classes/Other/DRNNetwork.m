//
//  DRNNetwork.m
//  Renren-Network
//
//  Created by 陈金铭 on 2019/9/5.
//

#import "DRNNetwork.h"
#import "DRRFile.h"
#import "AFNetworkReachabilityManager.h"
#import <DNNetworkAccessibity.h>

#import "DNHttpClient.h"
#import <AFHTTPSessionManager.h>

#import "YYModel.h"
#import "DRNMacro.h"

#define DRNGlobalParameterFile @"GlobalParameter"
#define DRNPublicParameterFile @"PublicParameter"
@interface DRNNetwork ()

/// 公共参数
@property(nonatomic, strong, readwrite) DRNGlobalParameter *globalParameter;
/// 公共参数
@property(nonatomic, strong, readwrite) DRNPublicParameter *publicParameter;

@end

@implementation DRNNetwork

+ (void)load {
    [DRNNetwork sharedNetwork];
}

//单例对象
static DRNNetwork *_instance = nil;
//单例
+ (instancetype)sharedNetwork {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [_instance initialization];
    });
    return _instance;
}

- (void)initialization {
    // 开始监测
    [DNNetworkAccessibity start];
    [DNNetworkAccessibity setAlertEnable:YES];
    [DNNetworkAccessibity setStateDidUpdateNotifier:^(DNNetworkAccessibleStatus status) {
        self.availableState = (DRNetworkAvailableState)status;
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 网络状态改变的回调
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝网络");
                self.status = DRNNetworkStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                self.status = DRNNetworkStatusReachableViaWiFi;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                self.status = DRNNetworkStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                self.status = DRNNetworkStatusUnknown;
                break;
            default:
                break;
        }
    
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        NSDictionary *userInfo = @{ DRNNetworkReachabilityNotificationStatusItem: @(self.status) };
        [notificationCenter postNotificationName:DRNNetworkReachabilityDidChangeNotification object:nil userInfo:userInfo];
    }];

    //设置对象归档的路径及归档文件名
    NSString *globalParameterFilePath = [[DRRFile sharedFile].configFilePath stringByAppendingPathComponent:DRNGlobalParameterFile];
    NSData *globalParameterData = [NSKeyedUnarchiver unarchiveObjectWithFile:globalParameterFilePath];
    DRNGlobalParameter *globalParameter = nil;
    if (globalParameterData) {
       globalParameter = [DRNGlobalParameter yy_modelWithJSON:globalParameterData];
        self.globalParameter = globalParameter;
    } else {
        globalParameter = [DRNGlobalParameter new];
        self.globalParameter = globalParameter;
    }
    
    
    
    
    NSString *publicParameterFilePath = [[DRRFile sharedFile].configFilePath stringByAppendingPathComponent:DRNPublicParameterFile];
    NSData *publicParameterData = [NSKeyedUnarchiver unarchiveObjectWithFile:publicParameterFilePath];
    DRNPublicParameter *publicParameter = nil;
    if (publicParameterData) {
       publicParameter = [DRNPublicParameter yy_modelWithJSON:publicParameterData];
        self.publicParameter = publicParameter;
    } else {
        publicParameter = [DRNPublicParameter new];
        self.publicParameter = publicParameter;
    }
    
}

- (BOOL)createGlobalParameter:(DRNGlobalParameter *)globalParameter {
    if (globalParameter == nil) {
        return NO;
    }
    NSString *globalParameterFilePath = [[DRRFile sharedFile].configFilePath stringByAppendingPathComponent:DRNGlobalParameterFile];
    //将对象归档到指定路径
    BOOL flag1 = [NSKeyedArchiver archiveRootObject:[globalParameter yy_modelToJSONData] toFile:globalParameterFilePath];
    if (flag1 == NO) {
        return NO;
    }
    self.globalParameter = globalParameter;
    return YES;
    
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    [DNHttpClient setAFHTTPSessionManagerProperty:^(AFHTTPSessionManager *sessionManager) {
        sessionManager.requestSerializer.timeoutInterval = timeoutInterval;
    }];
}

- (BOOL)cancelGlobalParameter {
    NSString *globalParameterFilePath = [[DRRFile sharedFile].configFilePath stringByAppendingPathComponent:DRNGlobalParameterFile];
    NSFileManager *fileManager = [NSFileManager defaultManager];
     BOOL flag1 = [fileManager removeItemAtPath:globalParameterFilePath error:nil];
    if (flag1 == YES) {
        self.globalParameter = [DRNGlobalParameter new];
    }
    return flag1;
}

/// 设置通用参数
/// @param publicParameter publicParameter
- (BOOL)createPublicParameter:(DRNPublicParameter *)publicParameter {
    if (publicParameter == nil) {
        return NO;
    }
    NSString *publicParameterFilePath = [[DRRFile sharedFile].configFilePath stringByAppendingPathComponent:DRNPublicParameterFile];
    //将对象归档到指定路径
    BOOL flag1 = [NSKeyedArchiver archiveRootObject:[publicParameter yy_modelToJSONData] toFile:publicParameterFilePath];
    if (flag1 == NO) {
        return NO;
    }
    self.publicParameter = publicParameter;
    return YES;
}

/// 清除通用参数，通常在退出登陆成功后立即执行
- (BOOL)cancelPublicParameter {
    NSString *publicParameterFilePath = [[DRRFile sharedFile].configFilePath stringByAppendingPathComponent:DRNPublicParameterFile];
    NSFileManager *fileManager = [NSFileManager defaultManager];
     BOOL flag1 = [fileManager removeItemAtPath:publicParameterFilePath error:nil];
    if (flag1 == YES) {
        self.publicParameter = [DRNPublicParameter new];
    }
    return flag1;
}

- (void)dealloc{
    [DNNetworkAccessibity stop];
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

@end
