//
//  DRIImagePickerController.m
//  RenrenOfficial-iOS-Concept
//
//  Created by 张健康 on 2019/4/24.
//  Copyright © 2019 renren. All rights reserved.
//

#import "DRIImagePickerManager.h"
#import "DRIImagePickerController/DRIImagePickerController.h"
#import "DRIPictureBrowse.h"
//#import "RHCPublishPhotoItem.h"
#import "DRIImageURLPreviewViewController.h"
#import <DNCommonKit/UIColor+CTHex.h>
#import "DRIRecordViewController.h"
#import "DRIImageRequestOperation.h"
#import "DRPPop.h"
#import "DRIVideoModel.h"
@interface DRIImagePickerManager()<DRIImagePickerControllerDelegate,DRIRecordDelegate>
//@property (nonatomic, strong) DRIImagePickerController *imagePicker;
@property (nonatomic, assign) NSInteger columnNumber;

@property (nonatomic, strong) DRIPictureBrowseInteractiveAnimatedTransition *animatedTransition;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end
@implementation DRIImagePickerManager

-(instancetype)initImagePicker{
    if (self == [super init]) {
        //        [self initdriImagePicker];
    }
    return self;
}
-(instancetype)initImagePickerWithColumnNumber:(NSInteger)columnNumber{
    if (self = [self init]) {
        self.columnNumber = columnNumber;
        //        [self initdriImagePicker];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.allowTakePicture = YES;
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = 3;
    }
    return self;
}

- (void)imagePickerAddDefaultSetting:(DRIImagePickerController *)imagePickerVc{
//        DRIImagePickerController *imagePickerVc = [[DRIImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:self.columnNumber delegate:self pushPhotoPickerVc:YES];
    
    imagePickerVc.isHiddenEdit = self.isHiddenEdit;
    imagePickerVc.isHidenTagAction = self.isHidenTagAction;
    
    imagePickerVc.maxImagesCount = self.maxImagesCount;
    imagePickerVc.showTagBtn = self.showTagBtn;
    imagePickerVc.showSelectedIndex = self.showSelectedIndex;
    imagePickerVc.hideWhenCanNotSelect = NO;
    imagePickerVc.selectedAssets = [NSMutableArray arrayWithArray:_selectedAssets];
    imagePickerVc.allowTakePicture = self.allowTakePicture; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = self.allowTakePicture;   // 在内部显示拍视频按
    imagePickerVc.autoDismiss = YES;
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    imagePickerVc.naviBgColor = [UIColor whiteColor];
    imagePickerVc.naviTitleColor = [UIColor ct_colorWithHex:0x333333];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    imagePickerVc.barItemTextColor = [UIColor ct_colorWithHex:0x333333];
    imagePickerVc.oKButtonTitleColorNormal = [UIColor ct_colorWithHex:0x3580F9];
    imagePickerVc.navigationBar.translucent = YES;
    
    imagePickerVc.iconThemeColor = [UIColor ct_colorWithHex:0x3580F9];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhoto;
    [imagePickerVc setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];
    /*
     [imagePickerVc setAssetCellDidSetModelBlock:^(DRIAssetCell *cell, UIImageView *imageView, UIImageView *selectImageView, UILabel *indexLabel, UIView *bottomView, UILabel *timeLength, UIImageView *videoImgView) {
     cell.contentView.clipsToBounds = YES;
     cell.contentView.layer.cornerRadius = cell.contentView.width * 0.5;
     }];
     */
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = self.allowPickVideo;
    imagePickerVc.allowPickingImage = true;
    imagePickerVc.allowPickingGif = true;
    imagePickerVc.allowPickingMultipleVideo = false; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = false;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    //     imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = YES;
    // 设置横屏下的裁剪尺寸
    // imagePickerVc.cropRectLandscape = CGRectMake((self.view.height - widthHeight) / 2, left, widthHeight, widthHeight);
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
    // 自定义导航栏上的返回按钮
    /*
     [imagePickerVc setNavLeftBarButtonSettingBlock:^(UIButton *leftButton){
     [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
     [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
     }];
     imagePickerVc.delegate = self;
     */
    
    // Deprecated, Use statusBarStyle
    // imagePickerVc.isStatusBarDefault = NO;
    imagePickerVc.statusBarStyle = UIStatusBarStyleDefault;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = true;
    
    //    // 自定义gif播放方案
    //    [[DRIImagePickerConfig sharedInstance] setGifImagePlayBlock:^(DRIPhotoPreviewView *view, UIImageView *imageView, NSData *gifData, NSDictionary *info) {
    //        FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
    //        FLAnimatedImageView *animatedImageView;
    //        for (UIView *subview in imageView.subviews) {
    //            if ([subview isKindOfClass:[FLAnimatedImageView class]]) {
    //                animatedImageView = (FLAnimatedImageView *)subview;
    //                animatedImageView.frame = imageView.bounds;
    //                animatedImageView.animatedImage = nil;
    //            }
    //        }
    //        if (!animatedImageView) {
    //            animatedImageView = [[FLAnimatedImageView alloc] initWithFrame:imageView.bounds];
    //            animatedImageView.runLoopMode = NSDefaultRunLoopMode;
    //            [imageView addSubview:animatedImageView];
    //        }
    //        animatedImageView.animatedImage = animatedImage;
    //    }];
    imagePickerVc.onlyTakePhoto = self.onlyTakePhoto;
}

