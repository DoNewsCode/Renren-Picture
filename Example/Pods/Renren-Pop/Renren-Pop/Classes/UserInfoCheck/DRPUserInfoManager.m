//
//  DRPUserInfoManager.m
//  Renren-Pop
//
//  Created by 李晓越 on 2020/4/15.
//

#import "DRPUserInfoManager.h"

static DRPUserInfoManager *_instance = nil;


@implementation DRPUserInfoManager

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
@end
