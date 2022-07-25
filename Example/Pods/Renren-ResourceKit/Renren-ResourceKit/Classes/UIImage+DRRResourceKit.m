//
//  UIImage+DRRResourceKit.m
//  Pods-Renren-ResourceKit_Example
//
//  Created by Ming on 2019/4/17.
//

#import "UIImage+DRRResourceKit.h"

#import "NSBundle+Renren_ResourceKitUtils.h"

@implementation UIImage (DRRResourceKit)

+ (nullable UIImage *)ct_imageResourceKitWithNamed:(NSString *)name {
    return [self imageNamed:name inBundle:[NSBundle ct_pictureUI_bundle] compatibleWithTraitCollection:nil];
}

@end
