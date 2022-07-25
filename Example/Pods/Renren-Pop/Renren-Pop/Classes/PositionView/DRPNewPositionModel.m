//
//  DRPNewPositionModel.m
//  Renren-Pop
//
//  Created by 李晓越 on 2019/9/3.
//

#import "DRPNewPositionModel.h"

@implementation DRPNewPositionList
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"_id" : @"id"};
}
@end

@implementation DRPNewPositionModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"_id" : @"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"positionList" : @"DRPPositionList"};
}
@end

