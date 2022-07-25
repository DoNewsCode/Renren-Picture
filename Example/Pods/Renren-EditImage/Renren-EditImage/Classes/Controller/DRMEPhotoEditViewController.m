//
//  DRMEPhotoEditViewController.m
//  Renren-EditImage
//
//  Created by 陈金铭 on 2019/10/17.
//

#import "DRMEPhotoEditViewController.h"
#import <DNCommonKit/UINavigationController+FDFullscreenPopGesture.h>
#import "DRMECustomBtn.h"
#import "DRMEEditPhotoOptionView.h"
#import "DRMEEditOptionModel.h"
#import "DRMECropViewController.h"          // 裁剪图片
#import "DRMEFilterEditViewController.h"    // 滤镜功能
#import "DRMEMosaicViewController.h"        // 马赛克图片
#import "DRMEAddTextViewController.h"       // 文字
#import "DRMEStickerLabelView.h"            // 文字贴纸
#import "DRMEInputTagViewController.h"      // 标签页面
#import "DRMEBrushViewController.h"         // 画笔页面

#import "DRMETagView.h"                     // 单个标签视图
#import "DRMEPreviewTagsView.h"             // 所有标签都add到此视图


#import "DRMECropScrollView.h"

@interface DRMEPhotoEditViewController ()
<DRMEEditPhotoOptionViewDelegate,
DRMECropViewControllerDelegate,
DRMEStickerLabelViewDelegate,
DRMETagViewDelegate,
UIScrollViewDelegate>

@property(nonatomic,weak) DRMEEditPhotoOptionView *editOptinoView;
// 画布
@property(nonatomic,weak) UIView *canvasView;
@property(nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *imageContainerView;
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,assign) CGRect imageViewRect;

/// 是否编辑过
@property(nonatomic,assign) BOOL isEdited;

/// 保存上次裁剪过的区域 和角度
@property(nonatomic,assign) CGRect lastCropRect;
@property(nonatomic,assign) NSInteger lastAngle;

@property(nonatomic,strong) NSMutableArray<DRMETagView*> *tagsArray;
/// 拖拽时做了一个假的tagView，置于最上层
@property(nonatomic,strong) DRMETagView *tempTagView;
/// 拖拽时做了一个假的文字视图，置于最上层
@property(nonatomic,strong) DRMEStickerLabelView *tempStickerLabel;
/// 垃圾桶
@property(nonatomic,weak) UIButton *trashBtn;

@property(nonatomic,strong) DRMEPreviewTagsView *tagsView;

@property(nonatomic,assign) CGRect beginViewFrame;

/// 记录之前选中的滤镜 index ，下次进来还要选中的
@property(nonatomic,assign) NSInteger filterIndex;

/// 记录是否添加过马赛克或画笔
@property(nonatomic,assign) BOOL isAddMosaicAndbrush;

/// 记录正在操作哪个文字视图
@property(nonatomic,strong) DRMEStickerLabelView *labelView;
@property(nonatomic,strong) NSMutableArray<DRMEStickerLabelView*> *labelArray;


@end

@implementation DRMEPhotoEditViewController

- (DRMEPreviewTagsView *)tagsView
{
    if (!_tagsView) {
        
        _tagsView = [[DRMEPreviewTagsView alloc] initWithFrame:self.imageContainerView.frame];
        _tagsView.isHitTest = YES;
        _tagsView.userInteractionEnabled = YES;
    }
    return _tagsView;
}

- (NSMutableArray<DRMETagView *> *)tagsArray
{
    if (!_tagsArray) {
        _tagsArray = [NSMutableArray array];
    }
    return _tagsArray;
}

