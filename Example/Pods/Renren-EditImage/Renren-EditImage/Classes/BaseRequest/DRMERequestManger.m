//
//  DRPRequestManger.m
//  Renren-Personal
//
//  Created by 李晓越 on 2019/10/16.
//

#import "DRMERequestManger.h"

@interface DRMERequestManger ()

/**
 已发送类型
 */
@property (nonatomic, strong) NSMutableArray *hasRequestArr;

@end

@implementation DRMERequestManger

+ (DRMERequestManger *)shareManager {
    
    static DRMERequestManger *requestManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestManager = [[DRMERequestManger alloc] init];
    });
    
    return requestManager;
}

- (NSMutableArray *)hasRequestArr {
    
    if (!_hasRequestArr) {
        _hasRequestArr = [NSMutableArray array];
    }
    
    return _hasRequestArr;
}

- (BOOL)hasRequestClass:(DRMERequestManger *)request {
    
    for (DRMERequestManger *request1 in self.hasRequestArr) {
        
        if ([request1 isKindOfClass:[request class]] ) {
            return YES;
        }
        
    }
    
    return NO;
}

- (void)addRequest:(DRMERequestManger *)request {
    if (request) {
        [self.hasRequestArr addObject:request];
    }
}

- (void)removeRequest:(DRMERequestManger *)request {
    if (request) {
        [self.hasRequestArr removeObject:request];
    }
}



@end
