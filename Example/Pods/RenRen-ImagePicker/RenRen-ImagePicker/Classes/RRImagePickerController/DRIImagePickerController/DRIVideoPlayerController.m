//
//  DRIVideoPlayerController.m
//  DRIImagePickerController
//
//  Created by 谭真 on 16/1/5.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "DRIVideoPlayerController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SDAutoLayout.h"
#import "DRIImageManager.h"
#import "DRIAssetModel.h"
#import "DRIImagePickerController.h"
#import "DRIPhotoPreviewController.h"
#import <DNCommonKit/DNBaseMacro.h>
#import <DNCommonKit/UIColor+CTHex.h>

#import "DRIVideoModel.h"
#import "DRIPictureBrowseInteractiveAnimatedTransition.h"
@interface DRIVideoPlayerController () {
    AVPlayer *_player;
    AVPlayerLayer *_playerLayer;
    UIButton *_playButton;
    
    
    UIView *_naviBar;
    UIButton *_backButton;
    UIButton *_selectButton;
    UIButton *_tagButton;
    UILabel *_indexLabel;
    
    UIView *_toolBar;
    UIButton *_doneButton;
    UIProgressView *_progress;
    
    UIStatusBarStyle _originStatusBarStyle;
}
@property (strong, nonatomic) UIImage *cover;
@property (assign, nonatomic) BOOL needShowStatusBar;
@property (strong, nonatomic) UIAlertController *alertView;

@property (strong, nonatomic) UIImageView *currentImageView;
@property (nonatomic, assign) CGPoint transitionImgViewCenter;
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation DRIVideoPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needShowStatusBar = NO;
    self.view.backgroundColor = [UIColor clearColor];
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    if (driImagePickVc) {
        self.navigationItem.title = driImagePickVc.previewBtnTitleStr;
    }
    [self configMoviePlayer];
    
    // 使用这个category的应用不会随着手机静音键打开而静音，可在手机静音下播放声音
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(interactiveTransitionRecognizerAction:)];
    [self.view addGestureRecognizer:pan];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayerAndShowNaviBar) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _originStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = _originStatusBarStyle;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    if (driImagePickVc.needShowStatusBar) {
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    [DRIImageManager manager].shouldFixOrientation = NO;
    self.animatedTransition.transitionParameter.transitionImage = _cover;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)configMoviePlayer {
    if (self.model) {
        [[DRIImageManager manager] getPhotoWithAsset:_model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            if (!isDegraded && photo) {
                self->_cover = photo;
                self->_doneButton.enabled = YES;
            }
        }];
        [[DRIImageManager manager] getVideoWithAsset:_model.asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self configPlayer:playerItem];
            });
        }];
    }
    if (self.videoModel) {
        self->_cover = self.videoModel.coverImage;
        self->_doneButton.enabled = YES;
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:self.videoModel.videoURL];
        [self configPlayer:item];
    }
}

- (void)configPlayer:(AVPlayerItem *)playerItem{
    self->_player = [AVPlayer playerWithPlayerItem:playerItem];
    self->_playerLayer = [AVPlayerLayer playerLayerWithPlayer:self->_player];
    self->_playerLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:self->_playerLayer];
    [self addProgressObserver];
    [self configCustomNaviBar];
    [self configPlayButton];
    //            [self configBottomToolBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayerAndShowNaviBar) name:AVPlayerItemDidPlayToEndTimeNotification object:self->_player.currentItem];
}

/// Show progress，do it next time / 给播放器添加进度更新,下次加上
- (void)addProgressObserver{
    AVPlayerItem *playerItem = _player.currentItem;
    UIProgressView *progress = _progress;
    [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([playerItem duration]);
        if (current) {
            [progress setProgress:(current/total) animated:YES];
        }
    }];
}

- (void)configPlayButton {
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setImage:[UIImage dri_imageNamedFromMyBundle:@"MMVideoPreviewPlay"] forState:UIControlStateNormal];
//    [_playButton setImage:[UIImage dri_imageNamedFromMyBundle:@"MMVideoPreviewPlayHL"] forState:UIControlStateHighlighted];
    [_playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
}

- (void)configBottomToolBar {
    _toolBar = [[UIView alloc] initWithFrame:CGRectZero];
    CGFloat rgb = 34 / 255.0;
    _toolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.7];
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    if (!_cover) {
        _doneButton.enabled = NO;
    }
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    if (driImagePickVc) {
        [_doneButton setTitle:driImagePickVc.doneBtnTitleStr forState:UIControlStateNormal];
        [_doneButton setTitleColor:driImagePickVc.oKButtonTitleColorNormal forState:UIControlStateNormal];
    } else {
        [_doneButton setTitle:[NSBundle dri_localizedStringForKey:@"Done"] forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:1.0] forState:UIControlStateNormal];
    }
    [_doneButton setTitleColor:driImagePickVc.oKButtonTitleColorDisabled forState:UIControlStateDisabled];
    [_toolBar addSubview:_doneButton];
    [self.view addSubview:_toolBar];
    
    if (driImagePickVc.videoPreviewPageUIConfigBlock) {
        driImagePickVc.videoPreviewPageUIConfigBlock(_playButton, _toolBar, _doneButton);
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
    _doneButton.frame = CGRectMake(self.view.width - 56, _backButton.frame.origin.y, 44, 44);
    
    
    CGFloat statusBarAndNaviBarHeight = statusBarHeight + self.navigationController.navigationBar.height;
    _playerLayer.frame = self.view.bounds;
    CGFloat toolBarHeight = [DRICommonTools dri_isIPhoneX] ? 44 + (83 - 49) : 44;
    _toolBar.frame = CGRectMake(0, self.view.height - toolBarHeight, self.view.width, toolBarHeight);
    _playButton.frame = CGRectMake(0, statusBarAndNaviBarHeight, self.view.width, self.view.height - statusBarAndNaviBarHeight - toolBarHeight);
    
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    if (driImagePickVc.videoPreviewPageDidLayoutSubviewsBlock) {
        driImagePickVc.videoPreviewPageDidLayoutSubviewsBlock(_playButton, _toolBar, _doneButton);
    }
}

