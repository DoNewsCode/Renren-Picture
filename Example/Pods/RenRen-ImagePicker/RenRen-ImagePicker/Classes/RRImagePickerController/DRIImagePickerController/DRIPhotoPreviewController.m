//
//  DRIPhotoPreviewController.m
//  DRIImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import "DRIPhotoPreviewController.h"
#import "DRIPhotoPreviewCell.h"
#import "DRIAssetModel.h"
#import "UIView+Layout.h"
#import "SDAutoLayout.h"
#import "DRIImagePickerController.h"
#import "DRIImageManager.h"
#import "DRIImageCropManager.h"
#import "DRIImagePreviewTagsViewController.h"
#import "PHAsset+Tags.h"
#import <DNCommonKit/DNBaseMacro.h>
#import <DNCommonKit/UIColor+CTHex.h>
#import "DRIPictureBrowseInteractiveAnimatedTransition.h"
#import "DRPPop.h"
#import <DNCommonKit/UIButton+CTTitlePlace.h>
#import "UIImage+YYAdd.h"
#import "DRIPhototPreviewToolsView.h"
#import "DNRouter.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface DRIPhotoPreviewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,UIViewControllerTransitioningDelegate,UINavigationControllerDelegate> {
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_layout;
    NSArray *_photosTemp;
    NSArray *_assetsTemp;
    
    UIView   *_naviBar;
    UIButton *_backButton;
    UIButton *_selectButton;
    UILabel  *_navIndexLabel;
    UIButton *_tagButton;
    UILabel  *_indexLabel;
    
    UIView *_toolBar;

    UIImageView *_numberImageView;
    UILabel *_numberLabel;
    UIButton *_tagPhotoButton;
    UILabel *_originalPhotoLabel;
    
    CGFloat _offsetItemCount;
    
    BOOL _didSetIsSelectOriginalPhoto;
}
@property (nonatomic, assign) BOOL isHideNaviBar;
@property (nonatomic, strong) UIView *cropBgView;
@property (nonatomic, strong) UIView *cropView;
@property (nonatomic, assign) BOOL isInAlbum;
@property (nonatomic, assign) double progress;
@property (strong, nonatomic) UIAlertController *alertView;
@property (nonatomic, strong) UIButton *doneButton;;
@property (strong, nonatomic) UIImageView *currentImageView;
@property (nonatomic, assign) CGPoint transitionImgViewCenter;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UIButton *editButton; //preview_bianji
@property (nonatomic, strong) UIButton *originalButton; //preview_bianji
@property(nonatomic,strong)UILabel * originalLabel;
@property(nonatomic,strong)DRIPhototPreviewToolsView *toolsView;
@end

@implementation DRIPhotoPreviewController

