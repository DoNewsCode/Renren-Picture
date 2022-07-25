//
//  DRPICPicturePreviewModel.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/17.
//

#import <Foundation/Foundation.h>

#import "DRPICAlbum.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRPICPicturePreviewModel : NSObject

/// 智能相册收藏夹（个人收藏）
@property (nonatomic, strong) NSMutableArray<DRPICAlbum *> *albums;
/// 相册
@property (nonatomic, strong) DRPICAlbum *album;
/// 当前图像
@property (nonatomic, strong) DRPICPicture *currentPicture;
/// 选中图像数组
@property (nonatomic, strong) NSMutableArray<DRPICPicture *> *selectedPictures;
/// 选中图像数组最大个数
@property (nonatomic, assign) NSInteger selectedPicturesMaxCount;
/// 选中图像数组的个数
@property (nonatomic, assign) NSInteger selectedPicturesCount;

@end

NS_ASSUME_NONNULL_END