- (NSMutableArray<DRMEStickerLabelView *> *)labelArray
{
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // 禁止左滑返回
    self.fd_interactivePopDisabled = YES;
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
    self.imageViewRect = _imageView.frame;
    
//    [self refreshScrollViewContentSize];
//    [self refreshImageContainerViewCenter];
    self.scrollView.maximumZoomScale = SCREEN_WIDTH / self.imageContainerView.width * 3.f;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.filterIndex = 0;
    self.lastCropRect = CGRectZero;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
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
    doneBtn.sd_layout.centerYEqualToView(backBtn)
    .rightSpaceToView(self.view, 15)
    .widthIs(64).heightIs(30);
    
    
    // 编辑照片所需的选项视图
    DRMEEditPhotoOptionView *editOptinoView = [[DRMEEditPhotoOptionView alloc] initWithIsFromChat:self.isFromChat];
    editOptinoView.delegate = self;
    [self.view addSubview:editOptinoView];
    self.editOptinoView = editOptinoView;
    
    editOptinoView.sd_layout.leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, kSafeAreaHeight + 20)
    .heightIs(60);
    
    // 画布视图 -- 子view有 scrollView 和 imageView 和 标签、文字等效果
    UIView *canvasView = [[UIView alloc] init];
//    canvasView.backgroundColor = UIColor.greenColor;
    [self.view addSubview:canvasView];
    self.canvasView = canvasView;
    [doneBtn updateLayout];
    [editOptinoView updateLayout];
    
    canvasView.frame = CGRectMake(0, doneBtn.bottom + 15, kScreenWidth,
                                  editOptinoView.top - 15 - (doneBtn.bottom + 15));

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
    
    // 装载标签视图的view
    [_scrollView addSubview:self.tagsView];
    
    // 添加一个 垃圾桶  配合手势拖拽来显示
    UIButton *trashBtn = [[UIButton alloc] init];
    trashBtn.adjustsImageWhenHighlighted = NO;
    [trashBtn setImage:[UIImage me_imageWithName:@"me_trash_close_icon"]
              forState:UIControlStateNormal];
    [trashBtn setImage:[UIImage me_imageWithName:@"me_trash_open_icon"]
              forState:UIControlStateSelected];
    [self.view addSubview:trashBtn];
    trashBtn.hidden = YES;
    self.trashBtn = trashBtn;
    
    trashBtn.sd_layout.centerXEqualToView(self.view)
    .bottomSpaceToView(self.view, kSafeAreaHeight + 32)
    .widthIs(60).heightIs(60);
    
    /// 这里是从预览页面进来的 ，将dict转为DRMETagModel，然后添加标签
    [self.tagsDict enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSNumber *x = dict[@"center_left_to_photo"];
        NSNumber *y = dict[@"center_top_to_photo"];
        DRMETagDirection direction = [dict[@"tagDirections"] integerValue];
        NSString *text = dict[@"target_name"];
        CGPoint point = CGPointMake(x.floatValue/1000, y.floatValue/1000);
        CGPoint absolutePoint = [DRMETagView absolutePositionForPoint:point containerSize:self.tagsView.size];
        
        DRMETagModel *tagModel = [[DRMETagModel alloc] init];
        tagModel.text = text;
        tagModel.tagPoint = absolutePoint;
        tagModel.tagDirection = direction;
        
        DRMETagView *tagView = [[DRMETagView alloc] initWithPoint:absolutePoint
                                                         tagModel:tagModel];
        tagView.tagDict = dict;
        tagView.zoomScale = self.scrollView.zoomScale;
        tagView.delegate = self;
        tagView.tapRelativePosition = [DRMETagView relativePositionForPoint:absolutePoint containerSize:self.tagsView.size];
        [self.tagsView addSubview:tagView];
        [self.tagsArray addObject:tagView];
        
    }];
    
    
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
    
    
    [self refreshImageContainerViewCenter:scrollView.zoomScale];
}

/// 缩放scrollView时，改变标签的大小
- (void)refreshImageContainerViewCenter:(CGFloat)zoomScale
{
    
    self.tagsView.frame = self.imageContainerView.frame;
    
    [self.tagsArray enumerateObjectsUsingBlock:^(DRMETagView *tagView, NSUInteger idx, BOOL * _Nonnull stop) {
        tagView.zoomScale = zoomScale;
    }];
}

