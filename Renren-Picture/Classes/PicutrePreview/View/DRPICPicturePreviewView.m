//
//  DRPICPicturePreviewView.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/18.
//

#import "DRPICPicturePreviewView.h"

#import "DRPICWebImageProtocol.h"
#import "DRPICWebImageManager.h"
//#import "UIImage+GIF.h"
#import "UIView+CTLayout.h"

static Class DRPICImageManagerClass = nil;

@interface DRPICPicturePreviewView ()<UIScrollViewDelegate>

/// 可开始展示标签
@property (nonatomic, getter=isShowTagsFinished) BOOL showTagsFinished;

@property(nonatomic, strong) id<DRPICWebImageProtocol> imageProtocol;

@end

@implementation DRPICPicturePreviewView

#pragma mark - Override Methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)dealloc {
    [self processCancelCurrentImageLoad];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Intial Methods
- (void)initialize {
    [self createContent];
}

#pragma mark - Create Methods
- (void)createContent {
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.scrollView];
    [self addSubview:self.loadingView];
    
}

#pragma mark - Process Methods

- (void)processCancelCurrentImageLoad {
    [self.imageView sd_cancelCurrentImageLoad];
}

- (void)processLoading:(BOOL)loading animated:(BOOL)animated {
    if (animated == NO) {
        self.loadingView.hidden = NO;
        return;
    }

    self.loadingView.hidden = NO;
}

- (CGPoint)processCenterOfScrollViewContent:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

#pragma mark - Event Methods

#pragma mark - Public Methods



#pragma mark - Setter And Getter Methods
- (FLAnimatedImageView *)animatedImageView {
    if (!_animatedImageView) {
        FLAnimatedImageView *animatedImageView = [FLAnimatedImageView new];
        _animatedImageView = animatedImageView;
    }
    return _animatedImageView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [UIImageView new];
//        imageView.clipsToBounds = YES;
//        imageView.layer.contentsRect=CGRectMake(0,0,1,0.5);
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _imageView = imageView;
    }
    return _imageView;
}

- (DRPICVideoView *)videoView {
    if (!_videoView) {
        DRPICVideoView *videoView = [DRPICVideoView new];
        _videoView = videoView;
    }
    return _videoView;
}

- (DRPICScrollView *)scrollView {
    if (!_scrollView) {
        DRPICScrollView *scrollView = [[DRPICScrollView alloc] initWithFrame:self.bounds];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.clipsToBounds = YES;
        scrollView.scrollEnabled = YES;
        scrollView.multipleTouchEnabled = YES; // 多点触摸开启
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (DRPICTagContainerView *)tagContainerView {
    if (!_tagContainerView) {
        DRPICTagContainerView *tagContainerView = [DRPICTagContainerView new];
        _tagContainerView = tagContainerView;
    }
    return _tagContainerView;
}

- (DRPICLoadingView *)loadingView {
    if (!_loadingView) {
        DRPICLoadingView *loadingView = [DRPICLoadingView new];
        _loadingView = loadingView;
    }
    return _loadingView;
}


@end
