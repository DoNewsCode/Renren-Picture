//
//  DRUStatusCenter.m
//  Renren-UserKit
//
//  Created by 陈金铭 on 2019/9/6.
//

#import "DRUStatusCenter.h"

@implementation DRUStatusCenter

//单例对象
static DRUStatusCenter *_instance = nil;
//单例
+ (instancetype)sharedStatusCenter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initialization {
    self.videoStatus = [DRUVideoStatus sharedVideoStatus];
    self.pushStatus = [DRUPushStatus sharedPushStatus];
}

@end
