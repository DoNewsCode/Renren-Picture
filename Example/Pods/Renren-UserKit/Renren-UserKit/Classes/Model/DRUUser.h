//
//  DRUUser.h
//  Pods-Renren-UserKit_Example
//
//  Created by Ming on 2019/3/21.
//  用户管理及信息

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DRUUserData, DRUUserLoginServerInfo,DRUUserTipCenter,DRUUserTip,DRUUserInfo;

typedef NS_ENUM(NSUInteger, DRULoginType) {
    DRULoginTypeAccount = 1,    // 账号加密码登录
    DRULoginTypePhoneNum        // 手机号另验证码登录
};

typedef NS_ENUM(NSUInteger, DRUUserStatus) {
    DRUUserStatusUnlogged,    // 未登录
    DRUUserStatusDeviant,    // 用户异常
    DRUUserStatusLogining,    // 登陆中
    DRUUserStatusLoginSuccess,    // 登陆成功
};

typedef NS_ENUM(NSInteger, DRUFissionStep) {
    DRUFissionStepDefault = -2,         // 默认值
    DRUFissionStepNeedFission = -1,     // 需要走裂变流程，进入裂变1，h5流程
    DRUFissionStepDontNeedFission = 0,  // 不需要走裂变流程，进入首页
    DRUFissionStepH5Animation = 1,      // 裂变1走完，需要进入裂变2--通讯录页面
    DRUFissionStepImportAddressBook = 2,    // 裂变2走完，需要进入裂变3--发布话题页面
    DRUFissionStepPublishTopic = 3  // 裂变3走完，进入首页
};

#pragma mark - 用户登录时传入的信息类，当使用切换账号功能时，使用这里的数据进行登录
@interface DRUUserLoginAccountInfo : NSObject

@property(nonatomic,assign) DRULoginType loginType;

/** 用户id，切换账号时，根据userid取对应的账号和密码 */
@property(nonatomic,copy) NSString *userid;
/** 用户昵称，显示在切换账号时的列表中 */
@property(nonatomic,copy) NSString *userName;
/** 账号 */
@property (nonatomic, copy) NSString *account;
/** 密码 */
@property (nonatomic, copy) NSString *password;
/** 手机号 */
@property(nonatomic,copy) NSString *phoneNumer;
/** 短信验证码 */
@property(nonatomic,copy) NSString *sms_verify_code;
/** 是否需要传递验证码给服务器 默认为NO */
@property (nonatomic, assign) BOOL isNeedVerification;
/** 验证码 */
@property (nonatomic, copy) NSString *verificationCode;
/** 图形验证码所需要的ick */
@property (nonatomic, copy) NSString *ick;
/** 某个账号是否是登录中; 多个账号中，只有一个账号的登录状态为YES */
@property (nonatomic, assign, getter=isLoginState) BOOL loginState;
/** 账号+密码登录时 是否支持验证码 1 为支持， 老用户登录，验证密码时传0*/
@property(nonatomic,assign) NSInteger isverify;
/** 是否选择了，这不是我 1 确定不是我， 0或不传*/
@property(nonatomic,copy) NSString *isNotMe;
/** 用户同意解冻并继续需要重新调登录并多传参数 is_confirm_unfreeze=1 表示同意解冻并继续 */
@property(nonatomic,copy) NSString *is_confirm_unfreeze;
/** 点击手机号仍在使用需要传1 */
@property(nonatomic,copy) NSString *is_mobile_still_use;
/** 绑定或换绑手机号时，需要将新手机号传入 */
@property(nonatomic,copy) NSString *bind_phone_number;
/** 绑定或换绑手机号时，需要将验证码传入 */
@property(nonatomic,copy) NSString *bind_mobile_captcha;
/// 增加字段is_mine用于跳过通过短信验证码登录时的问题验证
@property(nonatomic,assign) NSInteger is_mine;
/// 当用户状态7时需要验证码自动解冻
@property(nonatomic,copy) NSString *verifycode7;
/// 绑定或换绑手机号时，如果要强制换绑传 1
@property(nonatomic,assign) NSInteger is_confirm_conflict;

@end

#pragma mark - 用户数据信息写，包括登录数据，用户数据
@interface DRUUser : NSObject

