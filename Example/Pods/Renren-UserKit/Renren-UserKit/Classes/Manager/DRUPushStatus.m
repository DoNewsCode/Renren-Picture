//
//  DRUPushStatus.m
//  Renren-UserKit
//
//  Created by 陈金铭 on 2019/9/6.
//

#import "DRUPushStatus.h"

#ifdef __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

/** 文件名称 */
static NSString *const DRUPushStatusFile = @"PushStatus";

@interface DRUPushStatus ()

@property(nonatomic, copy) NSString *filePath;
@property(nonatomic, strong) NSMutableDictionary *pushStatus;
@property(nonatomic, strong) NSUserDefaults *defaults;

/**  推送状态 */
@property(nonatomic, assign, readwrite) DRUAuthorizationStatus status;

@property(nonatomic, copy, readwrite) NSString *deviceToken;


@end

@implementation DRUPushStatus

static DRUPushStatus *_instance = nil;

+ (instancetype)sharedPushStatus {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization {
    [self checkCurrentNotificationStatus];
    self.defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *videoStatus = [self.defaults objectForKey:DRUPushStatusFile];
    if (videoStatus == nil) {
        NSDictionary *tempVideoStatus = @{@"permission" : [NSNumber numberWithBool:YES],
                                          @"deviceToken" : @"0000000000000000000"
                                          };
        videoStatus = tempVideoStatus;
        [self.defaults setObject:videoStatus forKey:DRUPushStatusFile];
        [self.defaults synchronize];
        
    }
    self.pushStatus = [NSMutableDictionary dictionaryWithDictionary:videoStatus];
    self.permission = [[self.pushStatus objectForKey:@"permission"] boolValue];
    self.deviceToken = [self.pushStatus objectForKey:@"deviceToken"];
}

#pragma mark - Override Methods

#pragma mark - Intial Methods

#pragma mark - Event Methods

#pragma mark - Public Methods
- (void)registerPushNotification {
    
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 10, *)) {
        UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = (id <UNUserNotificationCenterDelegate>)[UIApplication sharedApplication].delegate;
        NSLog(@"接收push的代理是：%@", [UIApplication sharedApplication].delegate);
        [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            if (granted) {
                // 允许推送
                [weakSelf checkDeviceToken];
            }else{
                //不允许
            }
            [weakSelf checkCurrentNotificationStatus];
            
        }];
    } else if(@available(iOS 8 , *)) {
        UIApplication * application = [UIApplication sharedApplication];
        
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
        [application registerForRemoteNotifications];
        
        [weakSelf checkCurrentNotificationStatus];
    } else {
        
        [weakSelf checkCurrentNotificationStatus];
    }
}

- (void)cancellationPushNotification {
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

- (void)setPermission:(BOOL)permission {
    _permission = permission;
    if (permission == [[self.pushStatus objectForKey:@"permission"] boolValue]) {
        return;
    }
    [self.pushStatus setObject:[NSNumber numberWithBool:permission] forKey:@"permission"];
    [self.defaults setObject:self.pushStatus forKey:DRUPushStatusFile];
    [self.defaults synchronize];
}

- (BOOL)isFloatWindow
{
//    DRUUserInfo *userInfo = [DRUAccountManager sharedInstance].currentUser.userInfo;
    
    DRUUserData *userData = [DRUAccountManager sharedInstance].currentUser.userData;
    
    // 服务器采用  NO 为开   YES  为关来记录开关状态，这里取下反
    // 注意：已经安装过APP的，在不点击 我的 tab 时，userInfo中没有此值 notify_pop_open_status
    // 后端的默认值为0，表示开启，因为此前版本没有此值做的兼容
    if (userData.notify_pop_open_status == -1) {
        return NO;
    }
    return YES;
}

- (void)setDeviceToken:(NSString *)deviceToken {
    _deviceToken = deviceToken;
    if ([deviceToken isEqualToString:[self.pushStatus objectForKey:@"deviceToken"]]) {
        return;
    }
    [self.pushStatus setObject:deviceToken forKey:@"deviceToken"];
    [self.defaults setObject:self.pushStatus forKey:DRUPushStatusFile];
    [self.defaults synchronize];
}
- (void)processPushMessageUserInfo:(NSDictionary *)userInfo {
    //    [self eventPushWith:[DRSPushUserInfo yy_modelWithJSON:userInfo]];
}

- (void)createDeviceToken:(NSData *)deviceToken {
    if (!deviceToken || ([deviceToken length] == 0)) {
        return;
    }
    
    
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    token = [token substringWithRange:NSMakeRange(1, [token length] - 2)];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.deviceToken = token;
}

#pragma mark - Private Methods
- (void)checkCurrentNotificationStatus {
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 10 , *)) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            weakSelf.status = (DRUAuthorizationStatus)settings.authorizationStatus;
            
        }];
    } else if (@available(iOS 8 , *)) {
        UIUserNotificationSettings * setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        
        if (setting.types == UIUserNotificationTypeNone) {
            // 没权限
            weakSelf.status = DRUAuthorizationStatusDenied;
        } else if (setting.types == UIUserNotificationTypeAlert) {
            
            weakSelf.status = DRUAuthorizationStatusNotDetermined;
        } else {
            
            weakSelf.status = DRUAuthorizationStatusAuthorized;
        }
    } else {
        
    }
    
}

- (void)checkDeviceToken {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIApplication sharedApplication] registerForRemoteNotifications];  // required to get the app to do anything at all about push notifications
        
    }];
}

@end
