//
//  DRMEInputTagViewController.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/11/12.
//

#import "DRMEInputTagViewController.h"
#import "DRMETagBottomToolBar.h"
#import "DRMEPreviewTagsView.h"

@interface DRMEInputTagViewController ()
<UIScrollViewDelegate,
UITextFieldDelegate,
DRMETagBottomToolBarDelegate,
UIGestureRecognizerDelegate,
DRMETagViewDelegate>

/// 画布
@property(nonatomic,weak) UIView *canvasView;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *imageContainerView;
@property(nonatomic,strong) UIImageView *imageView;

@property(nonatomic,weak) UIView *tipView;
/// 默认显示的标签
@property(nonatomic,weak) DRMETagView *defautTagView;

@property(nonatomic,strong) DRMEPreviewTagsView *tagsView;

@property(nonatomic,assign) CGRect beginViewFrame;
/// 垃圾桶
@property(nonatomic,weak) UIButton *trashBtn;

@property(nonatomic, strong) DRMETagBottomToolBar *bottomToolBar;
@property(nonatomic, assign) CGPoint tempPoint;


/// 拖拽时做了一个假的tagView，置于最上层
@property(nonatomic,strong) DRMETagView *tempTagView;

/// 点击某个点时，要显示一个圆点
@property(nonatomic,strong) UIImageView *pointImgView;

@end

@implementation DRMEInputTagViewController

- (UIImageView *)pointImgView
{
    if (!_pointImgView) {
        _pointImgView = [[UIImageView alloc] init];
        _pointImgView.image = [UIImage me_imageWithName:@"me_tag_point"];
        _pointImgView.width = 14;
        _pointImgView.height = 14;
        _pointImgView.userInteractionEnabled = YES;
        _pointImgView.hidden = YES;
    }
    return _pointImgView;
}

- (NSMutableArray<DRMETagView *> *)tagsArray
{
    if (!_tagsArray) {
        _tagsArray = [NSMutableArray array];
    }
    return _tagsArray;
}

- (NSMutableArray<NSDictionary *> *)tagsDictArray
{
    if (!_tagsDictArray) {
        _tagsDictArray = [NSMutableArray array];
    }
    return _tagsDictArray;
}

- (DRMEPreviewTagsView *)tagsView {
    if (!_tagsView) {
        _tagsView = [[DRMEPreviewTagsView alloc] initWithFrame:self.imageContainerView.frame];
        _tagsView.userInteractionEnabled = YES;
    }
    return _tagsView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    
    // toolBar 只有一个垃圾桶
    UIView *toolBar = [[UIView alloc] init];
    [self.view addSubview:toolBar];
    
    toolBar.sd_layout.leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, kSafeAreaHeight + 20)
    .heightIs(60);
    
    // 画布视图 -- 子view有 scrollView 和 imageView 和 标签、文字等效果
    UIView *canvasView = [[UIView alloc] init];
    //    canvasView.backgroundColor = UIColor.greenColor;
    [self.view addSubview:canvasView];
    self.canvasView = canvasView;
    [doneBtn updateLayout];
    [toolBar updateLayout];

    canvasView.frame = CGRectMake(0, doneBtn.bottom + 15, kScreenWidth,
                                  toolBar.top - 15 - (doneBtn.bottom + 15));
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = canvasView.bounds;
    _scrollView.bouncesZoom = NO;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.multipleTouchEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
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
    
    // 改变现有层级关系
    // 拖拽的时候，搞个假标签在最上层，
    [_scrollView addSubview:self.tagsView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTapGestureAddTag:)];
    [self.tagsView addGestureRecognizer:tap];
    
    self.bottomToolBar = [[DRMETagBottomToolBar alloc] init];
    [self.bottomToolBar loadTagInputBottomBar];
    self.bottomToolBar.delegate = self;
    [self.view addSubview:self.bottomToolBar];
    
    
    // 测试效果 
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:@(381) forKey:@"center_left_to_photo"];
//    [dic setObject:@(323) forKey:@"center_top_to_photo"];
//    [dic setObject:@"我是你爸爸" forKey:@"target_name"];
//    [dic setObject:@(0) forKey:@"tagDirections"];
////    [dic setObject:tagID forKey:@"tagID"];
//
//    [self.tagsDictArray addObject:dic];
    
    // 如果之前有添加过标签，也要显示出来
    // 默认提示标签的，就不需要添加了
    if (self.tagsArray.count > 0) {
        
        [self.tagsArray enumerateObjectsUsingBlock:^(DRMETagView * _Nonnull tagView, NSUInteger idx, BOOL * _Nonnull stop) {
            tagView.delegate = self;
            tagView.zoomScale = _scrollView.zoomScale;
            [self.tagsView addSubview:tagView];
        }];

    } else if (self.tagsDictArray.count > 0) {
        
        /// 这里是从浏览大图，进来的 ，将dict转为DRMETagModel，然后添加标签
        [self.tagsDictArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
            
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
        
    } else {

        _scrollView.scrollEnabled = NO;
        
        // 默认提示标签的 父视图
        UIView *tipView = [[UIView alloc] initWithFrame:self.view.bounds];
        tipView.userInteractionEnabled = NO;
        [self.view addSubview:tipView];
        self.tipView = tipView;
        
        // 添加一个默认的提示标签
        DRMETagModel *defaultModel = [[DRMETagModel alloc] init];
        defaultModel.text = @"点击图片，标记这一刻";
        defaultModel.tagDirection = DRMETagDirectionRight;
        
        CGPoint point = tipView.center;
        DRMETagView *defaultTagView = [[DRMETagView alloc] initWithPoint:point
                                                                tagModel:defaultModel];
        defaultTagView.falseView = YES;
        [tipView addSubview:defaultTagView];
        defaultTagView.left = defaultTagView.left - defaultTagView.width/2;
        self.defautTagView = defaultTagView;
    }
    
    [self.view bringSubviewToFront:backBtn];
    [self.view bringSubviewToFront:doneBtn];
    [self.view bringSubviewToFront:self.bottomToolBar];
    
    
    
    // 如果之前添加过文字，要显示
    if (self.labelArray.count > 0) {
        
        for (DRMEStickerLabelView *labelView in self.labelArray) {
            [_imageContainerView addSubview:labelView];
        }
        
    }
    
    
    /// 添加一个 点， 不显示
    [self.view addSubview:self.pointImgView];
    
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
    
//    [self refreshScrollViewContentSize];
//    [self refreshImageContainerViewCenter];
    
    self.scrollView.maximumZoomScale = SCREEN_WIDTH / self.imageContainerView.width * 3.f;
}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (self.scrollView.scrollEnabled) {
        return _imageContainerView;
    }
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    if ([self.bottomToolBar.inputText isFirstResponder]) {
        [self.bottomToolBar.inputText resignFirstResponder];
        self.pointImgView.hidden = YES;
    }
    
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

