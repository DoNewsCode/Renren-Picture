//
//  DRMECameraViewController.m
//  Renren-EditImage
//
//  Created by 陈金铭 on 2019/10/17.
//

#import "DRMECameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <DNCommonKit/UINavigationController+FDFullscreenPopGesture.h>

#import "DRFTFilterManager.h"
#import <GLKit/GLKit.h>

#import "DRMEPhotoEditViewController.h"
#import "DRMECustomBtn.h"
#import "DRMEButtonScrollView.h"        // 拍照和摄像的滚动视图
#import "DRMECountDownAnimationView.h"  // 倒计时view

#import "DRMEPhotoButton.h"             // 新需求的 马杰  当年写的录视频按钮
#import "DRMEShootingButton.h"          // 最新的拍摄按钮
#import "DRMERecordingProgressView.h"   // 和当视频的进度条

#import "DRMEFilterOptionView.h"
#import "DRMEFilterIntensityView.h"
#import "DRFTFilterModel+DRMEExtension.h"

#import "DRPPop.h"
#import "DRMECameraViewController+videoRecord.h"

#import "DRMEPreviewViewController.h"   // 拍了一张的预览页面，个别上级页面需要

// 视频预览页面 -- 包含工具条
#import "DRMEVideoEditViewController.h"

#import "DRMERequestManger.h"

#define kToolHeight 215

@interface DRMECameraViewController ()
<
DRMECountDownAnimationViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
DRMEButtonScrollViewDelegate,
DRMEFilterOptionViewDelegate,
DRMEFilterIntensityViewDelegate,
UIScrollViewDelegate
>
{
    CGFloat _bottomMargin;
}

/// 相册采集到的视图
@property (strong, nonatomic) GLKView *renderView;

/// 拍照按钮
@property(nonatomic,weak) DRMEPhotoButton *takePicturesBtn;
/// 拍摄按钮
@property(nonatomic,weak) DRMEShootingButton *shootingBtn;

/// 关闭按钮
@property(nonatomic,weak) UIButton *closeBtn;
/// 翻转按钮
@property(nonatomic,weak) UIButton *flipBtn;
/// 当翻转摄像头时，记录当时闪光灯是否开启
@property(nonatomic,assign) BOOL isOpenFlash;
/// 闪光灯
@property(nonatomic,weak) UIButton *flashBtn;
/// 倒计时
@property(nonatomic,weak) UIButton *countdownBtn;
/// 相册
@property(nonatomic,weak) DRMECustomBtn *albumBtn;
/// 滤镜
@property(nonatomic,weak) DRMECustomBtn *filterBtn;
/// 小白点
@property(nonatomic,weak) UIView *whiteView;
/// 拍照和摄像按钮视图
@property(nonatomic,weak) DRMEButtonScrollView *btnsScrollView;

/// 记录是摄像还是拍照
@property(nonatomic,assign) BOOL isShooting;
@property(nonatomic,assign) BOOL isTakePicture;

/// 倒计时 3 2 1 视图
@property(nonatomic,strong) DRMECountDownAnimationView *countDownAnimationView;

/// 录视频相关的视图
/// 顶部进度视图
@property (nonatomic, strong) DRMERecordingProgressView *recordingProgress;
/// 删除
@property(nonatomic,weak) DRMECustomBtn *deleteBtn;
/// 完成
@property(nonatomic,weak) DRMECustomBtn *finishBtn;

/// 视频分段路径
@property(nonatomic,strong) NSMutableArray *videoPathArray;

@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) NSInteger timeInterval;

@property(nonatomic,assign) BOOL checkAuthorization;


/// 滤镜选择列表
@property(nonatomic,weak) DRMEFilterOptionView *optionView;
@property(nonatomic,weak) UIScrollView *scrollView;
@property(nonatomic,weak) UILabel *descLabel;
@property(nonatomic,weak) UILabel *nameLabel;

@property(nonatomic,strong) DRFTFilterModel *currentFilterModel;
@property(nonatomic,assign) NSInteger currentIndex;
@property(nonatomic,assign) NSInteger filterIndex;

@end

@implementation DRMECameraViewController

#pragma mark - 懒加载属性
- (NSMutableArray *)videoPathArray
{
    if (!_videoPathArray) {
        _videoPathArray = [NSMutableArray array];
    }
    return _videoPathArray;
}

- (GLKView *)renderView
{
    if (!_renderView) {
        // 上 90 - 20 = 70
        // 下 70
        CGRect rect = self.view.bounds;
        _bottomMargin = 7;
        if (kIsIPhoneX) {
            CGFloat y = kStatusBarHeight + 70;
            _bottomMargin = 70;
            CGFloat height = kScreenHeight - y - kSafeAreaHeight - _bottomMargin;
            rect = CGRectMake(0, y, kScreenWidth, height);
        }
        
        _renderView = [[GLKView alloc] initWithFrame:rect];
        [[DRFTFilterManager manager] setGlkView:_renderView sessionPreset:AVCaptureSessionPreset640x480 authorizationFailed:nil];
        
    }
    return _renderView;
}

- (DRMECountDownAnimationView *)countDownAnimationView
{
    if (!_countDownAnimationView) {
        _countDownAnimationView = [[DRMECountDownAnimationView alloc]
                                   initWithFrame:CGRectMake(30, 40,
                                                            kScreenWidth - 2*30,
                                                            kScreenHeight - 2*40)];
        _countDownAnimationView.delegate = self;
    }
    return _countDownAnimationView;
}

