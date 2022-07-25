//
//  DRIImageURLPreviewViewController.m
//  RenrenOfficial-iOS-Concept
//
//  Created by 张健康 on 2019/6/11.
//  Copyright © 2019 renren. All rights reserved.
//

#import "DRIImageURLPreviewViewController.h"
#import "DRIImageURLPreviewCell.h"
#import "DRIImagePickerController.h"
#import "SDAutoLayout.h"
#import <DNCommonKit/DNBaseMacro.h>
#import <DNCommonKit/UIColor+CTHex.h>
#import "DRIImagePreviewTagsViewController.h"
#import "UIImage+Tags.h"
#import "DRITagView.h"
#import <DNCommonKit/UIButton+CTTitlePlace.h>
#import "DRPPop.h"
#import "DRIImageManager.h"
@interface DRIImageURLPreviewViewController ()<UIGestureRecognizerDelegate>{
    
    UIView   *_naviBar;
    UIButton *_backButton;
    UIButton *_selectButton;
    UILabel  *_navIndexLabel;
    UIButton *_tagButton;
    UILabel  *_indexLabel;
    
    UIView *_toolBar;
    UIImageView *_numberImageView;
    UILabel *_numberLabel;
    UILabel *_originalPhotoLabel;
    
    UICollectionViewFlowLayout *_layout;
}
@property (nonatomic, assign) double progress;
@property (strong, nonatomic) UIImageView *currentImageView;
@property (nonatomic, assign) CGPoint transitionImgViewCenter;
@property (strong, nonatomic) DRIImagePreviewTagsViewController *tagsViewController;
@end

@implementation DRIImageURLPreviewViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCollectionView];
    [self configCustomNaviBar];
    [self configBottomToolBar];
    adjustsScrollViewInsets_NO(_collectionView, self);
    [_navIndexLabel setText:[NSString stringWithFormat:@"%ld/%ld",_currentIndex+1,self.imageModelArray.count]];
    
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
    if (_currentIndex) {
        [_collectionView setContentOffset:CGPointMake((self.view.width) * self.currentIndex, 0) animated:NO];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    if (driImagePickVc.needShowStatusBar) {
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    NSInteger index = [_collectionView indexPathsForVisibleItems].firstObject.item;
    self.animatedTransition.transitionParameter.transitionImgIndex = index;
    DRIImageURLPreviewCell *previewCell = [_collectionView visibleCells].firstObject;
    if ([previewCell isKindOfClass:[DRIImageURLPreviewCell class]]) {
        self.animatedTransition.transitionParameter.transitionImage = previewCell.previewView.imageView.image;
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
    _collectionView.bounces = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(self.imageModelArray.count * (self.view.width), 0);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[DRIImageURLPreviewCell class] forCellWithReuseIdentifier:@"DRIImageURLPreviewCell"];
    _collectionView.userInteractionEnabled = YES;
    
    //    if (self.navigationController.childViewControllers.count == 1) {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(interactiveTransitionRecognizerAction:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    //    }
}



- (void)configCustomNaviBar {
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    
    _naviBar = [[UIView alloc] initWithFrame:CGRectZero];
    _naviBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    _naviBar.hidden = self.navBarHidden;
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_backButton setImage:[UIImage dri_imageNamedFromMyBundle:@"navi_back"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _navIndexLabel = [[UILabel alloc] init];
    _navIndexLabel.font = [UIFont systemFontOfSize:19];
    _navIndexLabel.textColor = [UIColor ct_colorWithHexString: @"0xc9c9c9"];
    _navIndexLabel.textAlignment = NSTextAlignmentCenter;
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    NSString *rightTitle = self.rightBarButtonTitle;
    if (!rightTitle) {
        rightTitle = @"确定";
    }
    [_doneButton setTitle:rightTitle forState:UIControlStateNormal];
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
    _toolBar.hidden = self.toolBarHidden;
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
    
//    if (driImagePickVc.showTagBtn) {
        _tagPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _tagPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, [DRICommonTools dri_isRightToLeftLayout] ? 10 : -10, 0, 0);
        _tagPhotoButton.backgroundColor = [UIColor clearColor];
        [_tagPhotoButton addTarget:self action:@selector(tagPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _tagPhotoButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_tagPhotoButton setTitle:@"标签" forState:UIControlStateNormal];
        [_tagPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_tagPhotoButton setImage:[UIImage dri_imageNamedFromMyBundle:@"Publish_tag_button_icon"] forState:UIControlStateNormal];
//    }
    [_toolBar addSubview:_tagPhotoButton];
    [_toolBar addSubview:_selectButton];
    [_selectButton addSubview:_indexLabel];
    [self.view addSubview:_toolBar];
    
    if (driImagePickVc.photoPreviewPageUIConfigBlock) {
        driImagePickVc.photoPreviewPageUIConfigBlock(_collectionView, _naviBar, _backButton, _selectButton, _indexLabel, _toolBar, _tagPhotoButton, _originalPhotoLabel, _doneButton, _numberImageView, _numberLabel);
    }
}


#pragma mark - Layout

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGFloat statusBarHeight = ([DRICommonTools dri_isIPhoneX] ? 44.00 : 20.00);
    CGFloat statusBarHeightInterval = statusBarHeight - 20;
    CGFloat naviBarHeight = statusBarHeight + 44;
    _naviBar.frame = CGRectMake(0, 0, self.view.width, naviBarHeight);
    
    CGFloat toolBarHeight = [DRICommonTools dri_isIPhoneX] ? 44 + (83 - 49) : 44;
    CGFloat toolBarTop = self.view.height - toolBarHeight;
    _toolBar.frame = CGRectMake(0, toolBarTop, self.view.width, toolBarHeight);
    
    [_tagPhotoButton sizeToFit];
    _tagPhotoButton.frame = CGRectMake(20, 0, _tagPhotoButton.width, 44);
    
    _selectButton.frame = CGRectMake(self.view.width - _doneButton.width - 12, 0, _doneButton.width, 44);
    _indexLabel.frame = _selectButton.bounds;
    
    _backButton.frame = CGRectMake(10, 10 + statusBarHeightInterval, 44, 44);
    [_backButton ct_setEnlargeEdge:24.f];
    [_navIndexLabel sizeToFit];
    _navIndexLabel.centerY = _backButton.centerY;
    _navIndexLabel.centerX = _naviBar.centerX;
    [_doneButton sizeToFit];
    if (_doneButton.titleLabel.text.length) {
        _doneButton.hidden = NO;
        _doneButton.frame = CGRectMake(self.view.width - 56, 10 + statusBarHeightInterval, 44, 44);
    }else{
        _doneButton.hidden = YES;
    }
    
    _layout.itemSize = CGSizeMake(self.view.width, self.view.height);
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 0;
    _collectionView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [_collectionView setCollectionViewLayout:_layout];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetWidth = scrollView.contentOffset.x;
    CGFloat offSetHeight = scrollView.contentOffset.y;
    NSInteger currentIndex = offSetWidth / (self.view.width);
    if (currentIndex < _imageModelArray.count && _currentIndex != currentIndex) {
        self.currentIndex = currentIndex;
        [self scrollToIndex:currentIndex];
    }
    NSLog(@"scrollViewDidScroll");
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"photoPreviewCollectionViewDidScroll" object:nil];
}


