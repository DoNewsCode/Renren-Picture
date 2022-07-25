//
//  DRIRecordViewController.m
//  短视频录制
//
//  Created by lihaohao on 2017/5/19.
//  Copyright © 2017年 低调的魅力. All rights reserved.
//

#import "DRIRecordViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "DRIRecordManager.h"
#import "DRIRecordSuccessPreview.h"
#import "DRIRecordProgressView.h"
#import "UIButton+Convenience.h"
#import "DRIMotionManager.h"
#import <DNCommonKit/DNBaseMacro.h>
#import "DRIImagePickerController.h"
#import "DRPPop.h"
#define WEAKSELF __weak typeof(self) weakSelf = self;
#define STRONGSELF __strong typeof(weakSelf) strongSelf = weakSelf;
#define TIMER_INTERVAL 0.5 //定时器时间间隔
#define RECORD_TIME 0.5 //开始录制视频的时间
#define VIDEO_MIN_TIME 3 // 录制视频最短时间
@interface DRIRecordViewController ()<DRIRecordEngineDelegate,UIGestureRecognizerDelegate,DRIMotionManagerDeviceOrientationDelegate>
@property (nonatomic ,strong) DRIRecordManager *recordManger;
@property (nonatomic ,assign) BOOL allowRecord;//允许录制
@property (nonatomic ,strong) NSTimer *timer;// 定时器
@property (nonatomic ,assign) NSTimeInterval timeInterval;// 时长
@property (nonatomic ,assign) BOOL isEndRecord;// 录制结束
@property (nonatomic ,strong) UIImageView *focusView;// 对焦图片
@property (nonatomic ,strong) DRIRecordSuccessPreview *preview;// 拍摄成功预览视图
@property (nonatomic ,strong) DRIRecordProgressView *recordButton;// 录制按钮
@property (nonatomic ,strong) UILabel *tipLabel;// 提示标签
@property (nonatomic ,strong) UIButton *exitButton;// 退出按钮
@property (nonatomic ,strong) UIButton *switchButton;// 切换摄像头按钮
@property (nonatomic ,assign) UIDeviceOrientation lastDeviceOrientation;// 记录屏幕当前方向
@property (nonatomic ,strong) UILabel *alartLabel;// (提示)拍摄时间太短,不少于3s
@end

@implementation DRIRecordViewController
#pragma mark -
#pragma mark -Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"拍摄或录像";
    self.allowRecord = YES;
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // 监听设备方向
    [[DRIMotionManager sharedManager] startDeviceMotionUpdates];
    [DRIMotionManager sharedManager].delegate = self;;
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
#endif
    [self setUpAlbumAuthorizationStatus];
}

