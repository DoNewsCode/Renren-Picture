//
//  DNPopOperationQueue.h
//  DNPop
//
//  Created by 陈金铭 on 2019/7/3.
//

#import <Foundation/Foundation.h>

#import "DNPopOperation.h"

NS_ASSUME_NONNULL_BEGIN 

@interface DNPopOperationQueue : NSObject

@property (readonly, copy) NSArray<__kindof DNPopOperation *> *operations;

- (void)addOperation:(DNPopOperation *)op;
- (void)addOperations:(NSArray<DNPopOperation *> *)ops waitUntilFinished:(BOOL)wait;

- (void)addOperationWithBlock:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
