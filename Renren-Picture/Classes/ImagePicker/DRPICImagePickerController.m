//
//  DRPICImagePickerController.m
//  Pods
//
//  Created by Luis on 2020/3/2.
//

#import "UIImage+RenrenPicture.h"

#import "DRPICImagePickerController.h"
#import "DRPICImagePickerCollectionViewCell.h"
#import "DRPICAlbumModel.h"
#import "DRPICPhotoModel.h"
#import "DRPICAlbumView.h"
#import "UIView+DRPICCorner.h"
#import "DRPICImagePickerTopBar.h"
#import "DRPICImagePickerBottomBar.h"
#import "DRPICImageManager.h"

static NSString *albumCollectionViewCell = @"DRPICImagePickerCollectionViewCell";

@interface DRPICImagePickerController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong)UICollectionView *albumCollectionView;

@property(nonatomic, strong)UIButton *cancelButton;
@property(nonatomic, strong)UIButton *confirmButton;
@property(nonatomic, strong)UIButton *showAlbumButton;

@property(nonatomic, strong)DRPICImagePickerTopBar *topContainerView;
@property(nonatomic, strong)DRPICImagePickerBottomBar *bottomContainerView;



@property(nonatomic, strong) NSMutableArray<DRPICAlbumModel *> *assetCollectionList;

@property(nonatomic, strong) DRPICAlbumModel *albumModel;

@end

@implementation DRPICImagePickerController

- (NSInteger)maxCount{
    if (_maxCount && _maxCount < 10) {
        return _maxCount;
    }else{
        return 9;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"图片选择器";

    [DRPICImageManager sharedManager].maxCount = self.isMultiSelection?self.maxCount:1;


    NSLog(@"%ld", _maxCount);

    [self configNavigationItems];

    [self.view addSubview:self.topContainerView];
    __weak typeof(self) weakSelf = self;
    self.topContainerView.albumTitleBtnClickBlock = ^(UIButton * _Nonnull sender) {
        sender.selected = !sender.selected;
        [DRPICAlbumView showAlbumView:weakSelf.assetCollectionList navigationBarMaxY:CGRectGetMaxY(weakSelf.navigationController.navigationBar.frame) + 53 completion:^(DRPICAlbumModel *albumModel) {
            if (albumModel) {
                weakSelf.albumModel = albumModel;
            }
            sender.selected = !sender.selected;
        }];
    };
    self.topContainerView.fullImageBtnClickBlock = ^(UIButton * _Nonnull sender) {
        sender.selected = !sender.selected;
    };

//    [self.topContainerView addSubview:self.showAlbumButton];

    [self.view addSubview:self.albumCollectionView];

    [self.view addSubview:self.bottomContainerView];
    self.bottomContainerView.previewBtnClickBlock = ^(UIButton * _Nonnull sender) {
        NSLog(@"点击了预览按钮");
    };
    self.bottomContainerView.nextBtnClickBlock = ^(UIButton * _Nonnull sender) {
        NSLog(@"点击了下一步按钮");
    };

    [self fetchAllAlbumsData];

    [DRPICImageManager sharedManager].selectCountBlock = ^(NSInteger photoCount) {
        if (photoCount != 0) {
            weakSelf.confirmButton.enabled = YES;
        }
        if (photoCount == 0) {
            [weakSelf.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
            [weakSelf.confirmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }else{
            [weakSelf.confirmButton setTitle:[NSString stringWithFormat:@"确定%ld/%ld", [DRPICImageManager sharedManager].selectedCount, [DRPICImageManager sharedManager].maxCount] forState:UIControlStateNormal];
            [weakSelf.confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    };

}

- (void)fetchAllAlbumsData{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //获取个人收藏相册
        PHFetchResult<PHAssetCollection *> *favoritesCollection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumFavorites options:nil];
        //获得相机胶卷
        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        //获得全部相片
        PHFetchResult<PHAssetCollection *> *cameraRolls = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];

        for (PHAssetCollection *colletion in cameraRolls) {
            DRPICAlbumModel *model = [[DRPICAlbumModel alloc]init];
            model.collection = colletion;
            
            if (![model.collectionNumber isEqualToString:@"0"]) {
                [weakSelf.assetCollectionList addObject:model];
            }
        }

        for (PHAssetCollection *colletion in favoritesCollection) {
            DRPICAlbumModel *model = [[DRPICAlbumModel alloc]init];
            model.collection = colletion;
            if (![model.collectionNumber isEqualToString:@"0"]) {
                [weakSelf.assetCollectionList addObject:model];
            }
        }

        for (PHAssetCollection *collection in assetCollections) {
            DRPICAlbumModel *model = [[DRPICAlbumModel alloc]init];
            model.collection = collection;
            if (![model.collectionNumber isEqualToString:@"0"]) {
                [weakSelf.assetCollectionList addObject:model];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.albumModel = weakSelf.assetCollectionList.firstObject;
            [self.albumCollectionView reloadData];
        });
    });

}
/** 配合createLeftBar使用,点击返回事件，子类可重写 */
- (void)eventLeftLeftBarButtonClick:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}
- (void)configNavigationItems{

    UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc] initWithCustomView:self.confirmButton];
    self.navigationItem.rightBarButtonItem = confirmItem;

