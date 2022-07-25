//
//  DRPICAlbum.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/11.
//

#import <Foundation/Foundation.h>

#import "DRPICPicture.h"

NS_ASSUME_NONNULL_BEGIN

/// 加载状态
typedef NS_ENUM(NSInteger, DRPICAlbumType) {//相册资源展示类型
    DRPICAlbumTypeExtensionMixed,          // 混合，所有类型都展示
    DRPICAlbumTypeExtensionPhoto,          // 仅展示图片
    DRPICAlbumTypeExtensionVideo,          // 仅展示视频
    DRPICAlbumTypeExtensionGIF,          // 仅展示动图
};

@class PHFetchResult;
@interface DRPICAlbum : NSObject

/// 相册名称
@property (nonatomic, strong) NSString *name;
/// 相册内图像数量
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) PHFetchResult *fetchResult;

/// 相册内图像
@property (nonatomic, strong) NSMutableArray<DRPICPicture *> *pictures;
/// 相册内选中的图像
@property (nonatomic, strong) NSMutableArray<DRPICPicture *> *selectedPictures;
/// 相册内选中的图像数量
@property (nonatomic, assign) NSUInteger selectedCount;

@property (nonatomic, getter=isCameraRoll) BOOL cameraRoll;


- (void)setFetchResult:(PHFetchResult *)fetchResult needFetchAssets:(BOOL)needFetchAssets;

@end

NS_ASSUME_NONNULL_END