#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *urlString = self.imageModelArray[indexPath.item].urlStr;
    
    DRIImageURLPreviewCell *cell;
    DRIImagePickerController *_driImagePickVc = (DRIImagePickerController *)self.navigationController;
    __weak typeof(self) weakSelf = self;

        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DRIImageURLPreviewCell" forIndexPath:indexPath];
    cell.need_Scroll = YES;
    cell.showTag = self.showTag;
    [cell setImageProgressUpdateBlock:^(double progress) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (progress >= 1) {
            [strongSelf didFinishLoadImage:indexPath.row];
        }
    }];
    cell.model = self.imageModelArray[indexPath.row];
    cell.previewView.tagsView.delegate = self;
    __weak typeof(cell) weakCell = cell;
    [cell setSingleTapGestureBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf didTapPreviewCell];
    }];
    
//    [cell setImageProgressUpdateBlock:^(double progress) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        __strong typeof(weakCell) strongCell = weakCell;
//        weakSelf.progress = progress;
//        if (progress >= 1) {
//            //                [(DRIPhotoPreviewCell *)cell recoverSubviews];
//            for (UIView *view in ((DRIPhotoPreviewCell *)strongCell).previewView.imageView.subviews) {
//                if ([view isKindOfClass:[DRIImagePreviewTagsView class]]) {
//                    [view removeFromSuperview];
//                }
//            }
//            UIImage *image = strongSelf.imageViewsArray[indexPath.row].image;
//            if (image.tagsArray) {
//                DRIImagePreviewTagsView *tagsView = [[DRIImagePreviewTagsView alloc] initWithFrame:((DRIPhotoPreviewCell *)strongCell).previewView.imageView.bounds];
//                [tagsView addNewTagWithTagsArray:image.tagsArray];
//                [((DRIPhotoPreviewCell *)strongCell).previewView.imageView addSubview:tagsView];
//                [((DRIPhotoPreviewCell *)strongCell).previewView.imageView bringSubviewToFront:tagsView];
//            }
//        }
//    }];
    
//    [cell.previewView.scrollView setZoomScale:1.0 animated:NO];
    return cell;
}

