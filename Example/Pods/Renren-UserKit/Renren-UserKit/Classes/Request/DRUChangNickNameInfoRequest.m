//
//  DRUChangNickNameInfoRequest.m
//  Renren-UserKit
//
//  Created by 李晓越 on 2020/3/12.
//

#import "DRUChangNickNameInfoRequest.h"
#import "DRSAppInfo.h"

@implementation DRUChangNickNameInfoRequest

- (NSString *)requestUrl
{
    return MCS_HOST(@"/userbase/v1/updateUserName");
}

@end

