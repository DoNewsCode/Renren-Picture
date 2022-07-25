//
//  DRPICAlbum.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/11.
//

#import "DRPICAlbum.h"

#import "DRPICPictureManager.h"

@implementation DRPICAlbum

- (void)setFetchResult:(PHFetchResult *)fetchResult needFetchAssets:(BOOL)needFetchAssets {
    _fetchResult = fetchResult;
    if (needFetchAssets) {
        [[DRPICPictureManager sharedPictureManager] obtainAssetsFromFetchResult:fetchResult completion:^(NSMutableArray<DRPICPicture *> *pictures) {
            self->_pictures = pictures;
            if (self->_selectedPictures) {
                [self checkSelectedModels];
            }
        }];
    }
}

- (void)checkSelectedModels {
    self.selectedCount = 0;
    NSMutableSet *selectedAssets = [NSMutableSet setWithCapacity:self.selectedPictures.count];
    for (DRPICPicture *picture in self.selectedPictures) {
        [selectedAssets addObject:picture.source.asset];
    }
    for (DRPICPicture *picture in self.pictures) {
        if ([selectedAssets containsObject:picture.source.asset]) {
            self.selectedCount ++;
        }
    }
}

- (NSMutableArray<DRPICPicture *> *)pictures {
    if (!_pictures) {
        NSMutableArray<DRPICPicture *> *pictures = [NSMutableArray<DRPICPicture *> new];
        _pictures = pictures;
    }
    return _pictures;
}

- (NSMutableArray<DRPICPicture *> *)selectedPictures {
    if (!_selectedPictures) {
        NSMutableArray<DRPICPicture *> *selectedPictures = [NSMutableArray<DRPICPicture *> new];
        _selectedPictures = selectedPictures;
    }
    return _selectedPictures;
}
@end