#pragma mark - DRMEEditPhotoOptionViewDelegate
- (void)editPhotoOptionView:(DRMEEditPhotoOptionView *)editPhotoOptionView
           clickOptionModel:(DRMEEditOptionModel *)optionModel
{
    DRMEEditOption editOption = optionModel.editOption;
    
    WeakSelf(self)
    
    switch (editOption) {
        case DRMEEditOptionTailor:
        {
            NSLog(@"裁剪");
            
            @weakify(self)
            void(^cropBlock)(void) = ^{
                @strongify(self)
                DRMECropViewController  *cropController = [[DRMECropViewController alloc] initWithImage:self.imageView.image];
                
                /// 裁剪中，暂定去掉文字
//                cropController.labelArray = [self.labelArray mutableCopy];
                
//                // 等比例来手动调节选择框
//                cropController.aspectRatioLockEnabled = NO;
                cropController.delegate = self;
//                // 设置选择宽比例
//                cropController.aspectRatioPreset = DRMECropViewControllerAspectRatioPresetOriginal;
//                // 设置选择框可以手动移动
//                cropController.cropView.cropBoxResizeEnabled = YES;
                
//                if (!CGRectEqualToRect(self.lastCropRect, CGRectZero)) {
//                    cropController.imageCropFrame = self.lastCropRect;
//                }
//                cropController.angle = self.lastAngle;
                
                cropController.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:cropController animated:NO completion:nil];
            };
            
            // 如果添加过标签或文字，给个提示
            if (self.tagsArray.count > 0 ||
                self.labelArray.count > 0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"裁剪或旋转后，已添加的标签和文字将被删除，确认继续？" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    // 删除所有标签
                    [self.tagsArray enumerateObjectsUsingBlock:^(DRMETagView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [obj removeFromSuperview];
                    }];
                    [self.tagsArray removeAllObjects];
                    // 删除所有文字
                    [self.labelArray enumerateObjectsUsingBlock:^(DRMEStickerLabelView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [obj removeFromSuperview];
                    }];
                    [self.labelArray removeAllObjects];
                    
                    cropBlock();
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:cancelAction];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
                
            } else {
                cropBlock();
            }
            
            break;
        }
        case DRMEEditOptionFilter:
        {
            NSLog(@"滤镜");
            DRMEFilterEditViewController *filterVc = [DRMEFilterEditViewController new];
            // 4.14 如果添加过马赛克或画笔，就将 self.imageView.image 当做原图传递，并将 filterIndex = 0
            // 没有添加过，就使用 self.originImage 当做原图传递
                            
            // 使用添加过效果的图， 但不要选中效果
            filterVc.filterIndex = 0;
            filterVc.originImage = self.imageView.image;
            
            // 根据需求，需要展示添加过的文字和标签
            filterVc.labelArray = [self.labelArray mutableCopy];
            filterVc.tagsArray = [self.tagsArray mutableCopy];
            
            CGRect fromeRect = [self.imageView convertRect:self.imageView.frame toView:self.view];
            filterVc.animation.fromRect = fromeRect;
            filterVc.animation.animatImage = self.imageView.image;
            self.navigationController.delegate = filterVc;
            
            // 大于，说明缩放过了，给它还原后，再跳转
            if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
                
                [UIView animateWithDuration:0.1 animations:^{
                    self.imageView.frame = self.imageViewRect;
                } completion:^(BOOL finished) {
                    [self.navigationController pushViewController:filterVc animated:YES];
                }];
                
            } else {
                [self.navigationController pushViewController:filterVc animated:YES];
            }
            
            filterVc.filterEditSuccess = ^(UIImage * _Nonnull filterImage, NSInteger filterIndex) {
                weakself.isEdited = YES;
                weakself.filterIndex = filterIndex;
                weakself.imageView.image = filterImage;
            };
            
            // filterEditSuccess 中，也会调用 filterEditClickCancle
            filterVc.filterEditClickCancle = ^{
                /// 看看如果有标签，再次回显
                [weakself addTagViewWith:weakself.tagsArray];
            };
            
            break;
        }
        case DRMEEditOptionMosaic:
        {
            NSLog(@"马赛克");
            DRMEMosaicViewController *mosaicVc = [[DRMEMosaicViewController alloc] init];
            mosaicVc.originImage = self.imageView.image;
            
            CGRect fromeRect = [self.imageView convertRect:self.imageView.frame toView:self.view];
            mosaicVc.animation.fromRect = fromeRect;
            mosaicVc.animation.animatImage = self.imageView.image;
            self.navigationController.delegate = mosaicVc;
            
            [self.navigationController pushViewController:mosaicVc animated:YES];
            
            mosaicVc.mosaicEditDoneBlock = ^(UIImage * _Nonnull mosaicImage) {

                weakself.isAddMosaicAndbrush = YES;
                weakself.isEdited = YES;
                weakself.imageView.image = mosaicImage;
            };
            
            break;
        }
        case DRMEEditOptionStickers:
        {
            NSLog(@"贴纸");
            break;
        }
        case DRMEEditOptionBrush:
        {
            NSLog(@"画笔");
            DRMEBrushViewController *brushVc = [[DRMEBrushViewController alloc] init];
            brushVc.originImage = self.imageView.image;
            
            
            CGRect fromeRect = [self.imageView convertRect:self.imageView.frame toView:self.view];
            brushVc.animation.fromRect = fromeRect;
            brushVc.animation.animatImage = self.imageView.image;
            self.navigationController.delegate = brushVc;
            
            [self.navigationController pushViewController:brushVc animated:YES];
            
            brushVc.brushSuccessBlock = ^(UIImage * _Nonnull brushImage) {
                
                weakself.isAddMosaicAndbrush = YES;
                weakself.isEdited = YES;
                weakself.imageView.image = brushImage;
            };
            
            break;
        }
        case DRMEEditOptionText:
        {
            NSLog(@"文字");
            DRMEAddTextViewController *addTextVc = [[DRMEAddTextViewController alloc] init];
            addTextVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:addTextVc animated:YES completion:nil];
            
            __block NSString *_currentTextColorStr;
            __block BOOL _isChooseBackColor;
            
            addTextVc.clickDoneBlock = ^(NSString * _Nonnull text, UIFont * _Nonnull font, UIColor * _Nonnull textColor, UIColor * _Nonnull textBgColor, UITextView *textView, NSString *currentTextColorStr, BOOL isChooseBackColor) {

                _currentTextColorStr = currentTextColorStr;
                _isChooseBackColor = isChooseBackColor;
                
                if ([text isNotBlank]) {
                    
                    CGSize s = CGSizeMake(weakself.imageView.size.width - 30, weakself.imageView.size.height - 30);
                    
                    CGSize size = [text sizeForFont:font size:s mode:NSLineBreakByWordWrapping];
                    // 生成相应的文字
                    DRMEStickerLabelView *stickerLabel = [[DRMEStickerLabelView alloc] initWithLabelSize:size];
                    stickerLabel.delegate = weakself;
                    
                    size = CGSizeMake(size.width + 30, size.height + 30);
                    
                    stickerLabel.size = size;
                    stickerLabel.center = weakself.imageView.center;
                    stickerLabel.contentLabel.text = text;
                    stickerLabel.contentLabel.font = font;
                    stickerLabel.contentLabel.textColor = textColor;
                    stickerLabel.contentLabel.textAlignment = NSTextAlignmentLeft;
                    stickerLabel.backgroundColor = textBgColor;
                    
                    [weakself.imageContainerView addSubview:stickerLabel];
                    [weakself.labelArray addObject:stickerLabel];
                    
                    @weakify(stickerLabel)
                    stickerLabel.singleTapBlock = ^{
                        
                        @strongify(stickerLabel)
                        if (weakself.labelView != stickerLabel) {
                            [weakself.labelView hideBorder];
                            weakself.labelView = stickerLabel;
                        }
                        [stickerLabel showBorderWhenClicked];
                        
                    };
                    
                    // 双击显示边框
#warning TODO 再次编辑文字有bug，不要做了
                    // 前提是将图片放大，或将文字放大后，再次编辑后，文字的大小咋计算呀。。。。
//                    stickerLabel.doubleTapBlock = ^{
//
//                        @strongify(stickerLabel)
//                        DRMEAddTextViewController *addTextVc = [[DRMEAddTextViewController alloc] init];
//                        //                        addTextVc.lastText = stickerLabel.contentLabel.text;
//                        addTextVc.chooseBackColor = _isChooseBackColor;
//                        addTextVc.currentTextColorStr = _currentTextColorStr;
//
//                        addTextVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//                        [weakself presentViewController:addTextVc animated:YES completion:nil];
//
//                        addTextVc.textView.text = stickerLabel.contentLabel.text;
//                        addTextVc.textView.textColor = stickerLabel.contentLabel.textColor;
//                        addTextVc.textView.backgroundColor = stickerLabel.backgroundColor;
//
//                        addTextVc.clickDoneBlock = ^(NSString * _Nonnull text, UIFont * _Nonnull font, UIColor * _Nonnull textColor, UIColor * _Nonnull textBgColor, UITextView *textView, NSString *currentTextColorStr, BOOL isChooseBackColor) {
//
//                            _currentTextColorStr = currentTextColorStr;
//                            _isChooseBackColor = isChooseBackColor;
//
//                            if ([text isNotBlank]) {
//
////  CGSize s = CGSizeMake(weakself.imageView.size.width - 30, weakself.imageView.size.height - 30);
////
////  CGSize size = [text sizeForFont:font size:s mode:NSLineBreakByWordWrapping];
////
////  // 更新 label 的 size
////  stickerLabel.contentLabel.size = size;
////
////  size = CGSizeMake(size.width + 30, size.height + 30);
////  // 生成相应的文字
////  stickerLabel.size = size;
//                                stickerLabel.contentLabel.text = text;
//                                stickerLabel.contentLabel.textColor = textColor;
//                                stickerLabel.backgroundColor = textBgColor;
//
//                            } else {
//
//                                [stickerLabel removeFromSuperview];
//
//                            }
//
//                        };
//                    };
                    
                }
            };
            break;
        }
        case DRMEEditOptionTag:
        {
            NSLog(@"标签");
            
            DRMEInputTagViewController *inputTagVc = [[DRMEInputTagViewController alloc] init];
            inputTagVc.originImage = self.imageView.image;
            
            // 如果之前添加过标签，再次编辑要显示
            inputTagVc.tagsArray = [self.tagsArray mutableCopy];
            
            // 如果之前添加过文字，再次编辑要显示
            inputTagVc.labelArray = [self.labelArray mutableCopy];
            
            [self.navigationController pushViewController:inputTagVc animated:NO];
            
            inputTagVc.inputTagCompleteBlock = ^(NSMutableArray<DRMETagView *> * _Nonnull tagsArray,
                                                 NSMutableArray<DRMEStickerLabelView *> * _Nonnull labelArray) {
              
                NSLog(@"-- %s, %d", __func__, __LINE__);
                
                [weakself addTagViewWith:tagsArray];
                
                [weakself addLabelViewWith:labelArray];
                
            };
            
            break;
        }
        default:
            break;
    }
}

