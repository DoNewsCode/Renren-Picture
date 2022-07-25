//
//  DRTEmotionSafeMutableArray.h
//  Renren-TimeLine
//
//  Created by 陈文昌 on 2020/2/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRLRecordSafeMutableArray : NSObject

- (NSMutableArray *)safeArray;
- (NSUInteger)count;

- (BOOL)containsObject:(id)anObject;
- (void)addObject:(id)anObject;

- (id)objectAtIndex:(NSUInteger)index;

- (void)removeObjectAtIndex:(NSInteger)index;
- (void)removeObject:(id)object;
@end

NS_ASSUME_NONNULL_END
