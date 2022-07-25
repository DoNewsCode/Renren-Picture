//
//  DRMEVideoEditViewController.m
//  Renren-EditImage
//
//  Created by 陈金铭 on 2019/10/17.
//

#import "DRMEVideoEditViewController.h"
#import <DNCommonKit/UINavigationController+FDFullscreenPopGesture.h>
#import "DRMECustomBtn.h"
#import <AVFoundation/AVFoundation.h>
//#import "DRMEVideoReader.h"
//#import "DRMEOpenGLView.h"
//#import "DRMEManager.h"

#import "DRMECutVideoViewController.h"
#import "DRMEVideoCompiler.h"

#import "DRMEEditVideoOptionView.h"
#import "DRMEEditOptionModel.h"

@interface DRMEVideoEditViewController ()
<UINavigationControllerDelegate,
DRMEEditVideoOptionViewDelegate>
{
    NSString *videoPath;
}
@property (nonatomic , strong) DRMEVideoCompiler *videoCompiler;

@property(nonatomic,weak) UIButton *doneBtn;
@property(nonatomic,weak) DRMEEditVideoOptionView *editOptinoView;

@property (nonatomic , strong) UIView *avPlayerView;
@property (nonatomic , strong) AVPlayer *avPlayer;
@property (nonatomic , strong) AVPlayerLayer *avPlayerLayer;
@property (nonatomic , strong) AVPlayerItem *avPlayerItem;
@property (nonatomic , strong) AVAsset *videoAsset;

@end

@implementation DRMEVideoEditViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self createContent];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // 禁止左滑返回
    self.fd_interactivePopDisabled = YES;
    [self playerStartPlay];
//    [self startRendering];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_avPlayer pause];
//    _avPlayer = nil ;
//    [self.videoReader stopReading];
//    [self.videoReader destory];
    
    [super viewWillDisappear:animated];
    
}

- (void)createContent
{
    // TODO: 暂用本地视频
    //1.读取本地视频
    if (!self.videoURLStr) {
        NSLog(@"没有路径视频，你玩儿我呢");
        return;
    }
    //2.初始化播放器
    [self initAvPlayerSetttings:self.videoURLStr];
    
    [self configUI];
}

- (void)configUI
{
    // 返回
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage me_imageWithName:@"me_back_btn"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    backBtn.sd_layout.leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, kStatusBarHeight + 10)
    .widthIs(44)
    .heightIs(44);
    
    // 完成
    UIButton *doneBtn = [[UIButton alloc] init];
    doneBtn.backgroundColor = [UIColor colorWithHexString:@"#2A73EB"];
    doneBtn.titleLabel.font = kFontMediumSize(15);
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    self.doneBtn = doneBtn;
    
    doneBtn.layer.cornerRadius = 15.f;
    doneBtn.sd_layout.centerYEqualToView(backBtn)
    .rightSpaceToView(self.view, 15)
    .widthIs(64).heightIs(30);
    
    // 编辑视频所需的选项视图
    DRMEEditVideoOptionView *editOptinoView = [[DRMEEditVideoOptionView alloc] init];
    editOptinoView.delegate = self;
    [self.view addSubview:editOptinoView];
    self.editOptinoView = editOptinoView;
    
    editOptinoView.sd_layout.leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, kSafeAreaHeight + 20)
    .heightIs(60);
    
    [doneBtn updateLayout];
    [editOptinoView updateLayout];
    
    self.avPlayerView.frame = CGRectMake(15, doneBtn.bottom + 15, kScreenWidth - 30, editOptinoView.top - 15 - (doneBtn.bottom + 15));
    self.avPlayerLayer.frame = self.avPlayerView.bounds;
    
}

- (void)initAvPlayerSetttings:(NSString *)videoURLStr
{
    
    if ([videoURLStr isNotBlank]) {
        _videoAsset  = [AVAsset assetWithURL:[NSURL fileURLWithPath:videoURLStr]];
    }
    self.avPlayerItem = [AVPlayerItem playerItemWithAsset:_videoAsset];
    self.avPlayer = [AVPlayer playerWithPlayerItem:self.avPlayerItem];
    [self.avPlayerLayer removeFromSuperlayer];
    self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    [self.avPlayerView removeFromSuperview];
    self.avPlayerView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.avPlayerView];
    [self.avPlayerView.layer addSublayer:self.avPlayerLayer];
    
    [self.avPlayer seekToTime:kCMTimeZero];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayerItem];
    
    [self playerStartPlay];
    
    // 大小
    self.avPlayerView.frame = CGRectMake(15, self.doneBtn.bottom + 15, kScreenWidth - 30, self.editOptinoView.top - 15 - (self.doneBtn.bottom + 15));
    self.avPlayerLayer.frame = self.avPlayerView.bounds;
}


