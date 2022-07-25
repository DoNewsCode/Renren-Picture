//
//  DRPICPicturePickerViewController.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/10.
//

#import "DRPICPicturePickerViewController.h"

#import "DRPICMainNavigationController.h"

#import "DRPICPicturePickerCameraCollectionViewCell.h"
#import "DRPICPicturePickerCollectionViewCell.h"

#import "UIView+CTLayout.h"
#import "UIImage+DRRResourceKit.h"

#import "DRPICPicturePreviewViewController.h"

#import "DRPICPictureManager.h"

#import "DRMECameraViewController.h"
#import "DRPPop.h"
#import "DRIImageManager.h"

@interface DRPICPicturePickerViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,DRPICPicturePickerAlbumViewControllerDelegate,DRPICPicturePreviewViewControllerDelegate>

@property (nonatomic, assign) BOOL reload;

/// 相机控制器
@property (nonatomic, strong) DRMECameraViewController *cameraViewController;

@end

@implementation DRPICPicturePickerViewController

#pragma mark - Override Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createContent];
    [self createNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createNavigation];
    if (self.reload) {
        [self.collectionView reloadData];
        [self.albumViewController.tableView reloadData];
        self.reload = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    self.reload = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    for (DRPICPicture *picture in self.viewModel.model.currentAlbum.pictures) {
        picture.source.thumbnailImage = nil;
        picture.source.originImage = nil;
        picture.source.showImage = nil;
    }
}

#pragma mark - Intial Methods
-(DRMECameraViewController *)cameraViewController{
    if (!_cameraViewController) {
        _cameraViewController = [DRMECameraViewController new];
        _cameraViewController.showAlbumBtn = NO;
        _cameraViewController.onlyTakePhoto = NO;
        _cameraViewController.onlyTakeVideo = NO;
        [_cameraViewController hidesBottomBarWhenPushed];
    }
    return _cameraViewController;
}

#pragma mark - Create Methods
- (void)createContent {
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectedPicturesMaxCount = 9;
    __weak typeof(self) weakSelf = self;
    [self.viewModel createAlbumComplete:^(BOOL success) {
        if (success) {
            weakSelf.viewModel.model.selectedPicturesMaxCount = 9;
            [weakSelf creatPrepare];
        }
    }];
}