- (UIViewController *)previewURLImageIndex:(NSInteger)index
               imageURLArray:(NSArray *)imageURLArray
              imageViewArray:(NSArray <UIImageView *>*)imageViewArray{
    DRIImageURLPreviewViewController *vc = [[DRIImageURLPreviewViewController alloc] init];
    __block NSMutableArray *modelArr = [[NSMutableArray alloc] init];
    [imageURLArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DRIImageURLPreviewModel *model = [[DRIImageURLPreviewModel alloc] init];
        model.imageView = imageViewArray[idx];
        model.urlStr = imageURLArray[idx];
        model.image = imageViewArray[idx].image;
        [modelArr addObject:model];
    }];
    vc.currentIndex = index;
    vc.imageModelArray = [NSArray arrayWithArray:modelArr];
    return vc;
}
+ (DRIImagePickerController *)createNavigationController:(DRIImageURLPreviewViewController *)vc andNeedFullScreen:(BOOL)imageViewFullScreen{
    //封装参数对象
    if (vc.currentIndex > vc.imageModelArray.count) {
        return nil;
    }
    DRIPictureBrowseInteractiveAnimatedTransition *animatedTransition = [[DRIPictureBrowseInteractiveAnimatedTransition alloc] init];
    DRIPictureBrowseTransitionParameter *transitionParameter = [[DRIPictureBrowseTransitionParameter alloc] init];
    transitionParameter.imageViewFullScreen = imageViewFullScreen;
    NSInteger index = vc.currentIndex;
    transitionParameter.transitionImage = vc.imageModelArray[index].image;
    __block NSMutableArray *imageViewsArr = [[NSMutableArray alloc] init];
    [vc.imageModelArray enumerateObjectsUsingBlock:^(DRIImageURLPreviewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [imageViewsArr addObject:obj.imageView];
    }];
    transitionParameter.firstVCImgFrames = [self firstImageViewFramesWithImageViews:imageViewsArr];
    transitionParameter.transitionImgIndex = index;
//    self.animatedTransition = nil;
    animatedTransition.transitionParameter = transitionParameter;
    
    DRIImagePickerController *imagePickerVc = [[DRIImagePickerController alloc] initWithRootViewController:vc];
    [imagePickerVc configDefaultSetting];
    imagePickerVc.transitioningDelegate = animatedTransition;
    vc.animatedTransition = animatedTransition;
    return imagePickerVc;
}

+ (DRIImagePickerController *)createNavigationController:(DRIImageURLPreviewViewController *)vc{
    return [self createNavigationController:vc andNeedFullScreen:YES];
}