#pragma mark - 视图相关方法
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self startupCapture];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // 禁止左滑返回
    self.fd_interactivePopDisabled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 防止锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    // 请求权限
    if (self.checkAuthorization) {
        self.checkAuthorization = NO;
        // 只执行一次，写在这里，是为了弹框在相机页面展示
        [self gotoCheckAuthorization];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopCapture];
    
    // 如果开启过闪光灯，要关闭
    if (self.btnsScrollView.buttonType == DRMEButtonTypeTakePhoto) {
        
    } else if (self.btnsScrollView.buttonType == DRMEButtonTypeCamera) {
//        if (self.flashBtn.isSelected) {
//            [self clickFlashBtn:self.flashBtn];
//        }
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // 恢复默认锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)gotoCheckAuthorization
{
    BOOL authorization = [[DRFTFilterManager manager] checkAuthorization];
    
    if (!authorization) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请在iPhone的“设置-隐私“选项中，允许人人访问你的相机和麦克风" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            if (self.navigationController.childViewControllers.count >= 2) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.navigationController.childViewControllers.count >= 2) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
        [alert addAction:cancelAction];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        
        // 有权限就加载视图
        [self addObservers];

        // 添加采集到的画面，会渲染到renderView上
        [self.view addSubview:self.renderView];
        
        // 默认后置
        [[DRFTFilterManager manager] switchCamera:YES];

        // 添加UI层
        [self addUI];
        
        // 开始采集
        [self startupCapture];
           
    }
}

- (void)viewDidLoad {

    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];

    self.checkAuthorization = YES;
    self.isTakePicture = YES;
    
}