#pragma mark - Click Event

- (void)playButtonClick {
    CMTime currentTime = _player.currentItem.currentTime;
    CMTime durationTime = _player.currentItem.duration;
    if (_player.rate == 0.0f) {
        if (currentTime.value == durationTime.value) [_player.currentItem seekToTime:CMTimeMake(0, 1)];
        [_player play];
//        [self.navigationController setNavigationBarHidden:YES];
        _toolBar.hidden = YES;
        _naviBar.hidden = YES;
        [_playButton setImage:nil forState:UIControlStateNormal];
        [UIApplication sharedApplication].statusBarHidden = YES;
    } else {
        [self pausePlayerAndShowNaviBar];
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
}

- (void)doneButtonClick {
    if (self.navigationController) {
        DRIImagePickerController *_driImagePickVc = (DRIImagePickerController *)self.navigationController;
        // 如果图片正在从iCloud同步中,提醒用户
        if (_progress.progress > 0 && _progress.progress < 1) {
            _alertView = [_driImagePickVc showAlertWithTitle:[NSBundle dri_localizedStringForKey:@"Synchronizing photos from iCloud"]];
            return;
        }
        [self callDelegateMethod];
    }
}

- (void)callDelegateMethod {
    UIImage *cover = (!self->_cover || CGSizeEqualToSize(self->_cover.size, CGSizeZero))?self.animatedTransition.transitionParameter.transitionImage:self->_cover;
    DRIImagePickerController *imagePickerVc = (DRIImagePickerController *)self.navigationController;
    if (self.model) {
        if (_model.asset.duration < 3 || _model.asset.duration > 600) {
            _alertView = [imagePickerVc showAlertWithTitle:@"视频时长只支持\n 3s-600s"];
            return;
        }
        if ([imagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingVideo:sourceAssets:)]) {
            [imagePickerVc.pickerDelegate imagePickerController:imagePickerVc didFinishPickingVideo:cover sourceAssets:_model.asset];
        }
        if (imagePickerVc.didFinishPickingVideoHandle) {
            imagePickerVc.didFinishPickingVideoHandle(cover,_model.asset);
        }
    }
    if (imagePickerVc.autoDismiss) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

#pragma mark - Notification Method

- (void)pausePlayerAndShowNaviBar {
    [_player pause];
    _toolBar.hidden = NO;
    _naviBar.hidden = NO;
    [self.view bringSubviewToFront:_naviBar];
//    [self.navigationController setNavigationBarHidden:NO];
    [_playButton setImage:[UIImage dri_imageNamedFromMyBundle:@"MMVideoPreviewPlay"] forState:UIControlStateNormal];
    
    if (self.needShowStatusBar) {
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
}

- (void)configCustomNaviBar {
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    
    _naviBar = [[UIView alloc] initWithFrame:CGRectZero];
    _naviBar.backgroundColor = [UIColor blackColor];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_backButton setImage:[UIImage dri_imageNamedFromMyBundle:@"navi_back"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setTitle:driImagePickVc.doneBtnTitleStr forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_naviBar addSubview:_doneButton];
    [_naviBar addSubview:_backButton];
    [self.view addSubview:_naviBar];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
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
                [_player pause];
            if (!self->_cover || CGSizeEqualToSize(self->_cover.size, CGSizeZero)) {
                self.currentImageView.image = self.animatedTransition.transitionParameter.transitionImage;
            }else{
                self.currentImageView.image = self->_cover;
            }
//            }
            
            self.animatedTransition.transitionParameter.transitionImage = self.currentImageView.image;
//            self.animatedTransition.transitionParameter.transitionImgIndex = index;
            UIImage *transImage = self.currentImageView.image;
            CGFloat height = transImage.size.height/ transImage.size.width * SCREENWIDTH;
            
            self.currentImageView.frame = CGRectMake(0, 0, SCREENWIDTH, height);
            self.transitionImgViewCenter = self.view.center;
            _currentImageView.center = CGPointMake(self.transitionImgViewCenter.x + translation.x * scale, self.transitionImgViewCenter.y + translation.y);
            self.currentImageView.hidden = YES;
            _playerLayer.hidden = YES;
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
            _playerLayer.hidden = NO;
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
        [self.view addSubview:_currentImageView];
    }
    return _currentImageView;
}
@end
