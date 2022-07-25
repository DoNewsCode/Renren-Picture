//
//  DRMECutVideoViewController.m
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/12.
//  视频裁剪控制器

/// TODO: 实现方式变更 GPUImageMovie渲染图像 播放器播放声音 

#import "DRMECutVideoViewController.h"
#import <DNCommonKit/UINavigationController+FDFullscreenPopGesture.h>
#import "DRMECustomBtn.h"
#import "DRMEVideoTrimView.h"
#import "DRMEVideoCompiler.h"

#import "DRMEVideoManager.h"

#import "GPUImageView.h"
#import "GPUImageMovie.h"

#import "DRPPop.h"
#import "DRMEVideoEditPushAnimation.h"

@interface DRMECutVideoViewController ()
<DRMEVideoTrimViewDelegate>

@property (nonatomic , strong) UILabel *durationLabel;
@property (nonatomic , strong) UIImageView *backgroundImageView;
@property (nonatomic , strong) UIBlurEffect *blur;


@property (nonatomic , strong) DRMEVideoTrimView *videoTrimView;
@property (nonatomic , strong) DRMEVideoCompiler *videoCompiler;
@property (nonatomic , assign) CGFloat previewInterval;
@property (nonatomic , assign) float videoDuration;
@property (nonatomic , assign) CMTime recordStartTime;
@property (nonatomic , assign) CMTime recordEndTime;

@property (nonatomic , strong) AVPlayer *avPlayer;
@property (nonatomic , strong) AVPlayerItem *avPlayerItem;

@property (nonatomic, strong) GPUImageMovie *movieFile;
@property (nonatomic, strong) GPUImageView *filterPreview;

@property (nonatomic , strong) AVAsset *videoAsset;
@property (strong, nonatomic) UIView *shortVideoView;
@end

@implementation DRMECutVideoViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate = self;
    self.view.backgroundColor = [UIColor blackColor];
    
    [self createContent];
    
    self.currentPlayerView = self.filterPreview;
    
    self.recordStartTime = CMTimeMakeWithSeconds(0, self.videoAsset.duration.timescale);
    self.recordEndTime = self.videoAsset.duration;
    
    self.avPlayer.rate = 1.0f;
    if (!self.movieFile) {
        self.movieFile = [[GPUImageMovie alloc] initWithPlayerItem:self.avPlayerItem];
    }
    [self.movieFile cancelProcessing];
    self.movieFile.playAtActualSpeed = YES;
    self.movieFile.runBenchmark = NO;
    
    [self.movieFile addTarget:self.filterPreview];
    
    __weak typeof(self) weakSelf = self;
    self.movieFile.onProcessMovieFrameDone = ^(GPUImageMovie *imageMovie, CMTime time){
        [weakSelf replayWithCurrentTime:time];
    };
    [self.movieFile startProcessing];
    [self.avPlayer seekToTime:self.curPlayTime];
    [self playVideo];
//    [self playerStartPlay];
//    [self configPlayerView];
    
}

