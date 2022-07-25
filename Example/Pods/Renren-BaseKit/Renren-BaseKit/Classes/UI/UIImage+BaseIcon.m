//
//  UIImage+BaseIcon.m
//  DNCommonKit
//
//  Created by 文昌  陈 on 2019/8/1.
//

#import "UIImage+BaseIcon.h"
#import "DRBBaseTheme.h"

@implementation UIImage (BaseIcon)

+ (UIImage *)baseImageName:(NSString *)imageName {
    
    NSBundle *currentBundle = [NSBundle bundleForClass:[DRBBaseTheme class]];
    
    // 获取图片
    
    NSURL *url = [currentBundle URLForResource:@"BaseKit_UI" withExtension:@"bundle"];
    
    NSBundle *targetBundle = [NSBundle bundleWithURL:url];
    
    UIImage *image = [UIImage imageNamed:imageName inBundle:targetBundle compatibleWithTraitCollection:nil];
    
    return image;
    
}

@end
