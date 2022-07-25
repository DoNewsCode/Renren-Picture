//
//  DRMEGetTopicsModel.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/2/21.
//

#import "DRMEGetTopicsModel.h"


@implementation DRMERecentFiveTopic

@end


@implementation DRMETopicList

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"topic_id" : @"id"};
}
@end


@implementation DRMEGetTopicsModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{@"topic_list" : @"DRMETopicList"};
}

@end
