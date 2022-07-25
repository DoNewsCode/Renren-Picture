//
//  UIImage+BaseIcon.h
//  DNCommonKit
//
//  Created by 文昌  陈 on 2019/8/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (BaseIcon)

/**
 获取iCon

 @param imageName iconname
 @return UImage
 */
+ (UIImage *)baseImageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