- (void)startUp{
    dispatch_async(dispatch_get_main_queue(), ^{
    if (_recordManger == nil) {
            [self.recordManger previewLayer].frame = self.view.bounds;
            [self.view.layer insertSublayer:[self.recordManger previewLayer] atIndex:0];
    }
        self.recordButton.userInteractionEnabled = YES;
        [self.recordManger startUp];
    });
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    // 停止监听设备方向
    [DRIMotionManager sharedManager].delegate = nil;
    [[DRIMotionManager sharedManager] stopDeviceMotionUpdates];
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
#endif
    [self removeTimer];
    [self.recordManger shutdown];
}
- (void)exitRecordController{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_8_4
- (BOOL)prefersStatusBarHidden{
    return YES;
}
#endif

#pragma mark -
#pragma mark -拍照
- (void)takephoto{
    WEAKSELF
    [self.recordManger takePhoto:^(UIImage *image) {
        NSLog(@"拍照结束:%@",image);
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, NULL);
        STRONGSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.recordManger shutdown];
            [strongSelf.preview setImage:image videoPath:nil captureVideoOrientation:[[DRIMotionManager sharedManager] currentVideoOrientation]];
        });
    }];
}
#pragma mark -
#pragma mark -录制视频
- (void)startRecord{
    if (self.recordManger.isCapturing) {
        [self.recordManger resumeCapture];
    }else {
        [self.recordManger startCapture];
    }
}
- (void)stopRecord:(BOOL)isSuccess{
    WEAKSELF
    _isEndRecord = NO;
    [self.recordButton setProgress:0];
    if (isSuccess) {
        [self hideAllOperationViews];
    } else {
        [self showExitAndSwitchViews];
    }
    [self.recordManger stopCaptureWithStatus:isSuccess handler:^(UIImage *movieImage,NSString *filePath) {
        NSLog(@"第一帧:image:%@",movieImage);
        STRONGSELF
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.recordManger shutdown];
            [strongSelf.preview setImage:nil videoPath:filePath captureVideoOrientation:[[DRIMotionManager sharedManager] currentVideoOrientation]];
        });
    }];
}
#pragma mark -
#pragma mark - 发送 or 重拍
// 点击发送
- (void)sendWithImage:(UIImage *)image videoPath:(NSString *)videoPath{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (image){
        dict[UIImagePickerControllerMediaType] = @"public.image";
        dict[UIImagePickerControllerOriginalImage] = image.copy;
        
    }
    if (videoPath){
        dict[UIImagePickerControllerMediaType] = @"public.movie";
        dict[UIImagePickerControllerMediaURL] = [NSURL fileURLWithPath:videoPath];
    }
    
    if ([self.delegate respondsToSelector:@selector(recordViewController:didFinishPickingMediaWithInfo:)]) {
        [self.delegate recordViewController:self didFinishPickingMediaWithInfo:[NSDictionary dictionaryWithDictionary:dict] ];
    }
    NSLog(@"发送");
    
//    DRIImagePickerController *imagePickerVc = (DRIImagePickerController *)self.navigationController;
//    if (imagePickerVc.autoDismiss) {
    //    [self exitRecordController];
//    }
}
// 点击重拍
- (void)cancel{
    NSLog(@"重拍");
    if (_preview) {
        [_preview removeFromSuperview];
        _preview = nil;
    }
    [self.recordButton resetScale];
    [self.recordButton setEnabled:YES];
    [self showAllOperationViews];
    [self.recordManger startUp];
}
#pragma mark -
#pragma mark - set、get方法
- (DRIRecordManager *)recordManger {
    if (!_recordManger) {
        _recordManger = [[DRIRecordManager alloc] init];
        _recordManger.delegate = self;
    }
    return _recordManger;
}
- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(caculateTime) userInfo:nil repeats:YES];
    }
    return _timer;
}
- (UIImageView *)focusView{
    if (!_focusView) {
        _focusView = [[UIImageView alloc]initWithImage:[UIImage dri_imageNamedFromMyBundle:@"camera_focus_red"]];
        _focusView.bounds = CGRectMake(0, 0, 40, 40);
        [self.view addSubview:_focusView];
    }
    return _focusView;
}
- (DRIRecordSuccessPreview *)preview{
    if (!_preview) {
        _preview = [[DRIRecordSuccessPreview alloc]initWithFrame:self.view.bounds];
        WEAKSELF
        [_preview setSendBlock:^(UIImage *image,NSString *videoPath){
            STRONGSELF
            [strongSelf sendWithImage:image videoPath:videoPath];
        }];
        [_preview setCancelBlcok:^{
            STRONGSELF
            [strongSelf cancel];
        }];
        [self.view addSubview:_preview];
    }
    return _preview;
}
- (UILabel *)alartLabel{
    if (!_alartLabel) {
        _alartLabel = [[UILabel alloc]init];
        _alartLabel.text = @"拍摄时间太短,不少于3s";
        _alartLabel.font = [UIFont systemFontOfSize:15];
        _alartLabel.textColor = [UIColor whiteColor];
        _alartLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        _alartLabel.textAlignment = NSTextAlignmentCenter;
        _alartLabel.layer.cornerRadius = 19;
        _alartLabel.clipsToBounds = YES;
        CGFloat width = [_alartLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 76/2) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
        _alartLabel.bounds = CGRectMake(0, 0, width + 30, 76/2);
        _alartLabel.center = CGPointMake(self.view.center.x, _tipLabel.center.y - _tipLabel.bounds.size.height/2 - 48/2 - _tipLabel.bounds.size.height/2);
        [self.view addSubview:_alartLabel];
    }
    return _alartLabel;
}
#pragma mark -
#pragma mark -Set Up UI
- (void)setupUI{
    
    CGFloat statusBarHeight = [DRICommonTools dri_statusBarHeight];
    CGFloat statusBarHeightInterval = statusBarHeight - 20;
    // 退出按钮
    UIButton *exitButton = [UIButton image:@"Record_close" target:self action:@selector(exitRecordController)];
    exitButton.frame = CGRectMake(10, statusBarHeightInterval + 10, 44,44);
    [self.view addSubview:exitButton];
    _exitButton = exitButton;
    
    // 录制按钮
    DRIRecordProgressView *recordButton = [[DRIRecordProgressView alloc]initWithFrame:CGRectMake(0, 0, 86, 86)];
    recordButton.center = CGPointMake(self.view.center.x, self.view.bounds.size.height - (iPhoneX?146:126));
    [recordButton addTarget:self action:@selector(toucheUpInsideOrOutSide:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [recordButton addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:recordButton];
    _recordButton = recordButton;
    
    // 提示文字:点击拍照,长按拍摄
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.bounds = CGRectMake(0, 0, 200, 20);
    tipLabel.center = CGPointMake(self.view.center.x, self.view.bounds.size.height - (200 + 13));
    NSString *text = @"点击拍照，长按摄像";
    if (self.onlyTakePhoto) {
        text = @"点击拍照";
    }else if (self.onlyTakeVideo){
        text = @"长按摄像";
    }
    tipLabel.text = text;
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:tipLabel];
    _tipLabel = tipLabel;
    
    // 切换摄像头按钮
    UIButton *switchButton = [UIButton image:@"Record_rotato"target:self action:@selector(switchCamara:)];
    switchButton.frame = CGRectMake(self.view.bounds.size.width - 44 - 10 , 10 + statusBarHeightInterval, 44, 44);
    [self.view addSubview:switchButton];
    _switchButton = switchButton;
    
    // 对焦手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    self.recordButton.userInteractionEnabled = NO;
}

#pragma mark -
#pragma mark -对焦,闪光灯,曝光处理,切换摄像头
- (void)tapGesture:(UITapGestureRecognizer *)tapGesture{
    NSLog(@"点击屏幕");
    if (!self.recordManger.isRunning) return;
    CGPoint point = [tapGesture locationInView:self.view];
    [self setFocusCursorWithPoint:point];
    CGPoint camaraPoint = [self.recordManger.previewLayer captureDevicePointOfInterestForPoint:point];
    [self.recordManger focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposureMode:AVCaptureExposureModeContinuousAutoExposure atPoint:camaraPoint];
}
/**
 设置对焦光标位置
 
 @param point 光标位置
 */
-(void)setFocusCursorWithPoint:(CGPoint)point{
    self.focusView.center=point;
    self.focusView.transform=CGAffineTransformMakeScale(1.5, 1.5);
    self.focusView.alpha=1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusView.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusView.alpha=0;
        
    }];
}
// 切换摄像头
- (void)switchCamara:(UIButton *)button{
    button.selected = !button.selected;
    [self.recordManger changeCameraInputDeviceisFront:button.selected];
}
#pragma mark -
#pragma mark -显示或隐藏界面
// 显示所有操作按钮
- (void)showAllOperationViews{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.recordButton setHidden:NO];
        [self.exitButton setHidden:NO];
        [self.tipLabel setHidden:NO];
        [self.switchButton setHidden:NO];
    });
}
// 隐藏所有操作按钮
- (void)hideAllOperationViews{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.recordButton setHidden:YES];
        [self.exitButton setHidden:YES];
        [self.tipLabel setHidden:YES];
        [self.switchButton setHidden:YES];
    });
}
// 拍摄结束后显示退出按钮和切换摄像头按钮
- (void)showExitAndSwitchViews{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.exitButton setHidden:NO];
//        [self.switchButton setHidden:NO];
        [self.tipLabel setHidden:NO];
    });
}
// 开始拍摄时隐藏退出和切换摄像头按钮
- (void)hideExitAndSwitchViews{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.exitButton setHidden:YES];
//        [self.switchButton setHidden:YES];
        [self.tipLabel setHidden:YES];
    });
}
#pragma mark -
#pragma mark -定时器
// 计时
- (void)caculateTime{
    
    _timeInterval += TIMER_INTERVAL;
    NSLog(@"计时器:_timeInterval:%f",_timeInterval);
    if (_timeInterval == RECORD_TIME) {
        NSLog(@"开始录制视频");
        [self.recordButton setScale];
        [self startRecord];
    } else if (_timeInterval >= RECORD_TIME + VIDEO_MIN_TIME) {
        [self removeTimer];
    }
}
// 按钮按下事件
- (void)touchDown:(UIButton *)button{
    NSLog(@"按下按钮");
    [self hideExitAndSwitchViews];
    if (!self.onlyTakePhoto) {
        [self removeTimer];
        [self timer];
    }else{
        [self.recordButton setScale];
    }
}
// 按钮抬起
- (void)toucheUpInsideOrOutSide:(UIButton *)button{
    NSLog(@"抬起按钮:__timeInterval==:%f",_timeInterval);
    [self removeTimer];
    
    if (self.onlyTakePhoto) {
        [self.recordButton resetScale];
        // 拍照
        NSLog(@"拍照");
        [self.recordButton setEnabled:NO];
        [self hideAllOperationViews];
        [self takephoto];
        return;
    }
    if (_timeInterval >= RECORD_TIME && _timeInterval < RECORD_TIME + VIDEO_MIN_TIME) {
        // 录制时间太短
        NSLog(@"录制时间太短");
        [self stopRecord:NO];
        [self alart];//提示用户
        [self.recordButton resetScale];
    } else if (_timeInterval < RECORD_TIME) {
        if (self.onlyTakeVideo) {
            [self showAllOperationViews];
            [DRPPop showErrorHUDWithMessage:@"请长按进行摄像" completion:nil];
            return;
        }
        // 拍照
        NSLog(@"拍照");
        [self.recordButton setEnabled:NO];
        [self hideAllOperationViews];
        [self takephoto];
    } else {
        // 拍摄视频
        NSLog(@"结束录制");
        if (!_isEndRecord) {
            [self.recordButton setEnabled:NO];
            [self stopRecord:YES];
        }
    }
    _timeInterval = 0;
}
// 移除定时器
- (void)removeTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
#pragma mark -
#pragma mark -相机,麦克风权限
- (void)authorizationStatus{
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            NSLog(@"允许访问相机权限");
        } else {
            NSLog(@"不允许相机访问");
        }
    }];
    
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        if (granted) {
            NSLog(@"允许麦克风权限");
        } else {
            NSLog(@"不允麦克风访问");
        }
    }];
    
}

