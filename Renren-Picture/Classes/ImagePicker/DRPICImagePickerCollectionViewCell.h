//
//  DRPICImagePickerCollectionViewCell.h
//  Renren-Picture
//
//  Created by Luis on 2020/3/2.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void(^DRPICAlbumSelectedActionBlock)(PHAsset * _Nullable asset);

NS_ASSUME_NONNULL_BEGIN

@interface DRPICImagePickerCollectionViewCell : UICollectionViewCell

@property(nonatomic, assign)NSInteger row;
@property(nonatomic, strong)PHAsset *asset;
@property(nonatomic, assign)BOOL isSelected;
@property(nonatomic, copy)DRPICAlbumSelectedActionBlock selectedActionBlock;


- (void)loadImage:(NSIndexPath *)indexPath;

@end

#pragma mark 拍照Cell
@interface DRPICAssetCameraCell : UICollectionViewCell

@property(nonatomic, strong)UIImageView *backgroundImageView;
@property(nonatomic, strong)UIImageView *cameraImageView;

@end

NS_ASSUME_NONNULL_END