- (void)viewDidLoad {
    
    self.fd_prefersNavigationBarHidden = YES;
    
    [super viewDidLoad];
    [DRIImageManager manager].shouldFixOrientation = YES;
    DRIImagePickerController *_driImagePickVc = (DRIImagePickerController *)self.navigationController;
    if (!_didSetIsSelectOriginalPhoto) {
        _isSelectOriginalPhoto = _driImagePickVc.isSelectOriginalPhoto;
    }
    if (!self.models.count) {
        self.models = [NSMutableArray arrayWithArray:_driImagePickVc.selectedModels];
        _assetsTemp = [NSMutableArray arrayWithArray:_driImagePickVc.selectedAssets];
        self.isInAlbum = YES;
    }
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
    _photosTemp = [NSArray arrayWithArray:photos];
}
-(UIButton*)originalButton{
    if (!_originalButton) {
        _originalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_originalButton setBackgroundImage:[UIImage dri_imageNamedFromMyBundle:@"photo_original_def"] forState:UIControlStateNormal];
        [_originalButton setBackgroundImage:[UIImage dri_imageNamedFromMyBundle:@"photo_original_sel"] forState:UIControlStateSelected];
        _originalButton.size = CGSizeMake(21, 21);
        [_originalButton addTarget:self action:@selector(originalPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_originalButton ct_setEnlargeEdge:10];
    }
    return _originalButton;
}
-(UILabel*)originalLabel{
    if (!_originalLabel) {
        _originalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 16)];
        _originalLabel.textColor = [UIColor whiteColor];
        _originalLabel.textAlignment = NSTextAlignmentLeft;
        _originalLabel.font = [UIFont systemFontOfSize:14];
        _originalLabel.text = @"原图";
    }
    return _originalLabel;
}
- (void)originalPhotoButtonClick {
    self.originalButton.selected = !self.originalButton.selected;
    _isSelectOriginalPhoto = self.originalButton.selected;
    if (_isSelectOriginalPhoto) {
        [self showPhotoBytes];
    }else{
        self.originalLabel.text = @"原图";
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
    if (_currentIndex) {
        [_collectionView setContentOffset:CGPointMake((self.view.width + 20) * self.currentIndex, 0) animated:NO];
    }
    [self refreshNaviBarAndBottomBarState];
    
    if (self.animatedTransition) {
        self.navigationController.delegate = self.animatedTransition;
    }

    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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

    if (self.isInAlbum) {
        
    }
        _selectButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_selectButton setBackgroundImage:driImagePickVc.photoDefImage forState:UIControlStateNormal];
        UIImage *image = [UIImage imageWithColor:[UIColor ct_colorWithHex:0x2A73EB] size:CGSizeMake(24, 24)];
        [_selectButton setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [_selectButton setTintColor:UIColor.whiteColor];
        [_selectButton setBackgroundImage:image forState:UIControlStateSelected];
        _selectButton.imageView.clipsToBounds = YES;
        _selectButton.layer.cornerRadius = 12;
        _selectButton.clipsToBounds = YES;
    //    _selectButton.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
        _selectButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_selectButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
        _selectButton.hidden = !driImagePickVc.showSelectBtn;
         [_naviBar addSubview:_selectButton];
    
    
 //   [_naviBar addSubview:_doneButton];
 //   [_naviBar addSubview:_navIndexLabel];
    [_naviBar addSubview:_backButton];
    [self.view addSubview:_naviBar];
}
-(UIButton*)editButton{
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_editButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        _editButton.size = CGSizeMake(40 , 15);
        [_editButton addTarget:self action:@selector(editPhoto) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}
-(UIButton*)doneButton{
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_doneButton setBackgroundColor:[UIColor ct_colorWithHex:0x2A73EB]];
        [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _doneButton.size = CGSizeMake(64, 30);
        _doneButton.layer.cornerRadius = 15;
    }
    return _doneButton;
}
-(DRIPhototPreviewToolsView*)toolsView{
    if (!_toolsView) {
        _toolsView = [[DRIPhototPreviewToolsView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 62 + 26)]; //62是小视图的高度
    }
    return _toolsView;
}

#pragma mark = 编辑图片

-(void)editPhoto{
    
    
    self.navigationController.delegate = nil;
    
    DRIAssetModel *model = _models[self.currentIndex];
    
    NSMutableArray *tagArr = model.asset.tagsArray;
    
    if (tagArr.count == 0) {
        tagArr = [NSMutableArray array];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    DRIPhotoPreviewCell *cell = (DRIPhotoPreviewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    
    DRIImagePickerController *_driImagePickVc = (DRIImagePickerController *)self.navigationController;

    
    @weakify(self);
        [[DRIImageManager manager]getOriginalPhotoWithAsset:model.asset completion:^(UIImage *photo, NSDictionary *info) {
            @strongify(self);
            if ([[info objectForKey:@"PHImageResultIsDegradedKey"] boolValue] == YES) {
                return ;
            }
                        [DNRouter openURL:@"RR://MaterialEditor/PhotoEdit" withUserInfo:@{@"navigationVC" : self.navigationController,@"originImage" : photo,@"tagsDict":tagArr,@"isFromChat":@(_driImagePickVc.isHidenTagAction)} completion:^(id  _Nullable result) {
                
                            UIImage *resultImage = result[@"editImage"];
                            NSArray *tagsArr = result[@"tagsArray"];
                
                         if (result && [result isKindOfClass:[NSDictionary class]]) {
                             
                             
                             [[DRIImageManager manager]savePhotoWithImage:resultImage completion:^(PHAsset *asset, NSError *error) {
                                 if (error) {
                                     return ;
                                 }
                                 model.asset = asset;
                                 
                                 if ([tagsArr isKindOfClass:[NSArray class]]) {
                                     asset.tagsArray = [tagsArr mutableCopy];
                                 }else {
                                     asset.tagsArray = [NSMutableArray array];
                                 }
                                 
                                 if (cell) {
                                     [cell.previewView recoverSubviews];
                                 }

                                 
                            if (self.currentIndex >= _driImagePickVc.selectedAssetIds.count) {
                           //[_driImagePickVc.selectedAssetIds addObject:asset.localIdentifier];
                                                   }else{
                            [_driImagePickVc.selectedAssetIds replaceObjectAtIndex:self.currentIndex withObject:asset.localIdentifier];
                                    }

                                 if ([_driImagePickVc.selectedModels containsObject:model]) {
                                     
                                     NSInteger index = [_driImagePickVc.selectedModels indexOfObject:model];
                                     
                                     [_driImagePickVc.selectedAssetIds replaceObjectAtIndex:index withObject:asset.localIdentifier];
                                 }
                                 
                                 
                                 [self->_collectionView reloadData];
                                 if (!model.isSelected) {
                                    [self select:self->_selectButton];
                                 }else{
                                     [self refreshNaviBarAndBottomBarState];
                                 }
                    
                                 [[NSNotificationCenter defaultCenter]postNotificationName:@"NeedReloadPhotoPiclView" object:nil];
                                 if (self.photos.count) {
                                     @try {
                                    [self.photos replaceObjectAtIndex:self.currentIndex withObject:resultImage];
                                    [_driImagePickVc.selectedAssets replaceObjectAtIndex:self.currentIndex withObject:asset];
                                     } @catch (NSException *exception) {
                                         
                                     } @finally {
                                         
                                     }
                                 }
                             }];
                         }
                     }];
        }];


}
//绘制渐变色颜色的方法
- (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr{

//    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;

    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)[UIColor ct_colorWithHexString:fromHexColorStr].CGColor,(__bridge id)[UIColor ct_colorWithHexString:toHexColorStr].CGColor];

    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(1, 1);
    gradientLayer.endPoint = CGPointMake(0, 0);

    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];

    return gradientLayer;
}

- (void)configBottomToolBar {
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    
    _toolBar = [[UIView alloc] initWithFrame:CGRectZero];
    _toolBar.size = CGSizeMake(SCREEN_WIDTH, [DRICommonTools dri_isIPhoneX] ? 88 :68);
    _toolBar.backgroundColor = [UIColor colorWithRed:32 / 255.0 green:32 / 255.0 blue:32/ 255.0 alpha:0.69];

     UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView =[[UIVisualEffectView alloc]initWithEffect:blurEffect];
        effectView.alpha = 0.9;
        effectView.frame = _toolBar.bounds;
        [_toolBar addSubview:effectView];
    
    _indexLabel = [[UILabel alloc] init];
    _indexLabel.font = [UIFont systemFontOfSize:14];
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    
    if (driImagePickVc.showTagBtn) {
        _tagPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _tagPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, [DRICommonTools dri_isRightToLeftLayout] ? 10 : -10, 0, 0);
        _tagPhotoButton.backgroundColor = [UIColor clearColor];
        [_tagPhotoButton addTarget:self action:@selector(tagPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _tagPhotoButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_tagPhotoButton setTitle:@"标签" forState:UIControlStateNormal];
        [_tagPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_tagPhotoButton setImage:[UIImage dri_imageNamedFromMyBundle:@"Publish_tag_button_icon"] forState:UIControlStateNormal];
    }

        _originalPhotoLabel = [[UILabel alloc] init];
        _originalPhotoLabel.textAlignment = NSTextAlignmentLeft;
        _originalPhotoLabel.font = [UIFont systemFontOfSize:13];
        _originalPhotoLabel.textColor = [UIColor whiteColor];
        _originalPhotoLabel.backgroundColor = [UIColor clearColor];
    if (driImagePickVc.allowPickingOriginalPhoto) {
        [_toolBar addSubview:self.originalLabel];
        [_toolBar addSubview:self.originalButton];
    }
    if (_isSelectOriginalPhoto){
        self.originalButton.selected = YES;
       [self showPhotoBytes];
    }
//    }
    
    
    //    _numberImageView = [[UIImageView alloc] initWithImage:_driImagePickVc.photoNumberIconImage];
    //    _numberImageView.backgroundColor = [UIColor clearColor];
    //    _numberImageView.clipsToBounds = YES;
    //    _numberImageView.contentMode = UIViewContentModeScaleAspectFit;
    //    _numberImageView.hidden = _driImagePickVc.selectedModels.count <= 0;
    
    //    _numberLabel = [[UILabel alloc] init];
    //    _numberLabel.font = [UIFont systemFontOfSize:15];
    //    _numberLabel.textColor = [UIColor whiteColor];
    //    _numberLabel.textAlignment = NSTextAlignmentCenter;
    //    _numberLabel.text = [NSString stringWithFormat:@"%zd",_driImagePickVc.selectedModels.count];
    //    _numberLabel.hidden = _driImagePickVc.selectedModels.count <= 0;
    //    _numberLabel.backgroundColor = [UIColor clearColor];


//    [_toolBar addSubview:_numberImageView];
//    [_toolBar addSubview:_numberLabel];
 //   [_toolBar addSubview:_tagPhotoButton];
    [_toolBar addSubview:self.editButton];
   // [_selectButton addSubview:_indexLabel];
    [_toolBar addSubview:self.doneButton];
    [self.view addSubview:_toolBar];
    [self.view addSubview:self.toolsView];
    [self.toolsView didTapItemAtIndex:^(NSInteger tapItemIndex, DRIAssetModel * _Nonnull tapModel) {
  
       NSInteger newIndex = [_models indexOfObject:tapModel];
        if (newIndex > 5000 ) {
                int flag = 0;
              for (DRIAssetModel *model in _models) {
                  if ([model.asset.localIdentifier isEqualToString:tapModel.asset.localIdentifier]) {
                      newIndex = flag;
                      break;
                  }
                  flag++;
              }
        }
        CGFloat offsetX = newIndex * _layout.itemSize.width;
         [_collectionView setContentOffset:CGPointMake(offsetX, 0)];
    }];
    if (driImagePickVc.photoPreviewPageUIConfigBlock) {
        driImagePickVc.photoPreviewPageUIConfigBlock(_collectionView, _naviBar, _backButton, _selectButton, _indexLabel, _toolBar, _tagPhotoButton, _originalPhotoLabel, _doneButton, _numberImageView, _numberLabel);
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
    _collectionView.contentSize = CGSizeMake(self.models.count * (self.view.width + 20), 0);
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
 //   [_doneButton sizeToFit];
//    _doneButton.frame = CGRectMake(self.view.width - 56, 10 + statusBarHeightInterval, 44, 44);
    _doneButton.frame = CGRectMake(self.view.width - _doneButton.width - 15,20, _doneButton.width, _doneButton.height);
    _editButton.frame = CGRectMake(15, 30, _editButton.width, _editButton.height);
    _editButton.centerY = _doneButton.centerY;
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
    
    CGFloat toolBarHeight = [DRICommonTools dri_isIPhoneX] ? 88 : 68;
    CGFloat toolBarTop = self.view.height - toolBarHeight;
    _toolBar.frame = CGRectMake(0, toolBarTop, self.view.width, toolBarHeight);
    self.toolsView.frame  = CGRectMake(0, CGRectGetMinY(_toolBar.frame) - self.toolsView.height, self.toolsView.width, self.toolsView.height);
//    if (_driImagePickVc.allowPickingOriginalPhoto) {
//        CGFloat fullImageWidth = [_driImagePickVc.fullImageBtnTitleStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width;
     self.originalButton.frame = CGRectMake(0, 0, self.originalButton.width,self.originalButton.height);
     self.originalButton.center = CGPointMake(self.view.width / 2.f - 21, self.doneButton.centerY);
     self.originalLabel.frame = CGRectMake(CGRectGetMaxX(self.originalButton.frame)+4, 0, self.originalLabel.width, self.originalLabel.height);
     self.originalLabel.centerY = self.originalButton.centerY;
//    }
    _numberImageView.frame = CGRectMake(_doneButton.left - 24 - 5, 10, 24, 24);
    _numberLabel.frame = _numberImageView.frame;
    
    [_tagPhotoButton sizeToFit];
    _tagPhotoButton.frame = CGRectMake(20, 0, _tagPhotoButton.width, 44);
    
    _selectButton.frame = CGRectMake(self.view.width - 44, 10 + statusBarHeightInterval, 24, 24);
    _selectButton.centerY = _backButton.centerY;
    _indexLabel.frame = _selectButton.bounds;
    
    [self configCropView];
    
    if (_driImagePickVc.photoPreviewPageDidLayoutSubviewsBlock) {
        _driImagePickVc.photoPreviewPageDidLayoutSubviewsBlock(_collectionView, _naviBar, _backButton, _selectButton, _indexLabel, _toolBar, _tagPhotoButton, _originalPhotoLabel, _doneButton, _numberImageView, _numberLabel);
    }
}

#pragma mark - Notification

- (void)didChangeStatusBarOrientationNotification:(NSNotification *)noti {
    _offsetItemCount = _collectionView.contentOffset.x / _layout.itemSize.width;
}

#pragma mark - Click Event

- (void)select:(UIButton *)selectButton {
    DRIImagePickerController *_driImagePickVc = (DRIImagePickerController *)self.navigationController;
    DRIAssetModel *model = _models[self.currentIndex];
    if (!selectButton.isSelected) {
        // 1. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
        if (_driImagePickVc.selectedModels.count >= _driImagePickVc.maxImagesCount) {
            NSString *title = [NSString stringWithFormat:[NSBundle dri_localizedStringForKey:@"Select a maximum of %zd photos"], _driImagePickVc.maxImagesCount];
            [_driImagePickVc showAlertWithTitle:title];
            return;
            // 2. if not over the maxImagesCount / 如果没有超过最大个数限制
        } else {
            [_driImagePickVc addSelectedModel:model];
            if (self.photos) {
                [_driImagePickVc.selectedAssets addObject:_assetsTemp[self.currentIndex]];
                [self.photos addObject:_photosTemp[self.currentIndex]];
            }
            if (model.type == DRIAssetModelMediaTypeVideo && !_driImagePickVc.allowPickingMultipleVideo) {
                [_driImagePickVc showAlertWithTitle:[NSBundle dri_localizedStringForKey:@"Select the video when in multi state, we will handle the video as a photo"]];
            }
        }
    } else {
        NSArray *selectedModels = [NSArray arrayWithArray:_driImagePickVc.selectedModels];
        for (DRIAssetModel *model_item in selectedModels) {
            if ([model.asset.localIdentifier isEqualToString:model_item.asset.localIdentifier]) {
                // 1.6.7版本更新:防止有多个一样的model,一次性被移除了
                NSArray *selectedModelsTmp = [NSArray arrayWithArray:_driImagePickVc.selectedModels];
                for (NSInteger i = 0; i < selectedModelsTmp.count; i++) {
                    DRIAssetModel *model = selectedModelsTmp[i];
                    if ([model isEqual:model_item]) {
                        [_driImagePickVc removeSelectedModel:model];
                        // [_driImagePickVc.selectedModels removeObjectAtIndex:i];
                        break;
                    }
                }
                if (self.photos) {
                    // 1.6.7版本更新:防止有多个一样的asset,一次性被移除了
                    NSArray *selectedAssetsTmp = [NSArray arrayWithArray:_driImagePickVc.selectedAssets];
                    for (NSInteger i = 0; i < selectedAssetsTmp.count; i++) {
                        id asset = selectedAssetsTmp[i];
                        if ([asset isEqual:_assetsTemp[self.currentIndex]]) {
                            [_driImagePickVc.selectedAssets removeObjectAtIndex:i];
                            break;
                        }
                    }
                    // [_driImagePickVc.selectedAssets removeObject:_assetsTemp[self.currentIndex]];
                    [self.photos removeObject:_photosTemp[self.currentIndex]];
                }
                break;
            }
        }
    }
    model.isSelected = !selectButton.isSelected;
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
    // 如果图片正在从iCloud同步中,提醒用户
    if (_progress > 0 && _progress < 1 && (_selectButton.isSelected || !_driImagePickVc.selectedModels.count )) {
        _alertView = [_driImagePickVc showAlertWithTitle:[NSBundle dri_localizedStringForKey:@"Synchronizing photos from iCloud"]];
        return;
    }
    
    // 如果没有选中过照片 点击确定时选中当前预览的照片
    if (_driImagePickVc.selectedModels.count == 0 && _driImagePickVc.minImagesCount <= 0) {
        DRIAssetModel *model = _models[self.currentIndex];
        [_driImagePickVc addSelectedModel:model];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    DRIPhotoPreviewCell *cell = (DRIPhotoPreviewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    if (self.doneButtonClickBlock) { // 非裁剪状态
        self.doneButtonClickBlock(_isSelectOriginalPhoto);
    }
    if (self.doneButtonClickBlockWithPreviewType) {
        self.doneButtonClickBlockWithPreviewType(self.photos,_driImagePickVc.selectedAssets,self.isSelectOriginalPhoto);
    }
}

#pragma mark = 添加标签的操作,之前,现在修改为点击编辑跳转编辑页面

- (void)tagPhotoButtonClick {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    DRIPhotoPreviewCell *cell = (DRIPhotoPreviewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    DRIAssetModel *model = _models[_currentIndex];
    if (model.type == DRIAssetModelMediaTypePhoto ||
        model.type == DRIAssetModelMediaTypeLivePhoto)
        
    {
        [cell.previewView.scrollView setZoomScale:1.0 animated:NO];
        //    CGRect rc = [self.view convertRect:cell.previewView.imageView.frame fromView:self.view];
        CGRect rect = [cell.previewView.imageView.superview convertRect:cell.previewView.imageView.frame toView:self.view];
        UIImage *image = cell.previewView.imageView.image;
        DRIImagePreviewTagsViewController *vc = [[DRIImagePreviewTagsViewController alloc] initWithImage:cell.previewView.imageView.image];
        @weakify (self);
        
        vc.dismissBlock = ^(BOOL done,NSMutableArray *tagsData) {
            weak_self.isHideNaviBar = NO;
            _naviBar.hidden = self.isHideNaviBar;
            _toolBar.hidden = self.isHideNaviBar;
            if (tagsData) {
                model.asset.tagsArray = tagsData.mutableCopy;
                //            DRIImagePreviewTagsView *tagsView = [[DRIImagePreviewTagsView alloc] initWithFrame:cell.previewView.imageView.bounds];
                //            [tagsView addNewTagWithTagsArray:tagsData];
                ////            tagsView.frame = ;
                //            [cell.previewView.imageView addSubview:tagsView];
                [cell.previewView recoverSubviews];
                if (!model.isSelected)[weak_self select:_selectButton];
            }
        };
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:NO completion:^{
            [vc addExistTags:model.asset.tagsArray.copy];
            model.asset.tagsArray = nil;
            for (UIView *view in cell.previewView.imageView.subviews) {
                if ([view isKindOfClass:[DRIImagePreviewTagsView class]]) {
                    [view removeFromSuperview];
                }
            }
            self.isHideNaviBar = YES;
            _naviBar.hidden = self.isHideNaviBar;
            _toolBar.hidden = self.isHideNaviBar;
        }];
        
    }
}

- (void)dismissImagePreviewTagsView{
//    self.isHideNaviBar = NO;
//    _naviBar.hidden = self.isHideNaviBar;
//    _toolBar.hidden = self.isHideNaviBar;
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
    if (currentIndex < _models.count && _currentIndex != currentIndex) {
        _currentIndex = currentIndex;
        [self refreshNaviBarAndBottomBarState];
    }
    NSLog(@"scrollViewDidScroll");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"photoPreviewCollectionViewDidScroll" object:nil];
}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didEndDisplayingCell");
    if ([cell isKindOfClass:[DRIPhotoPreviewCell class]]) {
        DRIAssetModel *model = _models[indexPath.item];
        
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
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DRIImagePickerController *_driImagePickVc = (DRIImagePickerController *)self.navigationController;
    DRIAssetModel *model = _models[indexPath.item];
    if (model.isSelected) {
        [_driImagePickVc.selectedAssets enumerateObjectsUsingBlock:^(PHAsset *  _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([asset.localIdentifier isEqualToString:model.asset.localIdentifier]) {
                model.asset = asset;
            }
        }];
    }

    DRIAssetPreviewCell *cell;
    
    __weak typeof(self) weakSelf = self;
    if (_driImagePickVc.allowPickingMultipleVideo && model.type == DRIAssetModelMediaTypeVideo) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DRIVideoPreviewCell" forIndexPath:indexPath];
    } else if (_driImagePickVc.allowPickingMultipleVideo && model.type == DRIAssetModelMediaTypePhotoGif && _driImagePickVc.allowPickingGif) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DRIGifPreviewCell" forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DRIPhotoPreviewCell" forIndexPath:indexPath];
        DRIPhotoPreviewCell *photoPreviewCell = (DRIPhotoPreviewCell *)cell;
        photoPreviewCell.cropRect = _driImagePickVc.cropRect;
        photoPreviewCell.allowCrop = _driImagePickVc.allowCrop;
        __weak typeof(_driImagePickVc) weakdriImagePickVc = _driImagePickVc;
        __weak typeof(_collectionView) weakCollectionView = _collectionView;
        __weak typeof(photoPreviewCell) weakCell = photoPreviewCell;
        [photoPreviewCell setImageProgressUpdateBlock:^(double progress) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            __strong typeof(weakdriImagePickVc) strongdriImagePickVc = weakdriImagePickVc;
            __strong typeof(weakCollectionView) strongCollectionView = weakCollectionView;
            __strong typeof(weakCell) strongCell = weakCell;
            weakSelf.progress = progress;
            if (progress >= 1) {
//                [(DRIPhotoPreviewCell *)cell recoverSubviews];
//                for (UIView *view in ((DRIPhotoPreviewCell *)strongCell).previewView.imageView.subviews) {
//                    if ([view isKindOfClass:[DRIImagePreviewTagsView class]]) {
//                        [view removeFromSuperview];
//                    }
//                }
//                [strongCell recoverSubviews];
//                DRIAssetModel *model = strongSelf.models[indexPath.item];
//                PHAsset *asset = model.asset;
//                if (asset.tagsArray) {
//                    DRIImagePreviewTagsView *tagsView = [[DRIImagePreviewTagsView alloc] initWithFrame:strongCell.previewView.imageView.bounds];
//                    [tagsView addNewTagWithTagsArray:asset.tagsArray];
//                    [((DRIPhotoPreviewCell *)strongCell).previewView.imageView addSubview:tagsView];
//                    [((DRIPhotoPreviewCell *)strongCell).previewView.imageView bringSubviewToFront:tagsView];
//                }
                if (strongSelf.isSelectOriginalPhoto) [strongSelf showPhotoBytes];
                if (strongSelf.alertView && [strongCollectionView.visibleCells containsObject:strongCell]) {
                    [strongdriImagePickVc hideAlertView:strongSelf.alertView];
                    strongSelf.alertView = nil;
                    [strongSelf doneButtonClick];
                }
            }
        }];
    }
    
    cell.model = model;
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
    DRIAssetModel *model = _models[self.currentIndex];
    _selectButton.selected = model.isSelected;
    [self refreshSelectButtonImageViewContentMode];
