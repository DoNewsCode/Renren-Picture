//
//  NSBundle+DRIImagePicker.m
//  DRIImagePickerController
//
//  Created by 谭真 on 16/08/18.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "NSBundle+DRIImagePicker.h"
#import "DRIImagePickerController.h"
@interface RRImagePickerController : NSObject

@end

@implementation RRImagePickerController

@end

@implementation NSBundle (driImagePicker)

+ (NSBundle *)dri_imagePickerBundle {
    NSBundle *bundle = [NSBundle bundleForClass:[RRImagePickerController class]];
    NSURL *url = [bundle URLForResource:@"RRImagePickerController" withExtension:@"bundle"];
    bundle = [NSBundle bundleWithURL:url];
    return bundle;
}

+ (NSString *)dri_localizedStringForKey:(NSString *)key {
    return [self dri_localizedStringForKey:key value:@""];
}

+ (NSString *)dri_localizedStringForKey:(NSString *)key value:(NSString *)value {
    NSBundle *bundle = [DRIImagePickerConfig sharedInstance].languageBundle;
    NSString *value1 = [bundle localizedStringForKey:key value:value table:nil];
    return value1;
}

@end
