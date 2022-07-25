//
//  DRPICPictureManager.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/11.
//

#import <Foundation/Foundation.h>

#import "DRPICAlbum.h"
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DRPICPictureManagerCompleteBlock)(BOOL success,NSMutableArray<DRPICAlbum *> *albums);

@interface DRPICPictureManager : NSObject

+ (instancetype)sharedPictureManager;

- (void)obtainAlbumWithAllowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage complete:(DRPICPictureManagerCompleteBlock)complete;

- (void)obtainAssetsFromFetchResult:(PHFetchResult *)result completion:(void (^)(NSMutableArray<DRPICPicture *> *pictures))completion;

- (PHImageRequestID)obtainOrginImageWithAsset:(PHAsset *)asset completion:(void (^)(NSData *imageData,UIImageOrientation orientation,NSDictionary *info, BOOL isDegraded))completion progress:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;

- (PHImageRequestID)obtainOriginalPhotoDataWithAsset:(PHAsset *)asset progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler completion:(void (^)(NSData *data,NSDictionary *info,BOOL isDegraded))completion;

- (void)obtainVideoWithAsset:(PHAsset *)asset progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler completion:(void (^)(AVPlayerItem *playerItem, NSDictionary *info))completion;

- (UIImage *)processImageFixOrientation:(UIImage *)aImage;

- (PHImageRequestID)obtainImageWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *image, NSDictionary *info, BOOL isDegraded))completion progress:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;

@end

NS_ASSUME_NONNULL_END
