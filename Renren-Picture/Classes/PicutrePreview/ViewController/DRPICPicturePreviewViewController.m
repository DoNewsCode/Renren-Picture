//
//  DRPICPicturePreviewViewController.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/17.
//

#import "DRPICPicturePreviewViewController.h"

#import "DRPICPicturePreviewCollectionViewCell.h"

#import "UIView+CTLayout.h"
#import "UIImage+RenrenPicture.h"
#import "UIColor+CTHex.h"
#import "UIFont+DRBFont.h"

#import "DNRouter.h"
#import <Photos/Photos.h>

#import "DRPICPictureManager.h"

@interface DRPICPicturePreviewViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,DRPICPicturePreviewChannelViewControllerDelegate>

@property (nonatomic, assign) BOOL dragging;
@property (nonatomic, strong) UIBarButtonItem *rightNavigationItem;

@end

@implementation DRPICPicturePreviewViewController

#pragma mark - Override Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createContent];
    [self createNotifications];
    
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createNavigation];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.viewModel.model.album.pictures indexOfObject:self.viewModel.model.currentPicture] inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    [self createNavigation];
    if ([self.viewModel.model.selectedPictures containsObject:self.viewModel.model.currentPicture]) {
        [self.selectButton setSelected:YES animated:YES];
        self.selectButton.index = [self.viewModel.model.selectedPictures indexOfObject:self.viewModel.model.currentPicture] + 1;
    }
    [self.viewModel processContent];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.viewModel.previewChannelViewController processChannelItemSelectedWithPicture:self.viewModel.model.currentPicture selected:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    for (DRPICPicture *picture in self.viewModel.model.album.pictures) {
        picture.source.thumbnailImage = nil;
        picture.source.originImage = nil;
        picture.source.showImage = nil;
    }
}
#pragma mark - Intial Methods

#pragma mark - Create Methods
- (void)createContent {
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.viewModel.previewChannelViewController.view];
    [self.view addSubview:self.viewModel.levitateView];
    self.viewModel.levitateView.ct_y = CGRectGetMaxY(self.collectionView.frame);
    CGFloat previewChannelViewHeight = 90;
    CGFloat previewChannelViewY = self.viewModel.levitateView.ct_y - previewChannelViewHeight;
    self.viewModel.previewChannelViewController.view.frame = (CGRect){0.,previewChannelViewY,self.view.ct_width,previewChannelViewHeight};
    
    self.viewModel.previewChannelViewController.viewModel.model.pictures = self.viewModel.model.selectedPictures;
    self.viewModel.levitateView.nextStepButton.title = @"完成";
}

- (void)createNavigation {
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.rightBarButtonItem = self.rightNavigationItem;
}

- (void)createNotifications {
    
}

- (void)createThemeChange {
    
}

#pragma mark - Process Methods

#pragma mark - Event Methods
- (void)eventTouchUpInsideForLevitateViewEditButtonButton:(UIButton *)button {
    __weak typeof(self) weakSelf = self;
    if (self.viewModel.model.currentPicture.source.type == DRPICPictureSourceTypeEdited) {
        [DNRouter openURL:@"RR://MaterialEditor/PhotoEdit" withUserInfo:@{@"navigationVC" : self.navigationController,@"originImage" : self.viewModel.model.currentPicture.source.editedImage} completion:^(id  _Nullable result) {
            [weakSelf processEditImageCompleteWithResult:result];
        }];
    } else {
        [[DRPICPictureManager sharedPictureManager] obtainOrginImageWithAsset:self.viewModel.model.currentPicture.source.asset completion:^(NSData * _Nonnull imageData, UIImageOrientation orientation, NSDictionary * _Nonnull info, BOOL isDegraded) {
            UIImage* image = [UIImage imageWithData:imageData];
            if (orientation != UIImageOrientationUp) {
                // 尽然弯了,那就板正一下
                image = [[DRPICPictureManager sharedPictureManager] processImageFixOrientation:image];
            }
            [DNRouter openURL:@"RR://MaterialEditor/PhotoEdit" withUserInfo:@{@"navigationVC" : self.navigationController,@"originImage" : image} completion:^(id  _Nullable result) {
                [weakSelf processEditImageCompleteWithResult:result];
            }];
        } progress:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
            
        } networkAccessAllowed:YES];
        
    }
    
    
}

- (void)processEditImageCompleteWithResult:(id)result {
    if ([result isKindOfClass:[NSDictionary class]] == NO) {
        return;
    }
    NSDictionary *resultDictionary = (NSDictionary *)result;
    UIImage *editImage = [resultDictionary valueForKey:@"editImage"];
    if (editImage == nil) {
        return;
    }
    self.viewModel.model.currentPicture.source.type = DRPICPictureSourceTypeEdited;
    self.viewModel.model.currentPicture.source.editedImage = editImage;
    [self.collectionView reloadData];
}

