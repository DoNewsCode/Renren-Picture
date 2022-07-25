//
//  DRLLog.m
//  Renren-Library
//
//  Created by 陈金铭 on 2019/8/10.
//

#import "DRLLog.h"

#import "WCDB/WCDB.h"
#import "DRLLogMessage.h"
#import "DRLLogMessage+WCTTableCoding.h"


/** 跳转发现页 */
static NSString *tableNormal = @"Log";

/** appVersion */
static NSString *appVersion = @"null";

/** appVersion */
static NSString *appBuild = @"null";

@interface DRLLog ()

@property(nonatomic, strong) WCTDatabase *database;
@property(nonatomic, strong) DRLLogMessage *currentMessage;
@property(nonatomic, strong) DRLLogMessage *savedFirstMessage;
@property(nonatomic, getter=isLogEnabled) BOOL logEnabeld;

@property(nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation DRLLog

static DRLLog *_instance = nil;

#pragma mark - Intial Methods

//单例
+ (instancetype)sharedLog {
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

- (void)initialization {
    _saveLimit = 10000;
    _logEnabeld = YES;
    //获取沙盒根目录
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"Log.sqlite"];
    NSLog(@"path = %@",filePath);
    
    self.database = [[WCTDatabase alloc]initWithPath:filePath];
    //测试数据库是否能够打开
    if ([self.database canOpen]) {
        if ([self.database isOpened]) {
            if ([self.database isTableExists:tableNormal]) {
                
            }else {
                [self.database createTableAndIndexesOfName:tableNormal withClass:DRLLogMessage.class];
                DRLLogMessage *message = [DRLLogMessage new];
                message.content = @"Log Init";
                message.createTime = [NSDate date];
                message.modifiedTime = [NSDate date];
                [self.database insertObject:message into:tableNormal];
            }
        }
    }
    
    self.currentMessage = [self.database getOneObjectOfClass:DRLLogMessage.class fromTable:tableNormal orderBy:DRLLogMessage.localID.order(WCTOrderedDescending)];
    self.savedFirstMessage = [self.database getOneObjectOfClass:DRLLogMessage.class fromTable:tableNormal orderBy:DRLLogMessage.localID.order(WCTOrderedAscending)];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    appBuild = [infoDictionary objectForKey:@"CFBundleVersion"];
}

- (void)setLogEnabeld:(BOOL)logEnabeld {
    _logEnabeld = logEnabeld;
}

- (void)addLog:(nonnull NSString *)content {
    [self addLogWithType:DRLLogTypeNormal title:nil desc:nil content:content remark:nil completion:nil];
}

- (void)addLogWithType:(DRLLogType)type content:(nullable NSString *)content {
    [self addLogWithType:type title:nil desc:nil content:content remark:nil completion:nil];
}

- (void)addLogWithType:(DRLLogType)type title:(nullable NSString *)title content:(nullable NSString *)content {
    [self addLogWithType:type title:title desc:nil content:content remark:nil completion:nil];
}

- (void)addLogWithType:(DRLLogType)type title:(nullable NSString *)title desc:(nullable NSString *)desc content:(nullable NSString *)content {
    [self addLogWithType:type title:title desc:desc content:content remark:nil completion:nil];
}

- (void)addLogWithType:(DRLLogType)type title:(nullable NSString *)title desc:(nullable NSString *)desc content:(nullable NSString *)content remark:(nullable NSString *)remark{
    
    [self addLogWithType:type title:title desc:desc content:content remark:remark completion:nil];
}

- (void)addLogWithType:(DRLLogType)type title:(nullable NSString *)title desc:(nullable NSString *)desc content:(nullable NSString *)content remark:(nullable NSString *)remark completion:(nullable DRLLogCompletionBlock)completion {
    if (self.isLogEnabled == NO) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        DRLLogMessage *message = [DRLLogMessage new];
        NSInteger currentIndex = weakSelf.currentMessage.localID;
        message.localID = currentIndex + 1;
        message.createTime = [NSDate date];
        message.modifiedTime = [NSDate date];
        message.type = type;
        message.title = title;
        message.desc = desc;
        message.content = content;
        message.remark = remark;
        message.appVersion = appVersion;
        message.appBuild = appBuild;
        BOOL success = [weakSelf.database insertObject:message into:tableNormal];
        if (success == NO) {
            return ;
        }
        if (completion) {
            completion(message);
        }
        weakSelf.currentMessage = message;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (weakSelf.masterDelegate == nil && weakSelf.delegate) {
                if ([weakSelf.delegate respondsToSelector:@selector(newLogMessage:)]) {
                    [weakSelf.delegate newLogMessage:message];
                }
            } if (weakSelf.delegate == nil && weakSelf.masterDelegate) {
                if ([weakSelf.masterDelegate respondsToSelector:@selector(newLogMessage:)]) {
                    [weakSelf.masterDelegate newLogMessage:message];
                }
            } else if (weakSelf.delegate != nil && weakSelf.masterDelegate != nil) {
                if (weakSelf.delegate == weakSelf.masterDelegate) {
                    if ([weakSelf.delegate respondsToSelector:@selector(newLogMessage:)]) {
                        [weakSelf.delegate newLogMessage:message];
                    }
                } else {
                    if ([weakSelf.masterDelegate respondsToSelector:@selector(newLogMessage:)]) {
                        [weakSelf.masterDelegate newLogMessage:message];
                    }
                    if ([weakSelf.delegate respondsToSelector:@selector(newLogMessage:)]) {
                        [weakSelf.delegate newLogMessage:message];
                    }
                }
                
            }
            
            
        }];
        [weakSelf procaseLimitDeleteLogMessage];
        
    }];
    [self.operationQueue addOperation:operation];
}