- (UIViewController *)previewSelectImageIndex:(NSInteger)index
                 imageViewArray:(NSArray <UIImageView *>*)imageViewArray{
    if (!self.selectedAssets.count || self.selectedAssets.count <= index) {
        return nil;
    }
    PHAsset *asset = self.selectedAssets[index];
    BOOL isVideo = asset.mediaType == PHAssetMediaTypeVideo;
    BOOL isGif = [[asset valueForKey:@"filename"] containsString:@"GIF"];
    //    RHCPublishPhotoItem *cell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    
    self.animatedTransition = nil;
    if (imageViewArray && imageViewArray.count) {
        //封装参数对象
        DRIPictureBrowseTransitionParameter *transitionParameter = [[DRIPictureBrowseTransitionParameter alloc] init];
        transitionParameter.transitionImage = imageViewArray[index].image;
        transitionParameter.firstVCImgFrames = [self firstImageViewFramesWithImageViews:imageViewArray];
        transitionParameter.transitionImgIndex = index;
        self.animatedTransition.transitionParameter = transitionParameter;
    }
    
    if (isGif) {
        DRIAssetModel *model = [DRIAssetModel modelWithAsset:asset type:DRIAssetModelMediaTypePhotoGif timeLength:@""];
        model.isSelected = YES;
        DRIImagePickerController *imagePickerVc = [[DRIImagePickerController alloc] initGifWithSelectedAssets:self.selectedAssets selectedPhotos:self.selectedPhotos model:model transition:self.animatedTransition];
        [self imagePickerAddDefaultSetting:imagePickerVc];
        imagePickerVc.showSelectBtn = YES;
        imagePickerVc.showSelectedIndex = NO;
        imagePickerVc.showTagBtn = self.showTagBtn;
        imagePickerVc.iconThemeColor = [UIColor ct_colorWithHex:0x3580F9];
        imagePickerVc.oKButtonTitleColorNormal = [UIColor ct_colorWithHex:0x3580F9];
        imagePickerVc.maxImagesCount = self.maxImagesCount;
        __weak typeof(self) weakSelf = self;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [weakSelf imagePickerController:nil didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:isSelectOriginalPhoto infos:nil];
        }];
        return imagePickerVc;
    }else if (isVideo) {
        DRIVideoPlayerController *vc = [[DRIVideoPlayerController alloc] init];
        DRIAssetModel *model = [DRIAssetModel modelWithAsset:asset type:DRIAssetModelMediaTypeVideo timeLength:@""];
        vc.model = model;
        DRIImagePickerController *imagePickerVc = [[DRIImagePickerController alloc] initWithRootViewController:vc];
        [imagePickerVc configDefaultSetting];
        vc.animatedTransition = self.animatedTransition;
        imagePickerVc.transitioningDelegate = self.animatedTransition;
        [self imagePickerAddDefaultSetting:imagePickerVc];
        imagePickerVc.showSelectBtn = YES;
        imagePickerVc.showSelectedIndex = NO;
        imagePickerVc.showTagBtn = self.showTagBtn;
        imagePickerVc.iconThemeColor = [UIColor ct_colorWithHex:0x3580F9];
        imagePickerVc.oKButtonTitleColorNormal = [UIColor ct_colorWithHex:0x3580F9];
        imagePickerVc.maxImagesCount = self.maxImagesCount;
        __weak typeof(self) weakSelf = self;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [weakSelf imagePickerController:nil didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:isSelectOriginalPhoto infos:nil];
        }];
        return imagePickerVc;
    }else{
        DRIImagePickerController *imagePickerVc = [[DRIImagePickerController alloc] initWithSelectedAssets:self.selectedAssets selectedPhotos:self.selectedPhotos index:index transition:self.animatedTransition];
        [self imagePickerAddDefaultSetting:imagePickerVc];
        imagePickerVc.showSelectBtn = YES;
        imagePickerVc.showSelectedIndex = NO;
        imagePickerVc.showTagBtn = self.showTagBtn;
        imagePickerVc.iconThemeColor = [UIColor ct_colorWithHex:0x3580F9];
        imagePickerVc.oKButtonTitleColorNormal = [UIColor ct_colorWithHex:0x3580F9];
        imagePickerVc.maxImagesCount = self.maxImagesCount;
        __weak typeof(self) weakSelf = self;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [weakSelf imagePickerController:nil didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:isSelectOriginalPhoto infos:nil];
        }];
        return imagePickerVc;
    }
}


