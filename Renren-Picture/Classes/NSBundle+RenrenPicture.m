//
//  NSBundle+RenrenPicture.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/2.
//

#import "NSBundle+RenrenPicture.h"

// FakeClass 仅作占位符用，即只为分类中的 `bundleForClass:` 方法服务
@interface DRPICPictureUIFakeClass : NSObject

@end

@implementation DRPICPictureUIFakeClass

@end


@implementation NSBundle (RenrenPicture)


+ (NSBundle *)ct_renrenPictureUI_bundle {
    NSBundle *bundle = [self bundleForClass:[DRPICPictureUIFakeClass class]];
    NSURL *url = [bundle URLForResource:@"Renren-Picture-UI" withExtension:@"bundle"];
    return [self bundleWithURL:url];
}

@end
