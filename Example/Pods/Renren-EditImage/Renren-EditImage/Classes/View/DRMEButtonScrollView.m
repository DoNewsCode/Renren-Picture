//
//  DRMEButtonScrollView.m
//  TestPod
//
//  Created by 李晓越 on 2020/3/30.
//  Copyright © 2020 李晓越. All rights reserved.
//

#import "DRMEButtonScrollView.h"

@interface DRMEButtonScrollView ()<UIScrollViewDelegate>

@property(nonatomic,weak) UIScrollView *btnsScrollView;
@property(nonatomic,weak) UIButton *takePhotoBtn;
@property(nonatomic,weak) UIButton *cameraBtn;
@property(nonatomic,strong) UIButton *currentBtn;
@property(nonatomic,assign,readwrite) DRMEButtonType buttonType;

@end

@implementation DRMEButtonScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        

        // scrollview 包两个按钮，方便手势滑动
        UIScrollView *btnsScrollView = [[UIScrollView alloc] init];
        btnsScrollView.delegate = self;
        btnsScrollView.frame = CGRectMake(0, 0, 52, self.height);
        btnsScrollView.centerX = self.centerX;
        btnsScrollView.showsHorizontalScrollIndicator = NO;
        btnsScrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:btnsScrollView];
        self.btnsScrollView = btnsScrollView;
        
        btnsScrollView.clipsToBounds = NO;
        btnsScrollView.pagingEnabled = YES;
        
        UIButton *takePhotoBtn = [[UIButton alloc] init];
        takePhotoBtn.tag = DRMEButtonTypeTakePhoto;
        [takePhotoBtn setTitle:@"拍照" forState:UIControlStateNormal];
        [takePhotoBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateNormal];
        [takePhotoBtn setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateSelected];
        takePhotoBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        takePhotoBtn.frame = CGRectMake(0, 0, 52, self.height);
        [takePhotoBtn addTarget:self action:@selector(clickTakePhotoBtn) forControlEvents:UIControlEventTouchUpInside];
        [btnsScrollView addSubview:takePhotoBtn];
        takePhotoBtn.selected = YES;
        self.takePhotoBtn = takePhotoBtn;
        self.currentBtn = takePhotoBtn;
        
        
        UIButton *cameraBtn = [[UIButton alloc] init];
        cameraBtn.tag = DRMEButtonTypeCamera;
        [cameraBtn setTitle:@"摄像" forState:UIControlStateNormal];
        [cameraBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateNormal];
        [cameraBtn setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateSelected];
        cameraBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        cameraBtn.frame = CGRectMake(takePhotoBtn.right, 0, 52, self.height);
        [cameraBtn addTarget:self action:@selector(clickCameraBtn) forControlEvents:UIControlEventTouchUpInside];
        [btnsScrollView addSubview:cameraBtn];
        self.cameraBtn = cameraBtn;
        
        
        btnsScrollView.contentSize = CGSizeMake(cameraBtn.right, self.height);
        
    }
    return self;
}

#pragma mark - 设置当前选中的按钮
- (void)setCurrentBtn:(UIButton *)currentBtn
{
    if (_currentBtn == currentBtn) {
        return;
    }
    _currentBtn.selected = NO;
    _currentBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    
    _currentBtn = currentBtn;
    
    _currentBtn.selected = YES;
    _currentBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    
    // 选中某个按钮后，给外界一个回调
    NSInteger index = _currentBtn.tag;
    self.buttonType = index;
    
    NSLog(@" button index == %zd", index);
    if ([self.delegate respondsToSelector:@selector(buttonScrollView:scrollToButtonType:)]) {
        [self.delegate buttonScrollView:self scrollToButtonType:index];
    }
}

#pragma mark - 事件
- (void)clickTakePhotoBtn
{
    NSLog(@"-- %s, %d", __func__, __LINE__);
    [self.btnsScrollView setContentOffset:CGPointZero animated:YES];
    self.currentBtn = self.takePhotoBtn;
}

- (void)clickCameraBtn
{
    NSLog(@"-- %s, %d", __func__, __LINE__);
    [self.btnsScrollView setContentOffset:CGPointMake(52, 0) animated:YES];
    self.currentBtn = self.cameraBtn;
}

#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat offsetX = scrollView.contentOffset.x;
//    CGFloat tempIndex = offsetX/scrollView.width;
//
//    NSInteger index = (NSInteger)(tempIndex + 0.5);
//
//    NSLog(@"index == %zd", index);
//    // 边滑，边改变， 效果不太好
//    if (index == 0) {
//        self.currentBtn = self.paizhaoBtn;
//    } else if (index == 1) {
//        self.currentBtn = self.shexiangBtn;
//    }
//}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        // 停止后要执行的代码
        CGFloat offsetX = scrollView.contentOffset.x;
        CGFloat tempIndex = offsetX/scrollView.width;

        NSInteger index = (NSInteger)(tempIndex + 0.5);

        NSLog(@"index == %zd", index);

        if (index == 0) {
            self.currentBtn = self.takePhotoBtn;
        } else if (index == 1) {
            self.currentBtn = self.cameraBtn;
        }
    }
}

#pragma mark - 修改事件传递
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *child = [super hitTest:point withEvent:event];
  
    
    // 点击的点在按钮上，就先让按钮响应该事件
    CGPoint paizhaoPoint = [self.takePhotoBtn convertPoint:point fromView:self];
    if ([self.takePhotoBtn pointInside:paizhaoPoint withEvent:event]) {
        return self.takePhotoBtn;
    }
    
    CGPoint shexiangPoint = [self.cameraBtn convertPoint:point fromView:self];
    if ([self.cameraBtn pointInside:shexiangPoint withEvent:event]) {
        return self.cameraBtn;
    }
    
    if (child == self) {
        // 返回 btnsScrollView 时，DNScrollView 可视范围都能响应滑动手势
        return self.btnsScrollView;
    }
    
    return child;
}

#pragma mark - 处理业务逻辑
- (void)setOnlyTakePhoto:(BOOL)onlyTakePhoto
{
    _onlyTakePhoto = onlyTakePhoto;
    
    [self clickTakePhotoBtn];
    
}

- (void)setOnlyTakeVideo:(BOOL)onlyTakeVideo
{
    _onlyTakeVideo = onlyTakeVideo;
    
    [self clickCameraBtn];
}

@end
