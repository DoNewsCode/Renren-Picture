//
//  DRIGifPhotoPreviewController.m
//  DRIImagePickerController
//
//  Created by ttouch on 2016/12/13.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "DRIGifPhotoPreviewController.h"
#import "DRIImagePickerController.h"
#import "DRIAssetModel.h"
#import "SDAutoLayout.h"
#import "DRIPhotoPreviewCell.h"
#import "DRIImageManager.h"
#import "DRIPictureBrowseInteractiveAnimatedTransition.h"
#import <DNCommonKit/DNBaseMacro.h>
#import <DNCommonKit/UIColor+CTHex.h>
#import <DNCommonKit/UIButton+CTTitlePlace.h>
#import "UIView+Layout.h"

#import "UINavigationController+FDFullscreenPopGesture.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface DRIGifPhotoPreviewController () {
    UIView *_toolBar;
    UIButton *_doneButton;
    UIProgressView *_progress;
    
    UIView *_naviBar;
    UIButton *_backButton;
    UIButton *_selectButton;
    UIButton *_tagButton;
    UILabel *_indexLabel;
    
    DRIPhotoPreviewView *_previewView;
    
    UIStatusBarStyle _originStatusBarStyle;
}
@property (strong, nonatomic) UIImageView *currentImageView;
@property (nonatomic, assign) CGPoint transitionImgViewCenter;
@end

@implementation DRIGifPhotoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    self.view.backgroundColor = [UIColor clearColor];
    [self configPreviewView];
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    if (driImagePickVc) {
        self.navigationItem.title = [NSString stringWithFormat:@"GIF %@",driImagePickVc.previewBtnTitleStr];
    }
    [self configCustomNaviBar];
    [self configBottomToolBar];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(interactiveTransitionRecognizerAction:)];
    [self.view addGestureRecognizer:pan];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self refreshNaviBarAndBottomBarState];
}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    _originStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    
//}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = _originStatusBarStyle;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    if (driImagePickVc.needShowStatusBar) {
        [UIApplication sharedApplication].statusBarHidden = YES;
    }
    [DRIImageManager manager].shouldFixOrientation = NO;
    self.animatedTransition.transitionParameter.transitionImage = _previewView.imageView.image;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)configCustomNaviBar {
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    
    _naviBar = [[UIView alloc] initWithFrame:CGRectZero];
    _naviBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_backButton setImage:[UIImage dri_imageNamedFromMyBundle:@"navi_back"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
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
    
    [_selectButton addSubview:_indexLabel];
    
    [_naviBar addSubview:_selectButton];
    [_naviBar addSubview:_backButton];
    [self.view addSubview:_naviBar];
}

- (void)configPreviewView {
    _previewView = [[DRIPhotoPreviewView alloc] initWithFrame:CGRectZero];
    _previewView.backgroundColor = [UIColor blackColor];
    _previewView.model = self.model;
    __weak typeof(self) weakSelf = self;
    [_previewView setSingleTapGestureBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf signleTapAction];
    }];
    [self.view addSubview:_previewView];
}

