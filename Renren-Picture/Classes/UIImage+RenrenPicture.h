//
//  UIImage+RenrenPicture.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/2.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (RenrenPicture)

+ (nullable UIImage *)ct_imageRenrenPictureUIWithNamed:(NSString *)name;

+ (UIImage *)sd_dri_animatedGIFWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