//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 45)];
//    self.navigationItem.titleView = titleView;
//    [titleView addSubview:self.showAlbumButton];

}
- (void)setAlbumModel:(DRPICAlbumModel *)albumModel{
    _albumModel = albumModel;
    [self.topContainerView setAlbumTitle:albumModel.collectionTitle];
    [self.albumCollectionView reloadData];
}
-(void)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 确认回传已选照片
-(void)confirmAction:(UIButton *)sender {
    NSInteger selectedCount = [DRPICImageManager sharedManager].selectedCount;
    if (selectedCount > 0) {
        sender.enabled = NO;
        NSMutableArray<DRPICPhotoModel *> *photoModelList = [NSMutableArray array];
        __weak typeof(self) weakSelf = self;
        for (DRPICAlbumModel *albumModel in self.assetCollectionList) {
            for (NSNumber *row in albumModel.selectRows){
                if (row.integerValue < albumModel.assets.count) {
                    DRPICPhotoModel *photoModel = [[DRPICPhotoModel alloc]init];
                    __weak typeof(photoModel) weakPhotoModel = photoModel;
                    photoModel.fetchPhotoModelCompletion = ^{
                        [photoModelList addObject:weakPhotoModel];
                        if (photoModelList.count == selectedCount) {
                            sender.enabled = YES;
                            [DRPICImageManager sharedManager].photoModelList = photoModelList;
                            if (weakSelf.imagePickerDidFinishPickinghandler) {
                                weakSelf.imagePickerDidFinishPickinghandler([DRPICImageManager sharedManager].photoModelList);
                            }

                            [weakSelf dismissViewControllerAnimated:YES completion:nil];
                        }
                    };
                    photoModel.asset = albumModel.assets[row.integerValue];
                }
            }
        }
    }
}
#pragma mark UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.albumModel.assets.count + 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.item == 0) {
        DRPICAssetCameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DRPICAssetCameraCell" forIndexPath:indexPath];
        return cell;
    }
    DRPICImagePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:albumCollectionViewCell forIndexPath:indexPath];
    NSInteger index = indexPath.row - 1;
    cell.row = index;
    cell.asset = self.albumModel.assets[index];
    [cell loadImage:indexPath];
    cell.isSelected = [self.albumModel.selectRows containsObject:@(index)];
    __weak typeof(self) weakSelf = self;
    __weak typeof(cell) weakCell = cell;

    cell.selectedActionBlock = ^(PHAsset * _Nullable asset) {
        BOOL isReloadCollectionView = NO;
        if ([weakSelf.albumModel.selectRows containsObject:@(index)]) {
            [weakSelf.albumModel.selectRows removeObject:@(index)];
            [DRPICImageManager sharedManager].selectedCount--;
            isReloadCollectionView = [DRPICImageManager sharedManager].selectedCount == weakSelf.maxCount - 1;
        }else{
            if ([DRPICImageManager sharedManager].maxCount == [DRPICImageManager sharedManager].selectedCount) {
                return ;
            }
            [weakSelf.albumModel.selectRows addObject:@(index)];
            [DRPICImageManager sharedManager].selectedCount++;
            isReloadCollectionView = [DRPICImageManager sharedManager].selectedCount == weakSelf.maxCount;

        }

        if (isReloadCollectionView) {
            [weakSelf.albumCollectionView reloadData];
        }else{
            weakCell.isSelected = [weakSelf.albumModel.selectRows containsObject:@(index)];
        }
    };
    return cell;
}

#pragma mark LazyLoad
- (UICollectionView *)albumCollectionView{
    if (!_albumCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 2.0f;
        layout.minimumInteritemSpacing = 2.0f;
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - 2 * 3) / 4, (SCREEN_WIDTH - 2 * 3) / 4);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 2, 0); //设置距离上 左 下 右
        _albumCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.topContainerView.ct_bottom, SCREEN_WIDTH, SCREEN_HEIGHT - DNTabbarHeight - 53) collectionViewLayout:layout];
        _albumCollectionView.delegate = self;
        _albumCollectionView.dataSource = self;
        _albumCollectionView.backgroundColor = [UIColor whiteColor];
        _albumCollectionView.scrollEnabled = YES;
        _albumCollectionView.alwaysBounceVertical = YES;
        [_albumCollectionView registerClass:[DRPICImagePickerCollectionViewCell class] forCellWithReuseIdentifier:albumCollectionViewCell];
        [_albumCollectionView registerClass:[DRPICAssetCameraCell class] forCellWithReuseIdentifier:@"DRPICAssetCameraCell"];

    }
    return _albumCollectionView;
}

-(UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 0, 50, 50);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _cancelButton;
}

-(UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.enabled = NO;
        _confirmButton.frame = CGRectMake(0, 0, 80, 45);
        _confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }

    return _confirmButton;
}

#pragma mark 顶部容器view
- (DRPICImagePickerTopBar *)topContainerView{
    if (!_topContainerView) {
        _topContainerView = [[DRPICImagePickerTopBar alloc]initWithFrame:CGRectMake(0, DNNavHeight, SCREEN_WIDTH, 53)];
    }
    return _topContainerView;
}
#pragma mark 底部容器view
- (DRPICImagePickerBottomBar *)bottomContainerView{
    if (!_bottomContainerView) {
        _bottomContainerView = [[DRPICImagePickerBottomBar alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 116, SCREEN_WIDTH, 116)];
    }
    return _bottomContainerView;
}
- (NSMutableArray *)assetCollectionList{
    if (!_assetCollectionList) {
        _assetCollectionList = [NSMutableArray array];
    }
    return _assetCollectionList;
}

@end