- (void)backButtonClick{
    if (self.navigationController.childViewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - Private Method

- (void)dealloc {
     NSLog(@"%@ dealloc",NSStringFromClass(self.class));
}


- (void)doneButtonClick {
    if (self.navigationController) {
        DRIImagePickerController *imagePickerVc = (DRIImagePickerController *)self.navigationController;
        if (imagePickerVc.autoDismiss) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                [self callDelegateMethod];
            }];
        } else {
            [self callDelegateMethod];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            [self callDelegateMethod];
        }];
    }
}

- (void)callDelegateMethod {
    
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

- (void)tagPhotoButtonClick{
    [self showTagsViewWithTags:nil];
}

- (void)showTagsViewWithTags:(NSArray *)tags {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    DRIImageURLPreviewCell *cell = (DRIImageURLPreviewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
//    if (model.type == DRIAssetModelMediaTypePhoto ||
//        model.type == DRIAssetModelMediaTypeLivePhoto)
    
    
        UIImage *model = cell.model.image;
//        [cell.previewView.scrollView setZoomScale:1.0 animated:NO];
        CGRect rect = [cell.previewView.imageView.superview convertRect:cell.previewView.imageView.frame toView:self.view];
        DRIImagePreviewTagsViewController *vc = [[DRIImagePreviewTagsViewController alloc] initWithImage:cell.previewView.imageView.image];
        @weakify (self);
    
    
        vc.addTagBlock = ^(NSDictionary * _Nonnull tagData) {
            [weak_self addTagAction:tagData];
        };
        
        vc.deleteTagBlock = ^(NSDictionary * _Nonnull tagData) {
            [weak_self deleteTagAction:tagData];
        };
        
        vc.dismissBlock = ^(BOOL done,NSMutableArray *tagsData) {
            self->_naviBar.hidden = weak_self.navBarHidden;
            self->_toolBar.hidden = weak_self.toolBarHidden;
            if (tagsData) {
                model.tagsArray = tagsData.mutableCopy;
                DRIImageURLPreviewCell *cell = (DRIImageURLPreviewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
                //    if (model.type == DRIAssetModelMediaTypePhoto ||
                //        model.type == DRIAssetModelMediaTypeLivePhoto)
                
                
                UIImage *model = cell.model.image;
                model.tagsArray = [NSMutableArray arrayWithArray:tagsData.mutableCopy];
//                [cell.previewView.scrollView setZoomScale:1.0 animated:NO];
//                [self->_collectionView reloadItemsAtIndexPaths:@[indexPath]];
//                DRIImagePreviewTagsView *tagsView = [[DRIImagePreviewTagsView alloc] initWithFrame:cell.previewView.imageView.bounds];
//                [tagsView addNewTagWithTagsArray:tagsData];
//                //            tagsView.frame = ;
//                [cell.previewView.imageView addSubview:tagsView];
                [cell recoverSubviews];
            }
            weak_self.tagsViewController = nil;
            [weak_self tagsViewDidDismiss:done];
        };
    
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:NO completion:^{
            
            [vc addExistTags:model.tagsArray.copy];
            model.tagsArray = nil;
            for (UIView *view in cell.previewView.imageView.subviews) {
                if ([view isKindOfClass:[DRIImagePreviewTagsView class]]) {
                    [view removeFromSuperview];
                }
            }
            self->_naviBar.hidden = YES;
            self->_toolBar.hidden = YES;
        }];
        self.tagsViewController = vc;
}

- (void)tagsViewDidDismiss:(BOOL)okAction{
    
}

- (void)didFinishLoadImage:(NSInteger)index{
    
}


- (void)addTags:(NSArray *)tags toIndex:(NSInteger)index{
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
//    DRIImageURLPreviewCell *cell = (DRIImageURLPreviewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    //    if (model.type == DRIAssetModelMediaTypePhoto ||
    //        model.type == DRIAssetModelMediaTypeLivePhoto)
    if ([_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]]) {
//            UIImage *model = self.imageModelArray[index].image;
//        model.tagsArray = [NSMutableArray arrayWithArray:tags];

        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        DRIImageURLPreviewCell *cell = (DRIImageURLPreviewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        UIImage *image = cell.model.image;
        image.tagsArray = [NSMutableArray arrayWithArray:tags];
        [cell recoverSubviews];
    }
}
- (void)deleteTag:(NSMutableDictionary *)tag toIndex:(NSInteger)index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    DRIImageURLPreviewCell *cell = (DRIImageURLPreviewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    UIImage *image = cell.model.image;
    NSMutableArray *tagsArray = image.tagsArray;
    [tagsArray removeObject:tag];
//    [cell.previewView.scrollView setZoomScale:1.0 animated:NO];
    [cell recoverSubviews];
}

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
            NSLog(@"velocityInView ===== %@",NSStringFromCGPoint([gestureRecognizer velocityInView:gestureRecognizer.view]));
            if (!CGPointEqualToPoint(translation, CGPointZero) &&
                fabs(translation.x) >= fabs(translation.y)) {
                gestureRecognizer.state = UIGestureRecognizerStateEnded;
                return;
            }
            NSInteger index = [_collectionView indexPathsForVisibleItems].firstObject.item;
            self.animatedTransition.transitionParameter.transitionImgIndex = index;
            DRIImageURLPreviewCell *previewCell = [_collectionView visibleCells].firstObject;
            if ([previewCell isKindOfClass:[DRIImageURLPreviewCell class]]) {
                self.currentImageView.image = previewCell.previewView.imageView.image;
                [self.currentImageView sizeToFit];
            }
            
            self.animatedTransition.transitionParameter.transitionImage = previewCell.previewView.imageView.image;
            self.animatedTransition.transitionParameter.transitionImgIndex = index;
            CGRect rect = [previewCell.previewView.imageView.superview convertRect:previewCell.previewView.imageView.frame toView:self.view];
            self.currentImageView.frame = rect ;
            self.currentImageView.hidden = YES;
            _collectionView.hidden = YES;
            _currentImageView.left = rect.origin.x + translation.x;
            _currentImageView.top = rect.origin.y + translation.y;
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
            DRIImageURLPreviewCell *previewCell = [_collectionView visibleCells].firstObject;
            CGRect rect = [previewCell.previewView.imageView.superview convertRect:previewCell.previewView.imageView.frame toView:self.view];
            
            
            _currentImageView.left = rect.origin.x + translation.x;
            _currentImageView.top = rect.origin.y + translation.y;
//            _currentImageView.size = CGSizeMake(rect.size.width * (1 - scale), rect.size.height * (1 - scale));
//            _currentImageView.center = CGPointMake(self.transitionImgViewCenter.x + translation.x * scale, self.transitionImgViewCenter.y + translation.y);
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
            _toolBar.hidden = self.toolBarHidden;
            _naviBar.hidden = self.navBarHidden;
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

- (UIImageView *)currentImageView{
    if (!_currentImageView) {
        _currentImageView = [[UIImageView alloc] init];
        [self.view addSubview:_currentImageView];
    }
    return _currentImageView;
}

- (void)setNavBarHidden:(BOOL)navBarHidden{
    _navBarHidden = navBarHidden;
    _naviBar.hidden = navBarHidden;
}

- (void)setToolBarHidden:(BOOL)toolBarHidden{
    _toolBarHidden = toolBarHidden;
    _toolBar.hidden = toolBarHidden;
}

- (void)editTagsMode:(BOOL)on{
    if (on) {
        [self tagPhotoButtonClick];
    }else{
        [self.tagsViewController doneButtonClick];
    }
}

- (void)setShowTag:(BOOL)showTag{
    _showTag = showTag;
    [self.imageModelArray enumerateObjectsUsingBlock:^(DRIImageURLPreviewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DRIImageURLPreviewCell *cell = [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        if ([cell isKindOfClass:[DRIImageURLPreviewCell class]]) {
            cell.showTag = showTag;
            cell.previewView.tagsView.hidden = !showTag;
        }
    }];
}

- (void)reloadData{
    [_collectionView reloadData];
}


- (void)addTagAction:(NSDictionary *)tag{};
- (void)deleteTagAction:(NSDictionary *)tag{};
- (void)scrollToIndex:(NSInteger)index{};
- (void)didTapPreviewCell {};


- (BOOL)tagsViewShouldAddDeleteButton:(DRITagView *)tagView{
    NSString *tagID = tagView.tagData[@"tagID"];
    return !tagID.length;
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    [_navIndexLabel setText:[NSString stringWithFormat:@"%ld/%ld",currentIndex+1,self.imageModelArray.count]];
    [_navIndexLabel sizeToFit];
    _navIndexLabel.centerY = _backButton.centerY;
    _navIndexLabel.centerX = _naviBar.centerX;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[DRIImageURLPreviewCell class]]) {
        [(DRIImageURLPreviewCell *)cell recoverSubviews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[DRIImageURLPreviewCell class]]) {
        [(DRIImageURLPreviewCell *)cell recoverSubviews];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer.view == self.view &&
        [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")]) {
        UIScrollView *scrollView = otherGestureRecognizer.view;
        UIPanGestureRecognizer *panScroll = otherGestureRecognizer;
        CGPoint point = [panScroll translationInView:scrollView];
        DRIImageURLPreviewView *preview = scrollView.superview;
        if ([preview isKindOfClass:[DRIImageURLPreviewView class]]) {
            UIImageView *imageView = preview.imageView;
            UIImage *image = imageView.image;
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
@end
