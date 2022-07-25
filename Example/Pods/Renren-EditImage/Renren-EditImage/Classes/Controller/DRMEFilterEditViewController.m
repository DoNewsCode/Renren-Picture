//
//  DRMEFilterEditViewController.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/3/16.
//

#import "DRMEFilterEditViewController.h"
#import <DNCommonKit/UINavigationController+FDFullscreenPopGesture.h>
#import "DRMEFilterOptionView.h"
#import "DRMEFilterIntensityView.h"

#import "DRFTFilterManager.h"
#import "DRFTFilterModel.h"
#import "DRFTFilterModel+DRMEExtension.h"
#import <GLKit/GLKit.h>

#define kToolHehgit 190

@interface DRMEFilterEditViewController ()
<DRMEFilterOptionViewDelegate,
DRMEFilterIntensityViewDelegate,
UIScrollViewDelegate>

@property(nonatomic,weak) UIView *canvasView;

@property (nonatomic, strong) UIView *imageContainerView;
@property(nonatomic,weak) UIImageView *imageView;
@property(nonatomic,weak) UIScrollView *scrollView;
@property(nonatomic,weak) UILabel *descLabel;
@property(nonatomic,weak) UILabel *nameLabel;
@property(nonatomic,weak) DRMEFilterOptionView *optionView;

@property(nonatomic,strong) DRFTFilterModel *currentFilterModel;
@property(nonatomic,assign) NSInteger currentIndex;

@end

@implementation DRMEFilterEditViewController

- (DRMEPhotoEditAnimation *)animation
{
    if (!_animation) {
        _animation = [[DRMEPhotoEditAnimation alloc] init];
    }
    return _animation;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // 禁止左滑返回
    self.fd_interactivePopDisabled = YES;
    self.navigationController.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showOptionView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
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
    CGSize scaledImageSize = (CGSize){floorf(imageSize.width * scale),
                                      floorf(imageSize.height * scale)};
    
    
    self.imageContainerView.sd_layout.centerXEqualToView(self.canvasView)
    .centerYEqualToView(self.canvasView)
    .widthIs(scaledImageSize.width)
    .heightIs(scaledImageSize.height);
    
    [self.imageContainerView updateLayout];
    
    self.imageView.frame = self.imageContainerView.bounds;
    
//    self.imageView.sd_layout.centerXEqualToView(self.canvasView)
//    .centerYEqualToView(self.canvasView)
//    .widthIs(scaledImageSize.width)
//    .heightIs(scaledImageSize.height);
//
//    [self.imageView updateLayout];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    self.view.backgroundColor = UIColor.blackColor;
    
    // 拍照后的图片，临时用 UIImageView 展示
    // kToolHehgit 是底部滤镜选择工具条的高 25是 上下间距
    CGFloat height = kScreenHeight - kToolHehgit - kStatusBarHeight - 25 - 25;
    CGRect rect = CGRectMake(0, kStatusBarHeight + 25, kScreenWidth, height);
    
    // 画布视图 --
    UIView *canvasView = [[UIView alloc] initWithFrame:rect];
    [self.view addSubview:canvasView];
    self.canvasView = canvasView;
    
    self.imageContainerView = [[UIView alloc] init];
    [self.canvasView addSubview:self.imageContainerView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.image = self.originImage;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageContainerView addSubview:imageView];
    self.imageView = imageView;
    
    [self layoutMosaicViewViewSize];
    
    CGRect toRect = [self.imageView convertRect:self.imageView.bounds toView:self.view];
    self.animation.toRect = toRect;
    
    GLKView *glkView = [[GLKView alloc] initWithFrame:self.imageContainerView.frame];
    [canvasView addSubview:glkView];
    
    [[DRFTFilterManager manager] setGlkView:glkView image:self.originImage];
    [[DRFTFilterManager manager] setViewDisplayMode:UIViewContentModeScaleAspectFit];
    
    // 滤镜标题和描述信息
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.font = kFontRegularSize(17);
    descLabel.textColor = UIColor.whiteColor;
    [self.canvasView addSubview:descLabel];
    self.descLabel = descLabel;
    
    
    descLabel.sd_layout.centerYEqualToView(self.imageContainerView)
    .leftEqualToView(self.imageContainerView)
    .rightEqualToView(self.imageContainerView)
    .heightIs(18);
    

    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = kFontRegularSize(23);
    nameLabel.textColor = UIColor.whiteColor;
    [self.canvasView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    nameLabel.sd_layout.bottomSpaceToView(descLabel, 15)
    .leftEqualToView(self.imageContainerView)
    .rightEqualToView(self.imageContainerView)
    .heightIs(25);
    
    // 盖一个scrollView，展示滑动展示滤镜效果
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:canvasView.bounds];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.canvasView addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 工具条，选择滤镜view
    DRMEFilterOptionView *optionView = [[DRMEFilterOptionView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kToolHehgit)];
    optionView.backgroundColor = UIColor.blackColor;
    optionView.delegate = self;
    [self.view addSubview:optionView];
    self.optionView = optionView;
    
    [optionView loadFilterData];
    
    // 用来再次显示文字和标签的视图
    UIView *showView = [[UIView alloc] initWithFrame:self.imageContainerView.frame];
    // 不能交互
    showView.userInteractionEnabled = NO;
    [canvasView addSubview:showView];

    // 根据需求，需要展示添加过的文字和标签
    // 这里的再次显示，要添加在 GLView 上
    if (self.labelArray.count > 0) {
        for (DRMEStickerLabelView *view in self.labelArray) {
            DRMEStickerLabelView *labelView = [view copy];
            [showView addSubview:labelView];
        }
    }
    
    if (self.tagsArray.count > 0) {
        for (DRMETagView *tagView in self.tagsArray) {
//            DRMETagView *tagView = [view copy];
            tagView.falseView = YES;
            [showView addSubview:tagView];
        }
    }
    
}

