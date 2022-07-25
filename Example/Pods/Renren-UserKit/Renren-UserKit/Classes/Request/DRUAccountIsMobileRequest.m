//
//  DRUAccountIsMobileRequest.m
//  Renren-UserKit
//
//  Created by 李晓越 on 2020/3/11.
//

#import "DRUAccountIsMobileRequest.h"
#import "DRSAppInfo.h"
#import "NSString+SafeKit.h"
#import <YYCategories.h>

@implementation DRUAccountIsMobileRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.session_key = [DRUAccountManager sharedInstance].currentUser.userLoginInfo.session_key;
    }
    return self;
}

- (NSString *)requestUrl
{
    return MCS_HOST(@"/user/accountIsMobile");
}
@end
