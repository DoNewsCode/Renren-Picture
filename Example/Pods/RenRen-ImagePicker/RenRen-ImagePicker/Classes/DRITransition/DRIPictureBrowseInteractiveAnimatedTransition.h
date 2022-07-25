//
//  DRIPictureBrowseInteractiveAnimatedTransition.h
//  LYCustomTransitionDemo
//
//  Created by liyang on 2017/12/5.
//  Copyright © 2017年 liyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRIPictureBrowseTransitionParameter.h"

#import "DRIPictureBrowsePercentDrivenInteractive.h"
#import "DRIPictureBrowsePushAnimator.h"
#import "DRIPictureBrowsePopAnimator.h"
@interface DRIPictureBrowseInteractiveAnimatedTransition : NSObject<UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) DRIPictureBrowseTransitionParameter *transitionParameter;

@property (nonatomic, strong) DRIPictureBrowsePushAnimator *customPush;
@property (nonatomic, strong) DRIPictureBrowsePopAnimator  *customPop;
@property (nonatomic, strong) DRIPictureBrowsePercentDrivenInteractive *percentIntractive;
@end
