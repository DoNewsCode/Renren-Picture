//
//  DRFTFilterModel+DRMEExtension.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/3/17.
//

#import "DRFTFilterModel+DRMEExtension.h"

@implementation DRFTFilterModel (DRMEExtension)

- (void)setSelected:(BOOL)selected
{
    objc_setAssociatedObject(self, @selector(setSelected:), [NSNumber numberWithBool:selected], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isSelected
{
    NSNumber *n = objc_getAssociatedObject(self, @selector(setSelected:));
    return [n boolValue];
}


- (void)setOriginalImage:(BOOL)originalImage
{
    objc_setAssociatedObject(self, @selector(setOriginalImage:), [NSNumber numberWithBool:originalImage], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isOriginalImage
{
    NSNumber *n = objc_getAssociatedObject(self, @selector(setOriginalImage:));
    return [n boolValue];
}

- (void)setCurrentIntensity:(CGFloat)currentIntensity
{
    objc_setAssociatedObject(self, @selector(setCurrentIntensity:), [NSNumber numberWithFloat:currentIntensity], OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)currentIntensity
{
    NSNumber *n = objc_getAssociatedObject(self, @selector(setCurrentIntensity:));
    return [n floatValue];
}

@end