//    if (_selectButton.isSelected && _driImagePickVc.showSelectedIndex && _driImagePickVc.showSelectBtn) {
//        NSString *index = [NSString stringWithFormat:@"%d", (int)([_driImagePickVc.selectedAssetIds indexOfObject:model.asset.localIdentifier] + 1)];
//        _indexLabel.text = index;
//        _indexLabel.hidden = NO;
//    } else {
//    }
    NSString *index = [NSString stringWithFormat:@"%d", (int)([_driImagePickVc.selectedAssetIds indexOfObject:model.asset.localIdentifier] + 1)];
    _navIndexLabel.text = [NSString stringWithFormat:@"%zd/%zd",_currentIndex+1,self.models.count];
    [_navIndexLabel sizeToFit];
    
    _navIndexLabel.centerY = _backButton.centerY;
    _navIndexLabel.centerX = _naviBar.centerX;
    
    _indexLabel.hidden = YES;
    _numberLabel.text = [NSString stringWithFormat:@"%zd",_driImagePickVc.selectedModels.count];
    if (_driImagePickVc.selectedModels.count == 0) {
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        self.toolsView.hidden = YES;
    }else{
        self.toolsView.hidden = NO;
    [_doneButton setTitle:[NSString stringWithFormat:@"完成(%zd)",_driImagePickVc.selectedModels.count] forState:UIControlStateNormal];
    [_selectButton setTitle:index forState:UIControlStateSelected];
    [self.toolsView updateWithModels:_driImagePickVc.selectedModels currentIndex:[index integerValue] -1 ];
    }
    
    //_isHideNaviBar
    _numberImageView.hidden = (_driImagePickVc.selectedModels.count <= 0 || _isCropImage);
    _numberLabel.hidden = (_driImagePickVc.selectedModels.count <= 0 || _isCropImage);
    
    _tagPhotoButton.selected = _isSelectOriginalPhoto;
    _originalPhotoLabel.hidden = !_tagPhotoButton.isSelected;
    if (_isSelectOriginalPhoto) [self showPhotoBytes];
    
    // If is previewing video, hide original photo button
    // 如果正在预览的是视频，隐藏原图按钮
    if (model.type == DRIAssetModelMediaTypeVideo) {
            self.editButton.enabled = NO;
            _selectButton.enabled = NO;
        self.originalLabel.hidden = YES;
        self.originalButton.hidden = YES;
      //  _originalPhotoLabel.hidden = YES;
    } else if(model.type == DRIAssetModelMediaTypePhotoGif) {
            self.editButton.enabled = YES;
              _selectButton.enabled = NO;
        self.originalLabel.hidden = YES;
           self.originalButton.hidden = YES;
//        _tagPhotoButton.hidden = NO;
//        if (_isSelectOriginalPhoto)  _originalPhotoLabel.hidden = NO;
    }else{
        self.editButton.enabled = YES;
              _selectButton.enabled = YES;
        self.originalLabel.hidden = NO;
           self.originalButton.hidden = NO;
    }
    
    if (self.isHiddenEdit) {
        self.editButton.hidden = YES;
    }
    
    _doneButton.hidden = NO;
    _selectButton.hidden = !_driImagePickVc.showSelectBtn;
    // 让宽度/高度小于 最小可选照片尺寸 的图片不能选中
    if (![[DRIImageManager manager] isPhotoSelectableWithAsset:model.asset]) {
        _numberLabel.hidden = YES;
        _numberImageView.hidden = YES;
        _selectButton.hidden = YES;
        _tagPhotoButton.hidden = YES;
        _originalPhotoLabel.hidden = YES;
        _doneButton.hidden = YES;
    }
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
    [[DRIImageManager manager] getPhotosBytesWithArray:@[_models[self.currentIndex]] completion:^(NSString *totalBytes) {
        self.originalLabel.text = [NSString stringWithFormat:@"原图(%@)",totalBytes];
    }];
}

