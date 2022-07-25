//
//  DRIImagePreviewController.m
//  DRIImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import "DRIImagePreviewController.h"
#import "DRIPhotoPreviewCell.h"
#import "DRIAssetModel.h"
#import "UIView+Layout.h"
#import "UIImage+DRISelect.h"
#import "SDAutoLayout.h"
#import "DRIImagePickerController.h"
#import "DRIImageManager.h"
#import "DRIImageCropManager.h"
#import <DNCommonKit/DNBaseMacro.h>
#import <DNCommonKit/UIColor+CTHex.h>
#import "DRIPictureBrowseInteractiveAnimatedTransition.h"
#import "DRPPop.h"
#import <DNCommonKit/UIButton+CTTitlePlace.h>
@interface DRIImagePreviewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,UIViewControllerTransitioningDelegate,UINavigationControllerDelegate> {
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_layout;
    NSArray *_photosTemp;
    NSArray *_assetsTemp;
    
    UIView   *_naviBar;
    UIButton *_backButton;
    UIButton *_selectButton;
    UILabel  *_navIndexLabel;
    UILabel  *_indexLabel;
    
    UIView *_toolBar;
    UIButton *_doneButton;
    UIImageView *_numberImageView;
    UILabel *_numberLabel;
    UILabel *_originalPhotoLabel;
    
    CGFloat _offsetItemCount;
    
    BOOL _didSetIsSelectOriginalPhoto;
}
@property (nonatomic, assign) BOOL isHideNaviBar;
@property (nonatomic, strong) UIView *cropBgView;
@property (nonatomic, strong) UIView *cropView;

@property (nonatomic, assign) double progress;
@property (strong, nonatomic) UIAlertController *alertView;

@property (strong, nonatomic) UIImageView *currentImageView;
@property (nonatomic, assign) CGPoint transitionImgViewCenter;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;
@end

@implementation DRIImagePreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [DRIImageManager manager].shouldFixOrientation = YES;
    DRIImagePickerController *_driImagePickVc = (DRIImagePickerController *)self.navigationController;
    [self configCollectionView];
    [self configCustomNaviBar];
    [self configBottomToolBar];
    self.view.clipsToBounds = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)setIsSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    _didSetIsSelectOriginalPhoto = YES;
}

