//
//  DRUUserData.m
//  Renren-UserKit
//
//  Created by 李晓越 on 2020/6/10.
//

#import "DRUUserData.h"
#import <YYModel/YYModel.h>

@implementation DRUWorkplaceInfo

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

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"_id" : @"id"};
}

@end
    
@implementation DRUUserInfoModel

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

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userId" : @"id"};
}

@end

@implementation DRUCollegeInfoList

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

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"_id" : @"id"};
}

@end

@implementation DRUHighSchoolInfoList

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

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"_id" : @"id"};
}

@end

@implementation DRUUniversityInfoList

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

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"_id" : @"id"};
}

@end

@implementation DRUElementarySchoolInfoList

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

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"_id" : @"id"};
}

@end

@implementation DRUJuniorHighSchoolInfoList

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

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"_id" : @"id"};
}

@end

@implementation DRUSchoolInfo

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

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"collegeInfoList" : @"DRUCollegeInfoList",
             @"highSchoolInfoList" : @"DRUHighSchoolInfoList",
             @"universityInfoList" : @"DRUUniversityInfoList",
             @"elementarySchoolInfoList" : @"DRUElementarySchoolInfoList",
             @"juniorHighSchoolInfoList" : @"DRUJuniorHighSchoolInfoList"
                 
    };
}


@end


@implementation DRURecentEducationWork

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"_id" : @"id"};
}

@end

@implementation DRUUserData

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

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"workplaceInfo" : DRUWorkplaceInfo.class};
}

@end