#pragma mark -
#pragma mark -DRIRecordEngineDelegate(录制进度回调)
- (void)recordProgress:(CGFloat)progress{
    NSLog(@"progress:%f",progress);
    if (progress >= 0) {
        [_recordButton setProgress:progress];
    }
    if ((int)progress == 1) {
        _isEndRecord = YES;
        [self stopRecord:YES];
    }
}

#pragma mark -
#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint point = [touch locationInView:self.view];
    if (point.y >= self.view.bounds.size.height - 190) {
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark -设备不支持自动选择
-(BOOL)shouldAutorotate{
    return NO;
}
#pragma mark -
#pragma mark -DRIMotionManagerDeviceOrientationDelegate --> 控制按钮方向
-(void)motionManagerDeviceOrientation:(UIDeviceOrientation)deviceOrientation{
    
    if (_lastDeviceOrientation == deviceOrientation) return;
    CGFloat angle = 0;
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:
            angle = 0;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        case UIDeviceOrientationLandscapeLeft:
            angle = M_PI_2;
            break;
        case UIDeviceOrientationLandscapeRight:
            angle = -M_PI_2;
            break;
        default:
            break;
    }
    [UIView animateWithDuration:0.25 animations:^{
        _exitButton.transform = CGAffineTransformRotate(CGAffineTransformIdentity, angle);
        _switchButton.transform = CGAffineTransformRotate(CGAffineTransformIdentity, angle);
    }];
    _lastDeviceOrientation = deviceOrientation;
    NSLog(@"deviceOrientation:%ld",(long)deviceOrientation);
}
- (void)alart{
    [self.view bringSubviewToFront:self.alartLabel];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_alartLabel) {
            [UIView animateWithDuration:0.25 animations:^{
                _alartLabel.alpha = 0;
            } completion:^(BOOL finished) {
                [_alartLabel removeFromSuperview];
                _alartLabel = nil;
            }];
        }
    });
}