#pragma mark - 添加UI层
- (void)addUI
{
    // 盖一个scrollView，展示滑动展示滤镜效果
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    WeakSelf(self)
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakself hideOptionView];
    }];
    [scrollView addGestureRecognizer:tapGesture];
    
    CGFloat margin = ((kScreenWidth - 20) - (44 * 4))/3;
    // 关闭
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage me_imageWithName:@"me_close_btn"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    self.closeBtn = closeBtn;

    closeBtn.sd_layout.leftSpaceToView(self.view, 10)
    .topSpaceToView(self.view, kStatusBarHeight + 20)
    .widthIs(44)
    .heightIs(44);
    
    // 闪光灯
    UIButton *flashBtn = [[UIButton alloc] init];
    [flashBtn setImage:[UIImage me_imageWithName:@"me_flash_off_btn"] forState:UIControlStateNormal];
    [flashBtn setImage:[UIImage me_imageWithName:@"me_flash_on_btn"] forState:UIControlStateSelected];
    [flashBtn setImage:[UIImage me_imageWithName:@"me_flash_disable_btn"] forState:UIControlStateDisabled];
    [flashBtn addTarget:self action:@selector(clickFlashBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:flashBtn];
    self.flashBtn = flashBtn;
    
    flashBtn.sd_layout.leftSpaceToView(closeBtn, margin)
    .topEqualToView(closeBtn)
    .widthIs(44)
    .heightIs(44);
    
    // 倒计时
    UIButton *countdownBtn = [[UIButton alloc] init];
    [countdownBtn setImage:[UIImage me_imageWithName:@"me_countdown_btn"] forState:UIControlStateNormal];
    [countdownBtn addTarget:self action:@selector(clickCountdownBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:countdownBtn];
    self.countdownBtn = countdownBtn;

    countdownBtn.sd_layout.leftSpaceToView(flashBtn, margin)
    .topEqualToView(closeBtn)
    .widthIs(44)
    .heightIs(44);
    
    
    // 翻转
    UIButton *flipBtn = [[UIButton alloc] init];
    [flipBtn setImage:[UIImage me_imageWithName:@"me_flip_btn"] forState:UIControlStateNormal];
    [flipBtn addTarget:self action:@selector(clickFlipBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:flipBtn];
    self.flipBtn = flipBtn;

    flipBtn.sd_layout.leftSpaceToView(countdownBtn, margin)
    .topEqualToView(closeBtn)
    .widthIs(44)
    .heightIs(44);
    
    // 小白条
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:whiteView];
    self.whiteView = whiteView;
    
    whiteView.sd_layout.centerXEqualToView(self.view)
    .bottomSpaceToView(self.view, _bottomMargin)
    .widthIs(18).heightIs(2);
    
    [whiteView updateLayout];
    
    // scrollview 包两个按钮，方便手势滑动
    DRMEButtonScrollView *btnsScrollView = [[DRMEButtonScrollView alloc] initWithFrame:CGRectMake(0, whiteView.top - 30, kScreenWidth, 30)];
    btnsScrollView.delegate = self;
    [self.view addSubview:btnsScrollView];
    self.btnsScrollView = btnsScrollView;
    
    [btnsScrollView updateLayout];
    
    // 拍照按钮
    DRMEPhotoButton *takePicturesBtn = [[DRMEPhotoButton alloc] init];
    [takePicturesBtn setImage:[UIImage me_imageWithName:@"me_takingPictures_btn"] forState:UIControlStateNormal];
    [takePicturesBtn addTarget:self action:@selector(clickTakePicturesBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takePicturesBtn];
    self.takePicturesBtn = takePicturesBtn;
    
    takePicturesBtn.sd_layout.bottomSpaceToView(btnsScrollView, 27)
    .centerXEqualToView(self.view)
    .widthIs(80).heightIs(80);
    
    [takePicturesBtn updateLayout];

    DRMEShootingButton *shootingBtn = [[DRMEShootingButton alloc] initWithFrame:takePicturesBtn.frame];
    [self.view addSubview:shootingBtn];
    self.shootingBtn = shootingBtn;
    [shootingBtn addTarget:self action:@selector(clickShootingBtn) forControlEvents:UIControlEventTouchUpInside];
    shootingBtn.hidden = YES;
    
    // 套一个view，方便居中
    UIView *leftBtnView = [[UIView alloc] init];
    [self.view addSubview:leftBtnView];
    
    leftBtnView.sd_layout.leftSpaceToView(self.view, 0)
    .rightSpaceToView(takePicturesBtn, 0)
    .centerYEqualToView(takePicturesBtn)
    .heightIs(80);
    
    
    // 相册
    DRMECustomBtn *albumBtn = [DRMECustomBtn buttonWithType:UIButtonTypeCustom
                                                    withTitle:@"相册"
                                              withImageNormal:@"me_album"
                                            withImageSelected:@"me_album"];
    [leftBtnView addSubview:albumBtn];
    self.albumBtn = albumBtn;
    [albumBtn addTarget:self action:@selector(clickAlbumBtn) forControlEvents:UIControlEventTouchUpInside];

    albumBtn.sd_layout.centerXEqualToView(leftBtnView)
    .centerYEqualToView(leftBtnView)
    .widthIs(45).heightIs(64);
    
    // 套一个view，方便居中
    UIView *rightBtnView = [[UIView alloc] init];
    [self.view addSubview:rightBtnView];
    
    rightBtnView.sd_layout.rightSpaceToView(self.view, 0)
    .leftSpaceToView(takePicturesBtn, 0)
    .centerYEqualToView(takePicturesBtn)
    .heightIs(80);
    
    // 滤镜
    DRMECustomBtn *filterBtn = [DRMECustomBtn buttonWithType:UIButtonTypeCustom
                                                    withTitle:@"滤镜"
                                              withImageNormal:@"me_filter_btn"
                                            withImageSelected:@""];
    [rightBtnView addSubview:filterBtn];
    self.filterBtn = filterBtn;
    [filterBtn addTarget:self action:@selector(clickFilterBtn) forControlEvents:UIControlEventTouchUpInside];

    filterBtn.sd_layout.centerXEqualToView(rightBtnView)
    .centerYEqualToView(rightBtnView)
    .widthIs(45).heightIs(64);
    
    // 完成
    DRMECustomBtn *finishBtn = [DRMECustomBtn buttonWithType:UIButtonTypeCustom
                                                   withTitle:@"完成"
                                             withImageNormal:@"video_finish_btn"
                                           withImageSelected:@""];
    [rightBtnView addSubview:finishBtn];
    [finishBtn addTarget:self action:@selector(clickFinishBtnAction) forControlEvents:UIControlEventTouchUpInside];
    finishBtn.alpha = 0;
    self.finishBtn = finishBtn;
    
    finishBtn.sd_layout.centerYEqualToView(rightBtnView)
    .rightSpaceToView(rightBtnView, 15)
    .widthIs(45).heightIs(64);
    
    // 删除
    DRMECustomBtn *deleteBtn = [DRMECustomBtn buttonWithType:UIButtonTypeCustom
                                                   withTitle:@"删除"
                                             withImageNormal:@"video_delete_btn"
                                           withImageSelected:@""];
    
    [deleteBtn addTarget:self action:@selector(clickDeleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtnView addSubview:deleteBtn];
    deleteBtn.sd_layout.centerYEqualToView(rightBtnView)
    .rightSpaceToView(finishBtn, 20)
    .widthIs(45).heightIs(64);
    self.deleteBtn = deleteBtn;
    deleteBtn.alpha = 0;
    
    // 视频进度条
    CGFloat progressY = closeBtn.bottom + 15;
    if (kIsIPhoneX) {
        progressY = self.renderView.top + 6;
    }
    self.recordingProgress = [[DRMERecordingProgressView alloc] initWithFrame:CGRectMake(0, progressY,kScreenWidth,20)];
    [self.view addSubview:self.recordingProgress];
    self.recordingProgress.alpha = 0;
    

    // 倒计时视图
    [self.view addSubview:self.countDownAnimationView];
    self.countDownAnimationView.hidden = YES;
    
    // 滤镜标题和描述信息
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.font = kFontRegularSize(17);
    descLabel.textColor = UIColor.whiteColor;
    [self.view addSubview:descLabel];
    self.descLabel = descLabel;
    
    descLabel.sd_layout.centerYEqualToView(self.view).offset(-100)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(18);
    

    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = kFontRegularSize(23);
    nameLabel.textColor = UIColor.whiteColor;
    [self.view addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    nameLabel.sd_layout.bottomSpaceToView(descLabel, 15)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(25);
    
    
    // 工具条，选择滤镜view
    DRMEFilterOptionView *optionView = [[DRMEFilterOptionView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kToolHeight)];
    optionView.sureBtn.hidden = YES;
    optionView.cancelBtn.hidden = YES;
    optionView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    optionView.delegate = self;
    [self.view addSubview:optionView];
    self.optionView = optionView;
    
    [optionView loadFilterData];
    
    
    // 处理 只拍照 或 只拍摄  逻辑
    if (self.onlyTakePhoto) {
        self.btnsScrollView.onlyTakePhoto = self.onlyTakePhoto;
        self.btnsScrollView.hidden = YES;
        whiteView.hidden = YES;
    } else if (self.onlyTakeVideo) {
        self.btnsScrollView.onlyTakeVideo = self.onlyTakeVideo;
        self.btnsScrollView.hidden = YES;
        whiteView.hidden = YES;
    }
    
    if (self.isShowAlbumBtn) {
        albumBtn.hidden = NO;
    } else {
        albumBtn.hidden = YES;
    }
    
    
    // 评论/反馈/认证，不显示倒计时、相册、滤镜、摄像等功能
    if (self.fromType == DRMEFromTypeComments ||
        self.fromType == DRMEFromTypeFeedback ||
        self.fromType == DRMEFromTypeCertification) {
        countdownBtn.hidden = YES;
        albumBtn.hidden = YES;
        filterBtn.hidden = YES;
        
        // 只拍照
        self.btnsScrollView.onlyTakePhoto = YES;
        self.btnsScrollView.hidden = YES;
        whiteView.hidden = YES;
    }
    
    // 头像，不显示倒计时、摄像
    if (self.fromType == DRMEFromTypeHead) {
        
        countdownBtn.hidden = YES;
        
        // 只拍照
        self.btnsScrollView.onlyTakePhoto = YES;
        self.btnsScrollView.hidden = YES;
        whiteView.hidden = YES;
    }
    
    // 如果滤镜按钮是显示的，就看之前有没有添加过滤镜效果
    if (!filterBtn.isHidden) {
        
//        NSInteger lastFilterIndex = [kUserDefault integerForKey:@"DRMELastFilterIndex"];
//
//        if (lastFilterIndex != 0) {
//
//            // 说明之前有在相机页面选择过滤镜
//            NSArray *array = [DRFTFilterManager manager].filterArray;
//
//            self.currentIndex = lastFilterIndex;
//
//            if (lastFilterIndex <= array.count) {
//
//                DRFTFilterModel *filterModel = array[lastFilterIndex];
//
//                self.filterIndex = lastFilterIndex;
//                [[DRFTFilterManager manager] setCameraFilterIndex:lastFilterIndex];
//                [[DRFTFilterManager manager] setCameraFilterIntensity:filterModel.currentIntensity];
//
//                [self showFilterName:filterModel];
//
//                [self.optionView scrollToIndex:lastFilterIndex animated:YES];
//
//                // 记录当前滤镜
//                self.currentFilterModel = filterModel;
//
//
//                CGPoint point = CGPointMake(self.scrollView.width * lastFilterIndex, self.scrollView.contentOffset.y);
//                [self.scrollView setContentOffset:point];
//            }
//        }
    } else {
        // 不显示滤镜，也就不需要啥交互了
        scrollView.userInteractionEnabled = NO;
    }
    
}

/// 显示滤镜名字时的动画
- (void)showFilterName:(DRFTFilterModel *)filterModel
{
    self.nameLabel.alpha = 0;
    self.descLabel.alpha = 0;
    
    [self.nameLabel.layer removeAllAnimations];
    [self.descLabel.layer removeAllAnimations];
    
    self.nameLabel.text = [NSString stringWithFormat:@"- %@ -", filterModel.name];
    self.descLabel.text = filterModel.desc;
    
    [UIView animateWithDuration:0.5  delay:0.25 options:UIViewAnimationOptionTransitionNone animations:^{
        
        self.nameLabel.alpha = 1;
        self.descLabel.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionTransitionNone animations:^{
            self.nameLabel.alpha = 0;
            self.descLabel.alpha = 0;
        } completion:nil];
        
    }];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"-- %s, %d", __func__, __LINE__);
    CGFloat tempIndex = scrollView.contentOffset.x / scrollView.width;
    NSInteger index = tempIndex + 0.5;
    
    NSArray *array = [DRFTFilterManager manager].filterArray;
    
    // 记录上次滑动后的 index，滑到第一个和最后一个后，就不做效果了
    if (self.currentIndex == index) {
        return;
    }
    
    self.currentIndex = index;
    
    /// 记录一下之前选过的滤镜 index
    [kUserDefault setInteger:index forKey:@"DRMELastFilterIndex"];
    [kUserDefault synchronize];
    
    if (index <= array.count) {
        DRFTFilterModel *filterModel = array[index];

        self.filterIndex = index;
        [[DRFTFilterManager manager] setCameraFilterIndex:index];
        [[DRFTFilterManager manager] setCameraFilterIntensity:filterModel.currentIntensity];
        
        [self showFilterName:filterModel];
        
        [self.optionView scrollToIndex:index animated:YES];
        
        // 记录当前滤镜
        self.currentFilterModel = filterModel;
    }
}

/// 切换 拍照和摄像时，重置闪光灯模式
- (void)resetFlashMode
{
    if (!self.flashBtn.isEnabled) {
        return;
    }
    
    // 只处理可点击状态
    self.flashBtn.selected = NO;
    [self closeFlash];
    [self closeTorch];
}

#pragma mark - DRMEButtonScrollViewDelegate
- (void)buttonScrollView:(DRMEButtonScrollView *)buttonScrollView
      scrollToButtonType:(DRMEButtonType)scrollToButtonType
{
    if (scrollToButtonType == DRMEButtonTypeTakePhoto) {
        NSLog(@"拍照布局");
        self.isTakePicture = YES;
        self.isShooting = NO;
        
        /// 显示拍照时的布局
        self.takePicturesBtn.hidden = NO;
        self.shootingBtn.hidden = YES;
        self.finishBtn.alpha = 0;
        self.deleteBtn.alpha = 0;
        self.albumBtn.alpha = 1;
        self.filterBtn.alpha = 1;
        
        self.recordingProgress.alpha = 0;
        
        [self resetFlashMode];
        
    } else if (scrollToButtonType == DRMEButtonTypeCamera) {
        
        NSLog(@"摄像布局");
        self.isTakePicture = NO;
        self.isShooting = YES;
        
        /// 显示拍摄时的布局
        self.takePicturesBtn.hidden = YES;
        self.shootingBtn.hidden = NO;
        self.albumBtn.alpha = 0;
        self.filterBtn.alpha = 0;
        
        
        [self resetFlashMode];
    }

}

#pragma mark - DRMEFilterOptionViewDelegate

- (void)filterLodaSuccess:(NSInteger)filterCount
{
    // 滤镜按钮都不显示，就不恢复上次记录的滤镜了
    if (self.filterBtn.hidden) {
        return;
    }
    
    CGFloat pageW = self.scrollView.width;
    CGFloat pageH = self.scrollView.height;
    self.scrollView.contentSize = CGSizeMake(filterCount * pageW, pageH);

    
    NSArray *array = [DRFTFilterManager manager].filterArray;
    DRFTFilterModel *firstModel = array.firstObject;
    // 第一个肯定是原图
    firstModel.originalImage = YES;
    
    // 一个牛B的交互
    NSInteger lastFilterIndex = [kUserDefault integerForKey:@"DRMELastFilterIndex"];
    
    if (lastFilterIndex != 0) {
        
        
        self.currentIndex = lastFilterIndex;
        
        if (lastFilterIndex <= array.count) {
            
            DRFTFilterModel *filterModel = array[lastFilterIndex];
            
            self.filterIndex = lastFilterIndex;
            [[DRFTFilterManager manager] setCameraFilterIndex:lastFilterIndex];
            [[DRFTFilterManager manager] setCameraFilterIntensity:filterModel.currentIntensity];
            
            [self showFilterName:filterModel];
            
            [self.optionView scrollToIndex:lastFilterIndex animated:YES];
            
            // 记录当前滤镜
            self.currentFilterModel = filterModel;
            
            CGPoint point = CGPointMake(self.scrollView.width * lastFilterIndex, self.scrollView.contentOffset.y);
            [self.scrollView setContentOffset:point];
        }
    } else {
        self.filterIndex = 0;
        [self.optionView scrollToIndex:self.filterIndex animated:NO];
    }
    
}

- (void)filterOptionView:(DRMEFilterOptionView *)filterOptionView
        clickFilterIndex:(NSInteger)index
             filterModel:(DRFTFilterModel *)filterModel
{
    self.filterIndex = index;
    self.currentIndex = index;
    
    /// 记录一下之前选过的滤镜 index
    [kUserDefault setInteger:index forKey:@"DRMELastFilterIndex"];
    [kUserDefault synchronize];
    
    [[DRFTFilterManager manager] setCameraFilterIndex:index];
    [[DRFTFilterManager manager] setCameraFilterIntensity:filterModel.currentIntensity];;
    
    [self showFilterName:filterModel];

    // 记录当前滤镜
    self.currentFilterModel = filterModel;
    
    CGPoint point = CGPointMake(self.scrollView.width * index, self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:point];
}


- (void)filterOptionIntensityDidClick
{
    // 显示滤镜范围调整视图
    DRMEFilterIntensityView *intensityView = [[DRMEFilterIntensityView alloc] initWithFrame:self.optionView.frame];
    intensityView.slider.maximumValue = self.currentFilterModel.maxIntensity;
    intensityView.filterName = self.currentFilterModel.name;
    intensityView.currentIntensity = self.currentFilterModel.currentIntensity;
    intensityView.delegate = self;
    [self.view addSubview:intensityView];
    
    intensityView.top = kScreenHeight;
    
    // 滤镜view下去，滑杆视图上来
    [UIView animateWithDuration:0.2 animations:^{
        self.optionView.alpha = 0;
    } completion:^(BOOL finished) {
        self.optionView.top = kScreenHeight;
        [UIView animateWithDuration:0.2 animations:^{
            intensityView.top = kScreenHeight - intensityView.height;
        }];
    }];
    
}

#pragma mark - DRMEFilterIntensityViewDelegate
- (void)filterSliderValueDidChanged:(CGFloat)value
{
    [[DRFTFilterManager manager] setCameraFilterIntensity:value];
    self.currentFilterModel.currentIntensity = value;
}

- (void)filterSliderHideComplete:(DRMEFilterIntensityView *)filterIntensityView
{
    [filterIntensityView removeFromSuperview];
    
    // 滤镜视图显示
    [self clickFilterBtn];
}

#pragma mark - 拍视频按钮代理回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error != NULL) {
        [DRPPop showTextHUDWithMessage:@"保存视频失败"];
    }else{
        [DRPPop showTextHUDWithMessage:@"视频已保存到相册"];
    }
}