- (void)eventTouchUpInsideForLevitateViewNextStepButton:(UIButton *)button {
    __weak typeof(self) weakSelf = self;
    if ([self.viewModel.model.selectedPictures containsObject:self.viewModel.model.currentPicture] == NO) {
        [self.viewModel.previewChannelViewController.collectionView performBatchUpdates:^{
            
            if ([weakSelf.viewModel processSelectedPicture:weakSelf.viewModel.model.currentPicture]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[weakSelf.viewModel.model.selectedPictures indexOfObject:weakSelf.viewModel.model.currentPicture] inSection:0];
                [weakSelf.viewModel.previewChannelViewController.collectionView insertItemsAtIndexPaths:@[indexPath]];
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(picturePreviewViewController:selectForPicture:selected:)]) {
                    [weakSelf.delegate picturePreviewViewController:weakSelf selectForPicture:weakSelf.viewModel.model.currentPicture selected:YES];
                }
            }
            
        } completion:^(BOOL finished) {
            
            self.selectButton.index = [self.viewModel.model.selectedPictures indexOfObject:self.viewModel.model.currentPicture] + 1;
            [self.selectButton setSelected:YES animated:YES];
            [self.viewModel.previewChannelViewController processChannelItemSelectedWithPicture:self.viewModel.model.currentPicture selected:YES];
        }];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(picturePreviewViewControllerForEventTouchUpInsideForLevitateViewNextStepButton:)]) {
        [self.delegate picturePreviewViewControllerForEventTouchUpInsideForLevitateViewNextStepButton:self];
    }
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (void)eventTouchUpInsideForSelectButton:(DRPICPicturePIckerSelectButton *)selectButton {
    if (selectButton.selected == NO) {
        __weak typeof(self) weakSelf = self;
        [self.viewModel.previewChannelViewController.collectionView performBatchUpdates:^{
            
            if ([weakSelf.viewModel processSelectedPicture:weakSelf.viewModel.model.currentPicture]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[weakSelf.viewModel.model.selectedPictures indexOfObject:weakSelf.viewModel.model.currentPicture] inSection:0];
                [weakSelf.viewModel.previewChannelViewController.collectionView insertItemsAtIndexPaths:@[indexPath]];
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(picturePreviewViewController:selectForPicture:selected:)]) {
                    [weakSelf.delegate picturePreviewViewController:weakSelf selectForPicture:weakSelf.viewModel.model.currentPicture selected:YES];
                }
            }
            
        } completion:^(BOOL finished) {
            
            selectButton.index = [self.viewModel.model.selectedPictures indexOfObject:self.viewModel.model.currentPicture] + 1;
            [selectButton setSelected:YES animated:YES];
            [self.viewModel.previewChannelViewController processChannelItemSelectedWithPicture:self.viewModel.model.currentPicture selected:YES];
        }];
        
    } else {
        if ([self.viewModel.model.selectedPictures containsObject:self.viewModel.model.currentPicture]) {
            __weak typeof(self) weakSelf = self;
            [self.viewModel.previewChannelViewController.collectionView performBatchUpdates:^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[weakSelf.viewModel.model.selectedPictures indexOfObject:weakSelf.viewModel.model.currentPicture] inSection:0];
                if ([weakSelf.viewModel processCancelSelectedPicture:weakSelf.viewModel.model.currentPicture]) {
                    [weakSelf.viewModel.previewChannelViewController.collectionView deleteItemsAtIndexPaths:@[indexPath]];
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(picturePreviewViewController:selectForPicture:selected:)]) {
                        [weakSelf.delegate picturePreviewViewController:weakSelf selectForPicture:weakSelf.viewModel.model.currentPicture selected:NO];
                    }
                }
                
            } completion:^(BOOL finished) {
                
                [selectButton setSelected:NO animated:YES];
            }];
        }
        
    }
}