- (void)creatPrepare {
    CGFloat y = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    CGFloat albumHeight = 50.;
    self.albumViewController.view.ct_y = y;
    self.albumViewController.view.ct_height = albumHeight;
    self.albumViewController.expandViewHeight = self.view.ct_height - y;
    self.albumViewController.stowedViewHeight = albumHeight;
    CGFloat collectionViewY = CGRectGetMaxY(self.albumViewController.view.frame);
    self.collectionView.frame = (CGRect){0.,collectionViewY,self.view.ct_width,self.view.ct_height - collectionViewY};
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.albumViewController.view];
    self.albumViewController.viewModel = self.viewModel;
    [self.albumViewController createContent];
    [self.albumViewController.tableView reloadData];
    [self.view addSubview:self.viewModel.levitateView];
    
    //    self.viewModel.levitateView.backgroundColor = [UIColor redColor];
    //    self.viewModel.levitateView.frame = CGRectMake(0, self.view.ct_height - self.viewModel.levitateView.ct_height, self.view.ct_width, self.viewModel.levitateView.ct_height);
    
    self.viewModel.levitateView.frame = CGRectMake(0, self.view.ct_height, self.view.ct_width, self.viewModel.levitateView.ct_height);
    if (self.viewModel.model.selectedPictures.count > 0) {
        [self.viewModel.levitateView setHidden:NO animaed:NO];
    } else {
        [self.viewModel.levitateView setHidden:YES animaed:NO];
    }
    
    [self.viewModel.levitateView.orginalButton addTarget:self action:@selector(eventTouchUpInsideForLevitateViewOrginalButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewModel.levitateView.nextStepButton addTarget:self action:@selector(eventTouchUpInsideForLevitateViewNextStepButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewModel.levitateView.previewButton addTarget:self action:@selector(eventTouchUpInsideForLevitateViewPreviewButtonButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.collectionView reloadData];
    
}

- (void)createNavigation {
    UIImage *imageTemp = [UIImage ct_imageResourceKitWithNamed:@"nav_button_close_default"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:imageTemp forState:UIControlStateNormal];
    [button setImage:imageTemp forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(eventTouchUpInsideForLetfNavigationItemButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)createNotifications {
    
}

- (void)createThemeChange {
    
}

#pragma mark - Process Methods
- (void)processLevitateView {
    CGFloat levitateViewY = self.view.ct_height;
    if (self.viewModel.model.selectedPictures.count > 0) {
        levitateViewY =  self.view.ct_height - self.viewModel.levitateView.ct_height;
    }
    [UIView animateWithDuration:0.618
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.viewModel.levitateView.ct_y = levitateViewY;
    }completion:^(BOOL finished) {
    }];
}

#pragma mark - Event Methods
- (void)eventForEventBlock:(DRPICPicturePickerViewControllerEventBlock)eventBlock {
    self.eventBlock = eventBlock;
}

- (void)eventTouchUpInsideForLevitateViewOrginalButton:(UIButton *)button {
    button.selected = !button.selected;
}

- (void)eventTouchUpInsideForLevitateViewNextStepButton:(UIButton *)button {
    if (self.viewModel.model.selectedPictures.count == 0) {
        return;
    }
    if (self.eventBlock) {
        self.eventBlock(self.viewModel.model.selectedPictures);
    }
    [self eventTouchUpInsideForLetfNavigationItemButton:nil];
}

- (void)eventTouchUpInsideForLevitateViewPreviewButtonButton:(UIButton *)button {
    if (self.viewModel.model.selectedPictures.count == 0) {
        return;
    }
    DRPICPicturePreviewViewController *picturePreviewViewController = [DRPICPicturePreviewViewController new];
    picturePreviewViewController.viewModel.model.album = self.viewModel.model.currentAlbum;
    picturePreviewViewController.viewModel.model.selectedPictures = self.viewModel.model.selectedPictures;
    picturePreviewViewController.viewModel.model.currentPicture =  self.viewModel.model.selectedPictures.firstObject;
    picturePreviewViewController.viewModel.model.albums = self.viewModel.model.albums;
    picturePreviewViewController.viewModel.model.selectedPicturesMaxCount = self.viewModel.model.selectedPicturesMaxCount;
    picturePreviewViewController.viewModel.model.selectedPicturesCount = self.viewModel.model.selectedPicturesCount;
    picturePreviewViewController.viewModel.levitateView.nextStepButton.title = self.viewModel.levitateView.nextStepButton.title;
    picturePreviewViewController.viewModel.levitateView.orginalButton.selected = self.viewModel.levitateView.orginalButton.selected;
    picturePreviewViewController.delegate = self;
    [self.navigationController pushViewController:picturePreviewViewController animated:YES];
}

- (void)eventTouchUpInsideForLetfNavigationItemButton:(UIButton *)button {
    if (self.navigationController) {
        if ([self.navigationController isKindOfClass:[DRPICMainNavigationController class]]) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.albumViewController processViewExpand:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

#pragma mark - UICollectionViewDataSource Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.viewModel.model.hiddenForCameraButton == NO) {
            return self.viewModel.model.currentAlbum.pictures.count + 1;
        } else {
            return self.viewModel.model.currentAlbum.pictures.count;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0 && self.viewModel.model.hiddenForCameraButton == NO) {
            reuseIdentifier = @"CameraItem";
            DRPICPicturePickerCameraCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            return cell;
        } else {
            return [self processPicturePickerCollectionViewCellForCollectionView:collectionView cellForItemAtIndexPath:indexPath];
        }
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (DRPICPicturePickerCollectionViewCell *)processPicturePickerCollectionViewCellForCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"PictureItem";
    NSInteger index = indexPath.row;
    if (self.viewModel.model.hiddenForCameraButton == NO) {
        index -= 1;
    }
    DRPICPicturePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (self.viewModel.model.currentAlbum.pictures.count > index && index >= 0) {
        cell.picture = self.viewModel.model.currentAlbum.pictures[index];
    }
    __weak typeof(self) weakSelf = self;
    [cell eventForSelectButtonEventBlock:^(DRPICPicturePIckerSelectButton * _Nonnull selectButton, DRPICPicture * _Nonnull picture) {
        if (cell.enabled == NO || picture == nil) {
            return ;
        }
        if (picture.status.selected == NO) {// 未被选中的将要进入选中流程
            
            [[DRPICPictureManager sharedPictureManager] obtainImageWithAsset:picture.source.asset completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info, BOOL isDegraded) {
                
                NSLog(@"ffff1---------------%d--------",isDegraded);
                if (isDegraded) return;
                NSLog(@"ffff2--------------%d--------",isDegraded);
                
                BOOL success = [weakSelf.viewModel processSelectedPicture:picture];
                [cell setSelected:picture.status.selected selectedIndex:picture.status.selectedIndex animated:YES completion:^(BOOL finished) {
                    if (success && weakSelf.viewModel.model.selectedPictures.count >= weakSelf.viewModel.model.selectedPicturesMaxCount) {
                        [collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([obj isKindOfClass:[DRPICPicturePickerCollectionViewCell class]] == NO) {
                                return ;
                            }
                            DRPICPicturePickerCollectionViewCell *collectionViewCell = (DRPICPicturePickerCollectionViewCell *)obj;
                            if (obj == cell) {
                                return;
                            }
                            collectionViewCell.picture = collectionViewCell.picture;
                        }];
                    }
                }];
                [weakSelf processLevitateView];
                
            } progress:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
                
                weakSelf.loadingView.hidden = progress;
                weakSelf.loadingView.progress = progress;
                
                NSLog(@"ffff00---------------%f--------",progress);
                if (progress < 1) return;
                NSLog(@"ffff01---------------%f--------",progress);
                *stop = YES;
                
                BOOL success = [weakSelf.viewModel processSelectedPicture:picture];
                [cell setSelected:picture.status.selected selectedIndex:picture.status.selectedIndex animated:YES completion:^(BOOL finished) {
                    if (success && weakSelf.viewModel.model.selectedPictures.count >= weakSelf.viewModel.model.selectedPicturesMaxCount) {
                        [collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([obj isKindOfClass:[DRPICPicturePickerCollectionViewCell class]] == NO) {
                                return ;
                            }
                            DRPICPicturePickerCollectionViewCell *collectionViewCell = (DRPICPicturePickerCollectionViewCell *)obj;
                            if (obj == cell) {
                                return;
                            }
                            collectionViewCell.picture = collectionViewCell.picture;
                        }];
                    }
                }];
                [weakSelf processLevitateView];
                
            } networkAccessAllowed:YES];
            
        } else {// 被选中的将要进入撤销选中流程
            [weakSelf.viewModel processCancelSelectedPicture:picture];
            [cell setSelected:picture.status.selected selectedIndex:picture.status.selectedIndex animated:YES completion:^(BOOL finished) {
                [collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[DRPICPicturePickerCollectionViewCell class]] == NO) {
                        return ;
                    }
                    DRPICPicturePickerCollectionViewCell *collectionViewCell = (DRPICPicturePickerCollectionViewCell *)obj;
                    if (obj == cell) {
                        return;
                    }
                    collectionViewCell.picture = collectionViewCell.picture;
                }];
                //                        [weakSelf.collectionView reloadData];
            }];
            [weakSelf processLevitateView];
        }
    }];
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.model.hiddenForCameraButton == NO && indexPath.row == 0) {
        
        //当前新增的功能，摄像
        UINavigationController *cameraNavigationController = [[UINavigationController alloc] initWithRootViewController:self.cameraViewController];
        cameraNavigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:cameraNavigationController animated:YES completion:nil];
        @weakify(self);
        [self.cameraViewController setCameraEditCompleteBlock:^(UIImage * _Nonnull editImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [DRPPop showLoadingHUDWithMessage:@"正在处理，请稍等"];
            });
            __block NSString *identifier = @"";
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                /// 会保存一个新图片到相册
                PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImage:editImage];
                identifier = request.placeholderForCreatedAsset.localIdentifier;
                
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                @strongify(self);
                PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[identifier] options:nil].firstObject;
                DRPICPicture *pictureM = [[DRPICPicture alloc] init];
                DRPICPictureSource *sourceM = [[DRPICPictureSource alloc] init];
                sourceM.asset = asset;
                pictureM.source = sourceM;
                if (self.eventBlock) {
                    self.eventBlock(@[pictureM]);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [DRPPop hideLoadingHUD];
                    [self eventTouchUpInsideForLetfNavigationItemButton:nil];
                });
            }];
        }];
        [self.cameraViewController setEditVideoCompleteBlock:^(NSString * _Nonnull videoPath) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 [DRPPop showLoadingHUDWithMessage:@"正在处理，请稍等"];
             });
            if (videoPath == nil) return;
            [[DRIImageManager manager] saveVideoWithUrl:[NSURL URLWithString:videoPath] completion:^(PHAsset *asset, NSError *error) {
                if (error) return;
                @strongify(self);
                DRPICPicture *picM = [[DRPICPicture alloc] init];
                DRPICPictureSource *sourM = [[DRPICPictureSource alloc] init];
                sourM.asset = asset;
                picM.source = sourM;
                if (self.eventBlock) {
                    self.eventBlock(@[picM]);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [DRPPop hideLoadingHUD];
                    [self eventTouchUpInsideForLetfNavigationItemButton:nil];
                });
            }];
        }];
        
        return;
    }
    NSInteger index = indexPath.row;
    if (self.viewModel.model.hiddenForCameraButton == NO) {
        index -= 1;
    }
    DRPICPicture *picture = self.viewModel.model.currentAlbum.pictures[index];
    if (picture.status.isEnabled == NO) {
        return;
    }
    DRPICPicturePreviewViewController *picturePreviewViewController = [DRPICPicturePreviewViewController new];
    picturePreviewViewController.viewModel.model.album = self.viewModel.model.currentAlbum;
    picturePreviewViewController.viewModel.model.selectedPictures = self.viewModel.model.selectedPictures;
    picturePreviewViewController.viewModel.model.currentPicture = picture;
    picturePreviewViewController.viewModel.model.albums = self.viewModel.model.albums;
    picturePreviewViewController.viewModel.model.selectedPicturesMaxCount = self.viewModel.model.selectedPicturesMaxCount;
    picturePreviewViewController.viewModel.model.selectedPicturesCount = self.viewModel.model.selectedPicturesCount;
    picturePreviewViewController.viewModel.levitateView.nextStepButton.title = self.viewModel.levitateView.nextStepButton.title;
    picturePreviewViewController.viewModel.levitateView.orginalButton.selected = self.viewModel.levitateView.orginalButton.selected;
    picturePreviewViewController.delegate = self;
    [self.navigationController pushViewController:picturePreviewViewController animated:YES];
}