- (void)setPhotos:(NSMutableArray *)photos {
    _photos = photos;
    [_photos enumerateObjectsUsingBlock:^(UIImage *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelected = YES;
    }];
    _photosTemp = [NSArray arrayWithArray:photos];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
    if (_currentIndex) {
        [_collectionView setContentOffset:CGPointMake((self.view.width + 20) * self.currentIndex, 0) animated:NO];
    }
    [self refreshNaviBarAndBottomBarState];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    if (driImagePickVc.needShowStatusBar) {
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    [DRIImageManager manager].shouldFixOrientation = NO;
    NSInteger index = [_collectionView indexPathsForVisibleItems].firstObject.item;
    self.animatedTransition.transitionParameter.transitionImgIndex = index;
    DRIPhotoPreviewCell *previewCell = [_collectionView visibleCells].firstObject;
    if ([previewCell isKindOfClass:[DRIPhotoPreviewCell class]]) {
        self.animatedTransition.transitionParameter.transitionImage = previewCell.previewView.imageView.image;
    }
}


- (void)configCustomNaviBar {
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    
    _naviBar = [[UIView alloc] initWithFrame:CGRectZero];
    _naviBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_backButton setImage:[UIImage dri_imageNamedFromMyBundle:@"navi_back"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _navIndexLabel = [[UILabel alloc] init];
    _navIndexLabel.font = [UIFont systemFontOfSize:19];
    _navIndexLabel.textColor = [UIColor ct_colorWithHex:0xc9c9c9];
    _navIndexLabel.textAlignment = NSTextAlignmentCenter;
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton setBackgroundImage:[UIImage dri_imageNamedFromMyBundle:@"Publish_imagePicker_right"] forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setTitle:driImagePickVc.doneBtnTitleStr forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [_naviBar addSubview:_doneButton];
    [_naviBar addSubview:_navIndexLabel];
    [_naviBar addSubview:_backButton];
    [self.view addSubview:_naviBar];
}

- (void)configBottomToolBar {
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    
    _toolBar = [[UIView alloc] initWithFrame:CGRectZero];
    _toolBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    _selectButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_selectButton setImage:driImagePickVc.photoDefImage forState:UIControlStateNormal];
    [_selectButton setImage:driImagePickVc.photoSelPreviewImage forState:UIControlStateSelected];
    _selectButton.imageView.clipsToBounds = YES;
//    _selectButton.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    _selectButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_selectButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    _selectButton.hidden = !driImagePickVc.showSelectBtn;
    
    
    _indexLabel = [[UILabel alloc] init];
    _indexLabel.font = [UIFont systemFontOfSize:14];
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.textAlignment = NSTextAlignmentCenter;
//
//        _originalPhotoLabel = [[UILabel alloc] init];
//        _originalPhotoLabel.textAlignment = NSTextAlignmentLeft;
//        _originalPhotoLabel.font = [UIFont systemFontOfSize:13];
//        _originalPhotoLabel.textColor = [UIColor whiteColor];
//        _originalPhotoLabel.backgroundColor = [UIColor clearColor];
//        if (_isSelectOriginalPhoto) [self showPhotoBytes];
//    }
    
    
    //    _numberImageView = [[UIImageView alloc] initWithImage:_driImagePickVc.photoNumberIconImage];
    //    _numberImageView.backgroundColor = [UIColor clearColor];
    //    _numberImageView.clipsToBounds = YES;
    //    _numberImageView.contentMode = UIViewContentModeScaleAspectFit;
    //    _numberImageView.hidden = self.photos .count <= 0;
    
    //    _numberLabel = [[UILabel alloc] init];
    //    _numberLabel.font = [UIFont systemFontOfSize:15];
    //    _numberLabel.textColor = [UIColor whiteColor];
    //    _numberLabel.textAlignment = NSTextAlignmentCenter;
    //    _numberLabel.text = [NSString stringWithFormat:@"%zd",self.photos .count];
    //    _numberLabel.hidden = self.photos .count <= 0;
    //    _numberLabel.backgroundColor = [UIColor clearColor];
//    [_toolBar addSubview:_numberImageView];
//    [_toolBar addSubview:_numberLabel];
    [_toolBar addSubview:_selectButton];
    [_selectButton addSubview:_indexLabel];
    [self.view addSubview:_toolBar];
    
    if (driImagePickVc.photoPreviewPageUIConfigBlock) {
        driImagePickVc.photoPreviewPageUIConfigBlock(_collectionView, _naviBar, _backButton, _selectButton, _indexLabel, _toolBar, nil, _originalPhotoLabel, _doneButton, _numberImageView, _numberLabel);
    }
}

- (void)configCollectionView {
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(self.photos.count * (self.view.width + 20), 0);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[DRIPhotoPreviewCell class] forCellWithReuseIdentifier:@"DRIPhotoPreviewCell"];
    [_collectionView registerClass:[DRIVideoPreviewCell class] forCellWithReuseIdentifier:@"DRIVideoPreviewCell"];
    [_collectionView registerClass:[DRIGifPreviewCell class] forCellWithReuseIdentifier:@"DRIGifPreviewCell"];
    
//    if (self.navigationController.childViewControllers.count == 1) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(interactiveTransitionRecognizerAction:)];
        pan.delegate = self;
        [self.view addGestureRecognizer:pan];
//    }
}

- (void)configCropView {
    DRIImagePickerController *_driImagePickVc = (DRIImagePickerController *)self.navigationController;
    if (_driImagePickVc.maxImagesCount <= 1 && _driImagePickVc.allowCrop && _driImagePickVc.allowPickingImage) {
        [_cropView removeFromSuperview];
        [_cropBgView removeFromSuperview];
        
        _cropBgView = [UIView new];
        _cropBgView.userInteractionEnabled = NO;
        _cropBgView.frame = self.view.bounds;
        _cropBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_cropBgView];
        [DRIImageCropManager overlayClippingWithView:_cropBgView cropRect:_driImagePickVc.cropRect containerView:self.view needCircleCrop:_driImagePickVc.needCircleCrop];
        
        _cropView = [UIView new];
        _cropView.userInteractionEnabled = NO;
        _cropView.frame = _driImagePickVc.cropRect;
        _cropView.backgroundColor = [UIColor clearColor];
        _cropView.layer.borderColor = [UIColor whiteColor].CGColor;
        _cropView.layer.borderWidth = 1.0;
        if (_driImagePickVc.needCircleCrop) {
            _cropView.layer.cornerRadius = _driImagePickVc.cropRect.size.width / 2;
            _cropView.clipsToBounds = YES;
        }
        [self.view addSubview:_cropView];
        if (_driImagePickVc.cropViewSettingBlock) {
            _driImagePickVc.cropViewSettingBlock(_cropView);
        }
        
        [self.view bringSubviewToFront:_naviBar];
        [self.view bringSubviewToFront:_toolBar];
    }
}

