//
//  DRBBaseColor.m
//  Pods-Renren-BaseKit_Example
//
//  Created by Ming on 2019/3/23.
//

#import "DRBBaseColor.h"


static DRBBaseColor *_instance = nil;

@implementation DRBBaseColor
#pragma mark - Intial Methods
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        
    });
    return _instance;
}

#pragma mark - Override Methods
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - Private Methods
- (void)initialize {
    [self createTextColor];
    [self createViewColor];
}

//文字颜色
- (void)createTextColor {
}

//视图颜色
- (void)createViewColor {
    
}

@end
