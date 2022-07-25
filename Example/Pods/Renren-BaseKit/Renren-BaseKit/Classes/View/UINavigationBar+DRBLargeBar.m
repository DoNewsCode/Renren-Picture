//
//  UINavigationBar+DRBLargeBar.m
//  Renren-BaseKit
//
//  Created by 陈金铭 on 2019/8/12.
//

#import "UINavigationBar+DRBLargeBar.h"

#import "UIImage+DRRResourceKit.h"
#import <objc/runtime.h>

@implementation UINavigationBar (DRBLargeBar)

static char overlayKey;

- (UIView *)overlay {
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay {
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)ct_setBackgroundColor:(UIColor *)backgroundColor {
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage ct_imageResourceKitWithNamed:@"un_image_background_clear"] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + [UIApplication sharedApplication].statusBarFrame.size.height)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;    // Should not set `UIViewAutoresizingFlexibleHeight`
        [[self.subviews firstObject] insertSubview:self.overlay atIndex:0];
    }
    self.overlay.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), [self statusBarGeight]);
    self.overlay.backgroundColor = backgroundColor;
}

- (BOOL)isIphoneX {
    
    if (@available(iOS 11.0, *)) {
    BOOL isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;
        
        return isPhoneX;
        
    }
    
    return NO;
}

- (CGFloat)statusBarGeight {
    return [self isIphoneX] ? 88:64;
}

- (void)ct_setTranslationY:(CGFloat)translationY {
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)ct_setElementsAlpha:(CGFloat)alpha {
    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")]) {
            obj.alpha = alpha;
        }
    }];
}

- (void)ct_reset {
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}

@end
