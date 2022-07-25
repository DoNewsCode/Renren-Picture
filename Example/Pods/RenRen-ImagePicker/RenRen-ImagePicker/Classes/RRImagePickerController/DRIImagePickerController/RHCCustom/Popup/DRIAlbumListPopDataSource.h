//
//  DRIAlbumListPopDataSource.h
//  RenrenOfficial-iOS-Concept
//
//  Created by 张健康 on 2019/3/16.
//  Copyright © 2019 renren. All rights reserved.
//

#import <UIKit/UIkit.h>

NS_ASSUME_NONNULL_BEGIN
@class DRIAlbumModel;
@interface DRIAlbumListPopDataSource : NSObject
@property (nonatomic, strong) NSArray *dataArray;
- (void)getSystemAlbums:(void (^)(NSArray<DRIAlbumModel *> * models))completion;
@end

NS_ASSUME_NONNULL_END
