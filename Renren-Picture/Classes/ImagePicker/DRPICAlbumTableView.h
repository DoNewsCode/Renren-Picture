//
//  DRPICAlbumTableView.h
//  Renren-Picture
//
//  Created by Luis on 2020/3/2.
//

#import <UIKit/UIKit.h>

@class DRPICAlbumModel;

typedef void(^DRPICTableViewSelectedAlbumBlock)(DRPICAlbumModel *model);

@interface DRPICAlbumTableView : UITableView

@property(nonatomic, strong)NSMutableArray<DRPICAlbumModel *> *assetCollectionList;
@property(nonatomic, copy)DRPICTableViewSelectedAlbumBlock selectedAlbumBlock;

@end