- (void)playVideo
{
    self.avPlayer.rate = 0.0f;
    [self playerStartPlay];
}

#pragma mark - DRMEEditVideoOptionView
- (void)editPhotoOptionView:(DRMEEditVideoOptionView *)editPhotoOptionView
           clickOptionModel:(DRMEEditOptionModel *)optionModel
{
    DRMEEditOption editOption = optionModel.editOption;
    
    switch (editOption) {
        case DRMEEditOptionVideoTailor:
        {
            NSLog(@"视频裁剪");
            [self bottomEditBtnClickAction];
            break;
        }
        case DRMEEditOptionFilter:
        {
            NSLog(@"滤镜");
            break;
        }
        default:
            break;
    }
}

#pragma mark - 点击事件
- (void)backBtnClickAction
{
    NSLog(@"关闭---点击事件");
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)bottomEditBtnClickAction
{
    NSLog(@"编辑---点击事件");
    [self.avPlayer pause];
    //视频裁剪控制器
    DRMECutVideoViewController *cutVc = [[DRMECutVideoViewController alloc]init];
    cutVc.videoURLStr = self.videoURLStr;
    //当前播放时间
    cutVc.curPlayTime = self.avPlayer.currentTime;
    cutVc.animation.animatImage = [self.videoCompiler getVideoCoverImage:self.avPlayerItem.asset withTime:[NSNumber numberWithFloat:CMTimeGetSeconds(self.avPlayer.currentTime)].doubleValue];
    cutVc.animation.fromRect = self.avPlayerView.frame;
    self.navigationController.delegate = cutVc;
    [self.navigationController pushViewController:cutVc animated:YES];
    
    @weakify(self)
    cutVc.cutVideoComplete = ^(NSString * _Nonnull videoPath) {
       
        @strongify(self)
        /// 这里是经过裁剪后的视频路径，需要保存并播放
        self.videoURLStr = videoPath;
        [self initAvPlayerSetttings:self.videoURLStr];
    };
    
}

- (void)doneBtnClickAction
{
    if (self.videoEditComplete) {
        self.videoEditComplete(self.videoURLStr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)playerStartPlay
{
    [self.avPlayer play];
}

- (void)moviePlayToEnd
{
    NSLog(@"视频播放结束");
    //重新播放
    [self replayWithCurrentTime:kCMTimeZero];
}


- (void)replayWithCurrentTime:(CMTime)time
{
    //TODO: iOS 13崩溃问题
    CMTime replayTime = CMTimeMake(0, self.avPlayerItem.duration.timescale);
    @try
    {
          if (CMTIME_IS_VALID(replayTime))
          {
               [self.avPlayer seekToTime:replayTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                   if (finished) {
                        [self playerStartPlay];
                    }
                }];
           }else{
                [self playerStartPlay];
           }
    }
    @catch (NSException * exception) {
          [self playerStartPlay];
    }
}

//
//#pragma mark -   FUVideoReaderDelegate
//- (void)videoReaderDidReadVideoBuffer:(CVPixelBufferRef)pixelBuffer
//{
//    [kDRMEManager renderItemsToPixelBuffer:pixelBuffer];
//    [self.glView displayPixelBuffer:pixelBuffer];
//}
//
///// 读取结束
//- (void)videoReaderDidFinishReadSuccess:(BOOL)success
//{
//    NSLog(@"---videoReaderDidFinishReadSuccess");
////    [self startRendering];
//    //重新播放
//    [self replayWithCurrentTime:kCMTimeZero];
//}



#pragma mark - lazyLoad
- (DRMEVideoCompiler *)videoCompiler{
    if (!_videoCompiler) {
        _videoCompiler = [[DRMEVideoCompiler alloc] initWithAVAsset:self.avPlayerItem.asset delegate:self];
    }
    return _videoCompiler;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
