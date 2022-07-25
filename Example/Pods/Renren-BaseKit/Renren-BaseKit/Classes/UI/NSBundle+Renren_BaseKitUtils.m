//
//  NSBundle+Renren_BaseKitUtils.m
//  Renren-BaseKit
//
//  Created by 陈金铭 on 2019/8/12.
//

#import "NSBundle+Renren_BaseKitUtils.h"

// FakeClass 仅作占位符用，即只为分类中的 `bundleForClass:` 方法服务
@interface DRBBaseKitUIFakeClass : NSObject

@end

@implementation DRBBaseKitUIFakeClass

@end

@implementation NSBundle (Renren_BaseKitUtils)

+ (NSBundle *)ct_bastKitUI_bundle {
    NSBundle *bundle = [self bundleForClass:[DRBBaseKitUIFakeClass class]];
    NSURL *url = [bundle URLForResource:@"Renren-BaseKitUI" withExtension:@"bundle"];
    return [self bundleWithURL:url];
}

@end
