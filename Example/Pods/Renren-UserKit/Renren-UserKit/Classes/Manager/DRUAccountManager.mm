//
//  DRUAccount.m
//  Pods-Renren-UserKit_Example
//
//  Created by Ming on 2019/3/21.
//

#import "DRUAccountManager.h"
#import <YYModel/YYModel.h>
#import <YYCategories/YYCategories.h>
#import "DRUClientLoginViewModel.h"
#import "DRUProfileGetInfoViewModel.h"
#import "DRUClientLogoutViewModel.h"
#import "DRULoginByVerifyCodeViewModel.h"
#import "DRRFile.h"
//#import <AdSupport/AdSupport.h>
#import "DRUValidateNameRequest.h"
#import "DRUGetBindInfoRequest.h"
#import "DRUAccountIsMobileRequest.h"
#import "DRUChangeAccountRequest.h"
#import "DRUChangNickNameInfoRequest.h"
#import "DRUGetLoginInfoRequest.h"
#import "DRUPushStatus.h"

#import <WCDB/WCDB.h>

#import "DRUUser+WCTTableCoding.h"
#import "DRNNetwork.h"


// ********** 一些重构后，新的的请求类 **********

#import "DRULoginByPasswordRequest.h"  // 登录请求
#import "DRUGetUsersBasicInfoRequest.h" // 获取用户信息
#import "DRUBatchgetRequest.h"  // 获取信息配置信息 —— 设置里的开关状态


// ********** 一些重构后，新的的请求类 **********

/// 文件名称
#define DRUUserInfoFileName @"DRUUserInfoTable.db"
/// 文件路径、表的路径
#define DRUUserInfoFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
/// 表名 、存DRUUser
#define DRUUserInfoTableName @"DRUUserInfoTable"

/// 多个账号的路径更换WCDB后暂不考虑
//#define DRUUserLoginAccountInfoFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"/DRUUserLoginAccountInfo.data"]

@interface DRUAccountManager ()

@property(nonatomic,strong) WCTDatabase *database;

/** 账号登录的viewModel */
@property(nonatomic,strong) DRUClientLoginViewModel *clientLoginViewModel;
/** 验证码登录的viewModel*/
@property(nonatomic,strong) DRULoginByVerifyCodeViewModel *loginByVerifyCodeViewModel;
/** 获取用户信息的viewModel */
@property(nonatomic,strong) DRUProfileGetInfoViewModel *profileGetInfoViewModel;
/** 退出账号的viewModel */
@property(nonatomic,strong) DRUClientLogoutViewModel *clientLogoutViewModel;

@property(nonatomic, copy) NSString *historicalUserFilePath;


@end

@implementation DRUAccountManager

static DRUAccountManager *_instance = nil;

#pragma mark - 懒加载
- (WCTDatabase *)database
{
    if (!_database) {
        
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *dbPath = [documentPath stringByAppendingPathComponent:DRUUserInfoFileName];
        NSLog(@"dbPath == %@", dbPath);
        _database = [[WCTDatabase alloc] initWithPath:dbPath];
    }
    return _database;
}


- (DRULoginByVerifyCodeViewModel *)loginByVerifyCodeViewModel
{
    if (!_loginByVerifyCodeViewModel) {
        _loginByVerifyCodeViewModel = [[DRULoginByVerifyCodeViewModel alloc] init];
    }
    return _loginByVerifyCodeViewModel;
}

- (DRUClientLoginViewModel *)clientLoginViewModel
{
    if (!_clientLoginViewModel) {
        _clientLoginViewModel = [[DRUClientLoginViewModel alloc] init];
    }
    return _clientLoginViewModel;
}

- (DRUProfileGetInfoViewModel *)profileGetInfoViewModel
{
    if (!_profileGetInfoViewModel) {
        _profileGetInfoViewModel = [[DRUProfileGetInfoViewModel alloc] init];
    }
    return _profileGetInfoViewModel;
}

- (DRUClientLogoutViewModel *)clientLogoutViewModel
{
    if (!_clientLogoutViewModel) {
        _clientLogoutViewModel = [[DRUClientLogoutViewModel alloc] init];
    }
    return _clientLogoutViewModel;
}

- (NSString *)account
{
    DRUUserLoginAccountInfo *info = self.currentUser.loginAccountInfo;
    if (info.loginType == DRULoginTypePhoneNum) {
        _account = info.phoneNumer;
    } else {
        _account = info.account;
    }
    return _account;
}