/**
 处理限制日志条数逻辑，仅保留最近的在限制条数内的日志
 */
- (void)procaseLimitDeleteLogMessage {
    NSUInteger currentLimit = (self.currentMessage.localID - self.savedFirstMessage.localID);
    if (currentLimit > self.saveLimit) {
        BOOL deleteSuccess = [self.database deleteObjectsFromTable:tableNormal where:DRLLogMessage.localID <= self.savedFirstMessage.localID];
        if (deleteSuccess) {
            self.savedFirstMessage = [self.database getOneObjectOfClass:DRLLogMessage.class fromTable:tableNormal orderBy:DRLLogMessage.localID.order(WCTOrderedAscending)];
        }
        
    }
}

- (void)deleteLog {
    [self.database deleteAllObjectsFromTable:tableNormal];
}


- (void)updateLogWith:(DRLLogMessage *)message {
    if (self.isLogEnabled == NO) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        BOOL success = [self.database updateRowsInTable:tableNormal onProperties:{DRLLogMessage.content,DRLLogMessage.remark,DRLLogMessage.desc,DRLLogMessage.modifiedTime} withObject:message where:DRLLogMessage.localID == message.localID ];
        if (success == NO) {
            return ;
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (weakSelf.masterDelegate == nil && weakSelf.delegate) {
                if ([weakSelf.delegate respondsToSelector:@selector(updateLogMessage:)]) {
                    [weakSelf.delegate updateLogMessage:message];
                }
            } if (weakSelf.delegate == nil && weakSelf.masterDelegate) {
                if ([weakSelf.masterDelegate respondsToSelector:@selector(updateLogMessage:)]) {
                    [weakSelf.masterDelegate updateLogMessage:message];
                }
            } else if (weakSelf.delegate != nil && weakSelf.masterDelegate != nil) {
                if (weakSelf.delegate == weakSelf.masterDelegate) {
                    if ([weakSelf.delegate respondsToSelector:@selector(updateLogMessage:)]) {
                        [weakSelf.delegate updateLogMessage:message];
                    }
                } else {
                    if ([weakSelf.masterDelegate respondsToSelector:@selector(updateLogMessage:)]) {
                        [weakSelf.masterDelegate updateLogMessage:message];
                    }
                    if ([weakSelf.delegate respondsToSelector:@selector(updateLogMessage:)]) {
                        [weakSelf.delegate updateLogMessage:message];
                    }
                }
                
            }
            
            
        }];
        
    }];
    
    [self.operationQueue addOperation:operation];
}

- (void)obtainAllMessagesWithResultBlock:(DRLLogResultBlock)resultBlock {
    NSArray<DRLLogMessage *> *array = @[];
    array = [self.database getObjectsOfClass:DRLLogMessage.class fromTable:tableNormal orderBy:DRLLogMessage.localID.order(WCTOrderedDescending) limit:10000];
    if (resultBlock) {
        resultBlock(array);
    }
}


