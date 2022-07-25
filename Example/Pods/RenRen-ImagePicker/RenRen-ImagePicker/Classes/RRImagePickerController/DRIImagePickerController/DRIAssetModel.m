//
//  DRIAssetModel.m
//  DRIImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import "DRIAssetModel.h"
#import "DRIImageManager.h"

@implementation DRIAssetModel

+ (instancetype)modelWithAsset:(PHAsset *)asset type:(DRIAssetModelMediaType)type{
    DRIAssetModel *model = [[DRIAssetModel alloc] init];
    model.asset = asset;
    model.isSelected = NO;
    model.type = type;
    return model;
}

+ (instancetype)modelWithAsset:(PHAsset *)asset type:(DRIAssetModelMediaType)type timeLength:(NSString *)timeLength {
    DRIAssetModel *model = [self modelWithAsset:asset type:type];
    model.timeLength = timeLength;
    return model;
}

- (BOOL)isImage{
    return self.type <= DRIAssetModelMediaTypePhotoGif;
}

@end



@implementation DRIAlbumModel

- (void)setResult:(PHFetchResult *)result needFetchAssets:(BOOL)needFetchAssets {
    _result = result;
    if (needFetchAssets) {
        [[DRIImageManager manager] getAssetsFromFetchResult:result cameraRoll:self.isCameraRoll completion:^(NSArray<DRIAssetModel *> *models) {
            
            self->_models = models;
            if (self->_selectedModels) {
                [self checkSelectedModels];
            }
        }];
    }
}

- (void)setSelectedModels:(NSArray *)selectedModels {
    _selectedModels = selectedModels;
    if (_models) {
        [self checkSelectedModels];
    }
}

- (void)checkSelectedModels {
    self.selectedCount = 0;
    NSMutableArray *selectedAssets = [NSMutableArray array];
    for (DRIAssetModel *model in _selectedModels) {
        [selectedAssets addObject:model.asset];
    }
    for (DRIAssetModel *model in _models) {
        if ([selectedAssets containsObject:model.asset]) {
            self.selectedCount ++;
        }
    }
}

- (NSString *)name {
    if (_name) {
        return _name;
    }
    return @"";
}

@end
