//
//  DRTEmotionSafeMutableArray.m
//  Renren-TimeLine
//
//  Created by 陈文昌 on 2020/2/6.
//

#import "DRLRecordSafeMutableArray.h"

@interface DRLRecordSafeMutableArray ()

@property (nonatomic, strong) dispatch_queue_t syncQueue;
@property (nonatomic, strong) NSMutableArray* array;

@end

@implementation DRLRecordSafeMutableArray

- (instancetype)init
{
    self = [super init];
    if (self) {
        //%p 以16进制的形式输出内存地址，附加前缀0x
        NSString* uuid = [NSString stringWithFormat:@"com.safe.array_%p", self];
        //注意：_syncQueue是并行队列
        _syncQueue = dispatch_queue_create([uuid UTF8String], DISPATCH_QUEUE_CONCURRENT);
        
        _array = [NSMutableArray array];
    }
    return self;
}


- (BOOL)containsObject:(id)anObject
{
    __block BOOL isExist = NO;
    dispatch_sync(_syncQueue, ^{
        isExist = [_array containsObject:anObject];
    });
    return isExist;
}

- (NSMutableArray *)safeArray
{
    __block NSMutableArray *safeArray;
    dispatch_sync(_syncQueue, ^{
        safeArray = _array;
    });
    return safeArray;
}

- (NSUInteger)count
{
    __block NSUInteger count;
    dispatch_sync(_syncQueue, ^{
        count = _array.count;
    });
    return count;
}

- (id)objectAtIndex:(NSUInteger)index
{
    __block id obj;
    dispatch_sync(_syncQueue, ^{
        if (index < [self.array count]) {
            obj = self.array[index];
        }
    });
    return obj;
}

- (void)addObject:(id)anObject
{
    dispatch_barrier_async(_syncQueue, ^{
        if(anObject){
            [self.array addObject:anObject];
        }
    });
}

- (void)removeObjectAtIndex:(NSInteger)index {
    
    dispatch_barrier_async(self.syncQueue, ^{
        NSUInteger count = self.array.count;
        if (index < count) {
            [self.array removeObjectAtIndex:index];
        }
    });
    
}

- (void)removeObject:(id)object {
    
    dispatch_barrier_async(self.syncQueue, ^{
        
        if ([self.array containsObject:object]) {
            [self.array removeObject:object];
        }
    });
    
}

- (void)dealloc
{
    if (_syncQueue) {
        _syncQueue = NULL;
    }
}

@end
