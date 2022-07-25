//
//  DRUUser.m
//  Pods-Renren-UserKit_Example
//
//  Created by Ming on 2019/3/21.
//

#import "DRUUser.h"
#import <YYModel/YYModel.h>
#import "DRUUserInfo.h"
#import <WCDB/WCDB.h>
#import "DRUUser+WCTTableCoding.h"

#pragma mark - 用户登录时传入的信息类
@implementation DRUUserLoginAccountInfo

// 归档 解档
- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [self yy_modelEncodeWithCoder:aCoder];
}

@end

#pragma mark - 用户数据信息写，包括登录数据，用户数据
@implementation DRUUser

//WCDB_IMPLEMENTATION，用于在类文件中定义绑定到数据库表的类

WCDB_IMPLEMENTATION(DRUUser)


WCDB_SYNTHESIZE(DRUUser,loginAccountInfo)
WCDB_SYNTHESIZE(DRUUser,userLoginInfo)
//WCDB_SYNTHESIZE(DRUUser,userInfo)
WCDB_SYNTHESIZE(DRUUser,userData)
WCDB_SYNTHESIZE(DRUUser,status)


// 归档 解档
- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [self yy_modelEncodeWithCoder:aCoder];
}

@end

@implementation DRUUserLoginServerInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fissionStep = DRUFissionStepDefault;
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userid" : @"uid",
    @"userName" : @[@"userName", @"user_name"],
    @"register_time" : @"registerTime",
    @"last_login_time" : @"lastLoginTime",
    // 重构新加的，映射，保持与之前一致
    @"fill_stage" : @"fillStage",
    @"head_url" : @"headUrl",
    @"last_login_time" : @"lastLoginTime",
    @"last_login_time_away_now" : @"lastLoginTimeAwayNow",
    @"login_count" : @"loginCount",
    @"register_time" : @"registerTime",
    @"register_time_away_now" : @"registerTimeAwayNow",
    @"secret_key" : @"secretKey",
    @"session_key" : @"sessionKey",
    @"web_ticket" : @"webTicket",
    @"uniq_key" : @"uniqKey",
    @"account_unsafe_msg" : @"accountUnsafeMsg"};

}

// 归档 解档
- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [self yy_modelEncodeWithCoder:aCoder];
}

@end