- (UIViewController *)previewOnlyImageIndex:(NSInteger)index
                             imageViewArray:(NSArray <UIImageView *>*)imageViewArray{
    if (!self.selectedPhotos.count || self.selectedPhotos.count <= index) {
        return nil;
    }
    self.animatedTransition = nil;
    if (imageViewArray && imageViewArray.count) {
        //封装参数对象
        DRIPictureBrowseTransitionParameter *transitionParameter = [[DRIPictureBrowseTransitionParameter alloc] init];
        transitionParameter.transitionImage = imageViewArray[index].image;
        transitionParameter.firstVCImgFrames = [self firstImageViewFramesWithImageViews:imageViewArray];
        transitionParameter.transitionImgIndex = index;
        self.animatedTransition.transitionParameter = transitionParameter;
    }
    DRIImagePickerController *imagePickerVc = [[DRIImagePickerController alloc] initWithSelectedPhotos:self.selectedPhotos index:index transition:self.animatedTransition];
    imagePickerVc.showSelectBtn = YES;
    imagePickerVc.showSelectedIndex = NO;
    imagePickerVc.showTagBtn = NO;
    imagePickerVc.iconThemeColor = [UIColor ct_colorWithHex:0x3580F9];
    imagePickerVc.oKButtonTitleColorNormal = [UIColor ct_colorWithHex:0x3580F9];
    imagePickerVc.maxImagesCount = self.maxImagesCount;
    __weak typeof(self) weakSelf = self;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [weakSelf imagePickerController:nil didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:isSelectOriginalPhoto infos:nil];
    }];
    return imagePickerVc;
}

- (UIViewController *)previewVideoURL:(NSURL *)videoURL
                       coverImageView:(UIImageView *)imageView{
    
    self.animatedTransition = nil;
    if (imageView) {
        //封装参数对象
        DRIPictureBrowseTransitionParameter *transitionParameter = [[DRIPictureBrowseTransitionParameter alloc] init];
        transitionParameter.transitionImage = imageView.image;
        transitionParameter.firstVCImgFrames = [self firstImageViewFramesWithImageViews:@[imageView]];
        transitionParameter.transitionImgIndex = index;
        self.animatedTransition.transitionParameter = transitionParameter;
    }
    DRIVideoPlayerController *vc = [[DRIVideoPlayerController alloc] init];
    vc.animatedTransition = self.animatedTransition;
    DRIImagePickerController *imagePickerVc = [[DRIImagePickerController alloc] initWithRootViewController:vc];
    [imagePickerVc configDefaultSetting];
    imagePickerVc.transitioningDelegate = self.animatedTransition;
    DRIVideoModel *model = [[DRIVideoModel alloc] init];
    model.videoURL = videoURL;
    model.coverImage = imageView.image;
    vc.videoModel = model;
    return imagePickerVc;
}

- (UIViewController *)showImagePicker{
    DRIImagePickerController *imagePickerVc = [[DRIImagePickerController alloc] initWithMaxImagesCount:self.maxImagesCount columnNumber:self.columnNumber delegate:self pushPhotoPickerVc:YES isHiddenEdit:self.isHiddenEdit];
    [self imagePickerAddDefaultSetting:imagePickerVc];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    return imagePickerVc;
}

- (void)showImagePickerWithViewController:(UIViewController *)viewController{
    DRIImagePickerController *imagePickerVc = [[DRIImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:self.columnNumber delegate:self pushPhotoPickerVc:YES isHiddenEdit:self.isHiddenEdit];
    
    [self imagePickerAddDefaultSetting:imagePickerVc];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [viewController presentViewController:imagePickerVc animated:YES completion:^{}];
}

#pragma mark -
- (void)imagePickerController:(DRIImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    self.selectedAssets = [[NSMutableArray alloc] initWithArray:assets];
    self.selectedPhotos = [[NSMutableArray alloc] initWithArray:photos];
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(dri_imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:infos:)]) {
        [self.delegate dri_imagePickerController:self didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:isSelectOriginalPhoto infos:infos];
    }
}

- (void)imagePickerController:(DRIImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(PHAsset *)asset isSelect:(BOOL)isSelect{
    NSInteger index = [self.selectedAssets indexOfObject:asset];
//    if (<#condition#>) {
//        <#statements#>
//    }
}

- (void)imagePickerController:(DRIImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset{
    self.selectedAssets = [[NSMutableArray alloc] initWithObjects:asset, nil];
    self.selectedPhotos = [[NSMutableArray alloc] initWithObjects:coverImage, nil];
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(dri_imagePickerController:didFinishPickingVideo:sourceAssets:)]) {
        [self.delegate dri_imagePickerController:self didFinishPickingVideo:coverImage sourceAssets:asset];
    }
}

- (void)dri_imagePickerControllerDidCancel:(DRIImagePickerController *)picker{
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(dri_imagePickerControllerDidCancel:)]) {
        [self.delegate dri_imagePickerControllerDidCancel:self];
    }
}