#pragma mark - 事件
- (void)clickBackBtn
{
    [self.bottomToolBar.inputText resignFirstResponder];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)clickDoneBtn
{
    DNLog(@"-- %s, %d", __func__, __LINE__);
    [self clickBackBtn];
    
    /// 回传标签 和 文字 给相册编辑页
    if (self.inputTagCompleteBlock) {
        self.inputTagCompleteBlock(self.tagsArray, self.labelArray);
    }
    
    /// 回传标签给大图浏览页
    if (self.editTagCompleteBlock) {
        NSMutableArray *array = [NSMutableArray array];
        for (DRMETagView *tagView in self.tagsArray) {
            NSDictionary *tagDict = [tagView getTagData];
            [array addObject:tagDict];
        }
        self.editTagCompleteBlock(array);
    }
}

#pragma mark - 点击了图片的容器
- (void)clickTapGestureAddTag:(UITapGestureRecognizer *)tap
{
    // 如果添加了 默认的提示标签，就给他删掉
    if (self.tipView) {
        [self.tipView removeFromSuperview];
        self.tipView = nil;
        self.scrollView.scrollEnabled = YES;
    }
    
    // 检查个数
    if (![self limitCheck]) {
        return;
    }
    
    CGPoint point = [tap locationInView:_imageContainerView];
    
    if ([self.bottomToolBar.inputText isFirstResponder]) {
        self.bottomToolBar.inputText.text = nil;
        [self.bottomToolBar.inputText resignFirstResponder];
        _tempPoint = CGPointZero;
    } else {
        _tempPoint = point;
        [self.bottomToolBar.inputText becomeFirstResponder];
        
    }
    
    // 将 point 转到 self.view 上的point
    CGPoint newPoint = [_imageContainerView convertPoint:point toView:self.view];

    self.pointImgView.hidden = NO;
    // 将点，设置到手点的位置
    self.pointImgView.center = newPoint;
}

/// 检查标签是否达到上限
- (BOOL)limitCheck
{
    BOOL pass = YES;;
    
    if (self.tagsArray.count >= 10) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"最多添加10个标签" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            DNLog(@"确定 -- 确定");
        }];
        
        [alertController addAction:alertAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        pass = NO;
    }
    
    return pass;
}

