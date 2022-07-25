//
//  DRPICWebImageProtocol.h
//  Pods
//
//  Created by 陈金铭 on 2019/9/24.
//

#import <SDWebImage/UIView+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/SDWebImageDownloader.h>

#ifndef DRPICWebImageProtocol_h
#define DRPICWebImageProtocol_h



typedef void (^DRPICWebImageProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);

typedef void (^DRPICWebImageCompletionBlock)(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL);

@protocol DRPICWebImageProtocol<NSObject>

// 加载图片
- (id _Nonnull )loadImageWithURL:(nullable NSURL *)url progress:(nullable DRPICWebImageProgressBlock)progress completed:(nullable DRPICWebImageCompletionBlock)completion;

- (void)cancelImageRequestWithImageView:(nullable UIImageView *)imageView;

- (UIImage *_Nullable)imageFromMemoryForURL:(nullable NSURL *)url;
- (NSData *_Nullable)imageDataFromDiskForURL:(nullable NSURL *)url;
@end

#endif /* DRPICWebImageProtocol_h */
