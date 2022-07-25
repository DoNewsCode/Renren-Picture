//
//  DRSSafeManager.h
//  Pods-Renren-SafeKit_Example
//
//  Created by Ming on 2019/3/21.
//  安全管理类

#import <Foundation/Foundation.h>

#import "DRSAppInfo.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DRSSafeManagerType) {
    DRSSafeManagerTypeRelease,//发布模式
    DRSSafeManagerTypeDebug//测试模式
};


@interface DRSSafeManager : NSObject

/** App相关信息 */
@property(nonatomic, strong) DRSAppInfo *appInfo;
@property(nonatomic, assign, readonly) DRSSafeManagerType type;


+ (instancetype)sharedInstance;

//+ (instancetype)sharedInstanceWithType:(DRSSafeManagerType)type;
//
//+ (void)changeType:(DRSSafeManagerType)type;

@end

NS_ASSUME_NONNULL_END
