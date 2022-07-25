//
//  DRPNewProvinceModel.m
//  RenRenRecallModule
//
//  Created by donews on 2019/1/23.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DRPNewProvinceModel.h"


@implementation DRPNewRegionModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"_id" : @"id"};
}

@end

@implementation DRPNewProvinceModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"_id" : @"id"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"regionList" : @"DRPRegionModel"};
}

@end