#pragma mark - DRPICPicturePreviewViewControllerDelegate Methods
- (void)picturePreviewViewController:(DRPICPicturePreviewViewController *)picturePreviewViewController selectForPicture:(DRPICPicture *)picture selected:(BOOL)selected {
    if (selected) {
        [self.viewModel processSelectedPicture:picture];
    } else {
        [self.viewModel processCancelSelectedPicture:picture];
    }
}

- (void)picturePreviewViewControllerForEventTouchUpInsideForLevitateViewNextStepButton:(DRPICPicturePreviewViewController *)picturePreviewViewController {
    [self eventTouchUpInsideForLevitateViewNextStepButton:nil];
}

#pragma mark - DRPICPicturePickerAlbumViewControllerDelegate Methods
- (void)albumViewController:(DRPICPicturePickerAlbumViewController *)albumViewController didSelectAlbumAtIndex:(NSInteger)index album:(DRPICAlbum *)album {
    if (self.viewModel.model.selectedPictures.count > 0) {
        [self.viewModel.levitateView setHidden:NO animaed:YES];
    } else {
        [self.viewModel.levitateView setHidden:YES animaed:YES];
    }
    [self.collectionView reloadData];
}

#pragma mark - LazyLoad Methods
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.collectionViewFlowLayout];
        [collectionView setBackgroundColor:[UIColor clearColor]];
        if (@available(iOS 11.0, *)) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        collectionView.bounces = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[DRPICPicturePickerCameraCollectionViewCell class] forCellWithReuseIdentifier:@"CameraItem"];
        [collectionView registerClass:[DRPICPicturePickerCollectionViewCell class] forCellWithReuseIdentifier:@"PictureItem"];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout {
    if (!_collectionViewFlowLayout) {
        UICollectionViewFlowLayout *collectionViewFlowLayout = [UICollectionViewFlowLayout new];
        collectionViewFlowLayout.itemSize = CGSizeMake(([UIApplication sharedApplication].keyWindow.bounds.size.width - 2 * 3) / 4, ([UIApplication sharedApplication].keyWindow.bounds.size.width - 2 * 3) / 4);
        collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 2, 0); //设置距离上 左 下 右
        collectionViewFlowLayout.minimumLineSpacing = 2.0;
        collectionViewFlowLayout.minimumInteritemSpacing = 2.0;
        collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionViewFlowLayout = collectionViewFlowLayout;
    }
    return _collectionViewFlowLayout;
}

