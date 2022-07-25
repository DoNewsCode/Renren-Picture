//
//  DRPICPicturePreviewChannelCollectionViewCell.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/20.
//

#import <UIKit/UIKit.h>


#import "DRPICPicture.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRPICPicturePreviewChannelCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) DRPICPicture *picture;
@property (nonatomic, strong) UIImageView *previewIamgeView;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
