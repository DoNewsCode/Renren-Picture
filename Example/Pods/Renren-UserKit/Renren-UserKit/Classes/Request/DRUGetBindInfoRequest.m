//
//  DRUGetBindInfoRequest.m
//  Renren-Personal
//
//  Created by 李晓越 on 2019/9/5.
//

#import "DRUGetBindInfoRequest.h"

@interface DRUGetBindInfoRequest ()

@property(nonatomic,copy) NSString *session_key;

@end

@implementation DRUGetBindInfoRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.session_key = [DRUAccountManager sharedInstance].currentUser.userLoginInfo.session_key;
        self.userId =[DRUAccountManager sharedInstance].currentUser.userLoginInfo.userid;
    }
    return self;
}

- (NSString *)requestUrl
{
    return MCS_HOST(@"/security/v1/pwdStatus");
}

@end
