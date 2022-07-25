//
//  DRUClientLoginModel.m
//  RenRenRecallModule
//
//  Created by donews on 2019/1/19.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DRUClientLoginModel.h"

@implementation DRUClientLoginModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"renren_id" : @"id",
             @"user_id" : @[@"user_id", @"uid"],
             @"head_url" : @[@"head_url", @"headUrl"],
             @"user_name" : @[@"user_name", @"name"]
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"accountInfo" : @"DNAccountInfoModel"};
}

@end