#pragma mark - Layout

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    DRIImagePickerController *_driImagePickVc = (DRIImagePickerController *)self.navigationController;
    
    CGFloat statusBarHeight = [DRICommonTools dri_statusBarHeight];
    CGFloat statusBarHeightInterval = statusBarHeight - 20;
    CGFloat naviBarHeight = statusBarHeight + _driImagePickVc.navigationBar.height;
    _naviBar.frame = CGRectMake(0, 0, self.view.width, naviBarHeight);
    _backButton.frame = CGRectMake(10, 10 + statusBarHeightInterval, 44, 44);
    [_backButton ct_setEnlargeEdge:24.f];
    [_navIndexLabel sizeToFit];
    _navIndexLabel.centerY = _backButton.centerY;
    _navIndexLabel.centerX = _naviBar.centerX;
    [_doneButton sizeToFit];
//    _doneButton.frame = CGRectMake(self.view.width - 56, 10 + statusBarHeightInterval, 44, 44);
    _doneButton.frame = CGRectMake(self.view.width - _doneButton.width - 12,_naviBar.height - 10.5 - _doneButton.height, _doneButton.width, _doneButton.height);
    _doneButton.centerY = _navIndexLabel.centerY;
    
    _layout.itemSize = CGSizeMake(self.view.width + 20, self.view.height);
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 0;
    _collectionView.frame = CGRectMake(-10, 0, self.view.width + 20, self.view.height);
    [_collectionView setCollectionViewLayout:_layout];
    if (_offsetItemCount > 0) {
        CGFloat offsetX = _offsetItemCount * _layout.itemSize.width;
        [_collectionView setContentOffset:CGPointMake(offsetX, 0)];
    }
    if (_driImagePickVc.allowCrop) {
        [_collectionView reloadData];
    }
    
    CGFloat toolBarHeight = [DRICommonTools dri_isIPhoneX] ? 44 + (83 - 49) : 44;
    CGFloat toolBarTop = self.view.height - toolBarHeight;
    _toolBar.frame = CGRectMake(0, toolBarTop, self.view.width, toolBarHeight);
//    if (_driImagePickVc.allowPickingOriginalPhoto) {
//        CGFloat fullImageWidth = [_driImagePickVc.fullImageBtnTitleStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width;
//        _originalPhotoLabel.frame = CGRectMake(fullImageWidth + 42, 0, 80, 44);
//    }
    _numberImageView.frame = CGRectMake(_doneButton.left - 24 - 5, 10, 24, 24);
    _numberLabel.frame = _numberImageView.frame;
    
    _selectButton.frame = CGRectMake(self.view.width - _doneButton.width - 12, 0, _doneButton.width, 44);
    _indexLabel.frame = _selectButton.bounds;
    
    [self configCropView];
    
    if (_driImagePickVc.photoPreviewPageDidLayoutSubviewsBlock) {
        _driImagePickVc.photoPreviewPageDidLayoutSubviewsBlock(_collectionView, _naviBar, _backButton, _selectButton, _indexLabel, _toolBar, nil, _originalPhotoLabel, _doneButton, _numberImageView, _numberLabel);
    }
}

#pragma mark - Notification

- (void)didChangeStatusBarOrientationNotification:(NSNotification *)noti {
    _offsetItemCount = _collectionView.contentOffset.x / _layout.itemSize.width;
}

#pragma mark - Click Event

