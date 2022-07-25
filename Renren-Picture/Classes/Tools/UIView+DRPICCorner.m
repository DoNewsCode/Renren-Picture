//
//  UIView+DRPICCorner.m
//  Renren-Picture
//
//  Created by Luis on 2020/3/4.
//

#import "UIView+DRPICCorner.h"
#import <objc/runtime.h>

static NSString *const DRPICCornerPositionKey = @"DRPICCornerPositionKey";
static NSString *const DRPICCornerRadiusKey = @"DRPICCornerRadiusKey";

@implementation UIView (DRPICCorner)

@dynamic drpic_cornerPosition;
- (DRPICCornerPosition)drpic_cornerPosition{
    return [objc_getAssociatedObject(self, &DRPICCornerPositionKey) integerValue];
}
- (void)setDrpic_cornerPosition:(DRPICCornerPosition)drpic_cornerPosition{
    objc_setAssociatedObject(self, &DRPICCornerPositionKey, @(drpic_cornerPosition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}
@dynamic drpic_cornerRadius;
- (CGFloat)drpic_cornerRadius{
    return [objc_getAssociatedObject(self, &DRPICCornerRadiusKey) integerValue];
}
- (void)setDrpic_cornerRadius:(CGFloat)drpic_cornerRadius{
    objc_setAssociatedObject(self, &DRPICCornerRadiusKey, @(drpic_cornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+(void)load{
    SEL ori = @selector(layoutSublayersOfLayer:);
    SEL new = NSSelectorFromString([@"drpic_" stringByAppendingString:NSStringFromSelector(ori)]);
    Method origiMethod = class_getInstanceMethod(self, ori);
    Method newMethod = class_getInstanceMethod(self, new);

    method_exchangeImplementations(origiMethod, newMethod);
}
- (void)drpic_layoutSublayersOfLayer:(CALayer *)layer{
    [self drpic_layoutSublayersOfLayer:layer];
    if (self.drpic_cornerRadius > 0) {
        UIBezierPath *maskPath;
        switch (self.drpic_cornerPosition) {
            case DRPICCornerPositionTop:
                maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(self.drpic_cornerRadius, self.drpic_cornerRadius)];
                break;
            case DRPICCornerPositionLeft:
                maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(self.drpic_cornerRadius, self.drpic_cornerRadius)];
                break;
            case DRPICCornerPositionBottom:
                maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(self.drpic_cornerRadius, self.drpic_cornerRadius)];
                break;
            case DRPICCornerPositionRight:
                maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(self.drpic_cornerRadius, self.drpic_cornerRadius)];
                break;
            case DRPICCornerPositionAll:
                maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(self.drpic_cornerRadius, self.drpic_cornerRadius)];
                break;

            default:
                break;
        }
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
}
- (void)drpic_setCornerOnTopWithRadius:(CGFloat)radius{
    self.drpic_cornerPosition = DRPICCornerPositionTop;
    self.drpic_cornerRadius = radius;
}
- (void)drpic_setCornerOnLeftWithRadius:(CGFloat)radius{
    self.drpic_cornerPosition = DRPICCornerPositionLeft;
    self.drpic_cornerRadius = radius;
}
- (void)drpic_setCornerOnBottomWithRadius:(CGFloat)radius{
    self.drpic_cornerPosition = DRPICCornerPositionBottom;
    self.drpic_cornerRadius = radius;
}
- (void)drpic_setCornerOnRightWithRadius:(CGFloat)radius{
    self.drpic_cornerPosition = DRPICCornerPositionRight;
    self.drpic_cornerRadius = radius;
}
- (void)drpic_setAllCornerWithRadius:(CGFloat)radius{
    self.drpic_cornerPosition = DRPICCornerPositionAll;
    self.drpic_cornerRadius = radius;
}
- (void)drpic_setNoneCorner{
    self.layer.mask = nil;
}
@end
