//
//  DRUClientLogoutRequest.m
//  AFNetworking
//
//  Created by lixiaoyue on 2019/6/6.
//

#import "DRUClientLogoutRequest.h"


@interface DRUClientLogoutRequest ()



@end

@implementation DRUClientLogoutRequest

- (NSString *)requestUrl
{
    return MCS_HOST(@"/client/logout");
}


@end
