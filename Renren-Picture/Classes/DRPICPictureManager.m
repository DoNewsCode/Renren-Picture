//
//  DRPICPictureManager.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/11.
//

#import "DRPICPictureManager.h"

@interface DRPICPictureManager ()


@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenScale;

@end

@implementation DRPICPictureManager
static DRPICPictureManager *_instance = nil;
//单例
+ (instancetype)sharedPictureManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        
    });
    return _instance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.screenWidth = [UIScreen mainScreen].bounds.size.width;
        // 测试发现，如果scale在plus真机上取到3.0，内存会增大特别多。故这里写死成2.0
        self.screenScale = 2.0;
        if (self.screenWidth > 700) {
            self.screenScale = 1.5;
        }
    }
    return self;
}



/// Get Assets 获得照片数组
- (void)obtainAssetsFromFetchResult:(PHFetchResult *)result completion:(void (^)(NSMutableArray<DRPICPicture *> *pictures))completion {
    return [self getAssetsFromFetchResult:result allowPickingVideo:YES allowPickingImage:YES completion:completion];
}

/// Get Assets 获得照片数组
- (void)obtainAssetsFromFetchResult:(PHFetchResult *)result needVideo:(BOOL)needVideo completion:(void (^)(NSMutableArray<DRPICPicture *> *pictures))completion {
    return [self getAssetsFromFetchResult:result allowPickingVideo:YES allowPickingImage:YES completion:completion];
}


- (void)getAssetsFromFetchResult:(PHFetchResult *)result allowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^)(NSMutableArray<DRPICPicture *> *pictures))completion {
    
    NSMutableArray *photos = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        DRPICPicture *model = [self assetModelWithAsset:asset allowPickingVideo:allowPickingVideo allowPickingImage:allowPickingImage];
        if (model) {
            [photos addObject:model];
        }
    }];
    if (completion) completion(photos);
}

- (DRPICPicture *)assetModelWithAsset:(PHAsset *)asset allowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage {
    DRPICPicture *picture = nil;
    DRPICPictureMediaType mediaType = [self getAssetType:asset];
    DRPICPictureMediaSubtype mediaSubtypes = [self getAssetMediaSubtypes:asset];
    
    picture = [DRPICPicture new];
    picture.source.asset = asset;
    picture.source.type = DRPICPictureSourceTypeLocal;
    picture.source.mediaType = mediaType;
    picture.source.mediaSubtypes = mediaSubtypes;
    
    return picture;
}

- (DRPICPictureMediaType)getAssetType:(PHAsset *)asset {
    DRPICPictureMediaType type = DRPICPictureMediaTypeUnknown;
    PHAsset *phAsset = (PHAsset *)asset;
    switch (phAsset.mediaType) {
        case PHAssetMediaTypeVideo:
            type = DRPICPictureMediaTypeVideo;
            break;
        case PHAssetMediaTypeAudio:
            type = DRPICPictureMediaTypeAudio;
            break;
        case PHAssetMediaTypeImage:
            type = DRPICPictureMediaTypeImage;
            break;
            
        default:
            break;
    }
    return type;
}

- (DRPICPictureMediaSubtype)getAssetMediaSubtypes:(PHAsset *)asset {
    DRPICPictureMediaSubtype type = DRPICPictureMediaSubtypeNone;
    PHAsset *phAsset = (PHAsset *)asset;
    if (@available(iOS 9.1, *)) {
        type =(DRPICPictureMediaSubtype)phAsset.mediaSubtypes;
    }
    if (phAsset.mediaType != PHAssetMediaTypeImage) {
        return type;
    }
    
    // Gif
    if ([[phAsset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
        if (type == 0) {//无法获取到类型
            type = DRPICPictureMediaSubtypePhotoGIF;
        } else {
            type = DRPICPictureMediaSubtypePhotoGIF | type;
        }
    }
    return type;
}

- (void)obtainAlbumWithAllowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage complete:(DRPICPictureManagerCompleteBlock)complete {
    NSMutableArray *operaQueueArray = [NSMutableArray array];
    NSMutableArray<DRPICAlbum *> *albumArr = [NSMutableArray array];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    if (!allowPickingVideo) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    if (!allowPickingImage) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",
                                                PHAssetMediaTypeVideo];
    // 排序方式- 依照创建时间
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    NSBlockOperation *smartAlbumUserLibraryOperation = [NSBlockOperation blockOperationWithBlock:^{
        // 我的照片流 1.6.10重新加入..
        PHFetchResult *myPhotoStreamAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        PHFetchResult *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
        PHFetchResult *sharedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil];
        NSArray *allAlbums = @[myPhotoStreamAlbum,smartAlbums,topLevelUserCollections,syncedAlbums,sharedAlbums];
        for (PHFetchResult *fetchResult in allAlbums) {
            for (PHAssetCollection *collection in fetchResult) {
                // 有可能是PHCollectionList类的的对象，过滤掉
                if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
                // 过滤空相册
                if (collection.estimatedAssetCount <= 0 && ![self isCameraRollAlbum:collection]) continue;
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
                if (fetchResult.count < 1 && ![self isCameraRollAlbum:collection]) {
                    continue;
                };
                
                if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumAllHidden) {
                    continue;
                }
                if (collection.assetCollectionSubtype == 1000000201) {
                    continue;
                } //『最近删除』相册
                if ([self isCameraRollAlbum:collection]) {
                    [albumArr insertObject:[self modelWithResult:fetchResult name:collection.localizedTitle isCameraRoll:YES needFetchAssets:YES] atIndex:0];
                    
                } else {
                    [albumArr addObject:[self modelWithResult:fetchResult name:collection.localizedTitle isCameraRoll:NO needFetchAssets:YES]];
                }
            }
        }
    }];
    NSBlockOperation *finishOperation = [NSBlockOperation blockOperationWithBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (complete) {
                complete(YES,albumArr);
            }
        }];
    }];
    [operaQueueArray addObject:smartAlbumUserLibraryOperation];
    [operaQueueArray addObject:finishOperation];
    [self.operationQueue addOperations:operaQueueArray waitUntilFinished:NO];
}

