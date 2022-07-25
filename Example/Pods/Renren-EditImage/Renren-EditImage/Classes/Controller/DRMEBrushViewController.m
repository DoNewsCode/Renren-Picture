//
//  DRMEBrushViewController.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/4/9.
//

#import "DRMEBrushViewController.h"
#import "DRMEDrawBackgoupImageView.h"
#import "UIImage+Pop.h"
#import "DRMEBrushOptionView.h"

@interface DRMEBrushViewController ()
<DRMEBrushOptionViewDelegate>

@property(nonatomic,weak) UIView *canvasView;
@property(nonatomic,weak) DRMEDrawBackgoupImageView *drawBackgourp;

@end

@implementation DRMEBrushViewController

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
    
    
    self.drawBackgourp.sd_layout.centerXEqualToView(self.canvasView)
    .centerYEqualToView(self.canvasView)
    .widthIs(scaledImageSize.width)
    .heightIs(scaledImageSize.height);

    [self.drawBackgourp updateLayout];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat height = kScreenHeight - kStatusBarHeight - 25 - 166;
    CGRect mosaicViewFrame = CGRectMake(0, kStatusBarHeight + 25, kScreenWidth, height);
    
    // 画布视图
    UIView *canvasView = [[UIView alloc] initWithFrame:mosaicViewFrame];
    [self.view addSubview:canvasView];
    self.canvasView = canvasView;
    
    DRMEDrawBackgoupImageView *drawBackgourp = [DRMEDrawBackgoupImageView initWithImage:self.originImage frame:CGRectZero lineWidth:8.0 lineColor:[UIColor whiteColor]];
    [self.view addSubview:drawBackgourp];
    self.drawBackgourp = drawBackgourp;

    [self layoutMosaicViewViewSize];
    [drawBackgourp addControl];
    
    
    CGRect toRect = [drawBackgourp convertRect:drawBackgourp.bounds toView:self.view];
    self.animation.toRect = toRect;
   
    
    
    DRMEBrushOptionView *brushOptionView = [[DRMEBrushOptionView alloc] init];
    brushOptionView.delegate = self;
    [self.view addSubview:brushOptionView];
    
    brushOptionView.sd_layout.leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(166);
    
    WeakSelf(self)
    brushOptionView.sureButtonButtonTapped = ^{
        UIImage *image = [drawBackgourp getImage];
        
        weakself.animation.animatImage = image;
        
        NSLog(@"最终的图片");
        if (weakself.brushSuccessBlock) {
            weakself.brushSuccessBlock(image);
        }
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    
    brushOptionView.cancelButtonButtonTapped = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    
    @weakify(brushOptionView)
    brushOptionView.resetButtonButtonTapped = ^{
        @strongify(brushOptionView)
        [weakself.drawBackgourp revokeScreen];
        
        if ([weakself.drawBackgourp hasRevoke]) {
            brushOptionView.resetBtn.selected = YES;
        } else {
            brushOptionView.resetBtn.selected = NO;
        }
    };

    drawBackgourp.touchesEndedBlock = ^{
        if ([weakself.drawBackgourp hasRevoke]) {
            brushOptionView.resetBtn.selected = YES;
        }
    };
    
//    brushOptionView.resetBtn.selected = NO;
//    brushOptionView.resetBtn.selected = YES;
}

#pragma mark - DRMEBrushOptionView
- (void)brushOptionView:(DRMEBrushOptionView *)brushOptionView
     didClickBrushModel:(DRMEBrushModel *)brushModel
{
    UIColor *color = brushModel.color;
    [self.drawBackgourp setStrokeColor:color];
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

@end
