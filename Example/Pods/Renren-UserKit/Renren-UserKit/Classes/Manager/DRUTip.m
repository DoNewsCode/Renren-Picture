//
//  DRUTip.m
//  Renren-UserKit
//
//  Created by 陈金铭 on 2019/8/5.
//

#import "DRUTip.h"

@interface DRUTip ()

/** 提示类型 */
@property(nonatomic, assign, readwrite) DRUTipType type;
/** 服务端返回的用户数据 */
@property (nonatomic, assign, readwrite) NSInteger count;

@property(nonatomic, strong) NSMutableDictionary *tipDict;
@property(nonatomic, strong) NSUserDefaults *defaults;
@property(nonatomic, copy) NSString *fileName;

@end

@implementation DRUTip

- (instancetype)initWithFileName:(NSString *)fileName
{
    self = [super init];
    if (self) {
        self.fileName = fileName;
        [self initialization];
    }
    return self;
}

- (void)initialization {
    self.defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *tipDict = [self.defaults objectForKey:self.fileName];
    if (tipDict == nil) {
        NSDictionary *temptipDict = @{@"type" : @0,@"count" : @0};
        tipDict = temptipDict;
        [self.defaults setObject:tipDict forKey:self.fileName];
        [self.defaults synchronize];
    }
    self.tipDict = [NSMutableDictionary dictionaryWithDictionary:tipDict];
    self.type = [[self.tipDict objectForKey:@"type"] integerValue];
    self.count = [[self.tipDict objectForKey:@"count"] integerValue];
}

-(void)setType:(DRUTipType)type {
    _type = type;
    [self.tipDict setValue:[NSNumber numberWithInteger:type] forKey:@"type"];
    
}

-(void)setCount:(NSInteger)count {
    _count = count;
    [self.tipDict setValue:[NSNumber numberWithInteger:count] forKey:@"count"];
}

- (void)processChange:(DRUTipType )type count:(NSInteger )count{
    self.type = type;
    self.count = count;
     [self.defaults setObject:self.tipDict.copy forKey:self.fileName];
    [self.defaults synchronize];
};

@end

