//
//  DRMEPictureCompression.h
//  Renren-MaterialEditor
//
//  Created by 陈金铭 on 2019/11/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 图片大于300K，则需要压缩
static NSUInteger const MaxImageSize = 300 * 1024;

typedef void (^DRMECompressCompleteBlock)(UIImage *image);
typedef void (^DRMECompressImagesCompleteBlock)(NSArray<UIImage *> *images);
@interface DRMEPictureCompression : NSObject

+ (instancetype)sharedPictureCompression;

- (void)processCompressImage:(UIImage *)image complete:(DRMECompressCompleteBlock)complete;

- (void)processCompressData:(NSData *)data complete:(DRMECompressCompleteBlock)complete;

- (void)processCompressImages:(NSArray<UIImage *> *)images complete:(DRMECompressImagesCompleteBlock)complete;

@end

NS_ASSUME_NONNULL_END
