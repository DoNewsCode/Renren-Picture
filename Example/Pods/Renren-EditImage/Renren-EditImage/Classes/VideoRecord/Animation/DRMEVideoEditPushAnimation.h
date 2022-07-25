//
//  DRMEVideoEditPushAnimation.h
//  Pods
//
//  Created by 张健康 on 2019/11/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRMEVideoEditPushAnimation : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) UINavigationControllerOperation operation;
@property (nonatomic, strong) UIImage *animatImage;
@property (nonatomic, assign) CGRect   fromRect;
@property (nonatomic, assign) CGRect   toRect;

@end

NS_ASSUME_NONNULL_END
