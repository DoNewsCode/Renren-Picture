//
//  DRIPhotoPickerController.m
//  DRIImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import "DRIPhotoPickerController.h"
#import "DRIImagePickerController.h"
#import "DRIPhotoPreviewController.h"
#import "DRIAssetCell.h"
#import "DRIAssetModel.h"
#import "UIView+Layout.h"
#import "DRIImageManager.h"
#import "DRIVideoPlayerController.h"
#import "DRIGifPhotoPreviewController.h"
#import "DRILocationManager.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "DRIImageRequestOperation.h"
#import "DRIRecordViewController.h"
#import "DRIAlbumListPopViewController.h"
#import "UIButton+CTTitlePlace.h"
#import "DRIPictureBrowse.h"
#import <DNCommonKit/DNBaseMacro.h>
#import <DNCommonKit/UIColor+CTHex.h>
#import "DRINavTitleView.h"
#import "SDAutoLayout.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "DRMECameraViewController.h"
@interface DRIPhotoPickerController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,DRIRecordDelegate,DRIAlbumListPopViewDelegate> {
    NSMutableArray *_models;
    UIImageView *_numberImageView;
    UILabel *_numberLabel;
    UIView *_divideLine;
    
    BOOL _shouldScrollToBottom;
    BOOL _showTakePhotoBtn;
    
    CGFloat _offsetItemCount;
    CGFloat _titleButtonMaxWidth;
    BOOL _popAnimation;
}
@property CGRect previousPreheatRect;
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
@property (nonatomic, strong) DRICollectionView *collectionView;
@property (nonatomic, strong) UILabel *noDataLabel;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) DRIAlbumListPopViewController *albumListView;
@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UIImageView *titleArrowView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (strong, nonatomic) DRINavTitleView *navView;
@property(nonatomic,strong)UIView * bottomToolBar;
@property(nonatomic,strong)UIButton * previewButton;
@property(nonatomic,strong)UIButton * doneButton;
@property(nonatomic,strong)UIButton * originalButton;
@property(nonatomic,strong)UILabel * originalLabel;
@property (nonatomic, strong) DRIPictureBrowseInteractiveAnimatedTransition *animatedTransition;
@end

static CGSize DRIAssetGridThumbnailSize;
static CGFloat DRIitemMargin = 5;

