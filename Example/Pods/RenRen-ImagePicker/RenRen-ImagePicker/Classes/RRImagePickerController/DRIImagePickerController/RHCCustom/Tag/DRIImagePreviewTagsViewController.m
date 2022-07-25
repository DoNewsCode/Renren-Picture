//
//  DRIImagePreviewTagsViewController.m
//  RenrenOfficial-iOS-Concept
//
//  Created by 张健康 on 2019/3/19.
//  Copyright © 2019 renren. All rights reserved.
//

#import "DRIImagePreviewTagsViewController.h"
#import "DRIImagePreviewTagsView.h"
#import "DRIImagePickerController.h"
#import "DRIImageTagBottomToolBar.h"
#import "DRIImageTagCommentTextField.h"
//#import "RHCNewsFeedActionSheet.h"
//#import "RHCUtilitiHelper.h"
#import "DRITagView.h"
#import "DRIImagePickerController.h"
#import "DRITagsScrollView.h"
#import "SDAutoLayout.h"
#import <DNCommonKit/DNBaseMacro.h>
#import <DNCommonKit/NSObject+CTAlert.h>
#import <DNCommonKit/UIButton+CTTitlePlace.h>
#import "DRPPop.h"
@interface DRIImagePreviewTagsViewController ()<DRIImageTagBottomToolBarDelegate,DRIImagePreviewTagsViewDelegate>{
    UIView *_tipView;
    UIView *_naviBar;
    UIButton *_backButton;
    UIButton *_selectButton;
    UIButton *_tagButton;
    UILabel *_indexLabel;
    UIButton *_doneButton;
}
@property (nonatomic, strong) DRIImageTagBottomToolBar *bottomToolBar;
@property(nonatomic, strong) DRIImagePreviewTagsView *tagsView;
@property(nonatomic, strong) PHAsset *asset;
@property(nonatomic, strong) UIView *dustbinView;
@property(nonatomic, strong) DRITagsScrollView *scrollView;
@property(nonatomic, assign) CGRect tagsViewRect;
@property(nonatomic, assign) CGPoint tempPoint;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *dustImageView;
@property (nonatomic, strong) UIImage *image;
@end

@implementation DRIImagePreviewTagsViewController

- (instancetype)initWithImage:(UIImage *)image{
    if (self = [self init]) {
        self.image = image;
    }
    return self;
}

- (instancetype)initWithPHAsset:(PHAsset *)asset{
    if (self = [self init]) {
        self.asset = asset;
    }
    return self;
}

- (instancetype)initWithTagsRect:(CGRect)tagsRect{
    if (self = [self init]) {
        self.tagsViewRect = tagsRect;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = UIColor.blackColor;
//    self.bottomToolBarPreviousTop = 0;
//    self.isKeyboardShowingForTheFirstTime = YES;
    [self configImageView];
    [self configCustomNaviBar];
    [self configDustbinView];
    [self configTagsView];
    [self configTipView];
    self.bottomToolBar = [[DRIImageTagBottomToolBar alloc] init];
    [self.bottomToolBar loadTagInputBottomBar];
    self.bottomToolBar.delegate = self;
    [self.view addSubview:self.bottomToolBar];
    // Do any additional setup after loading the view.
}

- (void)configTagsView{
    [self.scrollView addSubview:self.tagsView];
}

- (void)configImageView{
    [self.view addSubview:self.scrollView];
    _imageView = [[UIImageView alloc] init];
    _imageView.userInteractionEnabled = YES;
    _imageView.backgroundColor = [UIColor blackColor];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
    _imageView.image = self.image;
    [_scrollView addSubview:_imageView];
//    self.tagsView.imageRect = _imageView.frame;
}

- (void)configDustbinView{
    [self.view addSubview:self.dustbinView];
    [self.view sendSubviewToBack:self.dustbinView];
    self.dustbinView.hidden = YES;
}

- (void)configCustomNaviBar {
    
    //    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    
    _naviBar = [[UIView alloc] initWithFrame:CGRectZero];
    _naviBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_backButton setImage:[UIImage dri_imageNamedFromMyBundle:@"navi_back"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setBackgroundImage:[UIImage dri_imageNamedFromMyBundle:@"Publish_imagePicker_right"] forState:UIControlStateNormal];
    [_doneButton setTitle:@"确定" forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_naviBar addSubview:_doneButton];
    [_naviBar addSubview:_backButton];
    [self.view addSubview:_naviBar];
}

//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    if (_tipView.superview) {
//        [_tipView removeFromSuperview];
//        return;
//    }
//    [super touchesEnded:touches withEvent:event];
//}

- (void)configTipView{
    UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = UIColor.clearColor;
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    _tipView = bgView;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    CGFloat width = 45;
    CGFloat height = 210;
    view.frame = CGRectMake((SCREEN_WIDTH - 210)/2, (SCREEN_HEIGHT - 45) / 2, 210, 45);
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 22.5;
    view.center = self.view.center;
    [bgView addSubview:view];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"点击图片，标记这一刻";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:17];
    label.frame = view.bounds;
    [view addSubview:label];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tipViewDidClick:)];
    [_tipView addGestureRecognizer:tap];
}

