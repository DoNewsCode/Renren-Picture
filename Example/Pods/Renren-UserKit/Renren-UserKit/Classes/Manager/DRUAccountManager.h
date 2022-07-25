//
//  DRUAccount.h
//  Pods-Renren-UserKit_Example
//
//  Created by Ming on 2019/3/21.
//  账号/账户管理

#import <Foundation/Foundation.h>
#import "DRUUser.h"
#import "DRUUserData.h"
#import "DRUUserConfigInfo.h"

@class DRUUserConfigInfo;

NS_ASSUME_NONNULL_BEGIN


/**
 进度Block

 @param success 是否成功
 @param user 用户模型
 */
typedef void (^DRUAccountProgressBlock)(BOOL success, DRUUser * _Nullable user);

@interface DRUAccountManager : NSObject

/** 当前用户 */
@property (nonatomic, strong, nullable) DRUUser *currentUser;
/** 历史用户 */
@property (nonatomic, strong, nullable) DRUUser *historicalUser;

/** 当前用户的账号 */
@property (nonatomic, copy, nullable) NSString *account;

/** 当前用户的配置信息 —— 设置中的开关状态 */
@property(nonatomic,strong) DRUUserConfigInfo *userConfigInfo;

+ (instancetype)sharedInstance;

/** 是否是通用账号+手机号登录，即是否是通过登录流程登录的，此值不存在本地 */
@property(nonatomic,assign,getter=isLoginProcess) BOOL loginProcess;


/**
 是否有用户在登录
 如果用户存在，可以通过 currentUser 属性获取用户信息
 */
- (BOOL)isLogin;

/**
 用户登录

 @param accountInformation 用户账户信息 *必填
 @param handlerBlock
                        loginSuccess:是否登录成功;
                        error_code:错误码 -- 重要;
                        errorMessage:错误提示信息 -- 有时候也做图形验证码;
                        user:登录成功后的用户信息
 */
- (void)createUserLoginWith:(DRUUserLoginAccountInfo *)accountInformation
               handlerBlock:(void(^)(BOOL loginSuccess,
                                     NSInteger error_code,
                                     NSString *errorMessage,
                                     DRUUser *user))handlerBlock;

/**
 保存用户信息，会对 DRUUser 中的所有模型(登录信息，用户信息)进行保存，并赋值给 self.currentUser
 如果已经有登录的用户，请先获取 self.currentUser，然后将新修改的内容赋值并调用此方法
 @param user 需要保存的 user 信息
 */
- (void)saveUserInfoWithUser:(DRUUser *)user;

/**
 用户退出登录

 @param userid 根据userid来退出某个用户，并将本地关于此用户的信息移除
 @param progressBlock success:是否删除成功; user:返回nil
 */
- (void)logoutWithUserid:(NSString *)userid
               sessionId:(NSString *)sessionId
                progress:(DRUAccountProgressBlock)progressBlock;


/// 账号异常时，退出当前用户的操作
- (void)accountDeviantLogOut;

/// 当用户登录成功后，需要保存用户信息时调用
/// @param accountInformation 账号数据模型
/// @param user user 模型
- (void)saveUserLoginAccountInfo:(DRUUserLoginAccountInfo *)accountInformation andUser:(DRUUser *)user;

#pragma mark - 验证用户信息相关方法

/// 验证用户昵称和账号(account)是否符合规则
/// @param handlerBlock isViolation:昵称是否违禁
///                     isPhoneNumber:账号是否是手机号
- (void)validateUserInfoWithHandlerBlock:(void(^)(BOOL isViolation,
                                                  BOOL isPhoneNumber))handlerBlock;

/// 当账号account不符合规则时，修改账号并更新本地值
/// @param newAccount 新的账号
/// @param handlerBlock isSuccess:是否修改成功
///                     msg:未修改成功的提示信息
- (void)changeAccount:(NSString *)newAccount
         handlerBlock:(void(^)(BOOL isSuccess,
                               NSString *msg))handlerBlock;


/// 当用户昵称不符合规则时，修改用户昵称并更新本地值
/// @param newNickName 新昵称
/// @param handlerBlock isSuccess:是否修改成功
///                     msg:未修改成功的提示信息
- (void)changeNickName:(NSString *)newNickName
          handlerBlock:(void(^)(BOOL isSuccess,
                                NSString *msg))handlerBlock;


/// 获取用户是否设置了密码
/// @param handlerBlock isSetup:是否设置
- (void)isSetPasswordWithHandlerBlock:(void(^)(BOOL is_set_pwd))handlerBlock;



#pragma mark - 重构

/// 用户登录，此方法只是给其它组件提供了登录方法
/// @param accountInformation 账号信息
/// @param handlerBlock 是否登录成功，及错误信息
- (void)rr_test_userLoginWith:(DRUUserLoginAccountInfo *)accountInformation
                 handlerBlock:(void(^)(BOOL isLoginSuccess,
                                       NSString *errorMsg))handlerBlock;

/// 获取用户信息
- (void)rr_loadUserInfoWith:(nullable void(^)(DRUUser *user,
                                              NSString *errorStr))handlerBlock;

/// 获取用户配置信息 - 设置里的开关状态
- (void)rr_getUserConfigInfoWith:(nullable void(^)(DRUUserConfigInfo *userConfigInfo))handlerBlock;

/// 退出登录，这里不请求接口
- (void)rr_userLogout;

@end

NS_ASSUME_NONNULL_END