@implementation DRIPhotoPickerController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _popAnimation = YES;
    }
    return self;
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *driBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            driBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[DRIImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            driBarItem = [UIBarButtonItem appearanceWhenContainedIn:[DRIImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [driBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (DRIAlbumListPopViewController *)albumListView{
    if (!_albumListView) {
        _albumListView = [[DRIAlbumListPopViewController alloc] init];
        _albumListView.delegate = self;
    }
    return _albumListView;
}
-(UIView*)bottomToolBar{
    if (!_bottomToolBar) {
       _bottomToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, [DRICommonTools dri_isIPhoneX] ? 88 :68)];
       _bottomToolBar.backgroundColor = [UIColor colorWithRed:32 / 255.0 green:32 / 255.0 blue:32/ 255.0 alpha:0.69];
       _bottomToolBar.size = CGSizeMake(SCREEN_WIDTH, [DRICommonTools dri_isIPhoneX] ? 88 :68);
        UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
           UIVisualEffectView *effectView =[[UIVisualEffectView alloc]initWithEffect:blurEffect];
           effectView.alpha = 0.9;
           effectView.frame = _bottomToolBar.bounds;
           [_bottomToolBar addSubview:effectView];
    }
    return _bottomToolBar;
}
-(UIButton*)previewButton{
    if (!_previewButton) {
        _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previewButton addTarget:self action:@selector(previewButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _previewButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
        [_previewButton setTitle:@"预览" forState:UIControlStateDisabled];
        [_previewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_previewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        _previewButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _previewButton;
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
-(UIButton*)doneButton{
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_doneButton setTitle:@"完成(1)" forState:UIControlStateNormal];
        [_doneButton setTitle:@"完成(1)" forState:UIControlStateDisabled];
        [_doneButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_doneButton setTitleColor:UIColor.whiteColor forState:UIControlStateDisabled];
        [_doneButton setBackgroundColor:[UIColor colorWithRed:42 / 255.0 green:115 / 255.0 blue:235 / 255.0 alpha:1]];
        _doneButton.size = CGSizeMake(80, 29);
    }
    return _doneButton;
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
- (void)didSelectAlbum:(DRIAlbumModel *)album{
    self.model = album;
    [_navView.titleButton setTitle:[NSString stringWithFormat:@"%@ ",_model.name] forState:UIControlStateNormal];
    [_navView.titleButton setImage:[UIImage dri_imageNamedFromMyBundle:@"Publish_album_up"] forState:UIControlStateNormal];
    [self fetchAssetModels];
    [self.collectionView reloadData];
}

- (void)setupBarButton{
    @weakify(self);
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    DRINavTitleView *navView = [[DRINavTitleView alloc] initWithImagePickerController:driImagePickVc];
    [navView setTitle:[NSString stringWithFormat:@"%@ ",_model.name]];
    [navView.titleButton setImage:[UIImage dri_imageNamedFromMyBundle:@"Publish_album_down"] forState:UIControlStateNormal] ;
    NSString *rightTitle;
    if (driImagePickVc.selectedModels.count) {
        rightTitle = [NSString stringWithFormat:@"确定(%zd)",driImagePickVc.selectedModels.count];
    }else{
        rightTitle = @"确定";
    }
   [navView setRightTitle:@""];
//    [navView setSureAction:^{
//        [weak_self doneButtonClick];
//    }];
    [navView setCloseAction:^{
        [weak_self navLeftBarButtonClick];
    }];
    [navView setOriginAction:^(BOOL selected) {
        [weak_self originalPhotoButtonClick];
    }];
    [navView.titleButton addTarget:self action:@selector(onTitleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    navView.originalPhotoButton.hidden = YES;
    [self.view addSubview:navView];
    self.navView = navView;
    [_navView setRightButtonEnable:NO];
}


- (void)onTitleButtonClicked:(id)sender{
    if (self.albumListView.view.superview) {
        [_navView.titleButton setImage:[UIImage dri_imageNamedFromMyBundle:@"Publish_album_down"]  forState:UIControlStateNormal];
        [self.albumListView dismissAlbumList:YES];
        return;
    }
    self.albumListView.model = self.model;
    [self.albumListView showAlbumListInView:self.view fromRect:CGRectMake(0, CGRectGetMaxY(self.navView.frame), SCREEN_WIDTH, 8) animated:NO];
}

- (void)albumListDismissed{
    [_navView.titleButton setImage:[UIImage dri_imageNamedFromMyBundle:@"Publish_album_down"]  forState:UIControlStateNormal];
}

- (void)resetAlbumInfo{
    [self.albumListView loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    self.isFirstAppear = YES;
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    _isSelectOriginalPhoto = driImagePickVc.isSelectOriginalPhoto;
    _shouldScrollToBottom = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBarButton];
//    self.navigationItem.title = _model.name;
    
//    if (driImagePickVc.navLeftBarButtonSettingBlock) {
//        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        leftButton.frame = CGRectMake(0, 0, 44, 44);
//        [leftButton addTarget:self action:@selector(navLeftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        driImagePickVc.navLeftBarButtonSettingBlock(leftButton);
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    } else if (driImagePickVc.childViewControllers.count) {
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle dri_localizedStringForKey:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(navLeftBarButtonClick)];
//    }
    _showTakePhotoBtn = _model.isCameraRoll && ((driImagePickVc.allowTakePicture && driImagePickVc.allowPickingImage) || (driImagePickVc.allowTakeVideo && driImagePickVc.allowPickingVideo));
    // [self resetCachedAssets];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(needReload) name:@"NeedReloadPhotoPiclView" object:nil];
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 3;

    [self resetAlbumInfo];
}

-(void)needReload{
    [_collectionView reloadData];
}


- (void)fetchAssetModels {
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    if (_isFirstAppear && !_model.models.count) {
        [driImagePickVc showProgressHUD];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (!driImagePickVc.sortAscendingByModificationDate && self->_isFirstAppear && self->_model.isCameraRoll) {
            [[DRIImageManager manager] getCameraRollAlbum:driImagePickVc.allowPickingVideo allowPickingImage:driImagePickVc.allowPickingImage needFetchAssets:YES completion:^(DRIAlbumModel *model) {
                self->_model = model;
                self->_models = [NSMutableArray arrayWithArray:self->_model.models];
                [self initSubviews];
            }];
        } else {
            if (self->_showTakePhotoBtn || self->_isFirstAppear) {
                [[DRIImageManager manager] getAssetsFromFetchResult:self->_model.result cameraRoll:self->_model.isCameraRoll completion:^(NSArray<DRIAssetModel *> *models) {
                    self->_models = [NSMutableArray arrayWithArray:models];
                    [self initSubviews];
                }];
            } else {
                self->_models = [NSMutableArray arrayWithArray:self->_model.models];
                [self initSubviews];
            }
        }
    });
}

- (void)initSubviews {
    dispatch_async(dispatch_get_main_queue(), ^{
        DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
        [driImagePickVc hideProgressHUD];
        
        [self checkSelectedModels];
        [self configCollectionView];
        self->_collectionView.hidden = YES;
        [self configBottomToolBar];
        
        [self scrollCollectionViewToBottom];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.titleButton.hidden = YES;
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    driImagePickVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    DRIImagePickerController *driImagePicker = (DRIImagePickerController *)self.navigationController;
    if (driImagePicker && [driImagePicker isKindOfClass:[DRIImagePickerController class]]) {
        return driImagePicker.statusBarStyle;
    }
    return [super preferredStatusBarStyle];
}

- (void)configCollectionView {
    if (self.collectionView.superview) {
        return;
    }
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[DRICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.alwaysBounceHorizontal = NO;
    _collectionView.contentInset = UIEdgeInsetsMake(DRIitemMargin, DRIitemMargin, DRIitemMargin, DRIitemMargin);
    
    if (_showTakePhotoBtn) {
        _collectionView.contentSize = CGSizeMake(self.view.width, ((_model.count + self.columnNumber) / self.columnNumber) * self.view.width);
    } else {
        _collectionView.contentSize = CGSizeMake(self.view.width, ((_model.count + self.columnNumber - 1) / self.columnNumber) * self.view.width);
        if (_models.count == 0) {
            _noDataLabel = [UILabel new];
            _noDataLabel.textAlignment = NSTextAlignmentCenter;
            _noDataLabel.text = [NSBundle dri_localizedStringForKey:@"No Photos or Videos"];
            CGFloat rgb = 153 / 256.0;
            _noDataLabel.textColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
            _noDataLabel.font = [UIFont boldSystemFontOfSize:20];
            [_collectionView addSubview:_noDataLabel];
        }
    }
    if (self.collectionView.superview) {
        [self.collectionView reloadData];
        return;
    }
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[DRIAssetCell class] forCellWithReuseIdentifier:@"DRIAssetCell"];
    [_collectionView registerClass:[DRIAssetCameraCell class] forCellWithReuseIdentifier:@"DRIAssetCameraCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Determine the size of the thumbnails to request from the PHCachingImageManager
    self.titleButton.hidden = NO;
    CGFloat scale = 2.0;
    if ([UIScreen mainScreen].bounds.size.width > 600) {
        scale = 1.0;
    }
    CGSize cellSize = ((UICollectionViewFlowLayout *)_collectionView.collectionViewLayout).itemSize;
    DRIAssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
    
    if (!_models) {
        [self fetchAssetModels];
    }
    [self refreshBottomToolBarStatus];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.fd_interactivePopDisabled = YES;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.fd_interactivePopDisabled = YES;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    // [self updateCachedAssets];
     [self refreshBottomToolBarStatus];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES; self.navigationController.fd_interactivePopDisabled = NO;
    }
}

- (void)setTitle:(NSString *)title{
    _titleButton.enabled = YES;
    _titleArrowView.hidden = NO;
    self.titleLabel.text = title;
    CGFloat titleMaxWidth = _titleButtonMaxWidth - _titleArrowView.width - 2;
    CGSize titleSize = [title sizeWithFont:_titleLabel.font];
    CGFloat titleActualWidth = MIN(titleMaxWidth, titleSize.width);
    
    CGFloat btnWidth = titleActualWidth + _titleArrowView.width + 2;
    if (btnWidth < self.navigationItem.titleView.width) {
        btnWidth = self.navigationItem.titleView.width;
        self.titleLabel.frame = CGRectMake((btnWidth - titleActualWidth - 17)/2, 0, titleActualWidth, 44);
        self.titleArrowView.frame = CGRectMake(_titleLabel.right + 2, (44 - 15) / 2.f, 15, 15);
    }else{
        self.titleLabel.frame = CGRectMake(0, 0, titleActualWidth, 44);
        self.titleArrowView.frame = CGRectMake(_titleLabel.right + 2, (44 - 15) / 2.f, 15, 15);
    }
    self.titleButton.frame = CGRectMake((self.view.width - btnWidth)/2, 0, btnWidth, 44);
}

- (void)configBottomToolBar {
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    if (!driImagePickVc.showSelectBtn) return;
    
    CGFloat rgb = 253 / 255.0;
 

    self.previewButton.enabled = driImagePickVc.selectedModels.count;
    
    if (driImagePickVc.allowPickingOriginalPhoto) {
        self.originalButton.selected = _isSelectOriginalPhoto;
      //  self.originalButton.enabled = driImagePickVc.selectedModels.count > 0;
        if (_isSelectOriginalPhoto) [self getSelectedPhotoBytes];
    }
    

    self.doneButton.enabled = driImagePickVc.selectedModels.count || driImagePickVc.alwaysEnableDoneBtn;
    [ self.navView setRightButtonEnable:driImagePickVc.selectedModels.count || driImagePickVc.alwaysEnableDoneBtn];
    
    
    _numberImageView = [[UIImageView alloc] initWithImage:driImagePickVc.photoNumberIconImage];
    _numberImageView.hidden = driImagePickVc.selectedModels.count <= 0;
    _numberImageView.clipsToBounds = YES;
    _numberImageView.contentMode = UIViewContentModeScaleAspectFit;
    _numberImageView.backgroundColor = [UIColor clearColor];
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.font = [UIFont systemFontOfSize:15];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.text = [NSString stringWithFormat:@"%zd",driImagePickVc.selectedModels.count];
    _numberLabel.hidden = driImagePickVc.selectedModels.count <= 0;
    _numberLabel.backgroundColor = [UIColor clearColor];
    
    _divideLine = [[UIView alloc] init];
    CGFloat rgb2 = 222 / 255.0;
    _divideLine.backgroundColor = [UIColor colorWithRed:rgb2 green:rgb2 blue:rgb2 alpha:1.0];
    
 //   [self.bottomToolBar addSubview:_divideLine];
    [self.bottomToolBar addSubview:self.previewButton];
    [self.bottomToolBar addSubview:self.doneButton];
 //   [self.bottomToolBar addSubview:_numberImageView];
   // [self.bottomToolBar addSubview:_numberLabel];
    if (driImagePickVc.allowPickingOriginalPhoto) {
    [self.bottomToolBar addSubview:self.originalButton];
    [self.bottomToolBar addSubview:self.originalLabel];
    }
    [self.view addSubview:self.bottomToolBar];
    
    if (driImagePickVc.photoPickerPageUIConfigBlock) {
        driImagePickVc.photoPickerPageUIConfigBlock(_collectionView, nil, _previewButton, nil, nil, nil, _numberImageView, _numberLabel, _divideLine);
    }
    self.bottomToolBar.hidden = !driImagePickVc.selectedModels.count;
   
}

#pragma mark - Layout

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    
    CGFloat top = 0;
    CGFloat collectionViewHeight = 0;
    CGFloat naviBarHeight = self.navigationController.navigationBar.height;
    BOOL isStatusBarHidden = [UIApplication sharedApplication].isStatusBarHidden;
//    CGFloat toolBarHeight = [DRICommonTools dri_isIPhoneX] ? 50 + (83 - 49) : 50;
    CGFloat toolBarHeight = 0;
    if (self.navigationController.navigationBar.isTranslucent) {
        top = naviBarHeight;
        if (!isStatusBarHidden) top += [DRICommonTools dri_statusBarHeight];
        collectionViewHeight = driImagePickVc.showSelectBtn ? self.view.height - toolBarHeight - top : self.view.height - top;;
    } else {
        collectionViewHeight = driImagePickVc.showSelectBtn ? self.view.height - toolBarHeight : self.view.height;
    }
    _collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.navView.frame), self.view.width, SCREEN_HEIGHT - CGRectGetMaxY(self.navView.frame));
    _noDataLabel.frame = _collectionView.bounds;
    CGFloat itemWH = (self.view.width - (self.columnNumber + 1) * DRIitemMargin) / self.columnNumber;
    _layout.itemSize = CGSizeMake(itemWH, itemWH);
    _layout.minimumInteritemSpacing = DRIitemMargin;
    _layout.minimumLineSpacing = DRIitemMargin;
    [_collectionView setCollectionViewLayout:_layout];
    if (_offsetItemCount > 0) {
        CGFloat offsetY = _offsetItemCount * (_layout.itemSize.height + _layout.minimumLineSpacing);
        [_collectionView setContentOffset:CGPointMake(0, offsetY)];
    }
    
    CGFloat toolBarTop = 0;
    if (!self.navigationController.navigationBar.isHidden) {
        toolBarTop = self.view.height - toolBarHeight;
    } else {
        CGFloat navigationHeight = naviBarHeight + [DRICommonTools dri_statusBarHeight];
        toolBarTop = self.view.height - toolBarHeight - navigationHeight;
    }
    CGFloat navigationHeight = naviBarHeight + [DRICommonTools dri_statusBarHeight];
    toolBarHeight = [DRICommonTools dri_isIPhoneX] ? 88 :68;
    toolBarTop = self.view.height - toolBarHeight;
    self.bottomToolBar.frame = CGRectMake(0, SCREENHEIGHT, self.view.width, toolBarHeight);
    
    CGFloat previewWidth = [driImagePickVc.previewBtnTitleStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.width + 2;
    if (!driImagePickVc.allowPreview) {
        previewWidth = 0.0;
    }
    self.previewButton.frame = CGRectMake(15, 2, 35, 21);
    


//    if (driImagePickVc.allowPickingOriginalPhoto) {
//        CGFloat fullImageWidth = [driImagePickVc.fullImageBtnTitleStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width;
//        _originalPhotoButton.frame = CGRectMake(CGRectGetMaxX(_previewButton.frame), 0, fullImageWidth + 56, 50);
//        _originalPhotoLabel.frame = CGRectMake(fullImageWidth + 46, 0, 80, 50);
//    }
    self.doneButton.frame = CGRectMake(self.view.width - _doneButton.width - 15, 19, self.doneButton.width, self.doneButton.height);
    self.previewButton.centerY = self.doneButton.centerY;
    self.originalButton.frame = CGRectMake(0, 0, self.originalButton.width,self.originalButton.height);
    self.originalButton.center = CGPointMake(self.bottomToolBar.width / 2.f - 21, self.doneButton.centerY);
    self.originalLabel.frame = CGRectMake(CGRectGetMaxX(self.originalButton.frame)+4, 0, self.originalLabel.width, self.originalLabel.height);
    self.originalLabel.centerY = self.originalButton.centerY;
    _numberImageView.frame = CGRectMake(_doneButton.left - 24 - 5, 13, 24, 24);
    _numberLabel.frame = _numberImageView.frame;
    _divideLine.frame = CGRectMake(0, 0, self.view.width, 1);
    
    [DRIImageManager manager].columnNumber = [DRIImageManager manager].columnNumber;
    [DRIImageManager manager].photoWidth = driImagePickVc.photoWidth;
    [self.collectionView reloadData];
    
    if (driImagePickVc.photoPickerPageDidLayoutSubviewsBlock) {
        driImagePickVc.photoPickerPageDidLayoutSubviewsBlock(_collectionView, nil, _previewButton, nil, nil, nil, _numberImageView, _numberLabel, _divideLine);
    }
}

#pragma mark - Notification

- (void)didChangeStatusBarOrientationNotification:(NSNotification *)noti {
    _offsetItemCount = _collectionView.contentOffset.y / (_layout.itemSize.height + _layout.minimumLineSpacing);
}

#pragma mark - Click Event
- (void)navLeftBarButtonClick{
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    [driImagePickVc cancelButtonClick];
//    [self.navigationController popViewControllerAnimated:YES];
}
- (void)previewButtonClick {
    DRIPhotoPreviewController *photoPreviewVc = [[DRIPhotoPreviewController alloc] init];
    photoPreviewVc.isHiddenEdit = self.isHiddenEdit;
    self.navigationController.delegate = nil;
    [self pushPhotoPrevireViewController:photoPreviewVc needCheckSelectedModels:YES];
}

- (void)originalPhotoButtonClick {
    self.originalButton.selected = !self.originalButton.selected;
    _isSelectOriginalPhoto = self.originalButton.selected;
    if (_isSelectOriginalPhoto) {
        [self getSelectedPhotoBytes];
    }else{
        self.originalLabel.text = @"原图";
    }
}

- (void)doneButtonClick {
    
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    if (driImagePickVc.selectedModels.count == 0) {
        return;
    }
    // 1.6.8 判断是否满足最小必选张数的限制
    if (driImagePickVc.minImagesCount && driImagePickVc.selectedModels.count < driImagePickVc.minImagesCount) {
        NSString *title = [NSString stringWithFormat:[NSBundle dri_localizedStringForKey:@"Select a minimum of %zd photos"], driImagePickVc.minImagesCount];
        [driImagePickVc showAlertWithTitle:title];
        return;
    }
    
    [driImagePickVc showProgressHUD];
    NSMutableArray *assets = [NSMutableArray array];
    NSMutableArray *photos;
    NSMutableArray *infoArr;
    if (driImagePickVc.onlyReturnAsset) { // not fetch image
        for (NSInteger i = 0; i < driImagePickVc.selectedModels.count; i++) {
            DRIAssetModel *model = driImagePickVc.selectedModels[i];
            [assets addObject:model.asset];
        }
    } else { // fetch image
        photos = [NSMutableArray array];
        infoArr = [NSMutableArray array];
        for (NSInteger i = 0; i < driImagePickVc.selectedModels.count; i++) { [photos addObject:@1];[assets addObject:@1];[infoArr addObject:@1]; }
        
        __block BOOL havenotShowAlert = YES;
        [DRIImageManager manager].shouldFixOrientation = YES;
        __block UIAlertController *alertView;
        for (NSInteger i = 0; i < driImagePickVc.selectedModels.count; i++) {
            DRIAssetModel *model = driImagePickVc.selectedModels[i];
            DRIImageRequestOperation *operation = [[DRIImageRequestOperation alloc] initWithAsset:model.asset completion:^(UIImage * _Nonnull photo, NSDictionary * _Nonnull info, BOOL isDegraded) {
                if (isDegraded) return;
                if (photo) {
//                    if (![DRIImagePickerConfig sharedInstance].notScaleImage) {
//                        photo = [[DRIImageManager manager] scaleImage:photo toSize:CGSizeMake(driImagePickVc.photoWidth, (int)(driImagePickVc.photoWidth * photo.size.height / photo.size.width))];
//                    }
                    [photos replaceObjectAtIndex:i withObject:photo];
                }
                if (info)  [infoArr replaceObjectAtIndex:i withObject:info];
                [assets replaceObjectAtIndex:i withObject:model.asset];
                
                for (id item in photos) { if ([item isKindOfClass:[NSNumber class]]) return; }
                
                if (havenotShowAlert) {
                    [driImagePickVc hideAlertView:alertView];
                    [self didGetAllPhotos:photos assets:assets infoArr:infoArr];
                }
            } progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
                // 如果图片正在从iCloud同步中,提醒用户
                if (progress < 1 && havenotShowAlert && !alertView) {
                    [driImagePickVc hideProgressHUD];
                    alertView = [driImagePickVc showAlertWithTitle:[NSBundle dri_localizedStringForKey:@"Synchronizing photos from iCloud"]];
                    havenotShowAlert = NO;
                    return;
                }
                if (progress >= 1) {
                    havenotShowAlert = YES;
                }
            }];
            [self.operationQueue addOperation:operation];
        }
    }
    if (driImagePickVc.selectedModels.count <= 0 || driImagePickVc.onlyReturnAsset) {
        [self didGetAllPhotos:photos assets:assets infoArr:infoArr];
    }
}

- (void)didGetAllPhotos:(NSArray *)photos assets:(NSArray *)assets infoArr:(NSArray *)infoArr {
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    [driImagePickVc hideProgressHUD];
    
    if (driImagePickVc.autoDismiss) {
        [self.navigationController dismissViewControllerAnimated:_popAnimation completion:^{
        }];
        [self callDelegateMethodWithPhotos:photos assets:assets infoArr:infoArr];
    } else {
        [self callDelegateMethodWithPhotos:photos assets:assets infoArr:infoArr];
    }
}

- (void)callDelegateMethodWithPhotos:(NSArray *)photos assets:(NSArray *)assets infoArr:(NSArray *)infoArr {
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    if ([[DRIImageManager manager] isVideo:[assets firstObject]]) {
//        if (driImagePickVc.allowPickingVideo) {
            if ([driImagePickVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingVideo:sourceAssets:)]) {
                [driImagePickVc.pickerDelegate imagePickerController:driImagePickVc didFinishPickingVideo:[photos firstObject] sourceAssets:[assets firstObject]];
            }
            if (driImagePickVc.didFinishPickingVideoHandle) {
                driImagePickVc.didFinishPickingVideoHandle([photos firstObject], [assets firstObject]);
            }
//        }
        return;
    }
    
    if ([driImagePickVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:)]) {
        [driImagePickVc.pickerDelegate imagePickerController:driImagePickVc didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:_isSelectOriginalPhoto];
    }
    if ([driImagePickVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:infos:)]) {
        [driImagePickVc.pickerDelegate imagePickerController:driImagePickVc didFinishPickingPhotos:photos sourceAssets:assets isSelectOriginalPhoto:_isSelectOriginalPhoto infos:infoArr];
    }
    if (driImagePickVc.didFinishPickingPhotosHandle) {
        driImagePickVc.didFinishPickingPhotosHandle(photos,assets,_isSelectOriginalPhoto);
    }
    if (driImagePickVc.didFinishPickingPhotosWithInfosHandle) {
        driImagePickVc.didFinishPickingPhotosWithInfosHandle(photos,assets,_isSelectOriginalPhoto,infoArr);
    }
}

#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_showTakePhotoBtn) {
        return _models.count + 1;
    }
    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // the cell lead to take a picture / 去拍照的cell
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    if (((driImagePickVc.sortAscendingByModificationDate && indexPath.item >= _models.count) || (!driImagePickVc.sortAscendingByModificationDate && indexPath.item == 0)) && _showTakePhotoBtn) {
        DRIAssetCameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DRIAssetCameraCell" forIndexPath:indexPath];
        cell.imageView.image = driImagePickVc.takePictureImage;
        if ([driImagePickVc.takePictureImageName isEqualToString:@"takePicture80"]) {
            cell.imageView.contentMode = UIViewContentModeCenter;
            CGFloat rgb = 223 / 255.0;
            cell.imageView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
        } else {
            cell.imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        }
        return cell;
    }
    // the cell dipaly photo or video / 展示照片或视频的cell
    DRIAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DRIAssetCell" forIndexPath:indexPath];
    cell.allowPickingMultipleGif = driImagePickVc.allowPickingMultipleGif;
    cell.allowPickingMultipleVideo = driImagePickVc.allowPickingMultipleVideo;
    cell.photoDefImage = driImagePickVc.photoDefImage;
    cell.photoSelImage = driImagePickVc.photoSelImage;
    cell.assetCellDidSetModelBlock = driImagePickVc.assetCellDidSetModelBlock;
    cell.assetCellDidLayoutSubviewsBlock = driImagePickVc.assetCellDidLayoutSubviewsBlock;
    DRIAssetModel *model;
    if (driImagePickVc.sortAscendingByModificationDate || !_showTakePhotoBtn) {
        if (_models.count > indexPath.item)
            model = _models[indexPath.item];
    } else {
        if (_models.count > indexPath.item - 1)
            model = _models[indexPath.item - 1];
    }
    cell.allowPickingGif = driImagePickVc.allowPickingGif;
    cell.model = model;
    if (model.isSelected && driImagePickVc.showSelectedIndex) {
        cell.index = [driImagePickVc.selectedAssetIds indexOfObject:model.asset.localIdentifier] + 1;
    }
    cell.showSelectBtn = driImagePickVc.showSelectBtn;
    cell.allowPreview = driImagePickVc.allowPreview;
    DRIAssetModel *lastModel = driImagePickVc.selectedModels.lastObject;
    
    if (driImagePickVc.selectedModels.count >= driImagePickVc.maxImagesCount && driImagePickVc.showPhotoCannotSelectLayer && !model.isSelected) {
        cell.cannotSelectLayerButton.backgroundColor = driImagePickVc.cannotSelectLayerColor;
        cell.cannotSelectLayerButton.hidden = NO;
    } else if (driImagePickVc.selectedModels.count) {
        if (model.isImage != lastModel.isImage) {
            cell.cannotSelectLayerButton.backgroundColor = driImagePickVc.cannotSelectLayerColor;
            cell.cannotSelectLayerButton.hidden = NO;
        }else{
            cell.cannotSelectLayerButton.hidden = YES;
        }
    }
    else {
        cell.cannotSelectLayerButton.hidden = YES;
    }
    
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    __weak typeof(_numberImageView.layer) weakLayer = _numberImageView.layer;
    cell.didSelectPhotoBlock = ^(BOOL isSelected) {
        __strong typeof(weakCell) strongCell = weakCell;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        __strong typeof(weakLayer) strongLayer = weakLayer;
        DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)strongSelf.navigationController;
        // 1. cancel select / 取消选择
        if (isSelected) {
            strongCell.selectPhotoButton.selected = NO;
            model.isSelected = NO;
            NSArray *selectedModels = [NSArray arrayWithArray:driImagePickVc.selectedModels];
            for (DRIAssetModel *model_item in selectedModels) {
                if ([model.asset.localIdentifier isEqualToString:model_item.asset.localIdentifier]) {
                    [driImagePickVc removeSelectedModel:model_item];
                    break;
                }
            }
            [strongSelf refreshBottomToolBarStatus];
            if (driImagePickVc.showSelectedIndex || driImagePickVc.showPhotoCannotSelectLayer) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DRI_PHOTO_PICKER_RELOAD_NOTIFICATION" object:strongSelf.navigationController];
            }
            [UIView showOscillatoryAnimationWithLayer:strongLayer type:RHCOscillatoryAnimationToSmaller];
        } else {
            // 2. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
            if (driImagePickVc.selectedModels.count < driImagePickVc.maxImagesCount) {
                if (driImagePickVc.maxImagesCount == 1 && !driImagePickVc.allowPreview) {
                    model.isSelected = YES;
                    [driImagePickVc addSelectedModel:model];
                    [strongSelf doneButtonClick];
                    return;
                }
                if (lastModel && model.isImage != lastModel.isImage) {
                    return;
                }
                strongCell.selectPhotoButton.selected = YES;
                model.isSelected = YES;
                [driImagePickVc addSelectedModel:model];
                if (driImagePickVc.showSelectedIndex || driImagePickVc.showPhotoCannotSelectLayer) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DRI_PHOTO_PICKER_RELOAD_NOTIFICATION" object:strongSelf.navigationController];
                }
                [strongSelf refreshBottomToolBarStatus];
                [UIView showOscillatoryAnimationWithLayer:strongLayer type:RHCOscillatoryAnimationToSmaller];
            } else {
                NSString *title = [NSString stringWithFormat:[NSBundle dri_localizedStringForKey:@"Select a maximum of %zd photos"], driImagePickVc.maxImagesCount];
                [driImagePickVc showAlertWithTitle:title];
            }
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // take a photo / 去拍照
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if (((driImagePickVc.sortAscendingByModificationDate && indexPath.item >= _models.count) || (!driImagePickVc.sortAscendingByModificationDate && indexPath.item == 0)) && _showTakePhotoBtn)  {
        [self takePhoto]; return;
    }
    // preview phote or video / 预览照片或视频
    NSInteger index = indexPath.item;
    if (!driImagePickVc.sortAscendingByModificationDate && _showTakePhotoBtn) {
        index = indexPath.item - 1;
    }
    DRIAssetModel *model = _models[index];
    __weak typeof(self) weakSelf = self;
    if ([cell isKindOfClass:[DRIAssetCell class]]) {
        DRIAssetCell *assetCell = cell;
        //封装参数对象
        DRIPictureBrowseTransitionParameter *transitionParameter = [[DRIPictureBrowseTransitionParameter alloc] init];
        transitionParameter.transitionImage = assetCell.imageView.image;
        transitionParameter.firstVCImgFrames = [self firstImageViewFrames];
        transitionParameter.transitionImgIndex = index;
        self.animatedTransition = nil;
        self.animatedTransition.transitionParameter = transitionParameter;
        self.navigationController.delegate = self.animatedTransition;
    }
    if (model.type == DRIAssetModelMediaTypeVideo && !driImagePickVc.allowPickingMultipleVideo) {
//        if (driImagePickVc.selectedModels.count > 0) {
//            DRIImagePickerController *imagePickerVc = (DRIImagePickerController *)self.navigationController;
//            [imagePickerVc showAlertWithTitle:[NSBundle dri_localizedStringForKey:@"Can not choose both video and photo"]];
//        } else {
            DRIVideoPlayerController *videoPlayerVc = [[DRIVideoPlayerController alloc] init];
            videoPlayerVc.animatedTransition = self.animatedTransition;
            videoPlayerVc.model = model;
            [self.navigationController pushViewController:videoPlayerVc animated:YES];
//        }
    } else if (model.type == DRIAssetModelMediaTypePhotoGif && driImagePickVc.allowPickingGif && !driImagePickVc.allowPickingMultipleVideo) {
            DRIGifPhotoPreviewController *gifPreviewVc = [[DRIGifPhotoPreviewController alloc] init];
//        gifPreviewVc.photos =
        gifPreviewVc.animatedTransition = self.animatedTransition;
        gifPreviewVc.model = model;
        [gifPreviewVc setBackButtonClickBlock:^() {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf checkSelectedModels];
            [strongSelf.collectionView reloadData];
            [strongSelf refreshBottomToolBarStatus];
        }];
        [gifPreviewVc setDoneButtonClickBlock:^() {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf doneButtonClick];
        }];
            [self.navigationController pushViewController:gifPreviewVc animated:YES];
    } else {
        
        DRIPhotoPreviewController *photoPreviewVc = [[DRIPhotoPreviewController alloc] init];
        
        photoPreviewVc.animatedTransition = self.animatedTransition;
        photoPreviewVc.currentIndex = index;
        photoPreviewVc.models = _models;
        
        photoPreviewVc.isHiddenEdit = self.isHiddenEdit;
        
        [self pushPhotoPrevireViewController:photoPreviewVc];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // [self updateCachedAssets];
}

