//
//  UIView+BinAdd.h
//  psd
//
//  Created by 张健康 on 2018/10/29.
//  Copyright © 2018年 DoNews. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 指定 View 的圆角
typedef NS_OPTIONS(NSUInteger, DNRectCorner) {
    DNTopLeftRadius     = 1 << 0,
    DNTopRightRadius    = 1 << 1,
    DNBottomLeftRadius  = 1 << 2,
    DNBottomRightRadius = 1 << 3,
    DNRectCornerAllCorners  = ~0UL
};

@interface UIView (BinAdd)

/// View设置圆角
- (void)setRoundingCorners:(DNRectCorner)corners cornerRadii:(CGFloat)cornerRadii;
+ (void)setRoundingCorners:(DNRectCorner)corners view:(UIView *)view cornerRadii:(CGFloat)cornerRadii;

- (UIView *)clipCornerWithView:(UIView *)originView
                    andTopLeft:(BOOL)topLeft
                   andTopRight:(BOOL)topRight
                 andBottomLeft:(BOOL)bottomLeft
                andBottomRight:(BOOL)bottomRight;

@end