- (void)setCurrentUser:(DRUUser *)currentUser
{
    _currentUser = currentUser;
    
    if (currentUser) {

        [[DRRFile sharedFile] craeteCurrentUserFilePathWithUserid:currentUser.userLoginInfo.userid];
    } else {

        [[DRRFile sharedFile] craeteCurrentUserFilePathWithUserid:nil];
    }
}

#pragma mark - 单例
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.historicalUserFilePath = [[DRRFile sharedFile].configFilePath stringByAppendingPathComponent:@"historicalUser"];
               
        /// 从数据库中取
        DRUUser *user = [self getUserInfoFromLocal];
        
        if (user) {
            // 有就用数据库中的，还要看看旧的里面有没有，有就删除旧的
            self.currentUser = user;
            // 将旧的用户信息删除
            [self deleteOldUserInfo];
        } else {
            // 也要看看旧的有没有，有就拿到数据库里，并删除旧的
            [self handlerOldUserInfo];
            // 直接从本地数据库中取，目前本地数据库只存一份信息
            self.currentUser = [self getUserInfoFromLocal];
        }
        
        /// 对版本进行比较，不同则更新下用户登录数据，
        // [self compareVersionsUpdateLoginData];
        /// 获取用户配置信息
        [self rr_getUserConfigInfoWith:nil];
    }
    
    return self;
}

/** 对版本进行比较，不同则更新下用户登录数据 */
- (void)compareVersionsUpdateLoginData
{
    /// 如果用户没登录，比个毛线
    if (!self.isLogin) {
        return;
    }
    /// 本地保存的 key
    NSString *keyStr = @"DRULastVersion";
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:keyStr];;
    NSString *currentVersion = [UIApplication sharedApplication].appVersion;
    
    /// 版本发生了变化，就走接口更新登录信息
    if (![currentVersion isEqualToString:lastVersion]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:keyStr];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        DRUGetLoginInfoRequest *request = [DRUGetLoginInfoRequest new];
        request.session_key = self.currentUser.userLoginInfo.session_key;
        request.secret_key = self.currentUser.userLoginInfo.secret_key;
        
        // 更新登录信息，更新本地信息
        [request startWithSuccess:^(DNResponse *response) {
            
                
            NSDictionary *responseObject = response.responseObject;
            
            DRUUserLoginServerInfo *userLoginInfo = [DRUUserLoginServerInfo yy_modelWithJSON:responseObject];
            
            
            if (![responseObject containsObjectForKey:@"fissionStep"]) {
                userLoginInfo.fissionStep = DRUFissionStepDontNeedFission;
            }
            
            // 不为空时，记录一个值，需要弹窗提示账号异常
            if ([userLoginInfo.account_unsafe_msg isNotBlank]) {
                userLoginInfo.needTipAbnormal = YES;
            }
            
            // 更新本地信息
            // 修改成功了，更新下本地记录的值
            DRUUser *user = self.currentUser;
            user.userLoginInfo = userLoginInfo;
            [self saveUserInfoWithUser:user];
            
            // 更新登录信息时，也更新全局参数
            // 登录成功或修改密码成功后，更新全局参数
            DRNGlobalParameter *globalParameter = [DRNGlobalParameter new];
            globalParameter.sessionKey = userLoginInfo.session_key;
            globalParameter.uniqKey = userLoginInfo.uniq_key;
            globalParameter.uniqID = userLoginInfo.uniq_id;
            globalParameter.secretKey = userLoginInfo.secret_key;
            [[DRNNetwork sharedNetwork] createGlobalParameter:globalParameter];
            
            // 重构
            DRNPublicParameter *publicParameter = [DRNPublicParameter new];
            publicParameter.sessionKey = userLoginInfo.session_key;
            publicParameter.uniqKey = userLoginInfo.uniq_key;
            publicParameter.uniqID = userLoginInfo.uniq_id;
            publicParameter.secretKey = userLoginInfo.secret_key;
            
            [[DRNNetwork sharedNetwork] createPublicParameter:publicParameter];
            
        } failure:^(NSError *error) {
            NSLog(@"/client/getLoginInfo 出错了 == %@", error);
        }];
    }
}

#pragma mark - 兼容更换WCDB之前的方法
/**
  处理旧版用户数据，并保存到WCDB中
 */
