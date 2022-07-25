//
//  DNPop.h
//  DNPop
//
//  Created by 陈金铭 on 2019/6/27.
//

#import <UIKit/UIKit.h>

#import "DNPopViewController.h"
#import "DNPopOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface DNPop : UIView

/**
 插入一个Alert视图控制器（默认从根控制器弹出）
 
 @param alertViewController Alert视图控制器
 */
+ (void)insertAlertController:(nonnull DNPopViewController *)alertViewController;


/**
 插入一个Alert视图（指定弹出控制器）
 
 @param fromViewController 药弹出Alert的控制器
 @param alertViewController Alert控制器
 */
+ (void)insertFromViewController:(nullable UIViewController *)fromViewController alertController:(nonnull DNPopViewController *)alertViewController;

/**
 添加一个Alert动作
 可通过此方法自定义加入的alertOperation
 @param alertOperation Alert动作
 */
+ (void)insertAlertOperation:(DNPopOperation *)alertOperation;

@end

NS_ASSUME_NONNULL_END