- (void)showOptionView
{
//    self.optionView.top = kScreenHeight;
    self.optionView.alpha = 1;
    [UIView animateWithDuration:0.2 animations:^{
        self.optionView.top = kScreenHeight - kToolHehgit;
    }];
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
    
    if (index <= array.count) {
        DRFTFilterModel *filterModel = array[index];

        self.filterIndex = index;
        [[DRFTFilterManager manager] setFilterIndex:index];
        [[DRFTFilterManager manager] setImageFilterIntensity:filterModel.currentIntensity];
        
        [self showFilterName:filterModel];
        
        [self.optionView scrollToIndex:index animated:YES];
        
        // 记录当前滤镜
        self.currentFilterModel = filterModel;
    }
}

#pragma mark - DRMEFilterOptionViewDelegate

- (void)filterOptionViewClickCancel
{
    [UIView animateWithDuration:0.2 animations:^{
        self.optionView.top = kScreenHeight;
    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    if (self.filterEditClickCancle) {
        self.filterEditClickCancle();
    }
}

- (void)filterOptionViewClickSure
{
    UIImage *currentImage = [DRFTFilterManager manager].currentImage;
    
    self.animation.animatImage = currentImage;
    
    if (self.filterEditSuccess) {
        self.filterEditSuccess(currentImage, self.filterIndex);
        
        [self filterOptionViewClickCancel];
    }
}

- (void)filterLodaSuccess:(NSInteger)filterCount
{
    CGFloat pageW = self.scrollView.width;
    CGFloat pageH = self.scrollView.height;
    self.scrollView.contentSize = CGSizeMake(filterCount * pageW, pageH);
    // 为了让原图滤镜有选中的效果
    // 如果之前选择过滤镜，就选中之前的
    [self.optionView scrollToIndex:self.filterIndex animated:NO];
    [[DRFTFilterManager manager] setFilterIndex:self.filterIndex];
    
    CGPoint point = CGPointMake(self.scrollView.width * self.filterIndex, self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:point];
    
    NSArray *array = [DRFTFilterManager manager].filterArray;
    DRFTFilterModel *firstModel = array.firstObject;
    // 第一个肯定是原图
    firstModel.originalImage = YES;
    
    if (self.filterIndex <= array.count) {
        DRFTFilterModel *filterModel = array[self.filterIndex];
        // 记录当前滤镜
        self.currentFilterModel = filterModel;
    }
}

- (void)filterOptionView:(DRMEFilterOptionView *)filterOptionView
        clickFilterIndex:(NSInteger)index
             filterModel:(DRFTFilterModel *)filterModel
{
    self.filterIndex = index;
    self.currentIndex = index;
    [[DRFTFilterManager manager] setFilterIndex:index];
    [[DRFTFilterManager manager] setImageFilterIntensity:filterModel.currentIntensity];
    
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
    [[DRFTFilterManager manager] setImageFilterIntensity:value];
    self.currentFilterModel.currentIntensity = value;
}

- (void)filterSliderHideComplete:(DRMEFilterIntensityView *)filterIntensityView
{
    [filterIntensityView removeFromSuperview];
    
    // 滤镜视图显示
    [self showOptionView];
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

#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"-- %s, %d", __func__, __LINE__);
    [[DRFTFilterManager manager] clearImageHandler];
}

@end