- (void)handlerOldUserInfo
{
    
    NSString *accountPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"/DRUUserLoginAccountInfo.data"];

    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // 如果有这个文件，说明有旧用户信息，将信息更新到WCDB中
    BOOL isExists = [fileMgr fileExistsAtPath:accountPath];
    if (isExists) {
        
        NSDictionary *users = [NSKeyedUnarchiver unarchiveObjectWithFile:accountPath];
        
        NSArray *keys = [users allKeys];
        for (NSString *userid in keys) {
            DRUUserLoginAccountInfo *accountInfo = [users objectForKey:userid];
            if (accountInfo.isLoginState) {
                
                /// 是登录状态的，旧的文件名称及路径，需要保存到新数据库中
                NSString *fileName = [NSString stringWithFormat:@"DRUUserInfoFile_%@.data", userid];
                NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
                
                DRUUser *userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
                NSLog(@"DNInputaccountFilepath == %@", filePath);
                
                userModel.loginAccountInfo = accountInfo;
                /// 旧的路径下是有用户登录的
                /// 将旧用户数据，更新到WCDB中
                [self saveUserInfoWithUser:userModel];
                
                /// 删除旧的文件
                BOOL bRet = [fileMgr fileExistsAtPath:filePath];
                if (bRet) {
                    NSError *err;
                    [fileMgr removeItemAtPath:filePath error:&err];
                    NSLog(@"删除旧用户信息本地文件 ---  成功");
                }
                
            } else {
                /// 旧的文件名称及路径
                NSString *fileName = [NSString stringWithFormat:@"DRUUserInfoFile_%@.data", userid];
                NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
                
                /// 删除旧的文件
                BOOL bRet = [fileMgr fileExistsAtPath:filePath];
                if (bRet) {
                    NSError *err;
                    [fileMgr removeItemAtPath:filePath error:&err];
                    NSLog(@"删除旧用户信息本地文件 ---  成功");
                }
            }
        }
        [fileMgr removeItemAtPath:accountPath error:nil];
        NSLog(@"删除旧账号信息文件 ---- 成功");
    }
}

/**
  处理旧版用户数据，只做删除操作
 */
- (void)deleteOldUserInfo
{
    
    NSString *accountPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"/DRUUserLoginAccountInfo.data"];

    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    /// 如果有这个文件，说明有旧用户信息，将信息更新到WCDB中
    BOOL isExists = [fileMgr fileExistsAtPath:accountPath];
    if (isExists) {
        
        NSDictionary *users = [NSKeyedUnarchiver unarchiveObjectWithFile:accountPath];
        
        NSArray *keys = [users allKeys];
        
        /// 全部删除
        for (NSString *userid in keys) {
            /// 旧的文件名称及路径
            NSString *fileName = [NSString stringWithFormat:@"DRUUserInfoFile_%@.data", userid];
            NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
            
            /// 删除旧的文件
            BOOL bRet = [fileMgr fileExistsAtPath:filePath];
            if (bRet) {
                NSError *err;
                [fileMgr removeItemAtPath:filePath error:&err];
                NSLog(@"删除旧用户信息本地文件 ---  成功");
            }
        }
        [fileMgr removeItemAtPath:accountPath error:nil];
        NSLog(@"删除旧账号信息文件 ---- 成功");
    }
}


#pragma mark - 业务方法
- (BOOL)isLogin
{
    // 针对 bugly 中的异常上报，进行“猜测型”的修改，2-21修改，等待新包，看是否还有此问题
    if (self.currentUser) {
        return YES;
    }
    return NO;
}

/// 能不能给点时间让我优化一下登录方法，跟坨屎似的
/**
 用户登录
 
 @param accountInformation 用户账户信息 *必填
 @param handlerBlock     isNeedVerification:是否需要验证码;
                         imageCodeUrl:图形验证码url;
                         isImageCodeHaveError:是否是验证码输入错误;
                         loginSuccess:是否登录成功;
                         errorMessage:错误提示信息;
                         user:登录成功后的用户信息
 */
