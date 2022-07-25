//
//  DRPICWebImageManager.m
//  AFNetworking
//
//  Created by 陈金铭 on 2019/9/24.
//

#import "DRPICWebImageManager.h"

@implementation DRPICWebImageManager

- (id)loadImageWithURL:(NSURL *)url progress:(DRPICWebImageProgressBlock)progress completed:(DRPICWebImageCompletionBlock)completion {
    // 进度block
    SDWebImageDownloaderProgressBlock progressBlock = ^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {
        !progress ? : progress(receivedSize, expectedSize);
    };
    
    // 图片加载完成block
    SDInternalCompletionBlock completionBlock = ^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        !completion ? : completion(image, data, error, cacheType, finished, imageURL);
    };
    
    return [[SDWebImageManager sharedManager] loadImageWithURL:url options:SDWebImageRetryFailed progress:progressBlock completed:completionBlock];
}

- (void)cancelImageRequestWithImageView:(UIImageView *)imageView {
    [imageView sd_cancelCurrentImageLoad];
}

- (UIImage *)imageFromMemoryForURL:(NSURL *)url {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *key = [manager cacheKeyForURL:url];
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    return [imageCache imageFromCacheForKey:key];
}

- (NSData *)imageDataFromDiskForURL:(NSURL *)url {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *key = [manager cacheKeyForURL:url];
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    return [imageCache diskImageDataForKey:key];
}


@end
