//
//  DRUUserBaseModel.m
//  RenRenRecallModule
//
//  Created by donews on 2019/1/18.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DRUUserBaseModel.h"

@implementation DRUUserBaseModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"message" : @"error_msg",
             @"message" : @"error"};
}

@end