- (void)createUserLoginWith:(DRUUserLoginAccountInfo *)accountInformation
               handlerBlock:(void(^)(BOOL loginSuccess,
                                     NSInteger error_code,
                                     NSString *errorMessage,
                                     DRUUser *user))handlerBlock
{
    
    // 查看 cookie 中的内容
    // 获取 ick 的 cookie
    // 如果传图形验证码时再传 ick
    NSString *ick = @"";
     if (accountInformation.isNeedVerification) {
         ick = accountInformation.ick;
     }

    
    ///  只要调用了登录方法，说明是走登录流程过来的，也可能是其它组件内部调用登录方法进来的，标记为YES
    self.loginProcess = YES;
    
    // 手机号 加 验证码登录
    if (accountInformation.loginType == DRULoginTypePhoneNum) {
        
        [self.loginByVerifyCodeViewModel loginByVerfyCodeWithUser:accountInformation.phoneNumer sms_verify_code:accountInformation.sms_verify_code verifycode:accountInformation.verificationCode ickCookie:ick is_confirm_unfreeze:accountInformation.is_confirm_unfreeze is_mine:accountInformation.is_mine successBlock:^(NSInteger errorCode, NSString * _Nonnull error_msg, id  _Nonnull response) {
            
            DRUUser *user = [[DRUUser alloc] init];
            user.userLoginInfo = [DRUUserLoginServerInfo yy_modelWithJSON:response];
            if (![response containsObjectForKey:@"fissionStep"]) {
                user.userLoginInfo.fissionStep = DRUFissionStepDontNeedFission;
            }
            
            // 不为空时，记录一个值，需要弹窗提示账号异常
            if ([user.userLoginInfo.account_unsafe_msg isNotBlank]) {
                user.userLoginInfo.needTipAbnormal = YES;
            }
            
            if (errorCode == 10004) {
                /// 如果是封禁状态，将封禁信息带回
                handlerBlock(YES, errorCode, error_msg, response);
            } else if (errorCode == 10021) {
                handlerBlock(YES, errorCode, error_msg, response);
            } else {
                handlerBlock(YES, errorCode, error_msg, user);
            }
            
        } failureBlock:^(NSString * _Nonnull errorStr) {
            if (handlerBlock) {
                handlerBlock(NO, -1, errorStr, nil);
            }
        }];
        
    } else {
        
        // 账号 加 密码登录
        [self.clientLoginViewModel
         loadDataWithAccount:accountInformation.account
         password:accountInformation.password
        verifycode:accountInformation.verificationCode
         ickCookie:ick isverify:accountInformation.isverify
         bind_phone_number:accountInformation.bind_phone_number
         bind_mobile_captcha:accountInformation.bind_mobile_captcha
         is_confirm_unfreeze:accountInformation.is_confirm_unfreeze
         is_mobile_still_use:accountInformation.is_mobile_still_use
         is_confirm_conflict:accountInformation.is_confirm_conflict
         verifycode7:accountInformation.verifycode7
         successBlock:^(NSInteger errorCode, NSString * _Nonnull error_msg, id  _Nonnull response) {
            
            DRUUser *user = [[DRUUser alloc] init];
            user.userLoginInfo = [DRUUserLoginServerInfo yy_modelWithJSON:response];
            if (![response containsObjectForKey:@"fissionStep"]) {
                user.userLoginInfo.fissionStep = DRUFissionStepDontNeedFission;
            }
            // 不为空时，记录一个值，需要弹窗提示账号异常
            if ([user.userLoginInfo.account_unsafe_msg isNotBlank]) {
                user.userLoginInfo.needTipAbnormal = YES;
            }
          
            if (errorCode == 10004) {
                /// 如果是封禁状态，将封禁信息带回
                handlerBlock(YES, errorCode, error_msg, response);
            } else if (errorCode == 10008) {
                /// 手机号过旧，将额外信息返回
                handlerBlock(YES, errorCode, error_msg, response);
            } else if (errorCode == 10101) {
                /// 如果是需要绑定手机号，将response返回，response携带uid
                handlerBlock(YES, errorCode, error_msg, response);
            } else if (errorCode == 100012) {
                /// 冻结7，需要验证手机号，将response返回，response携带oldMobile
                handlerBlock(YES, errorCode, error_msg, response);
            } else {
                handlerBlock(YES, errorCode, error_msg, user);
            }
          
      } failureBlock:^(NSString * _Nonnull errorStr) {
          if (handlerBlock) {
              handlerBlock(NO, -1, errorStr, nil);
          }
      }];

    }
    
}

/**
 用户退出登录
 
 @param userid 用户id
 @param progressBlock 是否退出成功，不需要传 user 模型了
 */
