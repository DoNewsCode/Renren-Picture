//
//  DRFTFilterModel.m
//  Renren-Filter
//
//  Created by 张健康 on 2020/3/9.
//

#import "DRFTFilterModel.h"
@implementation DRFTFilterModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxIntensity = 1.f;
    }
    return self;
}
@end
