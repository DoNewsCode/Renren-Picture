//
//  DRIPictureBrowsePopAnimator.h
//  LYCustomTransitionDemo
//
//  Created by liyang on 2017/12/5.
//  Copyright © 2017年 liyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SCREENWIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREENHEIGHT ([UIScreen mainScreen].bounds.size.height)

@class DRIPictureBrowseTransitionParameter;

@interface DRIPictureBrowsePopAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) DRIPictureBrowseTransitionParameter *transitionParameter;

@end