#pragma mark - Private Method

/// 拍照按钮点击事件
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)) {
        
        NSDictionary *infoDict = [DRICommonTools dri_getInfoDictionary];
        // 无权限 做一个友好的提示
        NSString *appName = [infoDict valueForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [infoDict valueForKey:@"CFBundleName"];
        
        NSString *message = [NSString stringWithFormat:[NSBundle dri_localizedStringForKey:@"Please allow %@ to access your camera in \"Settings -> Privacy -> Camera\""],appName];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSBundle dri_localizedStringForKey:@"Can not use camera"] message:message delegate:self cancelButtonTitle:[NSBundle dri_localizedStringForKey:@"Cancel"] otherButtonTitles:[NSBundle dri_localizedStringForKey:@"Setting"], nil];
        [alert show];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self pushImagePickerController];
                });
            }
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    if (driImagePickVc.allowCameraLocation) {
        __weak typeof(self) weakSelf = self;
        [[DRILocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.location = [locations firstObject];
        } failureBlock:^(NSError *error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.location = nil;
        }];
    }
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: sourceType]) {
        self.imagePickerVc.sourceType = sourceType;
        //        NSMutableArray *mediaTypes = [NSMutableArray array];
        //        if (driImagePickVc.allowTakePicture) {
        //            [mediaTypes addObject:(NSString *)kUTTypeImage];
        //        }
        //        if (driImagePickVc.allowTakeVideo) {
        //            [mediaTypes addObject:(NSString *)kUTTypeMovie];
        //            self.imagePickerVc.videoMaximumDuration = driImagePickVc.videoMaximumDuration;
        //        }
        //        self.imagePickerVc.mediaTypes= mediaTypes;
        //        if (driImagePickVc.uiImagePickerControllerSettingBlock) {
        //            driImagePickVc.uiImagePickerControllerSettingBlock(_imagePickerVc);
        //        }
        //        [self presentViewController:_imagePickerVc animated:YES completion:nil];
        if (driImagePickVc.maxImagesCount <= driImagePickVc.selectedModels.count) {
            return;
        }
//        DRIRecordViewController *vc = [[DRIRecordViewController alloc]init];
//        vc.delegate = self;
//        PHAsset *asset = driImagePickVc.selectedModels.firstObject.asset;
//        if (asset) {
//            vc.onlyTakePhoto = asset.mediaType == PHAssetMediaTypeImage;
//            vc.onlyTakeVideo = asset.mediaType == PHAssetMediaTypeVideo;
//        }else{
//            vc.onlyTakePhoto = driImagePickVc.onlyTakePhoto;
//            vc.onlyTakeVideo = driImagePickVc.onlyTakeVideo;
//        }
//        vc.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self presentViewController:vc animated:YES completion:nil];
           DRMECameraViewController *cameraVc = [DRMECameraViewController new];
        
        
        
        if (self.isHiddenEdit) {
            cameraVc.fromType = DRMEFromTypeComments;
        }
        
       PHAsset *asset = driImagePickVc.selectedModels.firstObject.asset;
       if (asset) {
           cameraVc.onlyTakePhoto = asset.mediaType == PHAssetMediaTypeImage;
           cameraVc.onlyTakeVideo = asset.mediaType == PHAssetMediaTypeVideo;
       }else{
           cameraVc.onlyTakePhoto = driImagePickVc.onlyTakePhoto;
           cameraVc.onlyTakeVideo = driImagePickVc.onlyTakeVideo;
       }
           UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cameraVc];
           nav.modalPresentationStyle = UIModalPresentationCurrentContext;
           [cameraVc hidesBottomBarWhenPushed];
           [self presentViewController:nav animated:YES completion:nil];
           @weakify(self);
           
        
        if (driImagePickVc.isFromHead) {
            cameraVc.fromType = DRMEFromTypeHead;
            cameraVc.showAlbumBtn = NO;
            
            @weakify(cameraVc)
            cameraVc.clickAlbumBlock = ^{
                @strongify(cameraVc)
                [cameraVc dismissViewControllerAnimated:YES completion:nil];
            };
        }
        
           [cameraVc setCameraEditCompleteBlock:^(UIImage * _Nonnull editImage) {
                  @strongify(self);
               if (!editImage) {
                   return ;
               }
                   DRIImagePickerController *imagePickerVc = (DRIImagePickerController *)self.navigationController;
                   [imagePickerVc showProgressHUD];
                   UIImage *photo = editImage;
                   if (photo) {
                       [[DRIImageManager manager] savePhotoWithImage:photo location:self.location completion:^(PHAsset *asset, NSError *error){
                           if (!error) {
                               [self addPHAsset:asset];
                               self->_popAnimation = NO;
                           }
                       }];
                       self.location = nil;
                   }
        
           }];
  [cameraVc setEditVideoCompleteBlock:^(NSString * _Nonnull videoPath) {
          DRIImagePickerController *imagePickerVc = (DRIImagePickerController *)self.navigationController;
          [imagePickerVc showProgressHUD];
          NSURL *videoUrl = [NSURL URLWithString:videoPath];
          if (videoUrl) {
              [[DRIImageManager manager] saveVideoWithUrl:videoUrl location:self.location completion:^(PHAsset *asset, NSError *error) {
                  if (!error) {
                      DRIAssetModel *assetModel = [self addPHAsset:asset];
                      imagePickerVc.selectedModels = [[NSMutableArray alloc] initWithObjects:assetModel, nil];
                      imagePickerVc.selectedAssets = [[NSMutableArray alloc] initWithObjects:assetModel.asset, nil];
                      imagePickerVc.selectedAssetIds = [[NSMutableArray alloc] initWithObjects:assetModel.asset.localIdentifier, nil];
                      self->_popAnimation = NO;
                  }
              }];
              self.location = nil;
          }
  }];

    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)refreshBottomToolBarStatus {
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    
    UIBarButtonItem *item = self.navigationItem.rightBarButtonItem;
    if (driImagePickVc.selectedModels.count) {
     //   [item setTitle:[NSString stringWithFormat:@"确定(%zd)",driImagePickVc.selectedModels.count]];
   //     [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor ct_colorWithHex:0x3580F9],NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    }else{
   //     [item setTitle:[NSString stringWithFormat:@"确定"]];
   //     [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor ct_colorWithHex:0x999999],NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    }
//    if (driImagePickVc.selectedModels.count <= 0) {
////        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle dri_localizedStringForKey:@"OK"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonClick)];
//        item.tintColor = [UIColor ct_colorWithHex:0x999999];
//        [item setTitle:@"确定"];
//
//        item.enabled = NO;
//    }else{
//        [item setTitle:[NSString stringWithFormat:@"确定(%zd)",driImagePickVc.selectedModels.count]];
//        item.tintColor = [UIColor ct_colorWithHex:0x3580F9];
//        item.enabled = YES;
//    }
    
    self.previewButton.enabled = driImagePickVc.selectedModels.count > 0;
    NSString *str;
    bool rightEnable =  driImagePickVc.selectedModels.count > 0 || driImagePickVc.alwaysEnableDoneBtn;
    if (rightEnable) {
        str = [NSString stringWithFormat:@"确定(%lu)",(unsigned long)driImagePickVc.selectedModels.count];
    }else{
        str = @"确定";
    }
//    [self.navView setRightTitle:str];
 //   [self.navView setCount:driImagePickVc.selectedModels.count];
//    [self.navView setRightButtonEnable:rightEnable];
    self.bottomToolBar.hidden = driImagePickVc.selectedModels.count <= 0;
    _numberImageView.hidden = driImagePickVc.selectedModels.count <= 0;
    _numberLabel.hidden = driImagePickVc.selectedModels.count <= 0;
    _numberLabel.text = [NSString stringWithFormat:@"%zd",driImagePickVc.selectedModels.count];
    [self.doneButton setTitle:[NSString stringWithFormat:@"完成(%zd)",driImagePickVc.selectedModels.count] forState:UIControlStateNormal];
    [self.doneButton setTitle:[NSString stringWithFormat:@"完成(%zd)",driImagePickVc.selectedModels.count] forState:UIControlStateDisabled];
    [self.doneButton.layer setCornerRadius:self.doneButton.height / 2.0f];
    self.doneButton.enabled  = driImagePickVc.selectedModels.count > 0;
    _navView.originalPhotoButton.enabled = driImagePickVc.selectedModels.count > 0;
    _navView.originalPhotoButton.selected = (_isSelectOriginalPhoto && _navView.originalPhotoButton.enabled);
    _navView.originalPhotoLabel.hidden = (!_navView.originalPhotoButton.isSelected);
    if (_isSelectOriginalPhoto) [self getSelectedPhotoBytes];
    if (!self.bottomToolBar.hidden &&( CGRectGetMaxY(self.bottomToolBar.frame) >= SCREEN_HEIGHT) ){
        CGRect rect = CGRectMake(0, SCREEN_HEIGHT - self.bottomToolBar.height, self.bottomToolBar.width, self.bottomToolBar.height);
        [UIView animateWithDuration:0.5 animations:^{
            self.bottomToolBar.frame =rect;
        }];
    }
    if (self.bottomToolBar.hidden &&( CGRectGetMaxY(self.bottomToolBar.frame) == SCREEN_HEIGHT) ){
        CGRect rect = CGRectMake(0, SCREEN_HEIGHT, self.bottomToolBar.width, self.bottomToolBar.height);
        [UIView animateWithDuration:0.5 animations:^{
            self.bottomToolBar.frame =rect;
        }];
    }
    
}

- (void)pushPhotoPrevireViewController:(DRIPhotoPreviewController *)photoPreviewVc {
    [self pushPhotoPrevireViewController:photoPreviewVc needCheckSelectedModels:YES];
}

- (void)pushPhotoPrevireViewController:(DRIPhotoPreviewController *)photoPreviewVc needCheckSelectedModels:(BOOL)needCheckSelectedModels {
    __weak typeof(self) weakSelf = self;
    photoPreviewVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    [photoPreviewVc setBackButtonClickBlock:^(BOOL isSelectOriginalPhoto) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        if (needCheckSelectedModels) {
            [strongSelf checkSelectedModels];
        }
        [strongSelf.collectionView reloadData];
        [strongSelf refreshBottomToolBarStatus];
    }];
    [photoPreviewVc setDoneButtonClickBlock:^(BOOL isSelectOriginalPhoto) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [strongSelf doneButtonClick];
    }];
    [photoPreviewVc setDoneButtonClickBlockCropMode:^(UIImage *cropedImage, id asset) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf didGetAllPhotos:@[cropedImage] assets:@[asset] infoArr:nil];
    }];
    [self.navigationController pushViewController:photoPreviewVc animated:YES];
}