- (void)createContent
{
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = self.backgroundImageView.bounds;
    [self.backgroundImageView addSubview:effectview];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:self.backgroundImageView.bounds];
    alphaView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    [self.backgroundImageView addSubview:alphaView];
    
    // TODO: 暂用本地视频
    //1.读取本地视频
    if (!_videoURLStr) {
        NSLog(@"没有视频，就别玩儿的呀");
        return;
    }
    //2.初始化播放器
    [self initAvPlayerSetttings];
    
    // 返回
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage me_imageWithName:@"me_back_btn"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    backBtn.sd_layout.leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, kStatusBarHeight + 10)
    .widthIs(44)
    .heightIs(44);
    
    // 完成
    UIButton *doneBtn = [[UIButton alloc] init];
    doneBtn.backgroundColor = [UIColor colorWithHexString:@"#2A73EB"];
    doneBtn.titleLabel.font = kFontMediumSize(15);
    [doneBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(nextBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    doneBtn.layer.cornerRadius = 15.f;
    doneBtn.sd_layout.centerYEqualToView(backBtn)
    .rightSpaceToView(self.view, 15)
    .widthIs(64).heightIs(30);
    
    
    [self buildTrimView];
    [self buildFilterPreviewView];
    [self getVideoPreviewPictures];
    
}

- (void)buildFilterPreviewView{
    
    self.shortVideoView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight + 58, SCREEN_WIDTH, CGRectGetMinY(self.videoTrimView.frame) - kStatusBarHeight - 58 - 44)];
    [self.view addSubview:self.shortVideoView];
    
    _filterPreview = [[GPUImageView alloc] initWithFrame:self.shortVideoView.bounds];
    [_filterPreview setBackgroundColorRed:0.f green:0.f blue:0.f alpha:.72f];
    [_filterPreview setFillMode:kGPUImageFillModePreserveAspectRatio];
    NSArray *tracks = [self.videoAsset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        //        CGSize size = videoTrack.naturalSize;
        NSUInteger degress = [[DRMEVideoManager shareVideoManager] getVideoDegress:videoTrack];
        CGSize size = [videoTrack naturalSize];
        if (size.width > size.height) {
            _filterPreview.height = self.shortVideoView.width/size.width * size.height;
        }else if (size.width == size.height){
            _filterPreview.height = _filterPreview.width;
        }else{
            if (degress == 90 || degress == 270) {
                _filterPreview.width = self.shortVideoView.height;
                _filterPreview.height = self.shortVideoView.width;
            }else{
                _filterPreview.width = self.shortVideoView.height/size.height *size.width;
                if (_filterPreview.width > SCREEN_WIDTH) {
                    _filterPreview.width = SCREEN_WIDTH;
                }
            }
        }
        _filterPreview.centerY = self.shortVideoView.height/2;
        _filterPreview.centerX = self.shortVideoView.width/2;
    }
    [self.shortVideoView addSubview:_filterPreview];
    
    self.animation.toRect = [self.view convertRect:_filterPreview.frame fromView:_filterPreview.superview];
}

- (void)buildTrimView
{
    self.videoDuration = CMTimeGetSeconds(self.videoAsset.duration);
    self.videoTrimView = [[DRMEVideoTrimView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 62) videoDuration:self.videoDuration];
    self.videoTrimView.delegate = self;
    [self.videoTrimView setImagesWithVideo:self.videoAsset];
    [self.view addSubview:self.videoTrimView];
    self.videoTrimView.top = (SCREEN_HEIGHT - kHPercentage(73)) - self.videoTrimView.height;
    
    self.durationLabel = [[UILabel alloc] init];
}

- (void)initAvPlayerSetttings
{
    if (self.avPlayerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayerItem];
    }

    if ([self.videoURLStr isNotBlank]) {
        _videoAsset = [AVAsset assetWithURL:[NSURL fileURLWithPath:self.videoURLStr]];
    }
    self.avPlayerItem = [AVPlayerItem playerItemWithAsset:_videoAsset];
    self.avPlayer = [AVPlayer playerWithPlayerItem:self.avPlayerItem];
    
    [self.avPlayer seekToTime:kCMTimeZero];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayerItem];
    [self playVideo];

}

#pragma mark - TrimViewDelegate
- (void)trimControlDidChangeLeftValue:(double)leftValue rightValue:(double)rightValue
{
    @weakify(self)
    NSTimeInterval seekTime = leftValue;
    NSTimeInterval endTime = rightValue;
    
    //TODO: 截取时间需要调整.
    self.recordStartTime = CMTimeMakeWithSeconds(seekTime, self.videoAsset.duration.timescale);
    self.recordEndTime = CMTimeMakeWithSeconds(endTime, self.videoAsset.duration.timescale);
    
    [self.avPlayer seekToTime:self.recordStartTime
              toleranceBefore:kCMTimeZero
               toleranceAfter:kCMTimeZero
            completionHandler:^(BOOL finish){
        @strongify(self)
         [self playVideo];
     }];
//    if (self.videoObject.videoEndTime !=rightValue) {
//        self.videoObject.videoEndTime = rightValue;
//    }
//    self.videoObject.videoStartTime = leftValue;
}

- (void)playVideo
{
    @weakify(self);
    [self.avPlayer play];
    [self.videoTrimView startPlayIndicateBarAnimationWithStartTime:CMTimeGetSeconds(self.avPlayer.currentTime)];
}