#pragma mark 删除按钮点击
- (void)clickDeleteBtnAction
{
    if (self.videoPathArray.count == 0) {
        return;
    }
    
    ///进度视图删除
    [self.recordingProgress prepareDelete];
    [self.recordingProgress deleteProgress];
    
    NSString *videoPath = [self.videoPathArray lastObject];
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:videoPath error:nil];
    [self.videoPathArray removeLastObject];
    
    if (self.videoPathArray.count == 0) {
        /// 删没了，相关按钮也得隐藏
        self.deleteBtn.alpha = 0;
        self.finishBtn.alpha = 0;
        self.recordingProgress.alpha = 0;
        
        self.whiteView.alpha = 1;
        self.btnsScrollView.alpha = 1;
    }
}

- (void)clickFinishBtnAction
{
    [self stopRecord:^{
        @weakify(self)
        [kDRMEVideoManager asynchandleVideosWithVideoPathArr:self.videoPathArray progress:^(float progress) {
            
            dispatch_async_on_main_queue(^{
                [DRPPop showLoadingHUDWithMessage:nil];
            });
            
        } complete:^(NSString * _Nonnull finishVideoPath) {
            
            @strongify(self)
            dispatch_async_on_main_queue(^{
                
                if (self.timeInterval < 30) {
                    
                    [DRPPop showTextHUDWithMessage:@"视频时长不能少于3秒"];
                    
                    // 提示后，需要重新拍摄
                    [self.shootingBtn resetAnimation];
                    [self stopRecord];
                    [self clickDeleteBtnAction];
                    
                    self.deleteBtn.alpha = 0;
                    self.finishBtn.alpha = 0;
                    
                } else {
                    [DRPPop hideLoadingHUD];
                    if (self.editVideoCompleteBlock) {
                        self.editVideoCompleteBlock(finishVideoPath);
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }
            });
    }];
    
    

        // 这是需要的，下一版要打开
//        if (finishVideoPath) {
//            DRMEVideoEditViewController *recordVc = [[DRMEVideoEditViewController alloc]init];
//            recordVc.videoURLStr = finishVideoPath;
//            [self.navigationController pushViewController:recordVc animated:YES];
//
//            recordVc.videoEditComplete = ^(NSString * _Nonnull videoPath) {
//                if (self.editVideoCompleteBlock) {
//                    self.editVideoCompleteBlock(videoPath);
//                    [self clickCloseBtn];
//                }
//            };
//        }
    }];
}

#pragma mark - 事件
- (void)clickShootingBtn {
    
    // 视频的采集
    if ([DRFTFilterManager manager].isRecording) {
        NSLog(@"结束摄像");
        [self stopRecord];
        [self.shootingBtn resetAnimation];
    } else {
        NSLog(@"开始摄像");
        // 这版不做分段拍摄功能
        if (self.videoPathArray.count == 1) {
            NSLog(@" 1 1 8 这版不做分段拍摄功能");
            return;
        }
        [self startRecord];
        [self.shootingBtn scaleAnimation];
    }
}

- (void)clickAlbumBtn
{
    NSLog(@"-- %s, %d", __func__, __LINE__);
    if (self.clickAlbumBlock) {
        self.clickAlbumBlock();
    }
}

- (void)clickFilterBtn
{
    self.btnsScrollView.alpha = 0;
    self.whiteView.alpha = 0;
    self.optionView.alpha = 1;
    
    [self.view bringSubviewToFront:self.takePicturesBtn];
  
    self.takePicturesBtn.sd_layout.bottomSpaceToView(self.view, 27)
    .centerXEqualToView(self.view)
    .widthIs(45).heightIs(45);
    
    [UIView animateWithDuration:0.2 animations:^{
        // 这里的动画很不理想，后续调整吧
//        self.takePicturesBtn.sd_layout.bottomSpaceToView(self.view, 27)
//        .centerXEqualToView(self.view)
//        .widthIs(45).heightIs(45);

        self.albumBtn.alpha = 0;
        self.filterBtn.alpha = 0;
        // 滤镜视图出来
        self.optionView.top = kScreenHeight - kToolHeight;
    }];
}

- (void)hideOptionView
{

    self.takePicturesBtn.sd_layout.bottomSpaceToView(self.btnsScrollView, 27)
    .centerXEqualToView(self.view)
    .widthIs(80).heightIs(80);
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.albumBtn.alpha = 1;
        self.filterBtn.alpha = 1;
        
        self.optionView.top = kScreenHeight;

        // 这里的动画很不理想，后续调整吧
//        self.takePicturesBtn.sd_layout.bottomSpaceToView(self.btnsScrollView, 27)
//        .centerXEqualToView(self.view)
//        .widthIs(80).heightIs(80);
        
    } completion:^(BOOL finished) {
        
        self.optionView.alpha = 0;
        
        self.btnsScrollView.alpha = 1;
        self.whiteView.alpha = 1;
    }];
}

