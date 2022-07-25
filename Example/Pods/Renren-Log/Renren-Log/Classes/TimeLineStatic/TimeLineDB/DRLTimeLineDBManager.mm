//
//  DRLTimeLineDBManager.m
//  Renren-Log
//
//  Created by 陈文昌 on 2020/2/11.
//

#import "DRLTimeLineDBManager.h"

static NSString * const kDataBaseFileName = @"TimeLine.sqlite";

static DRLTimeLineDBManager *managerDB = nil;

@implementation DRLTimeLineDBManager

+ (DRLTimeLineDBManager *)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        managerDB = [[DRLTimeLineDBManager alloc] init];
    });
    
    return managerDB;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self createDataBase];
        
    }
    
    return self;
}

- (void)createDataBase {
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingString:kDataBaseFileName];
    
    self.dataBase = [[WCTDatabase alloc] initWithPath:path];
    
    if ([self.dataBase canOpen]) {
        
//        [self initAllTable];
        NSLog(@"创建数据库成功======");
    }else {
        NSLog(@"创建数据库失败======");
    }
    
}

- (void)initAllTable {
    
    self.hasRecordTable = [[DRLTimeLineHasRecordDBTable alloc] init];
    self.failRecodTable = [[DRLTimeLineFailRecordDBTable alloc] init];
    
}

// 当前毫秒时间
- (long long)curentTimemm {
    
    NSDate *curentData = [NSDate date];
    NSTimeInterval time = [curentData timeIntervalSince1970]*1000;
    
    return (long long)time;
    
}

- (DRLTimeLineHasRecordDBTable *)hasRecordTable {
    if (!_hasRecordTable) {
        _hasRecordTable = [[DRLTimeLineHasRecordDBTable alloc] init];
    }
    return _hasRecordTable;
}

- (DRLTimeLineFailRecordDBTable *)failRecodTable {
    if (!_failRecodTable) {
        _failRecodTable = [[DRLTimeLineFailRecordDBTable alloc] init];
    }
    return _failRecodTable;
}

@end
