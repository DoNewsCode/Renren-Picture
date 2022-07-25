//
//  DRUUserInfo.m
//  Renren-UserKit
//
//  Created by 李晓越 on 2019/9/11.
//

#import "DRUUserInfo.h"
#import <YYModel/YYModel.h>

@implementation DRUProfileInfoBirth
// 归档 解档
- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [self yy_modelEncodeWithCoder:aCoder];
}

@end

@implementation DRUProfileInfoRegionInfo

// 归档 解档
- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [self yy_modelEncodeWithCoder:aCoder];
}


@end

@implementation DRUProfileInfoUserSign

// 归档 解档
- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [self yy_modelEncodeWithCoder:aCoder];
}

@end


@implementation DRUProfileInfoRecentEducationWork

// 归档 解档
- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [self yy_modelEncodeWithCoder:aCoder];
}

@end

@implementation DRUUserInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fissionStep = DRUFissionStepDefault;
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userid" : @"user_id",
             @"userName" : @"user_name"};
}


// 归档 解档
- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [self yy_modelEncodeWithCoder:aCoder];
}


@end