- (void)setUpVideoAuthorizationStatus {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)) {

        dispatch_async(dispatch_get_main_queue(), ^{{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请在iPhone的“设置-隐私-相机\"选项中，允许人人访问你的相机" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:[NSBundle dri_localizedStringForKey:@"Setting"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    if (self.navigationController.childViewControllers.count >= 2) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[NSBundle dri_localizedStringForKey:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if (self.navigationController.childViewControllers.count >= 2) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
                [alert addAction:cancelAction];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
                
                return;
            }
        });
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
                if (granted) {
                    [self setUpAudioAuthorizationStatus];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];

                        });
                }
            
        }];
    } else {
        [self setUpAudioAuthorizationStatus];
    }
}

- (void)setUpAudioAuthorizationStatus {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)) {

        dispatch_async(dispatch_get_main_queue(), ^{{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请在iPhone的“设置-隐私-麦克风\"选项中，允许人人访问你的麦克风" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:[NSBundle dri_localizedStringForKey:@"Setting"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    if (self.navigationController.childViewControllers.count >= 2) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[NSBundle dri_localizedStringForKey:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if (self.navigationController.childViewControllers.count >= 2) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
                [alert addAction:cancelAction];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
                
                return;
            }
        });
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            
                if (granted) {
                    [self startUp];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];

                        });
                }
            
        }];
    } else {
        [self startUp];
    }
}

- (void)setUpAlbumAuthorizationStatus{
    //----第一次不会进来
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {

        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请在iPhone的“设置-隐私-照片\"选项中，允许人人访问你的手机相册" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:[NSBundle dri_localizedStringForKey:@"Setting"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                if (self.navigationController.childViewControllers.count >= 2) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self dismissViewControllerAnimated:YES completion:^{
//                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                }
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[NSBundle dri_localizedStringForKey:@"Cancel"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                if (self.navigationController.childViewControllers.count >= 2) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
            [alert addAction:cancelAction];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            
            return;
        });
    }else{
        //----每次都会走进来
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [self setUpVideoAuthorizationStatus];
                    NSLog(@"----------Authorized---------");
                    
                } else if(status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }
            }];
    }
    
    
}
#pragma mark - UIAlertViewDelegate

#pragma mark -
#pragma mark -dealloc
- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    [super dismissViewControllerAnimated:flag completion:completion];
}
@end

