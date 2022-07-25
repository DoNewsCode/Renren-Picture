//
//  UINavigationBar+DRBLargeBar.h
//  Renren-BaseKit
//
//  Created by 陈金铭 on 2019/8/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (DRBLargeBar)


- (void)ct_setBackgroundColor:(UIColor *)backgroundColor;

- (void)ct_setTranslationY:(CGFloat)translationY;

- (void)ct_setElementsAlpha:(CGFloat)alpha;

- (void)ct_reset;

@end

NS_ASSUME_NONNULL_END
