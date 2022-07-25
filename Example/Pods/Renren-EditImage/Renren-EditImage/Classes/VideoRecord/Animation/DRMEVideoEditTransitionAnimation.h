//
//  DRMEVideoEditTransitionAnimation.h
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRMEVideoEditTransitionAnimation : NSObject <UIViewControllerAnimatedTransitioning,UINavigationControllerDelegate,UIViewControllerInteractiveTransitioning>

@property (nonatomic , strong) UIPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic,    weak) id<UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic , assign) BOOL animationing;
@property (nonatomic , assign) BOOL manual;
@property (nonatomic , assign) BOOL autoAnimation;
@property (nonatomic , weak) UIViewController *viewController;
/// 结束当前转场动画
- (void)processCurrentCompleteTransition:(BOOL)didComplete;


- (void)processTopAndBottomContainerViewHidden:(BOOL)hidden animation:(BOOL)animation;

- (void)eventPopAnimation;

@end

NS_ASSUME_NONNULL_END
