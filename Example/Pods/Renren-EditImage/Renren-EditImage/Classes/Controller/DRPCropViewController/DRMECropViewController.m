
#import "DRMECropViewController.h"
#import "DRMECropView.h"
#import "DRMECropToolbar.h"
#import "DNBaseMacro.h"
#import "UIImage+DRMECropRotate.h"

@interface DRMECropViewController ()

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) DRMECropView *cropView;
@property (nonatomic, strong) DRMECropToolbar *toolbar;

@end

@implementation DRMECropViewController

#pragma mark - 懒加载

- (NSMutableArray<DRMEStickerLabelView *> *)labelArray
{
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

#pragma mark - 初始化
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (instancetype)initWithImage:(UIImage *)image
{
    NSParameterAssert(image);

    self = [super init];
    if (self) {
        self.image = image;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.blackColor;
    
    CGRect cropViewFrame;
    cropViewFrame.origin.x = 0;
    cropViewFrame.origin.y = kStatusBarHeight + 39;
    cropViewFrame.size.width = kScreenWidth;
    cropViewFrame.size.height = kScreenHeight - 180 - kStatusBarHeight - 39;
    
    // 裁剪区域视图
//    self.cropView = [[DRMECropView alloc] initWithFrame:cropViewFrame image:self.image];
    self.cropView = [[DRMECropView alloc] initWithFrame:cropViewFrame image:self.image labelArray:self.labelArray];
//    self.cropView.delegate = self;
    [self.view addSubview:self.cropView];
    
    // 工具条
    self.toolbar = [[DRMECropToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 180, SCREEN_WIDTH, 180)];
    [self.view addSubview:self.toolbar];
    
    WeakSelf(self)
    self.toolbar.rotateButtonButtonTapped = ^{
        [weakself rotateCropViewCounterclockwise];
    };
    
    self.toolbar.resetButtonButtonTapped = ^{
        [weakself resetCropViewLayout];
    };
    
    self.toolbar.cancelButtonButtonTapped = ^{
        [weakself cancelButtonTapped];
    };
    
    self.toolbar.sureButtonButtonTapped = ^{
        [weakself doneButtonTapped];
    };
}

#pragma mark - 事件

- (void)cancelButtonTapped
{
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(cropViewControllerDidCancelCrop:)]) {
        [self.delegate cropViewControllerDidCancelCrop:self];
    }
}

- (void)doneButtonTapped
{
    CGRect cropFrame = self.cropView.imageCropFrame;
    NSInteger angle = self.cropView.angle;
//    if ([self.delegate respondsToSelector:@selector(cropViewController:didCropToImage:withRect:angle:)]) {
//        UIImage *image = nil;
//        if (angle == 0 && CGRectEqualToRect(cropFrame, (CGRect){CGPointZero, self.image.size})) {
//            image = self.cropView.operationImage;
//        } else {
//            image = [self.cropView.operationImage croppedImageWithFrame:cropFrame angle:angle circularClip:NO];
//        }
//        //dispatch on the next run-loop so the animation isn't interuppted by the crop operation
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.delegate cropViewController:self didCropToImage:image withRect:cropFrame angle:angle];
//        });
//    }
    if ([self.delegate respondsToSelector:@selector(cropViewController:didCropToImage:centerXDistance:centerYDistance:cropSize:)]) {
        
        UIImage *image = nil;
        if (angle == 0 && CGRectEqualToRect(cropFrame, (CGRect){CGPointZero, self.image.size})) {
            image = self.cropView.operationImage;
        } else {
            image = [self.cropView.operationImage croppedImageWithFrame:cropFrame angle:angle circularClip:NO];
        }
        
        // 如果有文字，算一下，文字中心点距离裁剪框中心点的距离
        CGSize distanceS = [self.cropView getLabelDistance];
        
        NSLog(@"distanceS == %@", NSStringFromCGSize(distanceS));
        
        //dispatch on the next run-loop so the animation isn't interuppted by the crop operation
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.delegate cropViewController:self
                               didCropToImage:image
                              centerXDistance:distanceS.width
                              centerYDistance:distanceS.height
             cropSize:self.cropView.cropBoxFrame.size];
        });
        
    } else {
        [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)resetCropViewLayout
{
    NSLog(@"还原");
    [self.cropView resetLayoutToDefaultAnimated:YES];
}

- (void)rotateCropViewCounterclockwise
{
    NSLog(@"旋转");
    [self.cropView rotateImageNinetyDegreesAnimated:YES];
}

@end