- (void)eventTouchUpInsideForLevitateViewOrginalButton:(UIButton *)button {
    button.selected = !button.selected;
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.dragging = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.dragging = NO;
    if ([self.viewModel.model.selectedPictures containsObject:self.viewModel.model.currentPicture]) {
        [self.selectButton setSelected:YES animated:YES];
        self.selectButton.index = [self.viewModel.model.selectedPictures indexOfObject:self.viewModel.model.currentPicture] + 1;
    } else {
        [self.selectButton setSelected:NO animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.dragging == NO) {
        return;
    }
    NSInteger index = self.collectionView.contentOffset.x / self.collectionView.ct_width;
    DRPICPicture *picture = self.viewModel.model.album.pictures[index];
    if (self.viewModel.model.currentPicture == picture) {
        return;
    }
    [self.viewModel.previewChannelViewController processChannelItemSelectedWithPicture:picture selected:YES];
    self.viewModel.model.currentPicture = picture;
}


#pragma mark - UICollectionViewDataSource Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.viewModel.model.album) {
        return self.viewModel.model.album.pictures.count;
    }
    
    return self.viewModel.model.selectedPictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DRPICPicturePreviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picturePreviewCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    DRPICPicture *picture = self.viewModel.model.album.pictures[indexPath.row];
    cell.picture = picture;
    
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - DRPICPicturePreviewChannelViewControllerDelegate Methods
- (void)channelViewController:(DRPICPicturePreviewChannelViewController *)channelViewController didSelectChannelAtIndex:(NSInteger)index picture:(DRPICPicture *)picture {
    BOOL hasPicture = [self.viewModel.model.album.pictures containsObject:picture];
    if (hasPicture == NO) {
        return;
    }
    if ([self.viewModel.model.selectedPictures containsObject:self.viewModel.model.currentPicture]) {
        [self.selectButton setSelected:YES animated:YES];
        self.selectButton.index = [self.viewModel.model.selectedPictures indexOfObject:self.viewModel.model.currentPicture] + 1;
    } else {
        [self.selectButton setSelected:NO animated:YES];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.viewModel.model.album.pictures indexOfObject:picture] inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}


#pragma mark - LazyLoad Methods
- (DRPICPicturePreviewViewModel *)viewModel {
    if (!_viewModel) {
        DRPICPicturePreviewViewModel *viewModel = [DRPICPicturePreviewViewModel new];
        [viewModel.levitateView.nextStepButton addTarget:self action:@selector(eventTouchUpInsideForLevitateViewNextStepButton:) forControlEvents:UIControlEventTouchUpInside];
        [viewModel.levitateView.editButton addTarget:self action:@selector(eventTouchUpInsideForLevitateViewEditButtonButton:) forControlEvents:UIControlEventTouchUpInside];
        [viewModel.levitateView.orginalButton addTarget:self action:@selector(eventTouchUpInsideForLevitateViewOrginalButton:) forControlEvents:UIControlEventTouchUpInside];
        _viewModel = viewModel;
    }
    return _viewModel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat collectionViewWidth = self.view.ct_width;
        CGFloat bottomHeight = 49;
        if ([UIApplication sharedApplication].statusBarFrame.size.height > 20) {
            bottomHeight += 34;
        }
        CGFloat collectionViewY = [UIApplication sharedApplication].statusBarFrame.size.height + 44;
        CGFloat collectionViewHeight = self.view.ct_height - [UIApplication sharedApplication].statusBarFrame.size.height - 44 - self.viewModel.levitateView.ct_height;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:(CGRect){-10,collectionViewY,collectionViewWidth + 20,collectionViewHeight} collectionViewLayout:self.collectionViewFlowLayout];
        [collectionView setBackgroundColor:[UIColor clearColor]];
        if (@available(iOS 11.0, *)) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        collectionView.bounces = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        
        [collectionView registerClass:[DRPICPicturePreviewCollectionViewCell class] forCellWithReuseIdentifier:@"picturePreviewCollectionViewCell"];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout {
    if (!_collectionViewFlowLayout) {
        CGFloat collectionViewWidth = self.view.ct_width;
        CGFloat bottomHeight = 49;
        if ([UIApplication sharedApplication].statusBarFrame.size.height > 20) {
            bottomHeight += 34;
        }
        CGFloat collectionViewHeight = self.view.ct_height - [UIApplication sharedApplication].statusBarFrame.size.height - 44 - bottomHeight;
        UICollectionViewFlowLayout *collectionViewFlowLayout = [UICollectionViewFlowLayout new];
        collectionViewFlowLayout.itemSize = CGSizeMake(collectionViewWidth + 20, collectionViewHeight);
        collectionViewFlowLayout.minimumLineSpacing = 0.0;
        collectionViewFlowLayout.minimumInteritemSpacing = 0.0;
        collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionViewFlowLayout = collectionViewFlowLayout;
    }
    return _collectionViewFlowLayout;
}



- (DRPICPicturePIckerSelectButton *)selectButton {
    if (!_selectButton) {
        CGFloat selectButtonWidth = 32;
        DRPICPicturePIckerSelectButton *selectButton = [[DRPICPicturePIckerSelectButton alloc] initWithFrame:(CGRect){0.,0.,selectButtonWidth,selectButtonWidth}];
        [selectButton addTarget:self action:@selector(eventTouchUpInsideForSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        _selectButton = selectButton;
    }
    return _selectButton;
}

- (UIBarButtonItem *)rightNavigationItem {
    if (!_rightNavigationItem) {
        UIBarButtonItem *rightNavigationItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectButton];
        _rightNavigationItem = rightNavigationItem;
    }
    return _rightNavigationItem;
}

@end
