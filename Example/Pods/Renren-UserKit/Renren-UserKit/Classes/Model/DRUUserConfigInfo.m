//
//  DRUUserConfigInfo.m
//  Renren-UserKit
//
//  Created by 李晓越 on 2020/7/3.
//

#import "DRUUserConfigInfo.h"

@implementation DRUUserConfigDetails
@end

@implementation DRUUserConfigDetail
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"userConfigDetails" : DRUUserConfigDetails.class};
}
@end

@implementation DRUUserConfigInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"userConfigDetail" : DRUUserConfigDetail.class};
}

- (DRUUserConfigDetails *)validationConfig
{
    DRUUserConfigDetail *configDetail = self.userConfigDetail.firstObject;
    NSArray *userConfigDetails = configDetail.userConfigDetails;
    for (DRUUserConfigDetails *configDetails in userConfigDetails) {
        // configType == 1 好友申请设置
        if (configDetails.configType == 1) {
            return configDetails;
        }
    }
    return nil;
}

- (DRUUserConfigDetails *)followmeConfig
{
    DRUUserConfigDetail *configDetail = self.userConfigDetail.firstObject;
    NSArray *userConfigDetails = configDetail.userConfigDetails;
    for (DRUUserConfigDetails *configDetails in userConfigDetails) {
        // configType == 7 添加关注设置
        if (configDetails.configType == 7) {
            return configDetails;
        }
    }
    return nil;
}

- (DRUUserConfigDetails *)lookMeInfo
{
    DRUUserConfigDetail *configDetail = self.userConfigDetail.firstObject;
    NSArray *userConfigDetails = configDetail.userConfigDetails;
    for (DRUUserConfigDetails *configDetails in userConfigDetails) {
        // configType == 9 个人信息是否可见设置
        if (configDetails.configType == 9) {
            return configDetails;
        }
    }
    return nil;
}

- (DRUUserConfigDetails *)nonFriendChat
{
    DRUUserConfigDetail *configDetail = self.userConfigDetail.firstObject;
    NSArray *userConfigDetails = configDetail.userConfigDetails;
    for (DRUUserConfigDetails *configDetails in userConfigDetails) {
        // configType == 8 允许非好友与我聊天
        if (configDetails.configType == 8) {
            return configDetails;
        }
    }
    return nil;
}

- (DRUUserConfigDetails *)halfSwitch
{
    DRUUserConfigDetail *configDetail = self.userConfigDetail.firstObject;
    NSArray *userConfigDetails = configDetail.userConfigDetails;
    for (DRUUserConfigDetails *configDetails in userConfigDetails) {
        // configType == 0 新鲜事可见时间设置
        if (configDetails.configType == 0) {
            return configDetails;
        }
    }
    return nil;
}

- (DRUUserConfigDetails *)autoPlayVideo
{
    DRUUserConfigDetail *configDetail = self.userConfigDetail.firstObject;
    NSArray *userConfigDetails = configDetail.userConfigDetails;
    for (DRUUserConfigDetails *configDetails in userConfigDetails) {
        // configType == 4 wifi下自动播放视频
        if (configDetails.configType == 4) {
            return configDetails;
        }
    }
    return nil;
}

@end
