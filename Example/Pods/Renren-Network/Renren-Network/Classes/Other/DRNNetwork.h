//
//  DRNNetwork.h
//  Renren-Network
//
//  Created by 陈金铭 on 2019/9/5.
//  网络配置管理 在登录后请使用createGlobalParameter设置公共参数 在退出登录时请使用cancelGlobalParameter 清空公共参数

#import <Foundation/Foundation.h>
#import "DRNGlobalParameter.h"
#import "DRNPublicParameter.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DRNNetworkStatus) {
    DRNNetworkStatusUnknown          = -1,
    DRNNetworkStatusNotReachable     = 0,
    DRNNetworkStatusReachableViaWWAN = 1,
    DRNNetworkStatusReachableViaWiFi = 2,
};
typedef NS_ENUM(NSUInteger, DRNetworkAvailableState) {
    DNNetworkAvailableStateChecking  = 0,
    DNNetworkAvailableStateUnknown     ,
    DNNetworkAvailableStateDNNetworkAccessible  ,
    DNNetworkAvailableStateRestricted  ,
};

@interface DRNNetwork : NSObject
/// 当前网络可用状态
@property(nonatomic, assign) DRNetworkAvailableState availableState;

/// 网络状态
@property(nonatomic, assign) DRNNetworkStatus status;

/// 公共参数
@property(nonatomic, strong, readonly) DRNGlobalParameter *globalParameter;

/// 公共参数
@property(nonatomic, strong, readonly) DRNPublicParameter *publicParameter;

//单例
+ (instancetype)sharedNetwork;

/// 设置公共参数
/// @param globalParameter globalParameter
- (BOOL)createGlobalParameter:(DRNGlobalParameter *)globalParameter;

/// 清除公共参数，通常在退出登陆成功后立即执行
- (BOOL)cancelGlobalParameter;

/// 设置通用参数
/// @param publicParameter globalParameter
- (BOOL)createPublicParameter:(DRNPublicParameter *)publicParameter;

/// 清除通用参数，通常在退出登陆成功后立即执行
- (BOOL)cancelPublicParameter;

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval;

@end

NS_ASSUME_NONNULL_END
