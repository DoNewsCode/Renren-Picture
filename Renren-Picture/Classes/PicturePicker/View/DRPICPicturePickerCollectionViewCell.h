//
//  DRPICPicturePickerCollectionViewCell.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/10.
//

#import <UIKit/UIKit.h>

#import "DRPICPicture.h"

#import "DRPICPicturePIckerSelectButton.h"
#import "DRPICPicturePickerInformationView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^DRPICPicturePickerCollectionViewCellSelectButtonEventBlock)(DRPICPicturePIckerSelectButton *selectButton, DRPICPicture *picture);

@interface DRPICPicturePickerCollectionViewCell : UICollectionViewCell

/// 是否禁用
@property (nonatomic, getter=isEnabled) BOOL enabled;
/// 数据模型
@property (nonatomic, strong) DRPICPicture *picture;
/// 预览视图
@property (nonatomic, strong) UIImageView *previewIamgeView;
/// 选中按钮
@property (nonatomic, strong) DRPICPicturePIckerSelectButton *selectButton;
/// 信息栏
@property (nonatomic, strong) DRPICPicturePickerInformationView *informationView;
/// 遮罩
@property (nonatomic, strong) UIView *coverView;
/// 禁用时的遮罩
@property (nonatomic, strong) UIView *enabledCoverView;
/// 选中事件的Block
@property (nonatomic, copy) DRPICPicturePickerCollectionViewCellSelectButtonEventBlock selectButtonEventBlock;

- (void)cteateImage;

- (void)setEnabled:(BOOL)enabled animated:(BOOL)animated;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)setSelected:(BOOL)selected selectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;
- (void)setSelected:(BOOL)selected selectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated completion:(void (^ __nullable)(BOOL finished))completion;

- (void)eventForSelectButtonEventBlock:(DRPICPicturePickerCollectionViewCellSelectButtonEventBlock)selectButtonEventBlock;

@end

@interface DRPICPicturePickerPhotoCollectionViewCell : DRPICPicturePickerCollectionViewCell

@end

@interface DRPICPicturePickerVideoCollectionViewCell : DRPICPicturePickerCollectionViewCell

@end

@interface DRPICPicturePickerAudioCollectionViewCell : DRPICPicturePickerCollectionViewCell

@end

@interface DRPICPicturePickerOtherCollectionViewCell : DRPICPicturePickerCollectionViewCell

@end

NS_ASSUME_NONNULL_END
