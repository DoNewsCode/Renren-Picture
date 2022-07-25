//
//  NSBundle+Renren_ResourceKitUtils.m
//  Pods-Renren-ResourceKit_Example
//
//  Created by Ming on 2019/3/16.
//

#import "NSBundle+Renren_ResourceKitUtils.h"

// FakeClass 仅作占位符用，即只为分类中的 `bundleForClass:` 方法服务
@interface DRRPictureUIFakeClass : NSObject

@end

@implementation DRRPictureUIFakeClass

@end

@implementation NSBundle (Renren_ResourceKitUtils)

+ (NSBundle *)ct_pictureUI_bundle {
    NSBundle *bundle = [self bundleForClass:[DRRPictureUIFakeClass class]];
    NSURL *url = [bundle URLForResource:@"Picture-UI" withExtension:@"bundle"];
    return [self bundleWithURL:url];
}

+ (NSBundle *)ct_localization_bundle {
    NSBundle *bundle = [self bundleForClass:[DRRPictureUIFakeClass class]];
    NSURL *url = [bundle URLForResource:@"Localization-Strings" withExtension:@"bundle"];
    
    NSBundle *locationBundle = [self bundleWithURL:url];
    
    NSURL *locationUrl = [locationBundle URLForResource:@"Localization-Strings" withExtension:@"bundle"];
    
    return [self bundleWithURL:locationUrl];
}

+ (NSBundle *)ct_fileData_bundle {
    NSBundle *bundle = [self bundleForClass:[DRRPictureUIFakeClass class]];
    NSURL *url = [bundle URLForResource:@"File-Data" withExtension:@"bundle"];
    return [self bundleWithURL:url];
}

/*
 _podImage = [UIImage imageNamed:@"Pod"
 inBundle:[NSBundle pod1_bundle]
 compatibleWithTraitCollection:nil];
 */

@end