#pragma mark - 添加一个标签
- (void)addTagWith:(CGPoint)point text:(NSString *)text
{
    // 不能加在 _imageContainerView 上
    DRMETagModel *tagModel = [[DRMETagModel alloc] init];
    tagModel.text = text;
    tagModel.tagPoint = point;
    tagModel.tagDirection = DRMETagDirectionRight;
    
    DRMETagView *tagView = [[DRMETagView alloc] initWithPoint:point
                                                     tagModel:tagModel];

    tagView.tapRelativePosition = [DRMETagView relativePositionForPoint:point containerSize:self.tagsView.size];
    tagView.zoomScale = self.scrollView.zoomScale;
    tagView.delegate = self;
    [self.tagsView addSubview:tagView];
    [self.tagsArray addObject:tagView];
    
    // 需求，添加的标签，文字默认朝右，
    // 如果超出图片区域，就看看朝左是否能放下，能就朝左
    // 如果放不下就朝右吧
    
    BOOL isContains = [self isContainsTagView:tagView];
    if (!isContains) {
        [tagView layoutLeft];
        
        isContains = [self isContainsTagView:tagView];
        
        if (!isContains) {
            [tagView layoutRight];
        }
    }
    
}

#pragma mark - DRMETagBottomToolBarDelegate
- (void)bottomToolBarPublishAction:(NSString *)text {
    
    if (!self.bottomToolBar.inputText.isFirstResponder) {
        [self resetScrollViewWithAnimationDuration:0.3 animationCurve:UIViewAnimationCurveLinear];
    } else {
        [self.bottomToolBar.inputText resignFirstResponder];
        self.pointImgView.hidden = YES;
    }
    // 检查个数
    if (![self limitCheck]) {
        return;
    }
        
    CGPoint point = _tempPoint;
    // 根据点去添加标签
    [self addTagWith:point text:text];
    
    // 清空之前输入内容
    self.bottomToolBar.inputText.text = @"";
    _tempPoint = CGPointZero;
    
}

- (void)bottomToolBarKeyboardWillShow:(NSDictionary *)keyboardInfo
{
    // 键盘输入框要在最上层
    [self.view bringSubviewToFront:self.bottomToolBar];
    
    CGRect rect = [keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = ((NSNumber *)keyboardInfo[UIKeyboardAnimationDurationUserInfoKey]).doubleValue;
    UIViewAnimationCurve curve = ((NSNumber *)keyboardInfo[UIKeyboardAnimationCurveUserInfoKey]).integerValue;
    
    if (rect.size.height > 0) {
        CGFloat top = self.view.height - rect.size.height - self.bottomToolBar.height;
        __weak typeof(self) weakSelf = self;
        
        [UIView animateWithDuration:animationDuration animations:^{
            [UIView setAnimationCurve:curve];
            weakSelf.bottomToolBar.top = top;
        }];
    }
}

- (void)bottomToolBarKeyboardWillHide:(NSDictionary *)keyboardInfo
{
    NSTimeInterval       animationDuration = ((NSNumber *)keyboardInfo[UIKeyboardAnimationDurationUserInfoKey]).doubleValue;
    UIViewAnimationCurve curve = ((NSNumber *)keyboardInfo[UIKeyboardAnimationCurveUserInfoKey]).integerValue;
    [self resetScrollViewWithAnimationDuration:animationDuration animationCurve:curve];
}

- (void)resetScrollViewWithAnimationDuration:(NSTimeInterval)duration
                              animationCurve:(UIViewAnimationCurve)curve
{
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:curve];
        self.bottomToolBar.top = self.view.height;
    }];
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

#pragma mark - DRMETagViewDelegate
- (void)tagView:(DRMETagView *)tagView panGestureRecognizer:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        // 干掉键盘
        [self.view endEditing:YES];
        
        // 记录本次开始拖拽的起始frame
        self.beginViewFrame = tagView.frame;
        
        [self.view bringSubviewToFront:tagView];
        
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
    
    
    // 因为图片可以缩放XXX，先判断标签是否在scrollView里
    // 在 scrollView 里，接着判断 是否在 imageView 里
    
//    if (CGRectContainsRect(self.scrollView.bounds, tagRect)) {
//        // 在scrollView里
//        if (CGRectContainsRect(imageRect, tagRect)) {
//            DNLog(@"还在范围里面呢");
//            return YES;
//        } else {
//            DNLog(@"不在图片范围里，恢复原位置");
//            return NO;
//        }
//    } else {
//        DNLog(@"超出scrollView，也恢复原位置");
//        return NO;
//    }
    return NO;
}

- (void)dealloc
{
    DNLog(@"-- %s, %d", __func__, __LINE__);
}

@end
