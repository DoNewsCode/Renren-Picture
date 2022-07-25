//
//  DRMEMosaicViewController.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/10/28.
//

#import "DRMEMosaicViewController.h"
#import "DRMEMosaicOptionView.h"
#import "DRMEMosaiView.h"

@interface DRMEMosaicViewController ()<MosaiViewDelegate>

@property(nonatomic,weak)  DRMEMosaicOptionView *mosaicOptionView;
@property (nonatomic, strong) DRMEMosaiView *mosaicView;

@property(nonatomic,weak) UIView *canvasView;

@end

@implementation DRMEMosaicViewController

- (DRMEPhotoEditAnimation *)animation
{
    if (!_animation) {
        _animation = [[DRMEPhotoEditAnimation alloc] init];
    }
    return _animation;
}

// 根据originImage布局后mosaicView
- (void)layoutMosaicViewViewSize
{
    
    CGSize imageSize = self.originImage.size;
    // 将self.view理解成一个画布
    CGRect bounds = self.canvasView.bounds;
    CGSize boundsSize = bounds.size;

    //work out the minimum scale of the object
    CGFloat scale = 0.0f;
    
    // Work out the size of the image to fit into the content bounds
    scale = MIN(boundsSize.width/imageSize.width,
                boundsSize.height/imageSize.height);
    CGSize scaledImageSize = (CGSize){floorf(imageSize.width * scale), floorf(imageSize.height * scale)};
    
//    self.mosaicView.centerX = scaledImageSize.width/2;
//    self.mosaicView.centerX = 0;
//    self.mosaicView.centerY = scaledImageSize.height/2;
//    self.mosaicView.size = scaledImageSize;
    
    self.mosaicView.sd_layout.centerXEqualToView(self.canvasView)
    .centerYEqualToView(self.canvasView)
    .widthIs(scaledImageSize.width)
    .heightIs(scaledImageSize.height);

    [self.mosaicView updateLayout];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    CGFloat height = kScreenHeight - kStatusBarHeight - 25 - 166;
    CGRect mosaicViewFrame = CGRectMake(0, kStatusBarHeight + 25, kScreenWidth, height);
    
    // 画布视图 -- 子view有 scrollView 和 imageView 和 标签、文字等效果
    UIView *canvasView = [[UIView alloc] initWithFrame:mosaicViewFrame];
    [self.view addSubview:canvasView];
    self.canvasView = canvasView;
    
    self.mosaicView = [[DRMEMosaiView alloc] init];
    self.mosaicView.deleagate = self;
    [canvasView addSubview:self.mosaicView];
    
    //  确定了self.mosaicView的frame后，再添加其子视图
    [self layoutMosaicViewViewSize];
    [self.mosaicView setupSubview];
    self.mosaicView.originalImage = self.originImage;
    
    CGRect toRect = [self.mosaicView convertRect:self.mosaicView.bounds toView:self.view];
    self.animation.toRect = toRect;
    
    UIImage *mosaicImage = [UIImage me_mosaicImage:self.originImage mosaicLevel:15];
    // 当前马赛克图
    self.mosaicView.mosaicImage = mosaicImage;
    
    DRMEMosaicOptionView *mosaicOptionView = [DRMEMosaicOptionView mosaicOptionView];
    [self.view addSubview:mosaicOptionView];
    self.mosaicOptionView = mosaicOptionView;
    
    mosaicOptionView.sd_layout.leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(166);
    
    WeakSelf(self)
    mosaicOptionView.clickCancelBlock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    
    mosaicOptionView.clickSureBlock = ^{
        NSLog(@"确定了 马赛克");
        
        UIImage *deadledImage = [weakself.mosaicView render];
        
        weakself.animation.animatImage = deadledImage;
        
        if (weakself.mosaicEditDoneBlock) {
            weakself.mosaicEditDoneBlock(deadledImage);
        }
        [weakself.navigationController popViewControllerAnimated:YES];
        
    };
    
    mosaicOptionView.clickResetBlock = ^{
        NSLog(@"还原上一次的马赛克路径");
        [weakself.mosaicView undo];
        
        // 判断是否可还原
        // 改变撤销按钮状态
        if ([weakself.mosaicView canUndo]) {
            weakself.mosaicOptionView.resetBtn.selected = YES;
        } else {
            weakself.mosaicOptionView.resetBtn.selected = NO;
        }
    };
    
    @weakify(self)
    mosaicOptionView.clickMosaicBlock = ^(UIButton * _Nonnull mosaicBtn) {
        NSInteger tag = mosaicBtn.tag;
        @strongify(self)
        if (tag == 101) {
            // 使用原图生成的马赛克图
            UIImage *mosaicImage = [UIImage me_mosaicImage:self.originImage mosaicLevel:15];
            self.mosaicView.mosaicImage = mosaicImage;
                        
        } else {
            // 第二种马赛克效果，怎么也不行
            self.mosaicView.mosaicImage = [self filterImage:self.originImage blurLevel:10];
        }
    };
}

- (UIImage *)filterImage:(UIImage *)image blurLevel:(CGFloat)blur {
    // 创建属性
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    // 滤镜效果 高斯模糊
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    // 指定模糊值 默认为10, 范围为0-100
    [filter setValue:[NSNumber numberWithFloat:blur] forKey:@"inputRadius"];
    // 生成图片
    CIContext *context = [CIContext contextWithOptions:nil];
    // 创建输出
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    // 生成CGImageRef
    CGImageRef outImage = [context createCGImage: result fromRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    
    CGImageRelease(outImage);
    
    return blurImage;
}

#pragma mark - 转场动画相关
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush ||
        operation == UINavigationControllerOperationPop) {
        self.animation.operation = operation;
        return self.animation;
    }
    return nil;
}

#pragma mark - MosaiViewDelegate
- (void)mosaiView:(DRMEMosaiView *)view TouchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 改变撤销按钮状态
    if ([view canUndo]) {
        self.mosaicOptionView.resetBtn.selected = YES;
    } else {
        self.mosaicOptionView.resetBtn.selected = NO;
    }
}

- (void)dealloc
{
    NSLog(@"---马赛克页面 销毁");
}

@end
