//
//  DRUGetBasicConfigRequest.m
//  AFNetworking
//
//  Created by 李晓越 on 2019/6/24.
//

#import "DRUGetBasicConfigRequest.h"

@implementation DRUGetBasicConfigRequest

- (NSString *)requestUrl
{
    return MCS_HOST(@"/profile/getBasicConfig");
}

@end
