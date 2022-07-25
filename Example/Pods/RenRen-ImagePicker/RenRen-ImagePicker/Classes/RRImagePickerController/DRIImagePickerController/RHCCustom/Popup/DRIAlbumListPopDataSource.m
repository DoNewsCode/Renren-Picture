//
//  DRIAlbumListPopDataSource.m
//  RenrenOfficial-iOS-Concept
//
//  Created by 张健康 on 2019/3/16.
//  Copyright © 2019 renren. All rights reserved.
//

#import "DRIAlbumListPopDataSource.h"
#import "DRIImageManager.h"
#import "DRIAlbumListPopCell.h"
@implementation DRIAlbumListPopDataSource

- (void)getSystemAlbums:(void (^)(NSArray<DRIAlbumModel *> *))completion{
    [[DRIImageManager manager] getAllAlbums:YES allowPickingImage:YES needFetchAssets:YES completion:^(NSArray<DRIAlbumModel *> *models) {
        self.dataArray = models;
    }];
}
@end
