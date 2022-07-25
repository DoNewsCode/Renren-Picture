//
//  UIImage+DRBBaseKit.m
//  Renren-BaseKit
//
//  Created by 陈金铭 on 2019/8/12.
//

#import "UIImage+DRBBaseKit.h"

#import "NSBundle+Renren_BaseKitUtils.h"

@implementation UIImage (DRBBaseKit)

+ (nullable UIImage *)ct_imageBaseKitWithNamed:(NSString *)name {
    return [self imageNamed:name inBundle:[NSBundle ct_bastKitUI_bundle] compatibleWithTraitCollection:nil];
}

@end
