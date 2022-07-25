
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Pop)

/**
 从 bundle 加载图片
 */
+ (instancetype)pop_imageWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
