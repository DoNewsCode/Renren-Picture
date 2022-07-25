//
//  DRPICImageManager.m
//  Renren-Picture
//
//  Created by Luis on 2020/3/4.
//

#import "DRPICImageManager.h"

@implementation DRPICImageManager

static DRPICImageManager *manager;

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}
- (void)setMaxCount:(NSInteger)maxCount{
    _maxCount = maxCount;
    self.photoModelList = [NSMutableArray array];
    self.selectedCount = 0;
}
- (void)setSelectedCount:(NSInteger)selectedCount{
    _selectedCount = selectedCount;
    if (self.selectCountBlock) {
        self.selectCountBlock(selectedCount);
    }
}
- (BOOL)authorizationStatusAuthorized{
    NSInteger status = [PHPhotoLibrary authorizationStatus];
    if (status == 0) {
        //用户未授权
        [self requestAuthorizationWithCompletion:nil];
    }
    return status == 3;
}
- (void)requestAuthorizationWithCompletion:(void (^)(void))completion {

    void (^callCompletionBlock)(void) = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    };

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            callCompletionBlock();
        }];
    });
}
#pragma mark
- (void)getCameraRollAlbum:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickerImage needFetchAssets:(BOOL)needFetchAssets completion:(void (^)(DRPICAlbumModel *))completion{
    PHFetchOptions *option = [[PHFetchOptions alloc]init];
    if (!allowPickingVideo) {
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    }
    if (!allowPickerImage) {
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
    }
    if (self.sortAscendingByModificationDate) {
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationData" ascending:self.sortAscendingByModificationDate]];
    }
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:(PHAssetCollectionTypeSmartAlbum) subtype:(PHAssetCollectionSubtypeAlbumRegular) options:option];
    for (PHAssetCollection *collection in smartAlbums) {
        if (![collection isKindOfClass:[PHAssetCollection class]]) {
            continue;
        }
        if (collection.estimatedAssetCount <= 0) {
            continue;
        }
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];

    }
}

@end
