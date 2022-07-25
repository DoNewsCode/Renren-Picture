//
//  UIImage+originData.m
//  RenRen-ImagePicker
//
//  Created by 张健康 on 2019/12/10.
//

#import "UIImage+originData.h"
#import <objc/runtime.h>

@implementation UIImage (originData)
- (NSData *)originData{
    return objc_getAssociatedObject(self, @selector(imageOriginData));
}

- (void)setOriginData:(NSData *)originData{
    objc_setAssociatedObject(self, @selector(imageOriginData), originData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
