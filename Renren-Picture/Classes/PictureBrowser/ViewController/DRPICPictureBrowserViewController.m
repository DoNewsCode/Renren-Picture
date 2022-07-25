//
//  DRPICPictureBrowserViewController.m
//  Renren-Picture
//
//  Created by 陈金铭 on 2019/9/24.
//

#import "DRPICPictureBrowserViewController.h"

#import "UIView+CTLayout.h"
#import "DRPICPanGestureRecognizer.h"

#import "DRPICPictureBrowserTransition.h"

@interface DRPICPictureBrowserViewController ()<UIScrollViewDelegate>

/// 拖拽手势
@property(nonatomic, strong) DRPICPanGestureRecognizer *panGestureRecognizer;


@property (nonatomic, strong) DRPICPictureBrowserTransition *transition;

@end

@implementation DRPICPictureBrowserViewController

#pragma mark - Override Methods
- (instancetype)init {
    if (self = [super init]) {
        // 设置转场代理
        self.transitioningDelegate = self.transition;
        // 自定义转场模式
        self.modalPresentationStyle = UIModalPresentationCustom;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.backgroundView];
    [self createContent];
    [self createGestureRecognizer];
    NSLog(@"DRPICPictureBrowserViewController---viewDidLoad");
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar ct_setBackgroundColor:[UIColor clearColor]];
    NSLog(@"DRPICPictureBrowserViewController---viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"DRPICPictureBrowserViewController---viewDidAppear");
    [self createLeftBar];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat safeAreaTopHeight = 0;
    CGFloat safeAreaBottomHeight = 0;
    if (@available(iOS 11.0, *)) {
        safeAreaTopHeight = self.view.safeAreaLayoutGuide.layoutFrame.origin.y - self.topContainerView.ct_height;
        safeAreaBottomHeight = self.view.ct_height - CGRectGetMaxY(self.view.safeAreaLayoutGuide.layoutFrame);
    } else {
        // Fallback on earlier versions
    }
    self.topContainerView.ct_height = self.topContainerView.ct_height + safeAreaTopHeight;
    
    self.bottomContainerView.ct_height = self.bottomContainerView.ct_height + safeAreaBottomHeight;
    self.bottomContainerView.ct_y = self.view.ct_height - self.bottomContainerView.ct_height;
    
    if (self.currentPictureView.animatedImageView.superview) {
        
        [self.currentPictureView.animatedImageView startAnimating];
        
    }
    
    NSLog(@"DRPICPictureBrowserViewController---viewDidLayoutSubviews");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    if (self.fromViewController.navigationController.delegate == self.transition) {
        self.fromViewController.navigationController.delegate = nil;
    }
}

- (void)createLeftBar {
    [self createLeftBarButtonItem:DRBNavigationBarLeftTypeWhite image:nil target:self action:@selector(eventLeftLeftBarButtonClick:)];
}

#pragma mark - Intial Methods


- (void)createContent {
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.topContainerView];
    self.topContainerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bottomContainerView];
    self.bottomContainerView.backgroundColor = [UIColor clearColor];
    [self procrssPictureViews];
    if (self.currentIndex != 0) {//定位到目标Picture
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.ct_width * self.currentIndex, 0) animated:NO];
    }
    self.currentPictureView = self.pictureViews[self.currentIndex];
}

#pragma mark 创建单击,双击,长按手势
- (void)createGestureRecognizer {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eventSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eventDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(eventLongPress:)];
    [self.view addGestureRecognizer:longPress];
    
    // 拖拽手势
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}

#pragma mark - Public Methods
- (void)processTopAndBottomContainerViewHidden:(BOOL)hidden animation:(BOOL)animation {
    if (animation == NO) {
        self.topContainerView.alpha = hidden ? 0 : 1;
        self.bottomContainerView.alpha = hidden ? 0 : 1;
        return;
    }
    [UIView animateWithDuration:0.618
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
        self.topContainerView.alpha = hidden ? 0 : 1;
        self.bottomContainerView.alpha = hidden ? 0 : 1;
        
    }completion:^(BOOL finished) {
    }];
}