- (void)logoutWithUserid:(NSString *)userid
               sessionId:(NSString *)sessionId
                progress:(DRUAccountProgressBlock)progressBlock
{
    
    [self.clientLogoutViewModel loadDataClientLogoutWithSession_id:sessionId successBlock:^(BOOL isLogoutSuccess) {
       
        //  如果退出成功，只需要将登录状态修改为未登录  NO , 账号列表信息不需要删除
//        if (isLogoutSuccess) {
            // 4.10改，不论接口是否成功，全退出
            // 只更改状态
            BOOL deleteSuccess = [self deleteUserInfo];
            
            if (deleteSuccess) {

                self.currentUser = nil;
                self.account = nil;
                
                if (progressBlock) {
                    progressBlock(YES, nil);
                }
            }
//        }
        
    } failureBlock:^(NSString * _Nonnull errorMsg) {
        NSLog(@"-- %s, %d", __func__, __LINE__);
        // 4.10改，不论接口是否成功，全退出
        // 只更改状态
        BOOL deleteSuccess = [self deleteUserInfo];
        
        if (deleteSuccess) {

            self.currentUser = nil;
            self.account = nil;
            
            if (progressBlock) {
                progressBlock(YES, nil);
            }
        }
    }];
}

#pragma mark - 用户本地数据操作方法
/**
 保存用户信息，会对 DRUUser 中的所有模型进行保存，并赋值给 self.currentUser
 如果已经有登录的用户，请先获取 self.currentUser，然后将新修改的内容赋值并调用此方法
 
 @param user 需要保存的 user 信息
 */
- (void)saveUserInfoWithUser:(DRUUser *)user
{
    if (!user) {
        return;
    }
    
    BOOL createSucces = [self.database createTableAndIndexesOfName:DRUUserInfoTableName withClass:user.class];

    if (createSucces) {
        
        NSLog(@"创建用户信息表 ---- 成功");
        
        BOOL insertSuccess = NO;
        DRUUser *localUser = [self getUserInfoFromLocal];
        if (!localUser) {
            // 如果之前没有，重新插入
            insertSuccess = [self.database insertObject:user into:DRUUserInfoTableName];
        } else {
            // 如果之前有，替换为新的信息   ---  替换操作没成功
            // 现在先删除，新重新插入
            [self deleteUserInfo];
            insertSuccess = [self.database insertObject:user into:DRUUserInfoTableName];
        }
        // 向表中插入一条数据、且始终只有一条
        if (insertSuccess) {
            NSLog(@"插入或更新成功");
        } else {
            NSLog(@"插入或更新失败");
        }
        
    } else {
        NSLog(@"创建用户信息表 ---- 失败");
    }
    
    BOOL saveHistoricalUserSucces = [NSKeyedArchiver archiveRootObject:user toFile:self.historicalUserFilePath];
    if (saveHistoricalUserSucces) {
        NSLog(@"保存历史账户列表 --- 成功");
        self.historicalUser = [NSKeyedUnarchiver unarchiveObjectWithFile:self.historicalUserFilePath];
    } else {
        NSLog(@"保存历史账户列表 --- 失败");
    }
}

/**
 从本地获取用户信息
 
 @return 当前登录的用户信息
 */
- (DRUUser *)getUserInfoFromLocal
{
    NSArray *array = [self.database getAllObjectsOfClass:DRUUser.class fromTable:DRUUserInfoTableName];
    NSLog(@"array = %@", array);
    if (array.count) {
        DRUUser *userModel = array.firstObject;
        return userModel;
    }
    return nil;
}

/**
 删除用户信息，删除数据库中信息
 */
- (BOOL)deleteUserInfo
{
    BOOL deleteSuccess = [self.database deleteAllObjectsFromTable:@"DRUUserInfoTable"];
    if (deleteSuccess) {
        NSLog(@"删除用户信息表 ---  成功");
    } else {
        NSLog(@"删除用户信息表 ---  失败");
    }
    return deleteSuccess;
}

/// 账号异常时，退出当前用户的操作
- (void)accountDeviantLogOut
{
    // 这里不清空 currentUser，有些地方还在使用里的的值，让外界用完后再清空
    [self deleteUserInfo];
}