//构造图片Frame数组
- (NSArray<NSValue *> *)firstImageViewFramesWithImageViews:(NSArray <UIImageView *>*)imageViews{
    
    NSMutableArray *imageFrames = [NSMutableArray new];
    
    [imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj) {
            //获取当前view在Window上的frame
            CGRect frame = [self getFrameInWindow:obj];
            [imageFrames addObject:[NSValue valueWithCGRect:frame]];
            
        }else{//当前不可见的cell,frame设为CGRectZero添加到数组中,防止数组越界
            CGRect frame = CGRectZero;
            [imageFrames addObject:[NSValue valueWithCGRect:frame]];
        }
    }];
    return imageFrames;
}

//构造图片Frame数组
+ (NSArray<NSValue *> *)firstImageViewFramesWithImageViews:(NSArray <UIImageView *>*)imageViews{
    
    NSMutableArray *imageFrames = [NSMutableArray new];
    
    [imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj) {
            //获取当前view在Window上的frame
            CGRect frame = [self getFrameInWindow:obj];
            [imageFrames addObject:[NSValue valueWithCGRect:frame]];
            
        }else{//当前不可见的cell,frame设为CGRectZero添加到数组中,防止数组越界
            CGRect frame = CGRectZero;
            [imageFrames addObject:[NSValue valueWithCGRect:frame]];
        }
    }];
    return imageFrames;
}


// 获取指定视图在window中的位置
- (CGRect)getFrameInWindow:(UIView *)view
{
    return [view.superview convertRect:view.frame toView:nil];
}

+ (CGRect)getFrameInWindow:(UIView *)view
{
    return [view.superview convertRect:view.frame toView:nil];
}

- (DRIPictureBrowseInteractiveAnimatedTransition *)animatedTransition
{
    if (!_animatedTransition) {
        _animatedTransition = [[DRIPictureBrowseInteractiveAnimatedTransition alloc] init];
    }
    return _animatedTransition;
}



- (DRIRecordViewController *)showRecordViewController{
    DRIRecordViewController *vc = [[DRIRecordViewController alloc]init];
    vc.delegate = self;
    vc.onlyTakePhoto = self.onlyTakePhoto;
    vc.onlyTakeVideo = self.onlyTakeVideo;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    return vc;
}


- (void)recordViewController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [DRPPop showLoadingHUDWithMessage:@""];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    __weak typeof(self) weakSelf = self;
    if ([type isEqualToString:@"public.image"]) {
        UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (photo) {
            [[DRIImageManager manager] savePhotoWithImage:photo location:nil completion:^(PHAsset *asset, NSError *error){
                if (asset && !error) {
                    if ([weakSelf.delegate respondsToSelector:@selector(dri_imagePickerController:didFinishTakePhoto:sourceAsset:info:)]) {
                        [weakSelf.delegate dri_imagePickerController:self didFinishTakePhoto:photo sourceAsset:asset info:info];
                    }
                    [DRPPop hideLoadingHUD];
                    [picker dismissViewControllerAnimated:YES completion:^{}];
                    return;
                }
                [DRPPop showErrorHUDWithMessage:@"保存图片失败，请重试" completion:nil];
            }];
        }
    } else if ([type isEqualToString:@"public.movie"]) {
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        if (videoUrl) {
            [[DRIImageManager manager] saveVideoWithUrl:videoUrl location:nil completion:^(PHAsset *asset, NSError *error) {
                if (!error) {
                    DRIImageRequestOperation *operation = [[DRIImageRequestOperation alloc] initWithAsset:asset completion:^(UIImage * _Nonnull photo, NSDictionary * _Nonnull info, BOOL isDegraded) {
                        if (isDegraded) return;
                        if (photo) {
                            if ([weakSelf.delegate respondsToSelector:@selector(dri_imagePickerController:didFinishTakeVideo:sourceAssets:)]) {
                                [weakSelf.delegate dri_imagePickerController:self didFinishTakeVideo:photo sourceAssets:asset];
                            }
                            [DRPPop hideLoadingHUD];
                            [picker dismissViewControllerAnimated:YES completion:^{}];
                            return;
                        }

                        [DRPPop showErrorHUDWithMessage:@"保存视频失败，请重试" completion:nil];
                    } progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
                        
                    }];
                    [self.operationQueue addOperation:operation];
                }
            }];
        }
    }
}
@end
