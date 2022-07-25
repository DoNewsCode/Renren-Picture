//
//  DRPICPicturePickerInformationView.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 资源媒体类型
typedef NS_ENUM(NSInteger, DRPICPicturePickerInformationType) {//资源媒体类型
    DRPICPicturePickerInformationTypeNone,// 未知
    DRPICPicturePickerInformationTypeEdited,// 已编辑
    DRPICPicturePickerInformationTypeGif,// 动图
    DRPICPicturePickerInformationTypeVideo,// 视频
    DRPICPicturePickerInformationTypeAudio,// 音频
};

@interface DRPICPicturePickerInformationView : UIView

@property (nonatomic, assign) DRPICPicturePickerInformationType type;

@property (nonatomic, strong) UIImageView *editedImageView;
@property (nonatomic, strong) UILabel *gifTitleLabel;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIImageView *audioImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