/// 当用户登录成功后，需要保存用户信息时调用
- (void)saveUserLoginAccountInfo:(DRUUserLoginAccountInfo *)accountInformation
                         andUser:(DRUUser *)user
{
    accountInformation.userid = user.userLoginInfo.userid;
    accountInformation.userName = user.userLoginInfo.userName;
    accountInformation.loginState = YES;
    user.status = DRUUserStatusLoginSuccess;
    user.loginAccountInfo = accountInformation;
    
    
    // 登录成功或修改密码成功后，更新全局参数
    DRUUserLoginServerInfo *userLoginInfo = user.userLoginInfo;
    DRNGlobalParameter *globalParameter = [DRNGlobalParameter new];
    globalParameter.sessionKey = userLoginInfo.session_key;
    globalParameter.uniqKey = userLoginInfo.uniq_key;
    globalParameter.uniqID = userLoginInfo.uniq_id;
    globalParameter.secretKey = userLoginInfo.secret_key;
    [[DRNNetwork sharedNetwork] createGlobalParameter:globalParameter];
    
    // 重构
    DRNPublicParameter *publicParameter = [DRNPublicParameter new];
    publicParameter.sessionKey = userLoginInfo.session_key;
    publicParameter.uniqKey = userLoginInfo.uniq_key;
    publicParameter.uniqID = userLoginInfo.uniq_id;
    publicParameter.secretKey = userLoginInfo.secret_key;
    
    [[DRNNetwork sharedNetwork] createPublicParameter:publicParameter];
    [[DRUAccountManager sharedInstance] saveUserInfoWithUser:user];
    
    self.currentUser = user;
    
    // 均为第一次登录后的情况
    // 获取用户信息放在设置公共参数之后
    [[DRUAccountManager sharedInstance] rr_loadUserInfoWith:nil];
    // 获取用户配置信息，设置相关信息
    [[DRUAccountManager sharedInstance] rr_getUserConfigInfoWith:nil];
    
}

- (DRUUser *)historicalUser {
    if (!_historicalUser) {
        DRUUser *userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:self.historicalUserFilePath];
        if (userModel && [userModel isKindOfClass:[DRUUser class]]) {
            _historicalUser = userModel;
        } else {
            _historicalUser = [DRUUser new];
        }
    }
    return _historicalUser;
}

- (void)validateUserInfoWithHandlerBlock:(void(^)(BOOL isViolation,
                                                  BOOL isPhoneNumber))handlerBlock
{
    dispatch_group_t group = dispatch_group_create();

    // 检测用户昵称、账号是否违规
    DRUValidateNameRequest *request = [DRUValidateNameRequest new];

    // 记录昵称是否规则
    __block BOOL isViolation = NO;
    // 记录用户名是否是手机号
    __block BOOL isPhoneNumber = NO;

    dispatch_group_enter(group);
    [request lodaDataWithSuccessBlock:^(id  _Nonnull response) {

        // 这里的成功不需要处理
        isViolation = NO;
        NSNumber *code = response[@"errorCode"];
        if (code.integerValue == 0) {
            
            NSDictionary *data = response[@"data"];
            
            NSNumber *accountReset = data[@"accountReset"];
            NSNumber *nicknameReset = data[@"nicknameReset"];
            
            if (data && [nicknameReset boolValue]) {
                isViolation = YES;
            }
            
            if (data && [accountReset boolValue]) {
                isPhoneNumber = YES;
            }
            
        }
        
        dispatch_group_leave(group);

    } faileBlock:^(NSString * _Nonnull error_msg, id  _Nonnull response) {
        // 10 是用户名违禁
        
        isViolation = NO;
        
        dispatch_group_leave(group);
    }];


    

    // 以下内容与产品沟通拿掉,目前没有这种情况
    
//    // 检测用户名，就是登录账号 是否为手机号
//    DRUAccountIsMobileRequest *mobileRequest = [DRUAccountIsMobileRequest new];
//
//
//    dispatch_group_enter(group);
//    [mobileRequest lodaDataWithSuccessBlock:^(id  _Nonnull response) {
//
//        NSInteger status = [[response objectForKey:@"status"] integerValue];
//
//        // status = 1;//是否为手机号，1是，0不是
//        if (status == 1) {
//            isPhoneNumber = YES;
//        } else {
//            isPhoneNumber = NO;
//        }
//        dispatch_group_leave(group);
//
//    } faileBlock:^(NSString * _Nonnull error_msg, id  _Nonnull response) {
//
//        dispatch_group_leave(group);
//    }];

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{

        NSLog(@"两个接口都成功了 %d - %d", isViolation, isPhoneNumber);
        if (handlerBlock) {
            handlerBlock(isViolation, isPhoneNumber);
        }

    });

    
}