- (void)processAddPictures:(NSArray<DRPICPicture *> *)pictures {
    if (pictures == nil) {
        return;
    }
    [self.pictures addObjectsFromArray:pictures];
    self.scrollView.contentSize = CGSizeMake(self.pictures.count * self.scrollView.ct_width, 0);
    for (NSInteger i = self.pictures.count - pictures.count; i < self.pictures.count; i++) {
        CGFloat pictureX = self.scrollView.ct_width * i;
        CGRect pictureFrame = (CGRect){pictureX,0.,self.view.ct_width,self.view.ct_height};
        DRPICPictureView *pictureView = [[DRPICPictureView alloc] initWithFrame:pictureFrame picture:self.pictures[i]];
        [pictureView processLoadContent];
        if (i % 1) {
            
            pictureView.backgroundColor = [UIColor clearColor];
        } else {
            
            pictureView.backgroundColor = [UIColor clearColor];
        }
        __weak typeof(self) weakSelf = self;
        [pictureView.tagContainerView returnTagEventBlock:^(DRPICTagView * _Nonnull tagView) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(pictureBrowser:didTagEventRowAtIndex:tag:)]) {
                [weakSelf.delegate pictureBrowser:weakSelf didTagEventRowAtIndex:weakSelf.currentIndex tag:tagView.pictureTag];
            }
        }];
        
        [self.pictureViews addObject:pictureView];
        [self.scrollView addSubview:pictureView];
        
    }
}

#pragma mark - Private Methods
- (void)procrssPictureViews {
    self.scrollView.contentSize = CGSizeMake(self.pictures.count * self.scrollView.ct_width, 0);
    for (NSInteger i = 0; i < self.pictures.count; i++) {
        CGFloat pictureX = self.scrollView.ct_width * i;
        CGRect pictureFrame = (CGRect){pictureX,0.,self.view.ct_width,self.view.ct_height};
        DRPICPictureView *pictureView = [[DRPICPictureView alloc] initWithFrame:pictureFrame picture:self.pictures[i]];
        [pictureView processLoadContent];
        if (i % 1) {
            
            pictureView.backgroundColor = [UIColor clearColor];
        } else {
            
            pictureView.backgroundColor = [UIColor clearColor];
        }
        __weak typeof(self) weakSelf = self;
        [pictureView.tagContainerView returnTagEventBlock:^(DRPICTagView * _Nonnull tagView) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(pictureBrowser:didTagEventRowAtIndex:tag:)]) {
                [weakSelf.delegate pictureBrowser:weakSelf didTagEventRowAtIndex:weakSelf.currentIndex tag:tagView.pictureTag];
            }
        }];
        [self.pictureViews addObject:pictureView];
        [self.scrollView addSubview:pictureView];
        
    }
}

#pragma mark - Event Methods
- (void)eventLeftLeftBarButtonClick:(UIButton *)button {
    [self.currentPictureView.tagContainerView eventTagHidden:YES animation:YES];
    [self processTopAndBottomContainerViewHidden:YES animation:NO];
    self.transition.interaction = NO;
    if (self.navigationController) {
        self.transition.type = DRPICPictureBrowserTransitionTypeNavigation;
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        self.transition.type = DRPICPictureBrowserTransitionTypeNone;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


/// 单击手势
- (void)eventSingleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.currentPictureView.tagContainerView eventTagHidden:YES animation:YES];
    [self processTopAndBottomContainerViewHidden:YES animation:NO];
    self.transition.type = DRPICPictureBrowserTransitionTypeNone;
    self.transition.interaction = NO;
    if (self.navigationController) {
        self.transition.type = DRPICPictureBrowserTransitionTypeNavigation;
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        self.transition.type = DRPICPictureBrowserTransitionTypeNone;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/// 双击手势
- (void)eventDoubleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    //以双击点为中心放大图片, 如果已经放大, 则缩小图片
    DRPICPictureView *pictureView = self.scrollView.subviews[self.currentIndex];
    DRPICPicture *picture = self.pictures[self.currentIndex];
    
    if (pictureView.scrollView.zoomScale > 1.0) {
        [pictureView.scrollView setZoomScale:1.0 animated:YES];
        picture.status.zooming = NO;
    }else{
        CGPoint location = [tapGestureRecognizer locationInView:pictureView];
        CGFloat wh = 1.0;
        CGRect zoomRect = [self frameWithWidth:wh height:wh center:location];
        [pictureView.scrollView zoomToRect:zoomRect animated:YES];
        picture.status.zooming = YES;
    }
}

- (CGRect)frameWithWidth:(CGFloat)width height:(CGFloat)height center:(CGPoint)center {
    CGFloat x = center.x - width * 0.5;
    CGFloat y = center.y - height * 0.5;
    
    return CGRectMake(x, y, width, height);
}

/// 长按手势
- (void)eventLongPress:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    switch (longPressGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            if ([self.delegate respondsToSelector:@selector(pictureBrowser:longPressWithIndex:)]) {
                [self.delegate pictureBrowser:self longPressWithIndex:self.currentIndex];
            }
            break;
        case UIGestureRecognizerStateEnded:
            break;
            
        default:
            break;
    }
}