- (void)select:(UIButton *)selectButton {
    DRIImagePickerController *_driImagePickVc = (DRIImagePickerController *)self.navigationController;
    UIImage *model = _photos[self.currentIndex];
    model.isSelected = !model.isSelected;
    [self refreshNaviBarAndBottomBarState];
    if (model.isSelected) {
        [UIView showOscillatoryAnimationWithLayer:selectButton.imageView.layer type:RHCOscillatoryAnimationToBigger];
    }
    [UIView showOscillatoryAnimationWithLayer:_numberImageView.layer type:RHCOscillatoryAnimationToSmaller];
}

- (void)backButtonClick {
    if (self.navigationController.childViewControllers.count < 2) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        if ([self.navigationController isKindOfClass: [DRIImagePickerController class]]) {
            DRIImagePickerController *nav = (DRIImagePickerController *)self.navigationController;
            if (nav.imagePickerControllerDidCancelHandle) {
                nav.imagePickerControllerDidCancelHandle();
            }
        }
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    if (self.backButtonClickBlock) {
        self.backButtonClickBlock(_isSelectOriginalPhoto);
    }
}

- (void)doneButtonClick {
    DRIImagePickerController *_driImagePickVc = (DRIImagePickerController *)self.navigationController;
    
    // 如果没有选中过照片 点击确定时选中当前预览的照片
//    if (self.photos .count == 0 && _driImagePickVc.minImagesCount <= 0) {
//        UIImage *model = _photos[self.currentIndex];
//        [_driImagePickVc addSelectedModel:model];
//    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    DRIPhotoPreviewCell *cell = (DRIPhotoPreviewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    __block NSMutableArray *returnImages = [NSMutableArray array];
    [self.photos enumerateObjectsUsingBlock:^(UIImage *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImage class]]) {
            if (obj.isSelected) {
                [returnImages addObject:obj];
            }
        }
    }];
    
    if (self.doneButtonClickBlock) {
        self.doneButtonClickBlock(_isSelectOriginalPhoto);
    }
    if (self.doneButtonClickBlockWithPreviewType) {
        self.doneButtonClickBlockWithPreviewType(returnImages,_driImagePickVc.selectedAssets,self.isSelectOriginalPhoto);
    }
}

- (void)didTapPreviewCell {
//    self.isHideNaviBar = !self.isHideNaviBar;
//    _naviBar.hidden = self.isHideNaviBar;
//    _toolBar.hidden = self.isHideNaviBar;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetWidth = scrollView.contentOffset.x;
    offSetWidth = offSetWidth +  ((self.view.width + 20) * 0.5);
    
    NSInteger currentIndex = offSetWidth / (self.view.width + 20);
    if (currentIndex < _photos.count && _currentIndex != currentIndex) {
        _currentIndex = currentIndex;
        [self refreshNaviBarAndBottomBarState];
    }
    NSLog(@"scrollViewDidScroll");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"photoPreviewCollectionViewDidScroll" object:nil];
}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didEndDisplayingCell");
    if ([cell isKindOfClass:[DRIPhotoPreviewCell class]]) {
        UIImage *model = _photos[indexPath.item];
        
        [(DRIPhotoPreviewCell *)cell recoverSubviews];

    } else if ([cell isKindOfClass:[DRIVideoPreviewCell class]]) {
        DRIVideoPreviewCell *videoCell = (DRIVideoPreviewCell *)cell;
        self.animatedTransition.transitionParameter.transitionImage = videoCell.cover;
        if (videoCell.player && videoCell.player.rate != 0.0) {
            [videoCell pausePlayerAndShowNaviBar];
        }
    }
    
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DRIImagePickerController *_driImagePickVc = (DRIImagePickerController *)self.navigationController;
    UIImage *model = _photos[indexPath.item];
    __weak typeof(self) weakSelf = self;
    
    DRIPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DRIPhotoPreviewCell" forIndexPath:indexPath];
    cell.image = model;
    [cell setSingleTapGestureBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf didTapPreviewCell];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[DRIPhotoPreviewCell class]]) {
//        [(DRIPhotoPreviewCell *)cell recoverSubviews];
    }
}


#pragma mark - Private Method

- (void)dealloc {
    // NSLog(@"%@ dealloc",NSStringFromClass(self.class));
}

