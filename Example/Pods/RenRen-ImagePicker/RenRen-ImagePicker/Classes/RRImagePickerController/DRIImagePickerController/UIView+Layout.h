//
//  UIView+Layout.h
//
//  Created by 谭真 on 15/2/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RHCOscillatoryAnimationToBigger,
    RHCOscillatoryAnimationToSmaller,
} RHCOscillatoryAnimationType;

@interface UIView (Layout)

+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer type:(RHCOscillatoryAnimationType)type;

@end