- (void)changeAccount:(NSString *)newAccount
         handlerBlock:(void(^)(BOOL isSuccess, NSString *msg))handlerBlock
{
    DRUChangeAccountRequest *request = [DRUChangeAccountRequest new];
    request.account = newAccount;
    
    // 修改 account 后，返回了登录信息，更新本地信息
    [request lodaDataWithSuccessBlock:^(id  _Nonnull response) {
        
        NSNumber *errorCode = response[@"errorCode"];
        NSString *errorMsg = response[@"errorMsg"];
        
        if (errorCode.integerValue == 0) {
            
            // 更新本地信息
            // 修改成功了，更新下本地记录的值
            DRUUser *user = self.currentUser;
            
            DRUUserLoginServerInfo *userLoginInfo = user.userLoginInfo;
            
            user.loginAccountInfo.account = newAccount;
            [self saveUserInfoWithUser:user];
            
            if (handlerBlock) {
                handlerBlock(YES, @"修改账号成功!");
            }
            
            // 暂时拿掉 待晓越确认
            
//            if (![response containsObjectForKey:@"fissionStep"]) {
//                userLoginInfo.fissionStep = DRUFissionStepDontNeedFission;
//            }
//
//            // 不为空时，记录一个值，需要弹窗提示账号异常 暂时拿掉
//            if ([userLoginInfo.account_unsafe_msg isNotBlank]) {
//                userLoginInfo.needTipAbnormal = YES;
//            }
            
            
        }else {
            
            
            if (handlerBlock) {
                handlerBlock(NO, errorMsg);
            }
        }
            
        
        
    } faileBlock:^(NSString * _Nonnull error_msg, id  _Nonnull response) {
        NSLog(@"error_msg = %@", error_msg);
        
        if (handlerBlock) {
            handlerBlock(NO, error_msg);
        }
    }];
}

- (void)changeNickName:(NSString *)newNickName
          handlerBlock:(void(^)(BOOL isSuccess,
                                NSString *msg))handlerBlock
{

    DRUChangNickNameInfoRequest *request = [[DRUChangNickNameInfoRequest alloc] init];
    
    request.nickName = newNickName;
    [request lodaDataWithSuccessBlock:^(id  _Nonnull response) {
        
        NSInteger errorCode = [[response objectForKey:@"errorCode"] integerValue];

        // 0 成功
        if (errorCode == 0) {
            
            /// 更新本地信息
            DRUUser *user = self.currentUser;
            user.userData.userInfo.nickname = newNickName;
            user.userLoginInfo.userName = newNickName;
            [self saveUserInfoWithUser:user];
            
            if (handlerBlock) {
                handlerBlock(YES, @"修改成功");
            }
        } else {
            if (handlerBlock) {
                handlerBlock(NO, @"修改昵称失败");
            }
        }
        
    } faileBlock:^(NSString * _Nonnull error_msg, id  _Nonnull response) {
        

        if (handlerBlock) {
            handlerBlock(NO, error_msg);
        }
        
    }];
    
}

- (void)isSetPasswordWithHandlerBlock:(void(^)(BOOL is_set_pwd))handlerBlock
{
    
    
    DRUGetBindInfoRequest *request = [[DRUGetBindInfoRequest alloc] init];

    [request lodaDataWithSuccessBlock:^(id  _Nonnull response) {
//        bind_mobile
//        logEmail
        NSNumber *status = response[@"data"][@"pwdStatus"];

        BOOL is_set_pwd = YES;
        if (status.integerValue > 0) {
            is_set_pwd = NO;
        }
        if (handlerBlock) {
            handlerBlock(is_set_pwd);
        }

    } faileBlock:^(NSString * _Nonnull error_msg, id  _Nonnull response) {
    }];
}


#pragma mark - 重构

