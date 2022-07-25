//
//  DRMEPreviewViewController.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/4/23.
//

#import "DRMEPreviewViewController.h"
#import "DRMECropScrollView.h"

@interface DRMEPreviewViewController ()
<UIScrollViewDelegate>

// 画布
@property(nonatomic,weak) UIView *canvasView;
@property(nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *imageContainerView;
@property(nonatomic,strong) UIImageView *imageView;

@end

@implementation DRMEPreviewViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
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
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(clickDoneBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    doneBtn.layer.cornerRadius = 15.f;
    doneBtn.sd_layout.bottomSpaceToView(self.view, kBottomSafeAreaHeight + 20)
    .rightSpaceToView(self.view, 15)
    .widthIs(64).heightIs(30);

    // 画布视图 -- 子view有 scrollView 和 imageView
    UIView *canvasView = [[UIView alloc] init];
    [self.view addSubview:canvasView];
    self.canvasView = canvasView;
    [backBtn updateLayout];
    [doneBtn updateLayout];
    
    canvasView.frame = CGRectMake(0, backBtn.bottom + 20, kScreenWidth,
                                  doneBtn.top - 20 - (backBtn.bottom + 20));
    
    _scrollView = [[DRMECropScrollView alloc] init];
    _scrollView.frame = canvasView.bounds;
    _scrollView.bouncesZoom = NO;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [canvasView addSubview:_scrollView];
    
    _imageContainerView = [[UIView alloc] init];
    _imageContainerView.clipsToBounds = YES;
    [_scrollView addSubview:_imageContainerView];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.image = self.originImage;
    _imageView.backgroundColor = [UIColor blackColor];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
    [_imageContainerView addSubview:_imageView];
    
    [self layoutImageViewSize];

}


// 布局imageView后，拿到frame就可以做范围限制了
- (void)layoutImageViewSize {
    _imageContainerView.origin = CGPointZero;
    //    _imageContainerView.width = self.scrollView.width;
    _imageContainerView.height = self.scrollView.height;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.canvasView.height / self.scrollView.width) {
        _imageContainerView.width = floor(image.size.width / (image.size.height / self.scrollView.height));
    } else {
        CGFloat height = image.size.height / image.size.width * self.scrollView.width;
        if (height < 1 || isnan(height)) height = self.canvasView.height;
        height = floor(height);
        _imageContainerView.height = height;
        _imageContainerView.width = self.scrollView.width;
        _imageContainerView.centerY = self.canvasView.height / 2;
    }
    if (_imageContainerView.height > self.canvasView.height) {
        _imageContainerView.height = self.canvasView.height;
    }
    CGFloat contentSizeH = MAX(_imageContainerView.height, self.canvasView.height);
    _scrollView.contentSize = CGSizeMake(self.scrollView.width, contentSizeH);
    [_scrollView scrollRectToVisible:self.canvasView.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.height <= self.canvasView.height ? NO : YES;
    
    _imageContainerView.centerX = _scrollView.width/2;
    // 记录最开始的图片 位置
    _imageView.frame = _imageContainerView.bounds;
    
    self.scrollView.maximumZoomScale = SCREEN_WIDTH / self.imageContainerView.width * 3.f;
    
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageContainerView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    CGFloat offsetX = (_scrollView.width > _scrollView.contentSize.width) ? ((_scrollView.width - _scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_scrollView.height > _scrollView.contentSize.height) ? ((_scrollView.height - _scrollView.contentSize.height) * 0.5) : 0.0;
    self.imageContainerView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - 事件
- (void)clickBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickDoneBtn
{
    if (self.previewDoneBlock) {
        self.previewDoneBlock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    NSLog(@"预览页面 销毁了～～～～");
}

@end