- (NSInteger)currentIndex {
    return [DRICommonTools dri_isRightToLeftLayout] ? self.models.count - _currentIndex - 1 : _currentIndex;
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
//    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
//
//    CGFloat scale = (translation.y / SCREENHEIGHT);
//    scale = scale < 0 ? 0 : scale;
//    scale = scale > 1 ? 1 : scale;
//
//    switch (gestureRecognizer.state) {
//        case UIGestureRecognizerStatePossible:
//            break;
//        case UIGestureRecognizerStateBegan:{
//
//            NSInteger index = [_collectionView indexPathsForVisibleItems].firstObject.item;
//            self.animatedTransition.transitionParameter.transitionImgIndex = index;
//            DRIPhotoPreviewCell *previewCell = [_collectionView visibleCells].firstObject;
//            if ([previewCell isKindOfClass:[DRIPhotoPreviewCell class]]) {
//                self.currentImageView.image = previewCell.previewView.imageView.image;
//                [self.currentImageView sizeToFit];
//            }
//
//            self.animatedTransition.transitionParameter.transitionImage = previewCell.previewView.imageView.image;
//            self.animatedTransition.transitionParameter.transitionImgIndex = index;
//
//            self.currentImageView.frame = CGRectMake(previewCell.previewView.imageView.superview.frame.origin.x / previewCell.previewView.scrollView.zoomScale, (previewCell.previewView.imageView.superview.frame.origin.y - DNNavHeight) /previewCell.previewView.scrollView.zoomScale, previewCell.previewView.imageView.superview.width /previewCell.previewView.scrollView.zoomScale, previewCell.previewView.imageView.superview.height /previewCell.previewView.scrollView.zoomScale) ;
//            self.currentImageView.hidden = YES;
//            self.transitionImgViewCenter = self.view.center;
//            _collectionView.hidden = YES;
//            _toolBar.hidden = YES;
//            _naviBar.hidden = YES;
//            _currentImageView.center = CGPointMake(self.transitionImgViewCenter.x + translation.x * scale, self.transitionImgViewCenter.y + translation.y);
//            self.currentImageView.hidden = NO;
//
//            self.animatedTransition.transitionParameter.gestureRecognizer = gestureRecognizer;
//            if (self.navigationController.childViewControllers.count == 1) {
//                [self dismissViewControllerAnimated:YES completion:nil];
//            }else{
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//
//        }
//            break;
//        case UIGestureRecognizerStateChanged: {
//
//            _currentImageView.center = CGPointMake(self.transitionImgViewCenter.x + translation.x * scale, self.transitionImgViewCenter.y + translation.y);
////            _currentImageView.transform = CGAffineTransformMakeScale(scale, scale);
//
//            break;
//        }
//        case UIGestureRecognizerStateFailed:
//        case UIGestureRecognizerStateCancelled:
//        case UIGestureRecognizerStateEnded: {
//
//            if (scale > 0.9f) {
//                [UIView animateWithDuration:0.2 animations:^{
//                    _currentImageView.center = self.transitionImgViewCenter;
//                    _currentImageView.transform = CGAffineTransformMakeScale(1, 1);
//
//                } completion:^(BOOL finished) {
//                    _currentImageView.transform = CGAffineTransformIdentity;
//                }];
//                NSLog(@"secondevc取消");
//            }else{
//            }
//            _collectionView.hidden = NO;
//            _toolBar.hidden = NO;
//            _naviBar.hidden = NO;
//            _currentImageView.hidden = YES;
//            self.animatedTransition.transitionParameter.transitionImage = _currentImageView.image;
//            self.animatedTransition.transitionParameter.currentPanGestImgFrame = _currentImageView.frame;
//
//            self.animatedTransition.transitionParameter.gestureRecognizer = nil;
//
//            [_currentImageView removeFromSuperview];
//            _currentImageView = nil;
//            [self.navigationController setNavigationBarHidden:YES animated:NO];
//        }
//    }
//}
//
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    if (gestureRecognizer.view == self.view &&
//        [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")]) {
//        UIScrollView *scrollView = otherGestureRecognizer.view;
//        UIPanGestureRecognizer *panScroll = otherGestureRecognizer;
//        CGPoint point = [panScroll translationInView:scrollView];
//        DRIPhotoPreviewView *preview = scrollView.superview;
//        if ([preview isKindOfClass:[DRIPhotoPreviewView class]]) {
//            UIImageView *imageView = preview.imageView;
//            UIImage *image = imageView.image;
//            if ((preview.scrollView.contentSize.height / preview.scrollView.zoomScale) < SCREENHEIGHT) {
//                return NO;
//            }
//            if (fabs(point.x) > fabs(point.y)) {
//                return NO;
//            }
//            //            if (preview.isScrolling) return NO;
//            NSLog(@"%@",NSStringFromCGPoint(point));
//            if (scrollView.contentOffset.y <= 1 &&
//                (point.y >= 0)) {
//                return YES;
//            }
//            if ((imageView &&
//                 scrollView.contentOffset.y >= imageView.height *  scrollView.zoomScale - scrollView.height - 1) &&
//                (point.y <= 0)) {
//                return YES;
//            }
//        }
//    }
//    return NO;
}


- (UIImageView *)currentImageView{
    if (!_currentImageView) {
        _currentImageView = [[UIImageView alloc] init];
        [self.view addSubview:_currentImageView];
    }
    return _currentImageView;
}
@end