- (void)getSelectedPhotoBytes {
    // 越南语 && 5屏幕时会显示不下，暂时这样处理
    if ([[DRIImagePickerConfig sharedInstance].preferredLanguage isEqualToString:@"vi"] && self.view.width <= 320) {
        return;
    }
    DRIImagePickerController *imagePickerVc = (DRIImagePickerController *)self.navigationController;
    [[DRIImageManager manager] getPhotosBytesWithArray:imagePickerVc.selectedModels completion:^(NSString *totalBytes) {
        if (_isSelectOriginalPhoto) {
        self.originalLabel.text = [NSString stringWithFormat:@"原图(%@)",totalBytes];
        [self.originalLabel sizeThatFits:CGSizeMake(80, 16)];
        }

        [self.navView layoutSubviews];
    }];
}

- (void)scrollCollectionViewToBottom {
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    if (_shouldScrollToBottom && _models.count > 0) {
        NSInteger item = 0;
        if (driImagePickVc.sortAscendingByModificationDate) {
            item = _models.count - 1;
            if (_showTakePhotoBtn) {
                item += 1;
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self->_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            self->_shouldScrollToBottom = NO;
            self->_collectionView.hidden = NO;
        });
    } else {
        _collectionView.hidden = NO;
    }
}

- (void)checkSelectedModels {
    NSMutableArray *selectedAssets = [NSMutableArray array];
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    for (DRIAssetModel *model in driImagePickVc.selectedModels) {
        [selectedAssets addObject:model.asset];
    }
    for (DRIAssetModel *model in _models) {
        model.isSelected = NO;
        if ([selectedAssets containsObject:model.asset]) {
            model.isSelected = YES;
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)recordViewController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        DRIImagePickerController *imagePickerVc = (DRIImagePickerController *)self.navigationController;
        [imagePickerVc showProgressHUD];
        UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (photo) {
            [[DRIImageManager manager] savePhotoWithImage:photo location:self.location completion:^(PHAsset *asset, NSError *error){
                if (!error) {
                    [self addPHAsset:asset];
                    _popAnimation = NO;
                    [self doneButtonClick];
                }
            }];
            self.location = nil;
        }
    } else if ([type isEqualToString:@"public.movie"]) {
        DRIImagePickerController *imagePickerVc = (DRIImagePickerController *)self.navigationController;
        [imagePickerVc showProgressHUD];
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        if (videoUrl) {
            [[DRIImageManager manager] saveVideoWithUrl:videoUrl location:self.location completion:^(PHAsset *asset, NSError *error) {
                if (!error) {
                    DRIAssetModel *assetModel = [self addPHAsset:asset];
                    imagePickerVc.selectedModels = [[NSMutableArray alloc] initWithObjects:assetModel, nil];
                    imagePickerVc.selectedAssets = [[NSMutableArray alloc] initWithObjects:assetModel.asset, nil];
                    imagePickerVc.selectedAssetIds = [[NSMutableArray alloc] initWithObjects:assetModel.asset.localIdentifier, nil];
                    _popAnimation = NO;
                    [self doneButtonClick];
                }
            }];
            self.location = nil;
        }
    }
}
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        DRIImagePickerController *imagePickerVc = (DRIImagePickerController *)self.navigationController;
        [imagePickerVc showProgressHUD];
        UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (photo) {
            [[DRIImageManager manager] savePhotoWithImage:photo location:self.location completion:^(PHAsset *asset, NSError *error){
                if (!error) {
                    [self addPHAsset:asset];
                }
            }];
            self.location = nil;
        }
    } else if ([type isEqualToString:@"public.movie"]) {
        DRIImagePickerController *imagePickerVc = (DRIImagePickerController *)self.navigationController;
        [imagePickerVc showProgressHUD];
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        if (videoUrl) {
            [[DRIImageManager manager] saveVideoWithUrl:videoUrl location:self.location completion:^(PHAsset *asset, NSError *error) {
                if (!error) {
                    [self addPHAsset:asset];
                }
            }];
            self.location = nil;
        }
    }
}