- (void)configBottomToolBar {
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    
    _toolBar = [[UIView alloc] initWithFrame:CGRectZero];
    _toolBar.backgroundColor = [UIColor colorWithRed:32 / 255.0 green:32 / 255.0 blue:32/ 255.0 alpha:0.69];

    UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
       UIVisualEffectView *effectView =[[UIVisualEffectView alloc]initWithEffect:blurEffect];
       effectView.alpha = 0.9;
       effectView.frame = _toolBar.bounds;
       [_toolBar addSubview:effectView];
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setTitle:driImagePickVc.doneBtnTitleStr forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _doneButton.backgroundColor = [UIColor colorWithRed:42.0f/255.0f green:115.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
    
    _doneButton.layer.masksToBounds = YES;
    _doneButton.layer.cornerRadius = 15.0f;
    
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
    [_toolBar addSubview:_doneButton];
//    [_selectButton addSubview:_indexLabel];
    [self.view addSubview:_toolBar];
    
    if (driImagePickVc.photoPreviewPageUIConfigBlock) {
//        driImagePickVc.photoPreviewPageUIConfigBlock(_collectionView, _naviBar, _backButton, _selectButton, _indexLabel, _toolBar, nil, _originalPhotoLabel, _doneButton, _numberImageView, _numberLabel);
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    DRIImagePickerController *driImagePicker = (DRIImagePickerController *)self.navigationController;
    if (driImagePicker && [driImagePicker isKindOfClass:[DRIImagePickerController class]]) {
        return driImagePicker.statusBarStyle;
    }
    return [super preferredStatusBarStyle];
}

#pragma mark - Layout

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    DRIImagePickerController *_driImagePickVc = (DRIImagePickerController *)self.navigationController;
    
    CGFloat statusBarHeight = [DRICommonTools dri_statusBarHeight];
    CGFloat statusBarHeightInterval = statusBarHeight - 20;
    CGFloat naviBarHeight = DNNavHeight;
    _naviBar.frame = CGRectMake(0, 0, self.view.width, naviBarHeight);
    _backButton.frame = CGRectMake(10, 10 + statusBarHeightInterval, 44, 44);
    [_doneButton sizeToFit];
    _doneButton.frame = CGRectMake(self.view.width - 76, 0, 64, 30);
    
    [_backButton ct_setEnlargeEdge:24.f];
    
    
    _previewView.frame = self.view.bounds;
    _previewView.scrollView.frame = self.view.bounds;
    CGFloat toolBarHeight = [DRICommonTools dri_isIPhoneX] ? 44 + (83 - 49) : 44;
    _toolBar.frame = CGRectMake(0, self.view.height - toolBarHeight, self.view.width, toolBarHeight);
        CGFloat toolBarTop = self.view.height - toolBarHeight;
        _toolBar.frame = CGRectMake(0, toolBarTop, self.view.width, toolBarHeight);
    //    if (_driImagePickVc.allowPickingOriginalPhoto) {
    //        CGFloat fullImageWidth = [_driImagePickVc.fullImageBtnTitleStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width;
    //        _originalPhotoLabel.frame = CGRectMake(fullImageWidth + 42, 0, 80, 44);
    //    }
//        _numberImageView.frame = CGRectMake(_doneButton.left - 24 - 5, 10, 24, 24);
//        _numberLabel.frame = _numberImageView.frame;
//        
//        [_tagPhotoButton sizeToFit];
//        _tagPhotoButton.frame = CGRectMake(20, 0, _tagPhotoButton.width, 44);
        
        _selectButton.frame = CGRectMake(self.view.width - 50, 0, 44, 44);
    
    _selectButton.centerY = _backButton.centerY;
    
        _indexLabel.frame = _selectButton.bounds;
        
    
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    if (driImagePickVc.gifPreviewPageDidLayoutSubviewsBlock) {
        driImagePickVc.gifPreviewPageDidLayoutSubviewsBlock(_toolBar, _doneButton);
    }
}

#pragma mark - Click Event

- (void)signleTapAction {
    _toolBar.hidden = !_toolBar.isHidden;
//    [self.navigationController setNavigationBarHidden:_toolBar.isHidden];
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    if (_toolBar.isHidden) {
        [UIApplication sharedApplication].statusBarHidden = YES;
    } else if (driImagePickVc.needShowStatusBar) {
        [UIApplication sharedApplication].statusBarHidden = YES;
    }
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

- (void)backButtonClick {
    if (!self.navigationController) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
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
        self.backButtonClickBlock();
    }
}

- (void)callDelegateMethod {
    DRIImagePickerController *imagePickerVc = (DRIImagePickerController *)self.navigationController;
    // 如果没有选中过照片 点击确定时选中当前预览的照片
    if (imagePickerVc.selectedModels.count == 0 && imagePickerVc.minImagesCount <= 0) {
        [imagePickerVc addSelectedModel:self.model];
    }
//    UIImage *animatedImage = _previewView.imageView.image;
//    [imagePickerVc.selectedAssets addObject:self.model.asset];
//    if ([imagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingGifImage:sourceAssets:)]) {
//        [imagePickerVc.pickerDelegate imagePickerController:imagePickerVc didFinishPickingGifImage:animatedImage sourceAssets:_model.asset isSelect:_selectButton.selected];
//    }
//    if (imagePickerVc.didFinishPickingGifImageHandle) {
//        imagePickerVc.didFinishPickingGifImageHandle(animatedImage,_model.asset);
//    }
    if (self.doneButtonClickBlock) {
        self.doneButtonClickBlock();
    }
    if (self.doneButtonClickBlockWithPreviewType) {
        self.doneButtonClickBlockWithPreviewType(self.photos,imagePickerVc.selectedAssets);
    }
}

#pragma clang diagnostic pop
#pragma mark - Event
- (void)interactiveTransitionRecognizerAction:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    
    CGFloat scale = 1 - (translation.y / SCREENHEIGHT);
    scale = scale < 0 ? 0 : scale;
    scale = scale > 1 ? 1 : scale;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:{
            
            //            NSInteger index = [_collectionView indexPathsForVisibleItems].firstObject.item;
            //            self.animatedTransition.transitionParameter.transitionImgIndex = index;
            //            DRIPhotoPreviewCell *previewCell = [_collectionView visibleCells].firstObject;
            //            if ([previewCell isKindOfClass:[DRIPhotoPreviewCell class]]) {
            self.currentImageView.image = _previewView.imageView.image;
            [self.currentImageView sizeToFit];
            //            }
            
            self.animatedTransition.transitionParameter.transitionImage = self.currentImageView.image;
            
            self.currentImageView.frame = _previewView.frame ;
            self.currentImageView.hidden = YES;
            self.transitionImgViewCenter = self.view.center;
            _previewView.hidden = YES;
            _toolBar.hidden = YES;
            _naviBar.hidden = YES;
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
//                _currentImageView.transform = CGAffineTransformMakeScale(scale, scale);
            
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
            _previewView.hidden = NO;
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

- (UIImageView *)currentImageView{
    if (!_currentImageView) {
        _currentImageView = [[UIImageView alloc] init];
        _currentImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_currentImageView];
    }
    return _currentImageView;
}

- (void)select:(UIButton *)selectButton {
    DRIImagePickerController *_driImagePickVc = (DRIImagePickerController *)self.navigationController;
    DRIAssetModel *model = self.model;
    if (!selectButton.isSelected) {
        // 1. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
        if (_driImagePickVc.selectedModels.count >= _driImagePickVc.maxImagesCount) {
            NSString *title = [NSString stringWithFormat:[NSBundle dri_localizedStringForKey:@"Select a maximum of %zd photos"], _driImagePickVc.maxImagesCount];
            [_driImagePickVc showAlertWithTitle:title];
            return;
            // 2. if not over the maxImagesCount / 如果没有超过最大个数限制
        } else {
            [_driImagePickVc addSelectedModel:model];
            [_driImagePickVc.selectedAssets addObject:self.model.asset];
            [self.photos addObject:_previewView.imageView.image];
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
//                         [_driImagePickVc.selectedModels removeObjectAtIndex:i];
                        break;
                    }
                }
                    // 1.6.7版本更新:防止有多个一样的asset,一次性被移除了
                    NSArray *selectedAssetsTmp = [NSArray arrayWithArray:_driImagePickVc.selectedAssets];
                    for (NSInteger i = 0; i < selectedAssetsTmp.count; i++) {
                        id asset = selectedAssetsTmp[i];
                        if ([asset isEqual:_model.asset]) {
                            [_driImagePickVc.selectedAssets removeObjectAtIndex:i];
                            [self.photos removeObjectAtIndex:i];
                            break;
                        }
                    }
//                NSInteger index = [_driImagePickVc.selectedAssets indexOfObject:self.model.asset];
//                [_driImagePickVc.selectedAssets removeObjectAtIndex:index];
                break;
            }
        }
    }
    model.isSelected = !selectButton.isSelected;
    [self refreshNaviBarAndBottomBarState];
    if (model.isSelected) {
        [UIView showOscillatoryAnimationWithLayer:selectButton.imageView.layer type:RHCOscillatoryAnimationToBigger];
    }
    [UIView showOscillatoryAnimationWithLayer:selectButton.layer type:RHCOscillatoryAnimationToSmaller];
}


- (void)refreshNaviBarAndBottomBarState {
    DRIImagePickerController *_driImagePickVc = (DRIImagePickerController *)self.navigationController;
    DRIAssetModel *model = self.model;
    _selectButton.selected = model.isSelected;
    [self refreshSelectButtonImageViewContentMode];
//    if (_selectButton.isSelected && _driImagePickVc.showSelectedIndex && _driImagePickVc.showSelectBtn) {
//        NSString *index = [NSString stringWithFormat:@"%d", (int)([_driImagePickVc.selectedAssetIds indexOfObject:model.asset.localIdentifier] + 1)];
//        _indexLabel.text = index;
//        _indexLabel.hidden = NO;
//    } else {
//    }
    _indexLabel.hidden = YES;
    
    _doneButton.hidden = NO;
    _selectButton.hidden = !_driImagePickVc.showSelectBtn;
    // 让宽度/高度小于 最小可选照片尺寸 的图片不能选中
    if (![[DRIImageManager manager] isPhotoSelectableWithAsset:model.asset]) {
        _selectButton.hidden = YES;
        _doneButton.hidden = YES;
    }
    [self.view bringSubviewToFront:_naviBar];
    [self.view bringSubviewToFront:_toolBar];
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
@end
