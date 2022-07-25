//
//  UIImage+DRISelect.m
//  RenRen-ImagePicker
//
//  Created by 张健康 on 2020/2/12.
//

#import "UIImage+DRISelect.h"
#import <objc/runtime.h>


@implementation UIImage (DRISelect)
- (BOOL)isSelected{
    return ((NSNumber *)objc_getAssociatedObject(self, @selector(observer))).boolValue;
}
- (void)setIsSelected:(BOOL)isSelected{
    objc_setAssociatedObject(self, @selector(observer), @(isSelected), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
