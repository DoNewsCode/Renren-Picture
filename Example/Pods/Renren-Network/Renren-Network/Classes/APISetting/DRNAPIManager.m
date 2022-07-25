//
//  DRNAPIManager.m
//  Renren-Network
//
//  Created by 张健康 on 2019/6/3.
//

#import "DRNAPIManager.h"

#import "DRLTimeLineStaticManager.h"

/** 文件名称 */
static NSString *const DRNAPISettingFile = @"DRNAPISetting";

@interface DRNAPIManager()

@end

@implementation DRNAPIManager
//单例对象
static DRNAPIManager *_instance = nil;
static NSDictionary *_configInitDictionary = nil;
static DRNURLConfig *_configInit = nil;
//单例
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [_instance initialization];
    });
    return _instance;
}

- (void)initialization {

}

@end