/// 从裁剪回显示所有文字，考虑间距
- (void)cropAddLabelViewWith:(NSMutableArray<DRMEStickerLabelView *> *)labelArray
{
    for (DRMEStickerLabelView *labelView in labelArray) {
        labelView.delegate = self;
        labelView.left += 5;
        labelView.top += 5;
        [self.imageContainerView addSubview:labelView];
    }
    // 保存 labelView
    self.labelArray = [labelArray mutableCopy];
}

/// 回显示所有文字
- (void)addLabelViewWith:(NSMutableArray<DRMEStickerLabelView *> *)labelArray
{
    for (DRMEStickerLabelView *labelView in labelArray) {
        labelView.delegate = self;
        [self.imageContainerView addSubview:labelView];
    }
    // 保存 labelView
    self.labelArray = [labelArray mutableCopy];
}

/// 回显所有标签
- (void)addTagViewWith:(NSMutableArray<DRMETagView*> *)tagsArray
{
    for (DRMETagView* tagView in tagsArray) {
        tagView.delegate = self;
        tagView.zoomScale = self.scrollView.zoomScale;
        tagView.falseView = NO;
        [self.tagsView addSubview:tagView];
    }
    // 保存 tagView
    self.tagsArray = [tagsArray mutableCopy];
}

#pragma mark - 事件
- (void)clickBackBtn
{
    if (self.isEdited) {
        
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"是否放弃此次编辑?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            // 不操作
        }];
        [vc addAction:cancelAction];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [vc addAction:sureAction];
        [self presentViewController:vc animated:YES completion:nil];
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)clickDoneBtn
{
    
    // 截取图片时，避免截取到文字白框
    if (self.labelView) {
        [self.labelView hideBorder];
    }
    
    if (self.photoEditCompleteBlock) {
        // 截取图片内容时，不要截取标签
        // imageContainerView 和 tagsView 是同一级，本来就不会被截上
        self.tagsView.hidden = YES;
        UIImage *snapshotImage = self.imageContainerView.snapshotImage;
        snapshotImage.isEdited = self.isEdited;
        self.photoEditCompleteBlock(snapshotImage);
    }

    NSMutableArray *array = [NSMutableArray array];
    for (DRMETagView *tagView in self.tagsArray) {
        NSDictionary *tagDict = [tagView getTagData];
        [array addObject:tagDict];
    }
    
    if (self.photoEditTagCompleteBlock) {
        
        // 截取图片内容时，不要截取标签
        // imageContainerView 和 tagsView 是同一级，本来就不会被截上
        self.tagsView.hidden = YES;
        
        UIImage *snapshotImage = self.imageContainerView.snapshotImage;
        snapshotImage.isEdited = self.isEdited;
        self.photoEditTagCompleteBlock(snapshotImage, array);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - DRPCropViewControllerDelegate
- (void)cropViewControllerDidCancelCrop:(DRMECropViewController *)cropViewController
{
    /// 裁剪取消后，如果之前有文字要显示出来
    [self cropAddLabelViewWith:self.labelArray];
}

- (void)cropViewController:(DRMECropViewController *)cropViewController
            didCropToImage:(UIImage *)image
                  withRect:(CGRect)cropRect
                     angle:(NSInteger)angle
{
    // 编辑过图片  之  裁剪过
    self.isEdited = YES;
    
    self.imageView.image = image;
    
    // 裁剪后需要更新imageView
    [self layoutImageViewSize];
    
    // 保存上次的裁剪区域
    self.lastCropRect = cropRect;
    
    // 保存上次的裁剪角度
    self.lastAngle = angle;
    
    [cropViewController dismissViewControllerAnimated:NO completion:nil];
        
    NSLog(@"-- %s, %d", __func__, __LINE__);
    
    /// 裁剪完成后，如果之前有文字要显示出来
    [self cropAddLabelViewWith:self.labelArray];

}

- (void)cropViewController:(DRMECropViewController *)cropViewController didCropToImage:(UIImage *)image centerXDistance:(CGFloat)centerXDistance centerYDistance:(CGFloat)centerYDistance cropSize:(CGSize)cropSize
{
    
    // 编辑过图片  之  裁剪过
    self.isEdited = YES;
    
    self.imageView.image = image;
    
    // 裁剪后需要更新imageView
    [self layoutImageViewSize];
    
    [cropViewController dismissViewControllerAnimated:NO completion:nil];
        
    NSLog(@"-- %s, %d", __func__, __LINE__);
//    4.26 暂定先去掉文字功能
//    /// 裁剪完成后，如果之前有文字要根据 中心间距 显示出来
//    [self cropAddLabelViewWith:self.labelArray];
//
//    DRMEStickerLabelView *labelView = self.labelArray.firstObject;
//
//    CGFloat scale = 0;
//    scale = MIN(self.imageView.width/cropSize.width, self.imageView.height/cropSize.height);
//
//    labelView.transform = CGAffineTransformScale(labelView.transform, scale, scale);
//    labelView.centerX = self.imageView.centerX + centerXDistance;
//    labelView.centerY = self.imageView.centerY + centerYDistance;
    
}

#pragma mark - DRMEStickerLabelViewDelegate
- (void)stickerLabelView:(DRMEStickerLabelView *)stickerLabelView panGestureRecognizer:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        // 显示垃圾桶
        self.trashBtn.hidden = NO;
        
        // 记录本次开始拖拽的起始frame
        self.beginViewFrame = stickerLabelView.frame;
        [self.imageContainerView bringSubviewToFront:stickerLabelView];
        
        if (self.labelView != stickerLabelView) {
            [self.labelView hideBorder];
            self.labelView = stickerLabelView;
        }
        /// 显示边框
        [stickerLabelView showBorderWhenDragging];
        
        // 隐藏选项视图
        self.editOptinoView.hidden = YES;
        
        
        // 隐藏真正的tagView，创建一个假的tagView，放在self.view的最上层，形成视觉效果
        #warning TODO 需要修改，假文字视图拖拽问题
//        stickerLabelView.hidden = YES;
//        [self createTempLabelViewWith:stickerLabelView];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        // 手指的点在垃圾桶上时，垃圾桶变红，否则不变或恢复
        CGPoint point = [gesture locationInView:self.view];
        
        CGRect insetRect = CGRectInset(self.trashBtn.frame, 10, 10);
        
        if (CGRectContainsPoint(insetRect, point)) {
            self.trashBtn.selected = YES;
        } else {
            self.trashBtn.selected = NO;
        }
        
        CGRect tempFrame = [stickerLabelView convertRect:stickerLabelView.bounds toView:self.view];
        self.tempStickerLabel.frame = tempFrame;
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        
        // 倒计时隐藏边框
        [stickerLabelView startCountDown];

        // 显示选项视图
        self.editOptinoView.hidden = NO;
        // 隐藏垃圾桶
        self.trashBtn.hidden = YES;
        
        // 将假文字视图干掉
        [self.tempStickerLabel removeFromSuperview];
        // 显示真正的标签view
        stickerLabelView.hidden = NO;
        
        // 松开时，手指的点在垃圾桶上时，删除文字
        if (self.trashBtn.isSelected) {
            // 删除文字
            [stickerLabelView removeFromSuperview];
            if ([self.labelArray containsObject:stickerLabelView]) {
                [self.labelArray removeObject:stickerLabelView];
            }
        } else {
            // 计算标签/文字，是否超出了图片范围，并还原
//            if (!CGRectContainsRect(self.imageView.frame, stickerLabelView.frame)) {
//                [UIView animateWithDuration:0.25 animations:^{
//                    stickerLabelView.frame = self.beginViewFrame;
//                }];
//            }
            
        }
    }
}

