//
//  DRSSafeManager.m
//  Pods-Renren-SafeKit_Example
//
//  Created by Ming on 2019/3/21.
//

#import "DRSSafeManager.h"

@interface DRSSafeManager ()

@property(nonatomic, assign, readwrite) DRSSafeManagerType type;

@end

@implementation DRSSafeManager
static DRSSafeManager *_instance = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [_instance initialization];
    });
    return _instance;
}

- (void)initialization {
    self.appInfo = [DRSAppInfo sharedInstance];
}

#pragma mark - Override Methods

#pragma mark - Intial Methods

#pragma mark - Event Methods

#pragma mark - Public Methods
+ (instancetype)sharedInstanceWithType:(DRSSafeManagerType)type {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance.type = type;
        [_instance initialization];
    });
    return _instance;
}

+ (void)changeType:(DRSSafeManagerType)type {
    
}

#pragma mark - Private Methods

@end