/// 用户登录，此方法只是给其它组件提供了登录方法
/// @param accountInformation 账号信息
/// @param handlerBlock 是否登录成功，及错误信息
- (void)rr_test_userLoginWith:(DRUUserLoginAccountInfo *)accountInformation
                 handlerBlock:(void(^)(BOOL isLoginSuccess,
                                       NSString *errorMsg))handlerBlock
{
    DRULoginByPasswordRequest *request = [[DRULoginByPasswordRequest alloc] init];
    request.user = accountInformation.account;
    request.password = [accountInformation.password md5String];
    
    [request lodaDataWithSuccessBlock:^(id  _Nonnull response) {
        
        NSLog(@"response = %@", response);
        NSInteger errorCode = [[response objectForKey:@"errorCode"] integerValue];

        // 0 成功
        if (errorCode == 0) {
            
            id data = [response objectForKey:@"data"];
            
            DRUUserLoginServerInfo *userLoginInfo = [DRUUserLoginServerInfo yy_modelWithJSON:data];
            
            DRUUser *user = [[DRUUser alloc] init];
            user.userLoginInfo = userLoginInfo;
            
            if (![data containsObjectForKey:@"fissionStep"]) {
                userLoginInfo.fissionStep = DRUFissionStepDontNeedFission;
            }
            
            // 不为空时，记录一个值，需要弹窗提示账号异常
            if ([userLoginInfo.account_unsafe_msg isNotBlank]) {
                userLoginInfo.needTipAbnormal = YES;
            }
            
            // 登录成功了，更新下本地用户信息
            [self saveUserLoginAccountInfo:accountInformation andUser:user];
            
            if (handlerBlock) {
                handlerBlock(YES, @"登录成功");
            }
            
        } else {
            
            NSString *errorMsg = [response objectForKey:@"errorMsg"];
            
            if (handlerBlock) {
                handlerBlock(NO, errorMsg);
            }
        }
        
    } faileBlock:^(NSString * _Nonnull error_msg, id  _Nonnull response) {
        
        if (handlerBlock) {
            handlerBlock(NO, error_msg);
        }
        
    }];
}

/// 获取用户信息
- (void)rr_loadUserInfoWith:(nullable void(^)(DRUUser *user,
                                              NSString *errorStr))handlerBlock
{
    DRUGetUsersBasicInfoRequest *request = [[DRUGetUsersBasicInfoRequest alloc] init];
    
    request.userId = self.currentUser.userLoginInfo.userid;
    
    [request lodaDataWithSuccessBlock:^(id  _Nonnull response) {
         
        NSLog(@"response = %@", response);
        NSInteger errorCode = [[response objectForKey:@"errorCode"] integerValue];
        
        // 0 成功
        if (errorCode == 0) {
            
            id data = [response objectForKey:@"data"];
            
            DRUUser *user = [DRUAccountManager sharedInstance].currentUser;
            user.userData = [DRUUserData yy_modelWithJSON:data];
            
            // 目前看，并没有返回 fissionStep 字段
            NSDictionary *userInfo = nil;
            if ([data containsObjectForKey:@"userInfo"]) {
                userInfo = data[@"userInfo"];
            }
            
            if (![data containsObjectForKey:@"fissionStep"] ||
                ![userInfo containsObjectForKey:@"fissionStep"]) {
                user.userData.fissionStep = DRUFissionStepDontNeedFission;
            }
            
            [self saveUserInfoWithUser:user];
            
            if (handlerBlock) {
                handlerBlock(user, @"");
            }
            
        } else {
            
            NSString *errorMsg = [response objectForKey:@"errorMsg"];
            
            if (handlerBlock) {
                handlerBlock(nil, errorMsg);
            }
        }
        
    } faileBlock:^(NSString * _Nonnull error_msg, id  _Nonnull response) {
        
        if (handlerBlock) {
            handlerBlock(nil, error_msg);
        }
        
    }];
}

/// 获取用户配置信息 - 设置里的开关状态
- (void)rr_getUserConfigInfoWith:(nullable void(^)(DRUUserConfigInfo *userConfigInfo))handlerBlock
{
    
    if (!self.isLogin) {
        // 没有用户登录，不需要请求
        return;
    }
    
    DRUBatchgetRequest *request = [DRUBatchgetRequest new];
    
    NSString *userid = self.currentUser.userLoginInfo.userid;
    if (userid) {
        request.userId = @[userid];
    }
    
    [request lodaDataWithSuccessBlock:^(id  _Nonnull response) {
        
        NSLog(@"response = %@", response);
        NSInteger errorCode = [[response objectForKey:@"errorCode"] integerValue];
        
        // 0 成功
        if (errorCode == 0) {
            
            NSDictionary *data = [response objectForKey:@"data"];
            DRUUserConfigInfo *userConfigInfo = [DRUUserConfigInfo yy_modelWithJSON:data];
            self.userConfigInfo = userConfigInfo;
            
            if (handlerBlock) {
                handlerBlock(userConfigInfo);
            }
        }
        
    } faileBlock:^(NSString * _Nonnull error_msg, id  _Nonnull response) {
    }];
    
}

/// 退出登录，这里不请求接口
- (void)rr_userLogout
{
    BOOL deleteSuccess = [self deleteUserInfo];
    
    if (deleteSuccess) {
        self.currentUser = nil;
        self.account = nil;
    }
}

@end

