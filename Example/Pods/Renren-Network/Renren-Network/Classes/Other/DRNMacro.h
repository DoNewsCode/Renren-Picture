//
//  DRNMacro.h
//  Renren-Network
//
//  Created by 陈金铭 on 2019/10/14.
//

#import <Foundation/Foundation.h>

#import "DRNAPIManager.h"

NS_ASSUME_NONNULL_BEGIN


// object 中的 message为返回的信息  userInfo中的 message为返回的信息 responseCode为返回的错误码
UIKIT_EXTERN NSNotificationName const DRNNetworkRequestDeviantNotification;

// object 中的 message为返回的信息  userInfo中的 message为返回的信息 responseCode为返回的错误码
UIKIT_EXTERN NSNotificationName const DRNNetworkReachabilityDidChangeNotification;

// object 中的 message为返回的信息  userInfo中的 message为返回的信息 responseCode为返回的错误码
UIKIT_EXTERN NSNotificationName const DRNNetworkReachabilityNotificationStatusItem;

typedef NS_ENUM(NSInteger, DRNErrorType) {
    DRNErrorTypeLoginSessionKeyError = 1118005,// seesionKey有问题,需重新登录,多端登录
};

#define MCS_HOST(x) [NSString stringWithFormat:@"%@%@",[DRNAPIManager sharedManager].host,x];



NS_ASSUME_NONNULL_END