- (void)refreshNaviBarAndBottomBarState {
    DRIImagePickerController *_driImagePickVc = (DRIImagePickerController *)self.navigationController;
    UIImage *model = _photos[self.currentIndex];
    _selectButton.selected = model.isSelected;
    [self refreshSelectButtonImageViewContentMode];
//    if (_selectButton.isSelected && _driImagePickVc.showSelectedIndex && _driImagePickVc.showSelectBtn) {
//        NSString *index = [NSString stringWithFormat:@"%d", (int)([_driImagePickVc.selectedAssetIds indexOfObject:model.asset.localIdentifier] + 1)];
//        _indexLabel.text = index;
//        _indexLabel.hidden = NO;
//    } else {
//    }
    _navIndexLabel.text = [NSString stringWithFormat:@"%zd/%zd",_currentIndex+1,_photosTemp.count];
    [_navIndexLabel sizeToFit];
    
    _navIndexLabel.centerY = _backButton.centerY;
    _navIndexLabel.centerX = _naviBar.centerX;
    
    _indexLabel.hidden = YES;
    _numberLabel.text = [NSString stringWithFormat:@"%zd",self.photos .count];
    
    //_isHideNaviBar
    _numberImageView.hidden = (self.photos .count <= 0 || _isCropImage);
    _numberLabel.hidden = (self.photos .count <= 0 || _isCropImage);
    _originalPhotoLabel.hidden = YES;
    if (_isSelectOriginalPhoto) [self showPhotoBytes];
    
    // If is previewing video, hide original photo button
    // 如果正在预览的是视频，隐藏原图按钮
    _originalPhotoLabel.hidden = YES;
    
    _doneButton.hidden = NO;
    _selectButton.hidden = !_driImagePickVc.showSelectBtn;
    // 让宽度/高度小于 最小可选照片尺寸 的图片不能选中
//    if (![[DRIImageManager manager] isPhotoSelectableWithAsset:model.asset]) {
//        _numberLabel.hidden = YES;
//        _numberImageView.hidden = YES;
//        _selectButton.hidden = YES;
//        _originalPhotoLabel.hidden = YES;
//        _doneButton.hidden = YES;
//    }
}

- (void)refreshSelectButtonImageViewContentMode {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self->_selectButton.imageView.image.size.width <= 27) {
            self->_selectButton.imageView.contentMode = UIViewContentModeCenter;
        } else {
            self->_selectButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
    });
}

- (void)showPhotoBytes {
    [[DRIImageManager manager] getPhotosBytesWithArray:@[_photos[self.currentIndex]] completion:^(NSString *totalBytes) {
        self->_originalPhotoLabel.text = [NSString stringWithFormat:@"(%@)",totalBytes];
    }];
}

- (NSInteger)currentIndex {
    return [DRICommonTools dri_isRightToLeftLayout] ? self.photos.count - _currentIndex - 1 : _currentIndex;
}



//- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
//
//    CGPoint  translation = [panGesture translationInView:_collectionView];
//    CGFloat percentComplete = 0.0;
//
//    _collectionView.center = CGPointMake(_collectionView.center.x + translation.x,
//                                        _collectionView.center.y + translation.y);
//    [panGesture setTranslation:CGPointZero inView:_collectionView];
//
//    percentComplete = (_collectionView.center.y - self.view.frame.size.height/ 2) / (self.view.frame.size.height/2);
//    percentComplete = fabs(percentComplete);
//    NSLog(@"%f",percentComplete);
//
//    switch (panGesture.state) {
//        case UIGestureRecognizerStateBegan:
//            break;
//        case UIGestureRecognizerStateChanged:
//            self.view.alpha = 1 - percentComplete;
//            break;
//        case UIGestureRecognizerStateEnded:{
//
//            if (percentComplete > 0.5) {
//                [self dismissViewControllerAnimated:YES completion:nil];
//
//            }else{
//                _collectionView.center = CGPointMake(self.view.center.x,
//                                                    self.view.center.y);
//                self.view.alpha = 1;
//            }
//            break;
//        }
//        default:
//            break;
//    }
//
//}