- (void)createTempLabelViewWith:(DRMEStickerLabelView *)stickerLabelView
{
    CGRect tempFrame = [stickerLabelView convertRect:stickerLabelView.bounds toView:self.view];
    
    // 生成相应的文字
    CGSize size = stickerLabelView.contentLabel.size;
    DRMEStickerLabelView *tempStickerLabel = [[DRMEStickerLabelView alloc] initWithLabelSize:size];
    tempStickerLabel.frame = tempFrame;
    tempStickerLabel.contentLabel.text = stickerLabelView.contentLabel.text;
    tempStickerLabel.contentLabel.font = stickerLabelView.contentLabel.font;
    tempStickerLabel.contentLabel.textColor = stickerLabelView.contentLabel.textColor;
    tempStickerLabel.contentLabel.textAlignment = NSTextAlignmentLeft;
    tempStickerLabel.backgroundColor = stickerLabelView.backgroundColor;
    tempStickerLabel.contentLabel.transform = tempStickerLabel.transform;
    [self.view addSubview:tempStickerLabel];
    
    [tempStickerLabel showBorderWhenDragging];
    
    self.tempStickerLabel = tempStickerLabel;
}

#pragma mark - DRMETagViewDelegate
- (void)tagView:(DRMETagView *)tagView panGestureRecognizer:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        if (self.labelView) {
            [self.labelView hideBorder];
            self.labelView = nil;
        }
        
        // 干掉键盘
        [self.view endEditing:YES];
        
        // 记录本次开始拖拽的起始frame
        self.beginViewFrame = tagView.frame;
        
        [self.view bringSubviewToFront:tagView];
        
        // 隐藏选项视图
        self.editOptinoView.hidden = YES;
        
        // 显示垃圾桶
        self.trashBtn.hidden = NO;
        
        // 隐藏真正的tagView，创建一个假的tagView，放在self.view的最上层，形成视觉效果
        tagView.hidden = YES;
        [self createTempTagViewWith:tagView];
    
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        // 手指的点在垃圾桶上时，垃圾桶变红，否则不变或恢复
        CGPoint point = [gesture locationInView:self.view];
        
        
        CGRect insetRect = CGRectInset(self.trashBtn.frame, 10, 10);
        
        if (CGRectContainsPoint(insetRect, point)) {
            self.trashBtn.selected = YES;
        } else {
            self.trashBtn.selected = NO;
        }
        
        CGRect tempFrame = [tagView convertRect:tagView.bounds toView:self.view];
        self.tempTagView.frame = tempFrame;
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        
        // 显示选项视图
        self.editOptinoView.hidden = NO;
        // 隐藏垃圾桶
        self.trashBtn.hidden = YES;
        // 将假标签干掉
        [self.tempTagView removeFromSuperview];
        // 显示真正的标签view
        tagView.hidden = NO;
        // 松开时，手指的点在垃圾桶上时，删除标签
        if (self.trashBtn.isSelected) {
            
            // 删除一个标签
            if ([self.tagsArray containsObject:tagView]) {
                [self.tagsArray removeObject:tagView];
            }
            [tagView removeFromSuperview];
            self.trashBtn.selected = NO;
            
        } else {
            
            // 计算标签/文字，是否超出了图片范围，并还原
            if (![self isContainsTagView:tagView]) {
                [UIView animateWithDuration:0.25 animations:^{
                    tagView.frame = self.beginViewFrame;
                }];
            }
        }
    }
}