- (DRPICLoadingView *)loadingView {
    if (!_loadingView) {
        DRPICLoadingView *loadingView = [DRPICLoadingView new];
        _loadingView = loadingView;
        [self.view addSubview:loadingView];
        loadingView.hidden = YES;
        loadingView.frame = CGRectMake(0, 0, 40, 40);
        loadingView.center = self.view.center;
    }
    return _loadingView;
}

- (DRPICPicturePickerPickingOriginalButton *)orginalButton {
    if (!_orginalButton) {
        DRPICPicturePickerPickingOriginalButton *orginalButton = [DRPICPicturePickerPickingOriginalButton buttonWithType:UIButtonTypeCustom];
        _orginalButton = orginalButton;
    }
    return _orginalButton;
}

- (DRPICPicturePickerViewModel *)viewModel {
    if (!_viewModel) {
        DRPICPicturePickerViewModel *viewModel = [DRPICPicturePickerViewModel new];
        _viewModel = viewModel;
    }
    return _viewModel;
}

- (DRPICPicturePickerAlbumViewController *)albumViewController {
    if (!_albumViewController) {
        DRPICPicturePickerAlbumViewController *albumViewController = [DRPICPicturePickerAlbumViewController new];
        albumViewController.delegate = self;
        _albumViewController = albumViewController;
    }
    return _albumViewController;
}



@end