/** 登录过程中保存的一些信息 ， 除登录组件外，其它组件用不到 */
@property(nonatomic,strong) DRUUserLoginAccountInfo *loginAccountInfo;
/** 服务端返回的用户登录数据 */
@property(nonatomic, strong) DRUUserLoginServerInfo *userLoginInfo;

@property(nonatomic,assign) DRUUserStatus status;

/** 服务端返回的用户数据 —— 旧，暂时保持旧功能能用 */
//@property (nonatomic, strong) DRUUserInfo *userInfo;

/** 服务端返回的用户数据 —— 重构*/
@property (nonatomic, strong) DRUUserData *userData;


@end

#pragma mark - 用户登录后，服务端返回的登录数据
@interface DRUUserLoginServerInfo : NSObject

/** 用户是否需要完善资料，0不需要，1需要 */
@property(nonatomic,assign) NSInteger fill_stage;
/** 当前用户的头像URL */
@property(nonatomic,copy) NSString *head_url;
/** 最后登录时间戳，毫秒 */
@property(nonatomic,assign) NSTimeInterval last_login_time;
/** 最后登录时间距离现在多久 几年前/几月前等 */
@property(nonatomic,copy) NSString *last_login_time_away_now;
/** 用户累计登录次数 */
@property(nonatomic,copy) NSString *login_count;
/** 长整型的当前时间，客户端使用时请根据本地时区决定如何使用 */
@property(nonatomic,assign) NSTimeInterval now;
/** 注册时间戳，毫秒 */
@property(nonatomic,assign) NSTimeInterval register_time;
/** 注册时间距离现在多久 几年前/几月前等 */
@property(nonatomic,copy) NSString *register_time_away_now;
/** 用户的密钥 */
@property(nonatomic,copy) NSString *secret_key;
/** 用户会话密钥 */
@property(nonatomic,copy) NSString *session_key;
/** 用户的票 */
@property(nonatomic,copy) NSString *ticket;
/** 表示当前用户的ID */
@property(nonatomic,copy) NSString *userid;
/** 表示当前用户的名字 */
@property(nonatomic,copy) NSString *userName;

/** 有使用，wiki没有说明，在旧项目中被存储在了cookie中 */
@property(nonatomic,copy) NSString *web_ticket;
/** 当has_right=0时 封闭隐私，当has_right=99时 是开放隐私 */
@property(nonatomic,assign) NSInteger has_right;
/** 本机的uuidstring */
@property(nonatomic,copy) NSString *uniq_id;
/** 服务端返回的 uniq_key */
@property(nonatomic,copy) NSString *uniq_key;
/** 账号异常的提醒，之前被挤下线，然后再次登录，如果有此值，需要弹窗提醒 */
@property(nonatomic,copy) NSString *account_unsafe_msg;
/** 根据account_unsafe_msg记录一个值，是否需要弹窗提示账号异常 */
@property(nonatomic,assign,getter=isNeedTipAbnormal) BOOL needTipAbnormal;

/// 是否是新注册用户
@property(nonatomic,assign) BOOL newRegister;
/// 是否绑定了手机号
@property(nonatomic,assign) BOOL bindMobile;

#warning TODO 张聪说，裂变没数据，先不管
/** 裂变步骤 -1需要裂变 1已阅动画，2已导入通讯录，3已发布一条新鲜事 0或无值表示不需要裂变
 *  -1 需要走裂变流程，进入裂变1，h5流程
 *  0 不需要走裂变流程，进入首页
 *  1 裂变1走完，需要进入裂变2--通讯录页面
 *  2 裂变2走完，需要进入裂变3--发布话题页面
 *  3 裂变3走完，进入首页
 */
@property(nonatomic,assign) DRUFissionStep fissionStep;


/// 重构新加的，没有说明，不知道有啥用
@property(nonatomic,copy) NSString *gender;

@property (nonatomic, assign) BOOL loginState;

@property(nonatomic,copy) NSString *clientConfigInfo;
@property(nonatomic,copy) NSString *h5AuthCookieInfo;
@property(nonatomic,assign) NSInteger isShowWelcomeBack;


@end


NS_ASSUME_NONNULL_END
