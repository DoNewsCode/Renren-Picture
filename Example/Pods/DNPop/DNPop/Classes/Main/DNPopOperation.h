//
//  DNPopOperation.h
//  DNPop
//
//  Created by 陈金铭 on 2019/7/3.
//

#import <Foundation/Foundation.h>

#import "DNPopViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DNPopOperationQueuePriority) {
    DNPopOperationQueuePriorityVeryLow = -8L,
    DNPopOperationQueuePriorityLow = -4L,
    DNPopOperationQueuePriorityNormal = 0,
    DNPopOperationQueuePriorityHigh = 4,
    DNPopOperationQueuePriorityVeryHigh = 8
};

@interface DNPopOperation : NSObject

/** fromViewController */
@property (nonatomic, weak) UIViewController *fromViewController;
/** toViewController */
@property (nonatomic, strong) DNPopViewController *toViewController;
//优先级
@property (nonatomic, assign) DNPopOperationQueuePriority priority;
@property (readonly, getter=isExecuting) BOOL executing;
@property (readonly, getter=isFinished) BOOL finished;
@property (readonly, getter=isAsynchronous) BOOL asynchronous API_AVAILABLE(macos(10.8), ios(7.0), watchos(2.0), tvos(9.0));
@property (readonly, getter=isReady) BOOL ready;

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(DNPopViewController *)toViewController;

- (void)start;
- (void)main;
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
