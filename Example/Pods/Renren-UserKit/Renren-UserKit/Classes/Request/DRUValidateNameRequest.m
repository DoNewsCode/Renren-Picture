//
//  DRUValidateNameRequest.m
//  Renren-UserKit
//
//  Created by 李晓越 on 2019/12/9.
//

#import "DRUValidateNameRequest.h"
#import "DRSAppInfo.h"
#import "NSString+SafeKit.h"
#import <NSString+YYAdd.h>

@implementation DRUValidateNameRequest

- (instancetype)init {
    if (self = [super init]) {
        self.hostId = [DRUAccountManager sharedInstance].currentUser.userLoginInfo.userid;
    }
    return self;
}

- (DNHttpRequestMethod)requestMethod {
    return DNRequestMethodGET;
}

- (NSString *)requestUrl
{
    return MCS_HOST(@"/userbase/v1/check");
}


@end
