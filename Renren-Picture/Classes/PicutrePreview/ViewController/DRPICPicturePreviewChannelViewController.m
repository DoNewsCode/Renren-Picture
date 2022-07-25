//
//  DRPICPicturePreviewChannelViewController.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/17.
//

#import "DRPICPicturePreviewChannelViewController.h"

#import "DRPICPicturePreviewChannelCollectionViewCell.h"

#import "UIView+CTLayout.h"
#import "UIImage+RenrenPicture.h"
#import "UIColor+CTHex.h"
#import "UIFont+DRBFont.h"

@interface DRPICPicturePreviewChannelViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) DRPICPicturePreviewChannelCollectionViewCell *previousSelecteditem;

@end

@implementation DRPICPicturePreviewChannelViewController

#pragma mark - Override Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createContent];
    [self createNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createNavigation];
}


#pragma mark - Intial Methods

#pragma mark - Create Methods
- (void)createContent {
    [self.view addSubview:self.effectView];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collectionView];
    self.effectView.frame = self.view.bounds;
}

- (void)createNavigation {
    
}

- (void)createNotifications {
    
}

- (void)createThemeChange {
    
}

#pragma mark - Process Methods
- (void)processChannelItemSelectedWithIndexPath:(NSIndexPath *)indexPath selected:(BOOL)selected {
    self.currentIndexPath = indexPath;
    if (self.previousSelecteditem) {
        [self.previousSelecteditem setSelected:NO animated:YES];
    }
    
    DRPICPicturePreviewChannelCollectionViewCell *item = (DRPICPicturePreviewChannelCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [item setSelected:YES animated:YES];
    self.previousSelecteditem = item;
}


- (void)processChannelItemSelectedWithPicture:(DRPICPicture *)picture selected:(BOOL)selected {
    BOOL hasPicture = [self.viewModel.model.pictures containsObject:picture];
    
    if (self.previousSelecteditem) {
        [self.previousSelecteditem setSelected:NO animated:YES];
    }
    
    if (hasPicture == NO) {
        return;
    }
    
    NSIndexPath *channelIndexPath = [NSIndexPath indexPathForItem:[self.viewModel.model.pictures indexOfObject:picture] inSection:0];
    if (self.currentIndexPath == channelIndexPath) {
        return;
    }
    
    DRPICPicturePreviewChannelCollectionViewCell *item = (DRPICPicturePreviewChannelCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:channelIndexPath];
    [item setSelected:selected animated:YES];
    [self.collectionView scrollToItemAtIndexPath:channelIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    if (selected) {
        self.previousSelecteditem = item;
    }
}

#pragma mark - Event Methods

#pragma mark - UICollectionViewDataSource Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.model.pictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DRPICPicturePreviewChannelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PicturePreviewChannelCollectionViewCell" forIndexPath:indexPath];
    DRPICPicture *picture = self.viewModel.model.pictures[indexPath.row];
    cell.picture = picture;
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self processChannelItemSelectedWithIndexPath:indexPath selected:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(channelViewController:didSelectChannelAtIndex:picture:)]) {
        DRPICPicture *picture = self.viewModel.model.pictures[indexPath.row];
        [self.delegate channelViewController:self didSelectChannelAtIndex:indexPath.row picture:picture];
    }
}

#pragma mark - LazyLoad Methods
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGRect collectionViewFrame = (CGRect){0.,15.,self.view.ct_width,60};
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:self.collectionViewFlowLayout];
        collectionView.contentInset = UIEdgeInsetsMake(0, 15., 0, 15);
        collectionView.backgroundColor = [UIColor clearColor];
        if (@available(iOS 11.0, *)) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        collectionView.bounces = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:[DRPICPicturePreviewChannelCollectionViewCell class] forCellWithReuseIdentifier:@"PicturePreviewChannelCollectionViewCell"];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout {
    if (!_collectionViewFlowLayout) {
        UICollectionViewFlowLayout *collectionViewFlowLayout = [UICollectionViewFlowLayout new];
        collectionViewFlowLayout.itemSize = CGSizeMake(60, 60);
        collectionViewFlowLayout.minimumLineSpacing = 7.0;
        collectionViewFlowLayout.minimumInteritemSpacing = 0.0;
        collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionViewFlowLayout = collectionViewFlowLayout;
    }
    return _collectionViewFlowLayout;
}


- (DRPICPicturePreviewChannelViewModel *)viewModel {
    if (!_viewModel) {
        DRPICPicturePreviewChannelViewModel *viewModel = [DRPICPicturePreviewChannelViewModel new];
        _viewModel = viewModel;
    }
    return _viewModel;
}

- (UIBlurEffect *)blurEffect {
    if (!_blurEffect) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _blurEffect = blurEffect;
    }
    return _blurEffect;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:self.blurEffect];
        effectView.alpha = 0.9;
        _effectView = effectView;
    }
  return _effectView;
}

@end
