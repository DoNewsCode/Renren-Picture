//
//  DRIImagePickerController.h
//  RenrenOfficial-iOS-Concept
//
//  Created by 张健康 on 2019/4/24.
//  Copyright © 2019 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN
@class DRIImagePickerController,DRIImageURLPreviewViewController,DRIRecordViewController,DRIImagePickerManager;
@protocol DRIImagePickerDelegate <NSObject>

- (void)dri_imagePickerControllerDidCancel:(DRIImagePickerManager *)picker;

- (void)dri_imagePickerController:(DRIImagePickerManager *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos;

- (void)dri_imagePickerController:(DRIImagePickerManager *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset;

- (void)dri_imagePickerController:(DRIImagePickerManager *)picker didFinishTakeVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset;

- (void)dri_imagePickerController:(DRIImagePickerManager *)picker didFinishTakePhoto:(UIImage *)photo sourceAsset:(PHAsset *)asset info:(NSDictionary *)info;

@end

@interface DRIImagePickerManager : NSObject
@property (nonatomic, weak)   id <DRIImagePickerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, assign) BOOL allowPickVideo;
@property (nonatomic, assign) BOOL allowTakePicture;
@property (nonatomic, assign) BOOL showTagBtn;            ///< 是否需要标签功能，默认为no
@property (nonatomic, assign) BOOL allowPickingOriginalPhoto;  
@property (nonatomic, assign) NSInteger maxImagesCount;
@property (nonatomic, assign) BOOL onlyTakePhoto;
@property (nonatomic, assign) BOOL onlyTakeVideo;
@property (nonatomic, assign) BOOL showSelectedIndex;
@property (nonatomic, assign) BOOL animateFullScreen;

/**
 拍照后是否 隐藏编辑按钮 默认为NO
 */
@property (nonatomic, assign) BOOL isHiddenEdit;

/**
 是否去掉打标签功能 编辑页面不需要打标签功能 默认为NO
 */
@property (nonatomic, assign) BOOL isHidenTagAction;


-(instancetype)initImagePickerWithColumnNumber:(NSInteger)columnNumber;

- (UIViewController *)showImagePicker;

- (void)showImagePickerWithViewController:(UIViewController *)viewController;

- (UIViewController *)previewSelectImageIndex:(NSInteger)index collectionView:(UICollectionView *)collectionView;

- (UIViewController *)previewSelectImageIndex:(NSInteger)index
                               imageViewArray:(NSArray <UIImageView *>*)imageViewArray;

- (UIViewController *)previewOnlyImageIndex:(NSInteger)index
                               imageViewArray:(NSArray <UIImageView *>*)imageViewArray;

- (UIViewController *)previewVideoURL:(NSURL *)videoURL
                       coverImageView:(UIImageView *)imageView;

- (DRIImageURLPreviewViewController *)previewURLImageIndex:(NSInteger)index
                                             imageURLArray:(NSArray *)imageURLArray
                                            imageViewArray:(NSArray <UIImageView *>*)imageViewArray;

+ (DRIImagePickerController *)createNavigationController:(DRIImageURLPreviewViewController *)vc;
//构造图片Frame数组
+ (NSArray<NSValue *> *)firstImageViewFramesWithImageViews:(NSArray <UIImageView *>*)imageViews;

- (DRIRecordViewController *)showRecordViewController;
@end

NS_ASSUME_NONNULL_END
