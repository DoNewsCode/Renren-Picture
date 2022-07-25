//
//  DRULoginByPasswordRequest.m
//  Renren-UserKit
//
//  Created by 李晓越 on 2020/6/5.
//

#import "DRULoginByPasswordRequest.h"

@implementation DRULoginByPasswordRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString *)requestUrl
{
    return MCS_HOST(@"/account/v1/loginByPassword");
}

@end
