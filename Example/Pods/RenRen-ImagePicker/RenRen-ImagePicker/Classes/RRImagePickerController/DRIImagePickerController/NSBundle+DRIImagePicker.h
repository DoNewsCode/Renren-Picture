//
//  NSBundle+DRIImagePicker.h
//  DRIImagePickerController
//
//  Created by 谭真 on 16/08/18.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSBundle (driImagePicker)

+ (NSBundle *)dri_imagePickerBundle;

+ (NSString *)dri_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)dri_localizedStringForKey:(NSString *)key;

@end