- (void)clickTakePicturesBtn
{
    // 拍照效果
//    takingPicturesBtn.enabled = NO;
//    UIView *whiteView = [[UIView alloc] initWithFrame:self.view.bounds];
//    whiteView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:whiteView];
//    whiteView.alpha = 0.3;
//    [UIView animateWithDuration:0.1 animations:^{
//        whiteView.alpha = 0.8;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.1 animations:^{
//            whiteView.alpha = 0;
//        } completion:^(BOOL finished) {
//            takingPicturesBtn.enabled = YES;
//            [whiteView removeFromSuperview];
//        }];
//    }];
    
    // 拍照
    NSLog(@"开始拍照");
    WeakSelf(self)
    [[DRFTFilterManager manager] takePicture:self.filterIndex intensity:self.currentFilterModel.currentIntensity completion:^(UIImage *image) {
        
        if (image) {
            
            /// 评论/反馈/认证的拍照逻辑
            /// 拍照完成直接进入预览页，预览页点完成就上传了
            if (weakself.fromType == DRMEFromTypeComments ||
                weakself.fromType == DRMEFromTypeFeedback ||
                weakself.fromType == DRMEFromTypeCertification ||
                weakself.fromType == DRMEFromTypeHead) {
                
                /// 增加一个预览页面，预览页点完成要关闭预览和相机页面，再走block返给上级页面
                DRMEPreviewViewController *previewVc = [[DRMEPreviewViewController alloc] init];
                previewVc.originImage = image;
                [weakself.navigationController pushViewController:previewVc animated:YES];
               
                /// 预览不会操作image，可直接返回image
                previewVc.previewDoneBlock = ^{
                    
                    if (weakself.cameraEditCompleteBlock) {
                        weakself.cameraEditCompleteBlock(image);
                        [weakself dismissViewControllerAnimated:YES completion:nil];
                    }
                };
              
            } else if (weakself.fromType == DRMEFromTypeHead) {
                /// 头像的直接返回，有专门裁剪头像的圆形页面
                if (weakself.cameraEditCompleteBlock) {
                    weakself.cameraEditCompleteBlock(image);
                    [weakself dismissViewControllerAnimated:YES completion:nil];
                }
                
            } else {
                [weakself takePhotoToSave:image];
                // 拍完照就要保存到手机相册
                // 到发布后，再保存编辑过的图片
                // 不保存，维持上版逻辑
//                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            }
        }
    }];
    
}

/// 保存图片回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        DNLog(@"保存成功");
    }
}

