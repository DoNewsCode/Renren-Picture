//
//  DRPICPicturePickerModel.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/11.
//

#import <Foundation/Foundation.h>

#import "DRPICAlbum.h"

NS_ASSUME_NONNULL_BEGIN

@class DRPICPicturePickerAlbumModel;
@interface DRPICPicturePickerModel : NSObject

/// 当前选中的相册
@property (nonatomic, strong) DRPICAlbum *currentAlbum;

/// 智能相册收藏夹（个人收藏）
@property (nonatomic, strong) NSMutableArray<DRPICAlbum *> *albums;

/// 选中图像数组
@property (nonatomic, strong) NSMutableArray<DRPICPicture *> *selectedPictures;
/// 选中图像数组最大个数
@property (nonatomic, assign) NSInteger selectedPicturesMaxCount;
/// 选中图像数组的个数
@property (nonatomic, assign) NSInteger selectedPicturesCount;

/// 相机按钮是否隐藏
@property (nonatomic, assign) BOOL hiddenForCameraButton;

/// 是否允许领料视频
@property (nonatomic, assign) BOOL allowPickingVideo;
/// 是否允许领料图片
@property (nonatomic, assign) BOOL allowPickingImage;


@end


NS_ASSUME_NONNULL_END
