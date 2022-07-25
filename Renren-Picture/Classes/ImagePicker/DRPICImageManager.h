//
//  DRPICImageManager.h
//  Renren-Picture
//
//  Created by Luis on 2020/3/4.
//

/**
相册资源管理器
 */

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@class DRPICAlbumModel;
@class DRPICPhotoModel;

typedef void(^DIPICImageMangerPhotoCountChangeBlock)(NSInteger photoCount);


@interface DRPICImageManager : NSObject

/**是否按照修改日期排序*/
@property(nonatomic, assign)BOOL sortAscendingByModificationDate;
/**可选照片最大数量*/
@property(nonatomic, assign)NSInteger maxCount;
/**已选照片数*/
@property(nonatomic, assign)NSInteger selectedCount;
/**已选照片list*/
@property(nonatomic, strong)NSMutableArray<DRPICPhotoModel *> *photoModelList;
/**照片选择变化回调*/
@property(nonatomic, copy)DIPICImageMangerPhotoCountChangeBlock selectCountBlock;

+ (instancetype)sharedManager;

/**相册授权*/
- (BOOL)authorizationStatusAuthorized;
- (void)requestAuthorizationWithCompletion:(void(^)(void))completion;

/**获得相册*/
- (void)getCameraRollAlbum:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickerImage needFetchAssets:(BOOL)needFetchAssets completion:(void(^)(DRPICAlbumModel *albumModel))completion;

@end


