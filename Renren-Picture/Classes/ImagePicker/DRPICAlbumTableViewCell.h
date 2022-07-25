//
//  DRPICAlbumTableViewCell.h
//  Renren-Picture
//
//  Created by Luis on 2020/3/2.
//

#import <UIKit/UIKit.h>

@class DRPICAlbumModel;

@interface DRPICAlbumTableViewCell : UITableViewCell

@property(nonatomic, strong)DRPICAlbumModel *albumModel;

@property(nonatomic, assign)NSInteger row;

- (void)loadImage:(NSIndexPath *)indexPath;

@end


