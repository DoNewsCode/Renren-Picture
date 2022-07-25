//
//  DRIAlbumListPopCell.h
//  RenrenOfficial-iOS-Concept
//
//  Created by 张健康 on 2019/3/16.
//  Copyright © 2019 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class DRIAlbumModel;
@interface DRIAlbumListPopCell : UITableViewCell
@property (strong, nonatomic) UILabel *albumNameLabel;
@property (strong, nonatomic) UIView *line;
@property (strong, nonatomic) UIImageView *albumIcon;
- (void)setObject:(DRIAlbumModel *)model;
@end

NS_ASSUME_NONNULL_END