- (void)takePhotoToSave:(UIImage *)image {
    
    NSLog(@"-- %s, %d", __func__, __LINE__);
    DRMEPhotoEditViewController *photoEditVc = [[DRMEPhotoEditViewController alloc] init];
    photoEditVc.originImage = image;
    
    /// 标识是否是从聊天过来，不展示标签
    if (self.fromType == DRMEFromTypeChat) {
        photoEditVc.isFromChat = YES;
    }
    
    [self.navigationController pushViewController:photoEditVc animated:YES];
    
    WeakSelf(self)
    photoEditVc.photoEditTagCompleteBlock = ^(UIImage * _Nonnull editImage, NSMutableArray * _Nonnull tagsDict) {
        
        if (tagsDict.count) {
            editImage.tagsDict = [tagsDict copy];
        }
        
        if (weakself.cameraEditCompleteBlock) {
            weakself.cameraEditCompleteBlock(editImage);
            [weakself dismissViewControllerAnimated:YES completion:nil];
        }
    };
}

#pragma mark - timer相关
- (void)updateTime
{
    // 600 = 1分钟   10 = 1秒
    if (self.timeInterval >= 600 ) {
        [self.shootingBtn resetAnimation];
        [self stopRecord];
        
        return;
    }
    self.timeInterval++;
    long long duration = self.timeInterval * NV_TIME_BASE;
    [self.recordingProgress currentValue:[self.recordingProgress getValue] + duration];
//    NSLog(@"-- timeInterval ==  %zd,", self.timeInterval);
}