- (void)tipViewDidClick:(id)sender{
    [_tipView removeFromSuperview];
    _tipView.hidden = YES;
    _tipView = nil;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    DRIImagePickerController *driImagePickVc = (DRIImagePickerController *)self.navigationController;
    CGFloat statusBarHeight = [DRICommonTools dri_statusBarHeight];
    CGFloat statusBarHeightInterval = statusBarHeight - 20;
    CGFloat naviBarHeight = statusBarHeight + 44 ;
    _naviBar.frame = CGRectMake(0, 0, self.view.width, naviBarHeight);
    
    _backButton.frame = CGRectMake(12, 10 + statusBarHeightInterval, 44, 44);
    [_backButton ct_setEnlargeEdge:24.f];
    [_doneButton sizeToFit];
    _doneButton.frame = CGRectMake(self.view.width - _doneButton.width - 12,_naviBar.height - 10.5 - _doneButton.height, _doneButton.width, _doneButton.height);
    _doneButton.centerY = _backButton.centerY;
    
//    _imageView.origin = CGPointZero;
//        _imageView.width = self.scrollView.width;
//    _imageView.height = self.self.scrollView.height;
//    _imageView.frame = self.scrollView.bounds;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.scrollView.height / self.scrollView.width) {
        _imageView.width = floor(image.size.width / (image.size.height / self.scrollView.height));
        _imageView.height = _imageView.width / image.size.width * image.size.height;
    } else {
        CGFloat height = image.size.height / image.size.width * self.scrollView.width;
        if (height < 1 || isnan(height)) height = self.scrollView.height;
        height = floor(height);
        _imageView.height = height;
        _imageView.width = self.scrollView.width;
    }
    if (_imageView.height > self.scrollView.height) {
        _imageView.height = self.scrollView.height;
    }
    _imageView.centerX = self.scrollView.width / 2;
    _imageView.centerY = (self.scrollView.height) / 2;
    CGFloat contentSizeH = MAX(_imageView.height, self.scrollView.height);
    _scrollView.contentSize = CGSizeMake(self.scrollView.width, contentSizeH);
    [_scrollView scrollRectToVisible:self.scrollView.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageView.height <= self.scrollView.height ? NO : YES;
    self.tagsView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height);
    _scrollView.maximumZoomScale = SCREEN_WIDTH / self.imageView.width * 3.f;
//    [self refreshScrollViewContentSize];
//    [self refreshImageContainerViewCenter];
}

- (void)doneButtonClick{
    self.tagsView.deleteButton.hidden = YES;
    self.tagsView.currentTagView = nil;
    if (self.dismissBlock) {
        self.dismissBlock(YES,[self.tagsView getAllTagsDic]);
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)tapAction:(CGPoint)point
{
    if (![self limitCheck]) {
        return;
    }
    if ([self.bottomToolBar.inputText isFirstResponder]) {
        self.bottomToolBar.inputText.text = nil;
        [self.bottomToolBar.inputText resignFirstResponder];
        _tempPoint = CGPointZero;
        [self.tagsView hidePointView];
    } else {
        _tempPoint = point;
        [self.tagsView showPointView:point];
        [self.bottomToolBar.inputText becomeFirstResponder];
    }
}

- (BOOL)limitCheck
{
    BOOL pass = YES;;
    if (self.tagsView.tagViews.count >= 15) {
        [self ct_showAlertWithTitle:@"图片标签数已达上限"
                            message:@"点击标签可删除"
                    actionTitleList:@[@"确定"]
                            handler:^(UIAlertAction *action, NSUInteger index) {
                                
                            } completion:nil];
        pass = NO;
    } else if (self.tagsView.tagViews.count >= 5) {
        [self ct_showAlertWithTitle:@"最多标记5个标签"
                            message:@"点击标签可删除"
                    actionTitleList:@[@"确定"]
                            handler:^(UIAlertAction *action, NSUInteger index) {
                                
                            } completion:nil];
        pass = NO;
    }
    return pass;
}

- (DRIImagePreviewTagsView *)tagsView{
    if (!_tagsView) {
        _tagsView = [[DRIImagePreviewTagsView alloc] initWithFrame:self.tagsViewRect];
        _tagsView.userInteractionEnabled = YES;
        _tagsView.canMove = YES;
        @weakify(self);
        [_tagsView setAddTag:^(CGPoint tagPoint) {
            [weak_self tapAction:tagPoint];
        }];
        _tagsView.delegate = self;
        _tagsView.zoomScale = 1;
    }
    return _tagsView;
}
- (void)bottomToolBarPublishAction:(NSString *)text{
    if (!self.bottomToolBar.inputText.isFirstResponder) {
        [self resetScrollViewWithAnimationDuration:0.3 animationCurve:UIViewAnimationCurveLinear];
    } else {
        [self.bottomToolBar.inputText resignFirstResponder];
    }
    
    if (![self limitCheck]) {
        return;
    }
    [self.tagsView addNewTag:_tempPoint text:text];
    [self.tagsView hidePointView];
    self.bottomToolBar.inputText.text = @"";
    _tempPoint = CGPointZero;
}
- (void)bottomToolBarKeyboardWillShow:(NSDictionary *)keyboardInfo
{
    CGRect               rect = [keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval       animationDuration = ((NSNumber *)keyboardInfo[UIKeyboardAnimationDurationUserInfoKey]).doubleValue;
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

- (void)resetScrollViewWithAnimationDuration:(NSTimeInterval)duration animationCurve:(UIViewAnimationCurve)curve
{
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:curve];
        self.bottomToolBar.top = self.view.height;
    }];
}