- (void)getVideoPreviewPictures
{
    NSInteger slotNum = 0;
    NSInteger maxSlotNum = [self.videoTrimView setImagesWithVideo:self.videoAsset];
    self.videoCompiler = [[DRMEVideoCompiler alloc] initWithAVAsset:self.videoAsset delegate:self];
    
    _previewInterval = CMTimeGetSeconds(self.avPlayerItem.asset.duration) / maxSlotNum;
    NSMutableArray *timeSlotArray = [[NSMutableArray alloc]init];
    NSUInteger currentIndex = [self.videoTrimView getCurrentIndex];
    for (slotNum = 0; slotNum <= maxSlotNum - 1; slotNum++) {
        if (slotNum < currentIndex) {
            continue;
        }
        if (slotNum != maxSlotNum - 1) {
            [timeSlotArray addObject:[NSValue valueWithCMTime:CMTimeMakeWithSeconds(slotNum*_previewInterval, 24)]];
        } else {
            [timeSlotArray addObject:[NSValue valueWithCMTime:self.videoAsset.duration]];
        }
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.videoCompiler fetchKeyFramesFromVideo:timeSlotArray
                              keyFramesArray:nil
                                    savePath:self.videoTrimView.imagePath
                                       index:(int)currentIndex];
    });
}

- (void)movieToEnd{
    [self.avPlayer seekToTime:self.recordStartTime completionHandler:
     ^(BOOL finish){
         [self playVideo];
     }];
}

#pragma mark --RHCShortVideoCompilerDelegate
- (void)fetchKeyFramesWithKeyNum:(NSInteger)num{
    __weak typeof(self) bself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [bself.videoTrimView reloadImageWithCount:num];
        NSString *imagePath = [NSString stringWithFormat:@"%@/IMG%d.jpg",bself.videoTrimView.imagePath,0];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        bself.backgroundImageView.image = image;
    });
}

- (void)clickBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
}
/// 下一步点击事件
- (void)nextBtnClickAction
{
    @weakify(self);
    [self.avPlayer seekToTime:self.recordStartTime completionHandler:^(BOOL finish){
        [weak_self.avPlayer pause];
    }];
    
    //1.裁剪视频
    [kDRMEVideoManager asyncOriginVideoPath:self.videoURLStr RangeVideosBystartTime:self.recordStartTime endTime:self.recordEndTime progress:^(float progress) {
        
        [DRPPop showLoadingHUDWithMessage:nil];
        
    } complete:^(NSString * _Nonnull finishVideoPath) {
        
        [DRPPop  hideLoadingHUD];

        @strongify(self)
        if (self.cutVideoComplete) {
            self.cutVideoComplete(finishVideoPath);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }];

}

- (void)replayWithCurrentTime:(CMTime)time{

    double currentSeconds = CMTimeGetSeconds(time);
    double totalSeconds = CMTimeGetSeconds(self.recordEndTime);
    @weakify(self);
//    if (self.isShowSubtitle) {
//        [self checkSubTitleWithSecond:currentSeconds];
//    }
    if (currentSeconds >= totalSeconds && totalSeconds < self.videoDuration) {
        [self.avPlayer seekToTime:self.recordStartTime completionHandler:
         ^(BOOL finish){
//             [weakSelf.editMusicView restartMusicWhileVideoReplay];
             [weak_self playVideo];
         }];
    }
//    else if((currentSeconds <=  totalSeconds - self.videoObject.tietuItem.tietuImageTimeLength )&&(currentSeconds >=  totalSeconds - self.videoObject.tietuItem.tietuImageTimeLength - 0.2)){
//        if (!self.selelNoBtn)
//        [self.shortVideoView showTietuViewWithObject:self.videoObject.tietuItem withDelegate:self];
//    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // 禁止左滑返回
    self.fd_interactivePopDisabled = YES;
    self.navigationController.delegate = self;
//    [self startRendering];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self playVideo];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush ||
        operation == UINavigationControllerOperationPop) {
        self.animation.operation = operation;
        return self.animation;
    }
    return nil;
}

- (DRMEVideoEditPushAnimation *)animation{
    if (!_animation) {
        _animation = [[DRMEVideoEditPushAnimation alloc] init];
    }
    return _animation;
}
@end
