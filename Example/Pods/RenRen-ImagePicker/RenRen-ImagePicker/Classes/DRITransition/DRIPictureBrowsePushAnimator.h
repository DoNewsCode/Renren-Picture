//
//  DRIPictureBrowsePushAnimator.h
//  LYCustomTransitionDemo
//
//  Created by liyang on 2017/12/5.
//  Copyright © 2017年 liyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DRIPictureBrowseTransitionParameter;

@interface DRIPictureBrowsePushAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) DRIPictureBrowseTransitionParameter *transitionParameter;


@end
