//
//  DNPopOperation.m
//  DNPop
//
//  Created by 陈金铭 on 2019/7/3.
//

#import "DNPopOperation.h"

@interface DNPopOperation ()

@property (assign) BOOL executing;
@property (assign) BOOL finished;
@property (assign) BOOL concurrent; // To be deprecated; use and override 'asynchronous' below
@property (assign) BOOL asynchronous;
@property (assign) BOOL ready;

@end

@implementation DNPopOperation

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(DNPopViewController *)toViewController
{
    self = [super init];
    if (self) {
        self.fromViewController = fromViewController;
        self.toViewController = toViewController;
        self.priority = DNPopOperationQueuePriorityNormal;
        self.finished = YES;
    }
    return self;
}

- (void)start {
    [self main];
}

- (void)main {
    if (self.fromViewController && self.toViewController) {
        self.ready = YES;
    }
    
    self.executing = YES;
    self.finished = NO;
    UIViewController *topRootViewController = [[UIApplication  sharedApplication] keyWindow].rootViewController;

    // 在这里加一个这个样式的循环
    while (topRootViewController.presentedViewController)
    {
        // 这里固定写法
      topRootViewController = topRootViewController.presentedViewController;
    }
    // 然后再进行present操作
     [topRootViewController presentViewController:self.toViewController animated:YES completion:^{
         
         self.executing = NO;
     }];
    
//    [self.fromViewController presentViewController:self.toViewController animated:YES completion:^{
//
//        self.executing = NO;
//    }];
    
    __weak typeof(self) weakSelf = self;
    [self.toViewController returnHandler:^(DNPopViewController * _Nonnull alertController) {
        [weakSelf cancel];
    }];
}

- (void)cancel {
    self.executing = YES;
    [self.toViewController dismissViewControllerAnimated:YES completion:^{
        self.executing = NO;
        self.finished = YES;
    }];
    
}

@end