- (DRIAssetModel *)addPHAsset:(PHAsset *)asset {
    DRIAssetModel *assetModel = [[DRIImageManager manager] createModelWithAsset:asset];
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    [driImagePickVc hideProgressHUD];
    if (driImagePickVc.sortAscendingByModificationDate) {
        [_models addObject:assetModel];
    } else {
        [_models insertObject:assetModel atIndex:0];
    }
    
    if (driImagePickVc.maxImagesCount <= 1) {
        if (driImagePickVc.allowCrop && asset.mediaType == PHAssetMediaTypeImage) {
            DRIPhotoPreviewController *photoPreviewVc = [[DRIPhotoPreviewController alloc] init];
            if (driImagePickVc.sortAscendingByModificationDate) {
                photoPreviewVc.currentIndex = _models.count - 1;
            } else {
                photoPreviewVc.currentIndex = 0;
            }
            photoPreviewVc.models = _models;
            [self pushPhotoPrevireViewController:photoPreviewVc];
        } else {
            [driImagePickVc addSelectedModel:assetModel];
            [self doneButtonClick];
        }
        return assetModel;
    }
    
    if (driImagePickVc.selectedModels.count < driImagePickVc.maxImagesCount) {
        if (assetModel.type == DRIAssetModelMediaTypeVideo && !driImagePickVc.allowPickingMultipleVideo) {
            // 不能多选视频的情况下，不选中拍摄的视频
        } else {
            assetModel.isSelected = YES;
            [driImagePickVc addSelectedModel:assetModel];
            [self refreshBottomToolBarStatus];
        }
    }
    _collectionView.hidden = YES;
    [_collectionView reloadData];
    
    _shouldScrollToBottom = YES;
    [self scrollCollectionViewToBottom];
    return assetModel;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    // NSLog(@"%@ dealloc",NSStringFromClass(self.class));
}

