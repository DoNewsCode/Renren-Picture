//
//  DRIRecordSuccessPreview.m
//  短视频录制
//
//  Created by lihaohao on 2017/5/22.
//  Copyright © 2017年 低调的魅力. All rights reserved.
//

#import "DRIRecordSuccessPreview.h"
#import "UIButton+Convenience.h"
#import "DRIImagePickerController.h"
#import <DNCommonKit/DNBaseMacro.h>
#import "SDAutoLayout.h"
@interface DRIRecordSuccessPreview(){
    float _width;
    float _distance;
    
    
    UIView *_naviBar;
    UIButton *_backButton;
    UIButton *_selectButton;
    UIButton *_tagButton;
    UILabel *_indexLabel;
    UIButton *_doneButton;
}
@property (nonatomic ,strong) UIButton *cancelButton;
@property (nonatomic ,strong) UIButton *sendButton;
@property (nonatomic ,strong) UIImage *image;// 拍摄的图片
@property (nonatomic ,copy) NSString *videoPath; // 拍摄的视频地址
@property (nonatomic ,assign) BOOL isPhoto;// 是否是图片
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_8_4
@property (nonatomic ,strong) AVPlayerViewController *avPlayer;
#endif
@property (nonatomic ,assign) AVCaptureVideoOrientation orientation;
@end
@implementation DRIRecordSuccessPreview
- (void)setImage:(UIImage *)image videoPath:(NSString *)videoPath captureVideoOrientation:(AVCaptureVideoOrientation)orientation{
    _image = image;
    _videoPath = videoPath;
    _orientation = orientation;
    self.backgroundColor = [UIColor blackColor];
    if (_image && !videoPath) {
        _isPhoto = YES;
    }
    [self setupUI];
}
- (void)setupUI{
    CGFloat previewWidth = SCREEN_WIDTH;
    CGFloat previewHeight = SCREEN_WIDTH / 9 * 16;
    if (_isPhoto) {
        UIImageView *imageview = [[UIImageView alloc]initWithImage:_image];
        imageview.frame = CGRectMake(0, 0, previewWidth, previewHeight);
        if (_orientation == AVCaptureVideoOrientationLandscapeRight || _orientation ==AVCaptureVideoOrientationLandscapeLeft) {
            imageview.contentMode = UIViewContentModeScaleAspectFit;
        }
        imageview.center = self.center;
        [self addSubview:imageview];
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
        MPMoviePlayerController *mpPlayer = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL fileURLWithPath:_videoPath]];
        mpPlayer.view.frame = CGRectMake(0, naviBarHeight, SCREEN_WIDTH, self.height - naviBarHeight - DNTabbarHeight);
        mpPlayer.controlStyle = MPMovieControlStyleNone;
        mpPlayer.movieSourceType = MPMovieSourceTypeFile;
        mpPlayer.repeatMode = MPMovieRepeatModeOne;
        [mpPlayer prepareToPlay];
        [mpPlayer play];
        [self addSubview:mpPlayer.view];
#else
        AVPlayerViewController *avPlayer = [[AVPlayerViewController alloc]init];
        avPlayer.view.frame = CGRectMake(0, 0, previewWidth, previewHeight);
        avPlayer.view.center = self.center;
        avPlayer.showsPlaybackControls = NO;
        avPlayer.videoGravity = AVLayerVideoGravityResizeAspect;
        avPlayer.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:_videoPath]];
        [avPlayer.player play];
        [self addSubview:avPlayer.view];
        _avPlayer = avPlayer;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replay) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
#endif
    }
    _width = 148/2;
    _distance = 120/2;
    
//    // 取消
//    UIButton *cancelButton = [UIButton image:@"短视频_重拍" target:self action:@selector(cancel)];
//    cancelButton.bounds = CGRectMake(0, 0, _width, _width);
//    cancelButton.center = CGPointMake(self.center.x, self.bounds.size.height -_distance - _width/2);
//    [self addSubview:cancelButton];
//    _cancelButton = cancelButton;
//
//    // 发送
//    UIButton *sendButton = [UIButton image:@"短视频_完成" target:self action:@selector(send)];
//    sendButton.bounds = CGRectMake(0, 0, _width, _width);
//    sendButton.center = CGPointMake(self.center.x, self.bounds.size.height - _distance - _width/2);
//    [self addSubview:sendButton];
//    _sendButton = sendButton;
    
    [self configCustomNaviBar];
}

- (void)configCustomNaviBar {
    
    _naviBar = [[UIView alloc] initWithFrame:CGRectZero];
    _naviBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_backButton setImage:[UIImage dri_imageNamedFromMyBundle:@"navi_back"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setTitle:@"确定" forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_naviBar addSubview:_doneButton];
    [_naviBar addSubview:_backButton];
    [self addSubview:_naviBar];
    
    CGFloat statusBarHeight = [DRICommonTools dri_statusBarHeight];
    CGFloat statusBarHeightInterval = statusBarHeight - 20;
    CGFloat naviBarHeight = statusBarHeight + 44;
    _naviBar.frame = CGRectMake(0, 0, self.width, naviBarHeight);
    _backButton.frame = CGRectMake(10, 10 + statusBarHeightInterval, 44, 44);
    [_doneButton sizeToFit];
    _doneButton.frame = CGRectMake(self.width - 56, 10 + statusBarHeightInterval, 44, 44);
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    NSLog(@"预览图");
//    [UIView animateWithDuration:0.25 animations:^{
//        _cancelButton.bounds = CGRectMake(0, 0, _width, _width);
//        _cancelButton.center = CGPointMake(self.bounds.size.width / 4, self.bounds.size.height -_distance - _width/2);
//        _sendButton.bounds = CGRectMake(0, 0, _width, _width);
//        _sendButton.center = CGPointMake(self.bounds.size.width / 4 * 3, self.bounds.size.height - _distance - _width/2);
//    }];
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_8_4
- (void)replay{
    if (_avPlayer) {
        [_avPlayer.player seekToTime:CMTimeMake(0, 1)];
        [_avPlayer.player play];
    }
}
#endif
- (void)cancel{
    if (self.cancelBlcok) {
        self.cancelBlcok();
    }
}
- (void)send{
    if (self.sendBlock) {
        self.sendBlock(_image, _videoPath);
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}
@end
