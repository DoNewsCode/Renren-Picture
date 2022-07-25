//
//  DRPICPicturePreviewCollectionViewCell.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/17.
//

#import <UIKit/UIKit.h>

#import "DRPICPictureViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRPICPicturePreviewCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) DRPICPicture *picture;

@property (nonatomic, strong) DRPICPictureViewModel *pictureViewModel;

@end

NS_ASSUME_NONNULL_END
