//
//  DRUPushStatus.h
//  Renren-UserKit
//
//  Created by 陈金铭 on 2019/9/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DRUAuthorizationStatus) {//定义前几字段与 UNAuthorizationStatus 一致 以确保转换逻辑；
    // The user has not yet made a choice regarding whether the application may post user notifications.
    DRUAuthorizationStatusNotDetermined = 0,
    
    // The application is not authorized to post user notifications.
    DRUAuthorizationStatusDenied,
    
    // The application is authorized to post user notifications.
    DRUAuthorizationStatusAuthorized,
    
    // The application is authorized to post non-interruptive user notifications.
    DRUAuthorizationStatusProvisional __IOS_AVAILABLE(12.0) __TVOS_AVAILABLE(12.0) __WATCHOS_AVAILABLE(5.0) __OSX_AVAILABLE(10.14)
};

@interface DRUPushStatus : NSObject

/**  推送状态 */
@property(nonatomic, assign, readonly) DRUAuthorizationStatus status;
/**  推送权限,默认开启 */
@property(nonatomic, assign) BOOL permission;
/**  应用内消息浮空,默认开启 */
@property(nonatomic, assign,getter=isFloatWindow) BOOL floatWindow;
/**  推送Token,仅在 (status == DRUAuthorizationStatusAuthorized || DRUAuthorizationStatusProvisional) && permission == YES 时返回正确值 */
@property(nonatomic, copy, readonly) NSString *deviceToken;

+ (instancetype)sharedPushStatus;

/**
 注册、获取推送服务权限
 */
- (void)registerPushNotification;


/**
 注销推送服务
 */
- (void)cancellationPushNotification;

/**
 配置deviceToken
 在 didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken 中使用
 @param deviceToken deviceToken
 */
- (void)createDeviceToken:(NSData *)deviceToken;


@end

NS_ASSUME_NONNULL_END