- (void)obtainMessagesWithResultBlock:(DRLLogResultBlock)resultBlock {
    NSArray<DRLLogMessage *> *array = @[];
    array = [self.database getObjectsOfClass:DRLLogMessage.class fromTable:tableNormal orderBy:DRLLogMessage.localID.order(WCTOrderedDescending) limit:50];
    if (resultBlock) {
        resultBlock(array);
    }
}

- (void)obtainMessagesWithCurrentMessage:(nullable DRLLogMessage *)currentMessage resultBlock:(DRLLogResultBlock)resultBlock {
    NSArray<DRLLogMessage *> *array = @[];
    array = [self.database getObjectsOfClass:DRLLogMessage.class fromTable:tableNormal where:DRLLogMessage.localID < currentMessage.localID orderBy:DRLLogMessage.localID.order(WCTOrderedDescending) limit:50];
    if (resultBlock) {
        resultBlock(array);
    }
}

- (void)obtainMessagesWithCurrentMessage:(nullable DRLLogMessage *)currentMessage limit:(NSUInteger)limit resultBlock:(DRLLogResultBlock)resultBlock {
    NSArray<DRLLogMessage *> *array = @[];
    array = [self.database getObjectsOfClass:DRLLogMessage.class fromTable:tableNormal where:DRLLogMessage.localID < currentMessage.localID orderBy:DRLLogMessage.localID.order(WCTOrderedDescending) limit:limit];
    if (resultBlock) {
        resultBlock(array);
    }
}

- (void)obtainMessagesWithCurrentMessage:(nullable DRLLogMessage *)currentMessage limit:(NSUInteger)limit order:(DRLLogOrder)order resultBlock:(DRLLogResultBlock)resultBlock {
    NSArray<DRLLogMessage *> *array = @[];
    if (order == DRLLogOrderAsc) {
        array = [self.database getObjectsOfClass:DRLLogMessage.class fromTable:tableNormal where:DRLLogMessage.localID < currentMessage.localID orderBy:DRLLogMessage.localID.order(WCTOrderedAscending) limit:limit];
        
    } else if (order == DRLLogOrderDesc) {
        array = [self.database getObjectsOfClass:DRLLogMessage.class fromTable:tableNormal where:DRLLogMessage.localID < currentMessage.localID orderBy:DRLLogMessage.localID.order(WCTOrderedDescending) limit:limit];
    } else {
        array = [self.database getObjectsOfClass:DRLLogMessage.class fromTable:tableNormal where:DRLLogMessage.localID < currentMessage.localID orderBy:DRLLogMessage.localID.order(WCTOrderedDescending) limit:limit];
    }
    
    if (resultBlock) {
        resultBlock(array);
    }
}

- (void)obtainMessagesWithCurrentMessage:(nullable DRLLogMessage *)currentMessage limit:(NSUInteger)limit order:(DRLLogOrder)order type:(DRLLogType)type resultBlock:(DRLLogResultBlock)resultBlock {
    NSArray<DRLLogMessage *> *array = @[];
    if (order == DRLLogOrderAsc) {
        array = [self.database getObjectsOfClass:DRLLogMessage.class fromTable:tableNormal where:DRLLogMessage.localID < currentMessage.localID && DRLLogMessage.type == type orderBy:DRLLogMessage.localID.order(WCTOrderedAscending) limit:limit];
        
    } else if (order == DRLLogOrderDesc) {
        array = [self.database getObjectsOfClass:DRLLogMessage.class fromTable:tableNormal where:DRLLogMessage.localID < currentMessage.localID && DRLLogMessage.type == type orderBy:DRLLogMessage.localID.order(WCTOrderedDescending) limit:limit];
    } else {
        array = [self.database getObjectsOfClass:DRLLogMessage.class fromTable:tableNormal where:DRLLogMessage.localID < currentMessage.localID && DRLLogMessage.type == type orderBy:DRLLogMessage.localID.order(WCTOrderedDescending) limit:limit];
    }
    
    if (resultBlock) {
        resultBlock(array);
    }
}


- (NSOperationQueue *)operationQueue {
    if (!_operationQueue) {
        NSOperationQueue *operationQueue = [NSOperationQueue new];
        operationQueue.maxConcurrentOperationCount = 1; // 串行队列
        _operationQueue = operationQueue;
    }
    return _operationQueue;
}

@end