/// 创建一个假的tagView，放在self.view的最上层，形成视觉效果
- (void)createTempTagViewWith:(DRMETagView *)tagView
{

    //        CGPoint p = tagView.tagModel.tagPoint;
    
    DRMETagModel *tempTagModel = [[DRMETagModel alloc] init];
    tempTagModel.text = tagView.tagModel.text;
    tempTagModel.tagPoint = tagView.tagModel.tagPoint;
    tempTagModel.tagDirection = tagView.tagModel.tagDirection;
    
    CGRect tempFrame = [tagView convertRect:tagView.bounds toView:self.view];
    
    DRMETagView *tempTagView = [[DRMETagView alloc] initWithPoint:CGPointZero tagModel:tempTagModel];
    tempTagView.falseView = YES;
    [self.view addSubview:tempTagView];
    tempTagView.frame = tempFrame;
    self.tempTagView = tempTagView;
}

/// 返回 标签/文字/贴纸view 是否在 image/_imageContainerView 中
- (BOOL)isContainsTagView:(UIView *)tagView
{
    CGRect tagRect = [tagView convertRect:tagView.bounds toView:self.scrollView];
    CGRect imageRect = [_imageContainerView convertRect:_imageContainerView.bounds toView:self.scrollView];
    
    
    if (CGRectContainsRect(imageRect, tagRect)) {
        DNLog(@"还在范围里面呢");
        return YES;
    } else {
        DNLog(@"不在图片范围里，恢复原位置");
        return NO;
    }
    return NO;
}

#pragma mark - dealloc
- (void)dealloc
{
    NSLog(@"---编辑照片页面销毁");
}

@end
