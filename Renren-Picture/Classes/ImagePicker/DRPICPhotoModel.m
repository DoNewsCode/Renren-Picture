//
//  DRPICPhotoModel.m
//  Renren-Picture
//
//  Created by Luis on 2020/3/2.
//

#import "DRPICPhotoModel.h"

@implementation DRPICPhotoModel

- (void)setAsset:(PHAsset *)asset{
    _asset = asset;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
        options.synchronous = YES;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        __weak typeof(self) weakSelf = self;
        [[PHCachingImageManager defaultManager]requestImageForAsset:self.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            weakSelf.highDefinitionImage = result;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.fetchPhotoModelCompletion) {
                    weakSelf.fetchPhotoModelCompletion();
                }
            });
        }];
    });
}

@end