#pragma mark - Event
- (void)interactiveTransitionRecognizerAction:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    
    CGFloat scale = (translation.y / SCREENHEIGHT);
    scale = scale < 0 ? 0 : scale;
    scale = scale > 1 ? 1 : scale;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:{
            
            NSInteger index = [_collectionView indexPathsForVisibleItems].firstObject.item;
            self.animatedTransition.transitionParameter.transitionImgIndex = index;
            DRIPhotoPreviewCell *previewCell = [_collectionView visibleCells].firstObject;
            if ([previewCell isKindOfClass:[DRIPhotoPreviewCell class]]) {
                self.currentImageView.image = previewCell.previewView.imageView.image;
                [self.currentImageView sizeToFit];
            }
            
            self.animatedTransition.transitionParameter.transitionImage = previewCell.previewView.imageView.image;
            self.animatedTransition.transitionParameter.transitionImgIndex = index;
            
            self.currentImageView.frame = CGRectMake(previewCell.previewView.imageView.superview.frame.origin.x / previewCell.previewView.scrollView.zoomScale, (previewCell.previewView.imageView.superview.frame.origin.y - DNNavHeight) /previewCell.previewView.scrollView.zoomScale, previewCell.previewView.imageView.superview.width /previewCell.previewView.scrollView.zoomScale, previewCell.previewView.imageView.superview.height /previewCell.previewView.scrollView.zoomScale) ;
            self.currentImageView.hidden = YES;
            self.transitionImgViewCenter = self.view.center;
            _collectionView.hidden = YES;
            _toolBar.hidden = YES;
            _naviBar.hidden = YES;
            _currentImageView.center = CGPointMake(self.transitionImgViewCenter.x + translation.x * scale, self.transitionImgViewCenter.y + translation.y);
            self.currentImageView.hidden = NO;
            
            self.animatedTransition.transitionParameter.gestureRecognizer = gestureRecognizer;
            if (self.navigationController.childViewControllers.count == 1) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
            break;
        case UIGestureRecognizerStateChanged: {
            
            _currentImageView.center = CGPointMake(self.transitionImgViewCenter.x + translation.x * scale, self.transitionImgViewCenter.y + translation.y);
//            _currentImageView.transform = CGAffineTransformMakeScale(scale, scale);
            
            break;
        }
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            
            if (scale > 0.9f) {
                [UIView animateWithDuration:0.2 animations:^{
                    _currentImageView.center = self.transitionImgViewCenter;
                    _currentImageView.transform = CGAffineTransformMakeScale(1, 1);
                    
                } completion:^(BOOL finished) {
                    _currentImageView.transform = CGAffineTransformIdentity;
                }];
                NSLog(@"secondevc取消");
            }else{
            }
            _collectionView.hidden = NO;
            _toolBar.hidden = NO;
            _naviBar.hidden = NO;
            _currentImageView.hidden = YES;
            self.animatedTransition.transitionParameter.transitionImage = _currentImageView.image;
            self.animatedTransition.transitionParameter.currentPanGestImgFrame = _currentImageView.frame;
            
            self.animatedTransition.transitionParameter.gestureRecognizer = nil;
            
            [_currentImageView removeFromSuperview];
            _currentImageView = nil;
            [self.navigationController setNavigationBarHidden:YES animated:NO];
        }
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer.view == self.view &&
        [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")]) {
        UIScrollView *scrollView = otherGestureRecognizer.view;
        UIPanGestureRecognizer *panScroll = otherGestureRecognizer;
        CGPoint point = [panScroll translationInView:scrollView];
        DRIPhotoPreviewView *preview = scrollView.superview;
        if ([preview isKindOfClass:[DRIPhotoPreviewView class]]) {
            UIImageView *imageView = preview.imageView;
            UIImage *image = imageView.image;
            if ((preview.scrollView.contentSize.height / preview.scrollView.zoomScale) < SCREENHEIGHT) {
                return NO;
            }
            if (fabs(point.x) > fabs(point.y)) {
                return NO;
            }
            //            if (preview.isScrolling) return NO;
            NSLog(@"%@",NSStringFromCGPoint(point));
            if (scrollView.contentOffset.y <= 1 &&
                (point.y >= 0)) {
                return YES;
            }
            if ((imageView &&
                 scrollView.contentOffset.y >= imageView.height *  scrollView.zoomScale - scrollView.height - 1) &&
                (point.y <= 0)) {
                return YES;
            }
        }
    }
    return NO;
}


- (UIImageView *)currentImageView{
    if (!_currentImageView) {
        _currentImageView = [[UIImageView alloc] init];
        [self.view addSubview:_currentImageView];
    }
    return _currentImageView;
}
@end