#pragma mark - Asset Caching

- (void)resetCachedAssets {
    [[DRIImageManager manager].cachingImageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect.
    CGRect preheatRect = _collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    /*
     Check if the collection view is showing an area that is significantly
     different to the last preheated area.
     */
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(_collectionView.bounds) / 3.0f) {
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        // Update the assets the PHCachingImageManager is caching.
        [[DRIImageManager manager].cachingImageManager startCachingImagesForAssets:assetsToStartCaching
                                                                       targetSize:DRIAssetGridThumbnailSize
                                                                      contentMode:PHImageContentModeAspectFill
                                                                          options:nil];
        [[DRIImageManager manager].cachingImageManager stopCachingImagesForAssets:assetsToStopCaching
                                                                      targetSize:DRIAssetGridThumbnailSize
                                                                     contentMode:PHImageContentModeAspectFill
                                                                         options:nil];
        
        // Store the preheat rect to compare against in the future.
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        if (indexPath.item < _models.count) {
            DRIAssetModel *model = _models[indexPath.item];
            [assets addObject:model.asset];
        }
    }
    
    return assets;
}

- (NSArray *)aapl_indexPathsForElementsInRect:(CGRect)rect {
    NSArray *allLayoutAttributes = [_collectionView.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) { return nil; }
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}
#pragma mark - Custom
//构造图片Frame数组
- (NSArray<NSValue *> *)firstImageViewFrames{

    NSMutableArray *imageFrames = [NSMutableArray new];
    for (int i = 0; i < _models.count; i ++) {

        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i + _showTakePhotoBtn inSection:0];
        DRIAssetCell * cell = (DRIAssetCell *)[_collectionView  cellForItemAtIndexPath:indexPath];

        if (cell.imageView) {
            //获取当前view在Window上的frame
            CGRect frame = [self getFrameInWindow:cell.imageView];
            [imageFrames addObject:[NSValue valueWithCGRect:frame]];

        }else{//当前不可见的cell,frame设为CGRectZero添加到数组中,防止数组越界
            CGRect frame = CGRectZero;
            [imageFrames addObject:[NSValue valueWithCGRect:frame]];
        }
    }

    return imageFrames;
}
// 获取指定视图在window中的位置
- (CGRect)getFrameInWindow:(UIView *)view
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
@end



@implementation DRICollectionView

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ([view isKindOfClass:[UIControl class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

- (void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
}
#pragma mark - Layout
- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
