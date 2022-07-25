//
//  DNPop.m
//  DNPop
//
//  Created by 陈金铭 on 2019/6/27.
//

#import "DNPop.h"

#import "DNPopOperation.h"
#import "DNPopOperationQueue.h"

@interface DNPop ()

/** queue */
@property (nonatomic, strong) NSMutableArray<DNPopOperation *> *alertQueue;
/** queue */
@property (nonatomic, strong) DNPopOperationQueue *alertOperationQueue;

/** 当前执行中的操作 */
@property (nonatomic, strong) DNPopOperation *executingOperation;

@end

@implementation DNPop

#pragma mark - Override Methods

#pragma mark - Intial Methods
//单例对象
static DNPop *_instance = nil;
//单例
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark - Public Methods
+ (void)insertAlertController:(nonnull DNPopViewController *)alertViewController {
    DNPop *manager = [DNPop sharedInstance];
    [manager insertFromViewController:[UIApplication sharedApplication].keyWindow.rootViewController alertController:alertViewController];
}

+ (void)insertFromViewController:(nullable UIViewController *)fromViewController alertController:(nonnull DNPopViewController *)alertViewController {
    if (fromViewController == nil) {
        fromViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    DNPop *manager = [DNPop sharedInstance];
    [manager insertFromViewController:fromViewController alertController:alertViewController];
}

+ (void)insertAlertOperation:(DNPopOperation *)alertOperation {
    if (alertOperation != nil) {
        DNPop *manager = [DNPop sharedInstance];
        [manager.alertOperationQueue addOperation:alertOperation];
    }
}

#pragma mark - Private Methods
- (void)insertFromViewController:(UIViewController *)fromViewController alertController:(nonnull DNPopViewController *)alertViewController {
    
    DNPopOperation *alertOperation = [DNPopOperation new];
    alertOperation.priority = DNPopOperationQueuePriorityNormal;
    alertOperation.fromViewController = fromViewController;
    alertOperation.toViewController = alertViewController;
    
    [self.alertOperationQueue addOperation:alertOperation];
}

#pragma mark - Event Methods

#pragma mark - Setter

#pragma mark - Getter
- (DNPopOperationQueue *)alertOperationQueue {
    if (!_alertOperationQueue) {
        DNPopOperationQueue *alertOperationQueue = [DNPopOperationQueue new];
        _alertOperationQueue = alertOperationQueue;
    }
    return _alertOperationQueue;
}
#pragma mark - NSCopying

#pragma mark - NSObject  Methods


@end
