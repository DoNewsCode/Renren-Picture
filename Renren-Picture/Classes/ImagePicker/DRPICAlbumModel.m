//
//  DRPICAlbumModel.m
//  Renren-Picture
//
//  Created by Luis on 2020/3/2.
//

#import "DRPICAlbumModel.h"

@implementation DRPICAlbumModel

- (void)setCollection:(PHAssetCollection *)collection{
    _collection = collection;
    if ([collection.localizedTitle isEqualToString:@"All Photos"]) {
        self.collectionTitle = @"全部相册";
    }else{
        self.collectionTitle = collection.localizedTitle;
    }
    self.collectionTitle = collection.localizedTitle;
    //获得某个相册中所有PHAsset对象
    self.assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
  

    if (self.assets.count > 0) {
        self.firstAsset = self.assets[0];
    }
    self.collectionNumber = [NSString stringWithFormat:@"%ld", self.assets.count];
}
- (NSMutableArray<NSNumber *> *)selectRows{
    if (!_selectRows) {
        _selectRows = [NSMutableArray array];
    }
    return _selectRows;
}
@end