- (void)startTimer
{
    if (self.timer == nil) {

        self.timeInterval = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTime) userInfo:NULL repeats:YES];
        [self.timer fire];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 录制视频相关
- (void)startRecord
{
    
    
    // 隐藏拍摄中不需要的按钮
    self.countdownBtn.alpha = 0;
    self.flashBtn.alpha = 0;
    self.flipBtn.alpha = 0;
    
    self.btnsScrollView.alpha = 0;
    self.whiteView.alpha = 0;
    
    self.deleteBtn.alpha = 0;
    self.finishBtn.alpha = 1;
    
    // 我艹，这里被顺序坑了
    self.recordingProgress.alpha = 1;
    [self.recordingProgress beginProgress];
    [self startTimer];
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddhhmmssSS"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString *videoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",dateString]];
    NSURL *url = [NSURL URLWithString:videoPath];
    [[DRFTFilterManager manager] startRecording:url size:CGSizeMake(480,640)];
    
    [self.videoPathArray addObject:videoPath];
}

- (void)stopRecord
{
    [self stopTimer];
    [self.recordingProgress endProgress];
    
    @weakify(self)
    [[DRFTFilterManager manager] endRecording:^{
        @strongify(self)
        NSLog(@"结束了一段录制");
        dispatch_async_on_main_queue(^{
            
            self.finishBtn.alpha = 1;
            self.deleteBtn.alpha = 1;

            self.flashBtn.alpha = 1;
            self.flipBtn.alpha = 1;
            self.countdownBtn.alpha = 1;
//            self.closeBtn.alpha = 1;
        });
    }];
}

// 这个只用在点击完成按钮的时候
- (void)stopRecord:(void(^)(void))compeleBlock
{
    [self stopTimer];
    [self.recordingProgress endProgress];
    
    @weakify(self)
    [[DRFTFilterManager manager] endRecording:^{
        @strongify(self)
        NSLog(@"结束了一段录制");
        dispatch_async_on_main_queue(^{
            
            self.finishBtn.alpha = 1;
            self.deleteBtn.alpha = 1;

            self.flashBtn.alpha = 1;
            self.flipBtn.alpha = 1;
            if (compeleBlock) {
                compeleBlock();
            }
        });
    }];
}