- (DRPICAlbum *)modelWithResult:(PHFetchResult *)result name:(NSString *)name isCameraRoll:(BOOL)isCameraRoll needFetchAssets:(BOOL)needFetchAssets {
    DRPICAlbum *album = [DRPICAlbum new];
    [album setFetchResult:result needFetchAssets:needFetchAssets];
    album.name = name;
    //    album.isCameraRoll = isCameraRoll;
    album.count = result.count;
    return album;
}

- (BOOL)isCameraRollAlbum:(PHAssetCollection *)metadata {
    NSString *versionStr = [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (versionStr.length <= 1) {
        versionStr = [versionStr stringByAppendingString:@"00"];
    } else if (versionStr.length <= 2) {
        versionStr = [versionStr stringByAppendingString:@"0"];
    }
    CGFloat version = versionStr.floatValue;
    // 目前已知8.0.0 ~ 8.0.2系统，拍照后的图片会保存在最近添加中
    if (version >= 800 && version <= 802) {
        return ((PHAssetCollection *)metadata).assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded;
    } else {
        return ((PHAssetCollection *)metadata).assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary;
    }
}

- (PHImageRequestID)obtainOrginImageWithAsset:(PHAsset *)asset completion:(void (^)(NSData *imageData,UIImageOrientation orientation,NSDictionary *info, BOOL isDegraded))completion progress:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed {

    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    //设置为同步, 只会返回1张图片
    options.synchronous = NO;
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
   int32_t PHImageRequestID = [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        if (completion) {
            completion(imageData,orientation,info,YES);
        }
    }];
    return PHImageRequestID;
}

- (PHImageRequestID)obtainOriginalPhotoDataWithAsset:(PHAsset *)asset progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler completion:(void (^)(NSData *data,NSDictionary *info,BOOL isDegraded))completion {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
        // if version isn't PHImageRequestOptionsVersionOriginal, the gif may cann't play
        option.version = PHImageRequestOptionsVersionOriginal;
    }
    [option setProgressHandler:progressHandler];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    return [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && imageData) {
            if (completion) completion(imageData,info,NO);
        }
    }];
}

- (PHImageRequestID)obtainImageWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *image, NSDictionary *info, BOOL isDegraded))completion progress:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed {
    CGFloat fullScreenWidth = self.screenWidth;
//    if (_photoPreviewMaxWidth > 0 && fullScreenWidth > _photoPreviewMaxWidth) {
////        fullScreenWidth = _photoPreviewMaxWidth;
//    }
    return [self getPhotoWithAsset:asset photoWidth:fullScreenWidth completion:completion progressHandler:progressHandler networkAccessAllowed:networkAccessAllowed];
}

- (PHImageRequestID)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed {
    CGSize imageSize;

    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    int32_t imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage *result, NSDictionary *info) {
        BOOL cancelled = [[info objectForKey:PHImageCancelledKey] boolValue];
        if (!cancelled && result) {
//            result = [self fixOrientation:result];
            if (completion) completion(result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        }
        // Download image from iCloud / 从iCloud下载图片
        if ([info objectForKey:PHImageResultIsInCloudKey] && !result && networkAccessAllowed) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (progressHandler) {
                        progressHandler(progress, error, stop, info);
                    }
                });
            };
            options.networkAccessAllowed = YES;
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                UIImage *resultImage = [UIImage imageWithData:imageData];

            }];
        }
    }];
    return imageRequestID;
}

- (void)obtainVideoWithAsset:(PHAsset *)asset progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler completion:(void (^)(AVPlayerItem *playerItem, NSDictionary *info))completion {
    PHVideoRequestOptions *option = [[PHVideoRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    option.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressHandler) {
                progressHandler(progress, error, stop, info);
            }
        });
    };
    [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:option resultHandler:^(AVPlayerItem *playerItem, NSDictionary *info) {
        if (completion) completion(playerItem,info);
    }];
}

- (UIImage *)processImageFixOrientation:(UIImage *)aImage {

    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;

        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }

    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }

    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;

        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }

    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (NSOperationQueue *)operationQueue {
    if (!_operationQueue) {
        NSOperationQueue *operationQueue = [NSOperationQueue new];
        operationQueue.maxConcurrentOperationCount = 1; // 并发数为1
        _operationQueue = operationQueue;
    }
    return _operationQueue;
}

@end
