//
//  DRUGetUsersBasicInfoRequest.m
//  Renren-UserKit
//
//  Created by 李晓越 on 2020/6/9.
//

#import "DRUGetUsersBasicInfoRequest.h"

@implementation DRUGetUsersBasicInfoRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestMethod = DNRequestMethodGET;
    }
    return self;
}

- (NSString *)requestUrl
{
    return MCS_HOST(@"/userbase/v1/getUsersBasicInfo");
}

@end