#pragma mark - 其它事件
- (void)clickCloseBtn
{
    
    
    // 如果正在录制 或 已经录制过一段以上了
    if ([DRFTFilterManager manager].isRecording || self.videoPathArray.count > 0) {
        
        [DRPPop showBottomActionSheetWithTitle:nil message:nil titleArray:@[@"重新拍摄", @"退出"] firstBtnShowRedFont:YES handleBlock:^(NSString * _Nonnull title) {
           
            if ([title isEqualToString:@"退出"]) {
                
//                [self closeFlash];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } else if ([title isEqualToString:@"重新拍摄"]) {
                
                [self.shootingBtn resetAnimation];
                [self stopRecord];
                [self clickDeleteBtnAction];
                
                self.deleteBtn.alpha = 0;
                self.finishBtn.alpha = 0;
            }
            
        }];
        
    } else {
//        [self closeFlash];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

// 切换摄像头
- (void)clickFlipBtn:(UIButton *)sender
{
    sender.userInteractionEnabled = NO ;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        sender.userInteractionEnabled = YES ;
    });
    
    sender.selected = !sender.isSelected;
    [[DRFTFilterManager manager] switchCamera:YES];
    
    // 如果开启过闪光灯，要关闭，还要记录
    if (self.flashBtn.isSelected) {
        self.isOpenFlash = YES;
        [self clickFlashBtn:self.flashBtn];
    }
    
    // 检查摄像头，并改变闪光灯按钮状态
    [self checkIsFrontCamera];
    
}

/// 看看是前置 还是 后置摄像头，控制闪光灯按钮状态
- (void)checkIsFrontCamera
{
//    AVCaptureDevicePositionBack
//    AVCaptureDevicePositionFront
   AVCaptureDevicePosition position = [DRFTFilterManager manager].cameraPosition;
   if (position == AVCaptureDevicePositionFront) {
       NSLog(@"是前置");
       self.flashBtn.enabled = NO;
   } else if (position == AVCaptureDevicePositionBack) {
       NSLog(@"是后置");
       self.flashBtn.enabled = YES;
       
       // 一个交互逻辑，需要在切换摄像头时，记录上次闪光灯的状态，并且恢复
       if (self.isOpenFlash) {
           self.isOpenFlash = NO;
           
           if (self.btnsScrollView.buttonType == DRMEButtonTypeTakePhoto) {
               [self openFlash];
           } else if (self.btnsScrollView.buttonType == DRMEButtonTypeCamera) {
               [self openTorch];
           }
       }
   }
}

- (void)clickFlashBtn:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    if (self.btnsScrollView.buttonType == DRMEButtonTypeTakePhoto) {
        /// 开闪光灯 或 关闪光灯
        if (sender.isSelected) {
            [self openFlash];
        } else {
            [self closeFlash];
        }
    } else if (self.btnsScrollView.buttonType == DRMEButtonTypeCamera) {
        /// 开灯 或 关灯
        if (sender.isSelected) {
            // 开灯
            [self openTorch];
        } else {
            // 关灯
            [self closeTorch];
        }
    }
}

/** 开闪光灯 */
- (void)openFlash {
    
    // 开灯
    self.flashBtn.selected = YES;
    [[DRFTFilterManager manager] setCameraFlashMode:AVCaptureFlashModeOn];
}

/** 关闪光灯 */
- (void)closeFlash {

    // 关灯
    self.flashBtn.selected = NO;
    [[DRFTFilterManager manager] setCameraFlashMode:AVCaptureFlashModeOff];
    
}

/** 开灯 */
- (void)openTorch {
    
    // 开灯
    self.flashBtn.selected = YES;
    [[DRFTFilterManager manager] setTorchMode:AVCaptureTorchModeOn];
}

/** 关灯 */
- (void)closeTorch {

    // 关灯
    self.flashBtn.selected = NO;
    [[DRFTFilterManager manager] setTorchMode:AVCaptureTorchModeOff];
    
}

- (void)clickCountdownBtn
{
    // 如果是拍摄 并且 已经录制过一段了，就啥也不干
    if (self.isShooting && self.videoPathArray.count > 0) {
        return;
    }
    self.countDownAnimationView.hidden = NO;
    [self.countDownAnimationView startAnimation];
}

#pragma mark - 开始采集
- (void)startupCapture
{
    if (![DRFTFilterManager manager].captureIsRunning) {
        [[DRFTFilterManager manager] startCameraCapture:YES];
    }
    [self checkIsFrontCamera];
    
}
#pragma mark - 停止采集
- (void)stopCapture
{
    if ([DRFTFilterManager manager].captureIsRunning) {
        [[DRFTFilterManager manager] startCameraCapture:NO];
    }
}

#pragma mark 注册应用前台后台通知事件
- (void)addObservers {
    [kNotificationCenter addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [kNotificationCenter addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)willResignActive{
    if (self.navigationController.visibleViewController == self) {
        [self stopCapture];
    }
}

- (void)didBecomeActive{
    if (self.navigationController.visibleViewController == self) {
        [self startupCapture];
    }
}

#pragma mark - DRMECountDownAnimationViewDelegate
- (void)countDownAnimationStopAnimationView:(DRMECountDownAnimationView *)countDownAnimationView
{
    self.countDownAnimationView.hidden = YES;

    // 3 2 1 结束后，触发拍照按钮
    // 如果是拍照，走拍照
    // 如果是摄像，走摄像
    if (self.isTakePicture) {
        [self clickTakePicturesBtn];
    } else if (self.isShooting) {
        [self clickShootingBtn];
    }
}

- (void)dealloc
{
    [kNotificationCenter removeObserver:self];
    NSLog(@"----相机界面销毁");
    [self closeFlash];
    [[DRFTFilterManager manager] clearCameraHandler];
}

@end