/// 拖拽手势
- (void)eventHandlePanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    //    NSLog(@"%ld",(long)panGestureRecognizer.state);
    
    DRPICPictureView *pictureView = self.scrollView.subviews[self.currentIndex];
    CGPoint point       = [panGestureRecognizer translationInView:self.view];
    CGPoint location    = [panGestureRecognizer locationInView:pictureView];
    CGPoint velocity    = [panGestureRecognizer velocityInView:self.view];
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.startLocation = location;
            self.orginImageViewHeight = pictureView.contentView.ct_height;
            if ( pictureView.contentView.ct_height > [UIScreen mainScreen].bounds.size.height) {
                pictureView.contentView.ct_height = [UIScreen mainScreen].bounds.size.height;
            }
            self.startFrame = pictureView.contentView.frame;
            self.currentPictureView.picture.source.sourceImageView.hidden = YES;
            self.transition.interaction = YES;
            if (self.navigationController) {
                self.transition.type = DRPICPictureBrowserTransitionTypeNavigation;
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                self.transition.type = DRPICPictureBrowserTransitionTypeNone;
                [self dismissViewControllerAnimated:YES completion:nil];
            }

            [self.currentPictureView.tagContainerView eventTagHidden:YES animation:YES];
            [self processTopAndBottomContainerViewHidden:YES animation:YES];
            
            UIImage *image = pictureView.contentView.image;
            CGFloat rect = pictureView.contentView.image.size.width / pictureView.contentView.image.size.height;
            if (rect < 0.5 && [DRPICPictureView isLongImage:self.currentPictureView.picture.source.showImage]) {
                CGFloat rectimageView = pictureView.contentView.frame.size.height / pictureView.contentView.frame.size.width;
                pictureView.contentView.layer.contentsRect = CGRectMake(0,0,1,rectimageView * rect);
            }
            if (![pictureView.contentView isKindOfClass:[FLAnimatedImageView class]]) {
                pictureView.contentView.image = image;
            }
            
            
        }
            
            break;
        case UIGestureRecognizerStateChanged: {
            if (self.view.frame.size.height == 0) return;
            double percent = 1 - fabs(point.y) / self.view.frame.size.height ;
            double sizePercent = MAX((1 - fabs(point.y) / (self.view.frame.size.height * 0.5)), 0);
            if (self.startFrame.size.width == 0 || self.startFrame.size.height == 0) return;
            
            CGFloat widthDifference = self.startFrame.size.width - pictureView.picture.source.sourceImageView.frame.size.width;
            CGFloat heightDifference = self.startFrame.size.height - pictureView.picture.source.sourceImageView.frame.size.height;
            CGFloat width = pictureView.picture.source.sourceImageView.frame.size.width + widthDifference * sizePercent;
            CGFloat height = pictureView.picture.source.sourceImageView.frame.size.height + heightDifference * sizePercent;
            
            CGFloat rateX = (self.startLocation.x - self.startFrame.origin.x) / self.startFrame.size.width;
            CGFloat x = location.x - width * rateX;
            
            CGFloat rateY = (self.startLocation.y - self.startFrame.origin.y) / self.startFrame.size.height;
            CGFloat y = location.y - height * rateY + pictureView.scrollView.contentOffset.y;
            
            pictureView.contentView.frame = CGRectMake(x, y, width, height);
            CGFloat rect = pictureView.contentView.image.size.width / pictureView.contentView.image.size.height;
            if (rect < 0.5 && [DRPICPictureView isLongImage:pictureView.picture.source.showImage]) {
                CGFloat rectimageView = pictureView.contentView.frame.size.height / pictureView.contentView.frame.size.width;
                pictureView.contentView.layer.contentsRect = CGRectMake(0,0,1,rectimageView * rect);
            }
            self.backgroundView.alpha = percent;
            
            // 更新 interactive transition 的进度
            if (self.transition.type == DRPICPictureBrowserTransitionTypeNavigation) {
                [self.transition.popInteractiveTransition updateInteractiveTransition:percent];
            } else {
                [self.transition.dismissInteractiveTransition updateInteractiveTransition:percent];
            }
            NSLog(@"percent====%f\n sizePercent======%f\nwidthDifference======%f\nheightDifference=======%f\nwidth======%f\nheight======%f\npictureView.scrollView.contentSize=======(%f,%f)\npictureView.contentView.image.size======(%f,%f)\npictureView.contentView.frame======((%f,%f)(%f,%f))\nself.orginImageViewHeight=======%f\npictureView.scrollView.contentOffset======(%f,%f)",percent,sizePercent,widthDifference,heightDifference,width,height,pictureView.scrollView.contentSize.width,pictureView.scrollView.contentSize.height,pictureView.contentView.image.size.width,pictureView.contentView.image.size.height,pictureView.contentView.frame.origin.x,pictureView.contentView.frame.origin.y,pictureView.contentView.frame.size.width,pictureView.contentView.frame.size.height,self.orginImageViewHeight,pictureView.scrollView.contentOffset.x,pictureView.scrollView.contentOffset.y);
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{
            if (self.transition.type == DRPICPictureBrowserTransitionTypeNavigation) {
                [self.transition.popInteractiveTransition updateInteractiveTransition:1];
            } else {
                [self.transition.dismissInteractiveTransition updateInteractiveTransition:1];
            }
            
            if (fabs(point.y) > 200 || fabs(velocity.y) > 500) {
                NSLog(@"finishInteractiveTransition");
                
                [self processTopAndBottomContainerViewHidden:NO animation:YES];
                if (self.transition.type == DRPICPictureBrowserTransitionTypeNavigation) {
                    [self.transition.popInteractiveTransition finishInteractiveTransition];
                } else {
                    [self.transition.dismissInteractiveTransition finishInteractiveTransition];
                }
                
            }else {
                NSLog(@"cancelInteractiveTransition");
                if (self.transition.type == DRPICPictureBrowserTransitionTypeNavigation) {
                    [self.transition.popInteractiveTransition cancelInteractiveTransition];
                } else {
                    [self.transition.dismissInteractiveTransition cancelInteractiveTransition];
                }
                
                
            }
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - ScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSUInteger index = (scrollView.contentOffset.x + scrollView.ct_width * 0.5) / scrollView.ct_width;
    if (_currentIndex == index) {
        return;
    }
    self.currentIndex = index > (self.pictures.count - 1) ? (self.pictures.count - 1) : index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(pictureBrowser:didAppearRowAtIndex:)]) {
        [self.delegate pictureBrowser:self didAppearRowAtIndex:self.currentIndex];
    }
}

// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger index = scrollView.contentOffset.x / scrollView.ct_width;
    self.currentIndex = index;
    self.currentPictureView = scrollView.subviews[self.currentIndex];
    
}


#pragma mark - Setter And Getter Methods
- (void)setCurrentIndex:(NSUInteger)currentIndex {
    _currentIndex = currentIndex;
}

- (void)setTransitionFinished:(BOOL)transitionFinished {
    _transitionFinished = transitionFinished;
    if (transitionFinished == YES) {
        self.currentPictureView.showTagsReady = YES;
    }
}
- (void)setCurrentPictureView:(DRPICPictureView *)currentPictureView {
    if (_currentPictureView != nil && currentPictureView && currentPictureView.isShowTagsReady == NO) {
        currentPictureView.showTagsReady = YES;
    }
    _currentPictureView = currentPictureView;
    
}
- (void)setFromViewController:(UIViewController *)fromViewController {
    _fromViewController = fromViewController;
    if (fromViewController.navigationController == nil) {
        return;
    }
    fromViewController.navigationController.delegate = self.transition;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGRect frame = self.view.bounds;
        frame.size.width += (2 * 15);
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
        scrollView.delegate = self;
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        scrollView.pagingEnabled  = YES;
        scrollView.delegate = self;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.backgroundColor = [UIColor clearColor];
        
        if (@available(iOS 11.0, *)) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView = backgroundView;
    }
    return _backgroundView;
}

- (DRPICPanGestureRecognizer *)panGestureRecognizer {
    if (!_panGestureRecognizer) {
        DRPICPanGestureRecognizer *panGestureRecognizer = [[DRPICPanGestureRecognizer alloc] initWithTarget:self action:@selector(eventHandlePanGestureRecognizer:)];
        panGestureRecognizer.direction = DRPICPanGestureRecognizerDirectionVertical;
        _panGestureRecognizer = panGestureRecognizer;
    }
    return _panGestureRecognizer;
}

- (NSMutableArray<DRPICPictureView *> *)pictureViews {
    if (!_pictureViews) {
        NSMutableArray<DRPICPictureView *> *pictureViews = [NSMutableArray<DRPICPictureView *> array];
        _pictureViews = pictureViews;
    }
    return _pictureViews;
}

- (UIView *)topContainerView {
    if (!_topContainerView) {
        
        CGFloat height = 44;
        UIView *topContainerView = [[UIView alloc] initWithFrame:(CGRect){0.,0.,self.view.ct_width,height}];
        _topContainerView = topContainerView;
    }
    return _topContainerView;
}

- (UIView *)bottomContainerView {
    if (!_bottomContainerView) {
        
        CGFloat height = 49;
        UIView *bottomContainerView = [[UIView alloc] initWithFrame:(CGRect){0.,0.,self.view.ct_width,height}];
        _bottomContainerView = bottomContainerView;
    }
    return _bottomContainerView;
}

- (DRPICPictureBrowserTransition *)transition {
    if (!_transition) {
        DRPICPictureBrowserTransition *transition = [DRPICPictureBrowserTransition new];
        _transition = transition;
    }
    return _transition;
}

@end