- (void)addExistTags:(NSMutableArray *)array{
    for (NSMutableDictionary *dict in array) {
        [self.tagsView addNewTagWithDict:dict];
    }
}

- (void)backButtonClick{
    if ([self.bottomToolBar.inputText isFirstResponder]) {
        self.bottomToolBar.inputText.text = nil;
        [self.bottomToolBar.inputText resignFirstResponder];
        _tempPoint = CGPointZero;
        [self.tagsView hidePointView];
    }
    [self goBack];
}

- (DRITagsScrollView *)scrollView{
    if (!_scrollView) {
        CGFloat statusBarHeight = [DRICommonTools dri_statusBarHeight];
        CGFloat statusBarHeightInterval = statusBarHeight - 20;
        CGFloat naviBarHeight = statusBarHeight + 44 ;
        _scrollView = [[DRITagsScrollView alloc] init];
        _scrollView.frame = CGRectMake(0,naviBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - naviBarHeight - self.dustbinView.height);
        _scrollView.bouncesZoom = NO;
        _scrollView.bounces = YES;
        _scrollView.maximumZoomScale = 1.f;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.canCancelContentTouches = NO;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.backgroundColor = UIColor.clearColor;
        if (@available(iOS 11, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

- (UIView *)dustbinView{
    if (!_dustbinView) {
        UIView *dustbinView = [[UIView alloc] init];
        CGFloat toolBarHeight = [DRICommonTools dri_isIPhoneX] ? 44 + (83 - 49) : 44;
        CGFloat toolBarTop = self.view.height - toolBarHeight;
        dustbinView.frame = CGRectMake(0, toolBarTop, self.view.width, toolBarHeight);
        dustbinView.backgroundColor = UIColor.clearColor;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage dri_imageNamedFromMyBundle:@"Publish_tag_dustbin"]];
        [imageView sizeToFit];
        imageView.frame = CGRectMake((self.view.width - imageView.width)/2, (toolBarHeight - imageView.height)/2, imageView.width, imageView.height);
        [dustbinView addSubview:imageView];
        self.dustImageView = imageView;
        _dustbinView = dustbinView;
    }
    return _dustbinView;
}

- (void)goBack{
    if (self.dismissBlock) {
        self.dismissBlock(NO,nil);
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - DRITagsScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    self.tagsView.deleteButton.hidden = YES;
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentInset.left - scrollView.contentInset.right - scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom - scrollView.contentSize.height) * 0.5, 0.0);
    
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                        scrollView.contentSize.height * 0.5 + offsetY);
    
    [self refreshImageContainerViewCenter:scrollView.zoomScale];
}

#pragma mark - Private

- (void)refreshImageContainerViewCenter:(CGFloat)scale {
    self.tagsView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height);
    self.tagsView.zoomScale = scale;
//    [self.tagsView refreshAllTagsView];
}

- (void)tagsViewDidAddNewTag:(NSDictionary *)tag{
    if (self.addTagBlock) {
        self.addTagBlock(tag);
    }
}

- (void)tagsViewDidDeleteNewTag:(NSDictionary *)tag{
    if (self.deleteTagBlock) {
        self.deleteTagBlock(tag);
    }
}
- (BOOL)tagsViewShouldAddDeleteButton:(DRITagView *)tagView{
    NSString *tagID = tagView.tagData[@"tagID"];
    return !tagID.length;
}

- (void)tagsViewDidMoveTag:(DRITagView *)tagView{
    self.dustbinView.hidden = NO;

    CGPoint convertPt = [self.view convertPoint:tagView.pointView.center fromView:tagView];
    if (self.dustbinView.frame.origin.y <= convertPt.y) {
        [UIView animateWithDuration:0.25f animations:^{
            self.dustImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 100/70.0, 100/70.0);
        }];
    }else{
        [UIView animateWithDuration:0.25f animations:^{
            self.dustImageView.transform = CGAffineTransformIdentity;
        }];
    }
}
- (void)tagsViewDidEndMoveTag:(DRITagView *)tagView{
    self.dustbinView.hidden = YES;
    
    CGPoint convertPt = [self.view convertPoint:tagView.pointView.center fromView:tagView];
    if (self.dustbinView.frame.origin.y <= convertPt.y) {
        [self.tagsView deleteTagView:tagView];
    }else{
        [tagView cancelMoved];
    }
    [UIView animateWithDuration:0.25f animations:^{
        self.dustImageView.transform = CGAffineTransformIdentity;
    }];
}
@end
