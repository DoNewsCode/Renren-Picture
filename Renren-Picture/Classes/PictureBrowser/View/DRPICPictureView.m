//
//  DRPICPictureView.m
//  Renren-Picture
//
//  Created by 陈金铭 on 2019/9/24.
//

#import "DRPICPictureView.h"
#import "DRPICWebImageProtocol.h"
#import "DRPICWebImageManager.h"
//#import "UIImage+GIF.h"
#import "UIView+CTLayout.h"

static Class DRPICImageManagerClass = nil;

@interface DRPICPictureView ()<UIScrollViewDelegate>
/// 可开始展示标签
@property (nonatomic, getter=isShowTagsFinished) BOOL showTagsFinished;

@property(nonatomic, strong) id<DRPICWebImageProtocol> imageProtocol;

@end

@implementation DRPICPictureView

#pragma mark - Override Methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
#pragma mark - Intial Methods
- (instancetype)initWithFrame:(CGRect)frame picture:(DRPICPicture *)picture
{
    self = [super initWithFrame:frame];
    if (self) {
        self.picture = picture;
        if (!DRPICImageManagerClass) {
            DRPICImageManagerClass = [DRPICWebImageManager class];
        }
        self.imageProtocol = [DRPICImageManagerClass new];
        [self initialize];
        //        self.imageView.image
    }
    return self;
}

#pragma mark - Public Methods
- (void)createPictureTag {
    if (self.picture.tags == nil || self.picture.tags.count == 0) {
        return;
    }
    
}

- (void)processLoadContent {
#pragma TO DO
    if (self.picture.source.extension == DRPICPictureExtensionNone) {
        NSString *extensionString = [self.picture.source.originUrlString pathExtension];
        if ([extensionString isEqualToString:@"png"]) {
            self.picture.source.extension = DRPICPictureExtensionPNG;
        } else if ([extensionString isEqualToString:@"jpg"] || [extensionString isEqualToString:@"jpeg"]) {
            self.picture.source.extension = DRPICPictureExtensionJPEG;
        } else if ([extensionString isEqualToString:@"gif"]) {
            self.picture.source.extension = DRPICPictureExtensionGIF;
        } else {
            self.picture.source.extension = DRPICPictureExtensionUnknown;
        }
    }
    
    if (self.picture.source.extension == DRPICPictureExtensionGIF) {
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.animatedImageView];
        self.contentView = self.animatedImageView;
        // 原图与缩略图的处理暂缓
        if (self.animatedImageView.image != nil) {
            return;
        }
        NSString *urlString = self.picture.source.thumbnailUrlString;
//        NSData *imageData = [self.imageProtocol im]
        NSData *imageData = [self.imageProtocol imageDataFromDiskForURL:[NSURL URLWithString:urlString]];
        if (imageData) {// 若有图片则直接展示
            [self processImageDataLoadedWithImage:imageData];
            [self processTagContainerView];
            return;
        }
        if (self.picture.status.loadStatus != DRPICPictureLoadStatusPending) {// 若图片等待加载则进入等待加载状态
            return;
        }
        // 只有图片未加载j并且处于可加载状态才开始图片加载操作
        
        if (self.picture.source.sourceImageView.image) {
            
            [self processImageDataLoadedWithImage:UIImagePNGRepresentation(self.picture.source.sourceImageView.image)];
            [self processTagContainerView];
            
        }
        
        [self processPictureLoading];
        
    } else if (self.picture.source.extension == DRPICPictureExtensionJPEG || self.picture.source.extension == DRPICPictureExtensionPNG) {

        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        self.contentView = self.imageView;
        // 原图与缩略图的处理暂缓
        if (self.imageView.image != nil) {
            return;
        }
        NSString *urlString = self.picture.source.thumbnailUrlString;
        
        UIImage *image = [self.imageProtocol imageFromMemoryForURL:[NSURL URLWithString:urlString]];
        if (image) {// 若有图片则直接展示
            [self processImageLoadedWithImage:image];
            [self processTagContainerView];
            return;
        }
        if (self.picture.status.loadStatus != DRPICPictureLoadStatusPending) {// 若图片等待加载则进入等待加载状态
            return;
        }
        // 只有图片未加载j并且处于可加载状态才开始图片加载操作
        [self processPictureLoading];
    } else {
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        self.contentView = self.imageView;
        // 原图与缩略图的处理暂缓
        if (self.imageView.image != nil) {
            return;
        }
        NSString *urlString = self.picture.source.thumbnailUrlString;
        
        UIImage *image = [self.imageProtocol imageFromMemoryForURL:[NSURL URLWithString:urlString]];
        if (image) {// 若有图片则直接展示
            [self processImageLoadedWithImage:image];
            [self processTagContainerView];
            return;
        }
        if (self.picture.status.loadStatus != DRPICPictureLoadStatusPending) {// 若图片等待加载则进入等待加载状态
            return;
        }
        // 只有图片未加载j并且处于可加载状态才开始图片加载操作
        [self processPictureLoading];
    }
    
}

- (void)processPictureLoading {
    self.picture.status.loadStatus = DRPICPictureLoadStatusLoading;
    [self addSubview:self.loadingView];
    self.loadingView.center = self.center;
    self.loadingView.hidden = NO;
    __weak typeof(self) weakSelf = self;
    [self.imageProtocol loadImageWithURL:[NSURL URLWithString:self.picture.source.thumbnailUrlString] progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
            dispatch_async(dispatch_get_main_queue(), ^{
            
                weakSelf.picture.status.receivedSize = receivedSize;
                weakSelf.picture.status.expectedSize = expectedSize;
                
                NSString *received = [NSString stringWithFormat:@"%ld",receivedSize];
                double progress = received.doubleValue/expectedSize;
                
                weakSelf.loadingView.progress = progress;
            
            });
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (image == nil) {
            return ;
        }
        
        if ([self.picture.source.thumbnailUrlString hasSuffix:@".gif"]) {
            [weakSelf processImageDataLoadedWithImage:data];
            [weakSelf processTagContainerView];
            weakSelf.loadingView.hidden = YES;
        }else {
            [weakSelf processImageLoadedWithImage:image];
            [weakSelf processTagContainerView];
            weakSelf.loadingView.hidden = YES;
        }
    }];
}

- (void)processImageDataLoadedWithImage:(NSData *)imageData {
    self.scrollView.scrollEnabled = YES;
    [self.scrollView setZoomScale:1.0 animated:NO];
    FLAnimatedImage *animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:imageData];
    self.animatedImageView.animatedImage = animatedImage;
    self.picture.status.loadStatus = DRPICPictureLoadStatusFinished;
    self.picture.source.showImage = [UIImage imageWithData:imageData];
    [self processPictureFrame];

}

- (void)processImageLoadedWithImage:(UIImage *)image {
    self.scrollView.scrollEnabled = YES;
    [self.scrollView setZoomScale:1.0 animated:NO];
    self.imageView.image = image;
    self.picture.status.loadStatus = DRPICPictureLoadStatusFinished;
    self.picture.source.showImage = image;
    [self processPictureFrame];

}

- (void)processTagContainerView {
    if (self.isShowTagsFinished == YES || self.isShowTagsReady == NO) {
        return;
    }
    self.showTagsFinished = YES;
    self.picture.status.imageViewSize = self.contentView.frame.size;
    
    [self.scrollView addSubview:self.tagContainerView];
    self.tagContainerView.frame = self.contentView.frame;
    self.tagContainerView.tags = self.picture.tags;
    
    [self.tagContainerView processLoadTag];
}
#pragma mark 重新布局
- (void)processResetFrame {
    self.scrollView.frame = self.bounds;
    if (self.picture) {
        [self processPictureFrame];
    }
}
#pragma mark 调整frame
- (void)processPictureFrame {
    CGSize imageSize = (CGSize){0.,0.};
    if (self.picture.source.extension == DRPICPictureExtensionGIF) {
        imageSize = self.picture.source.showImage.size;
        
    } else {
        imageSize = self.imageView.image.size;
    }
    CGRect frame = self.scrollView.frame;
    CGRect imageF = (CGRect){{0, 0}, imageSize};
    
    // 图片的宽度 = 屏幕的宽度
    CGFloat ratio = frame.size.width / imageF.size.width;
    imageF.size.width  = frame.size.width;
    imageF.size.height = ratio * imageF.size.height;
    
    // 默认情况下，显示出的图片的宽度 = 屏幕的宽度
    // 如果kIsFullWidthForLandSpace = NO，需要把图片全部显示在屏幕上
    // 此时由于图片的宽度已经等于屏幕的宽度，所以只需判断图片显示的高度>屏幕高度时，将图片的高度缩小到屏幕的高度即可
    
    // 设置图片的frame
    self.contentView.frame = imageF;
    self.scrollView.contentSize = self.contentView.frame.size;
    if (imageF.size.height <= self.scrollView.bounds.size.height) {
        self.contentView.center = CGPointMake(self.scrollView.bounds.size.width * 0.5, self.scrollView.bounds.size.height * 0.5);
    } else {
        self.contentView.center = CGPointMake(self.scrollView.bounds.size.width * 0.5, imageF.size.height * 0.5);
    }
    // 根据图片大小找到最大缩放等级，保证最大缩放时候，不会有黑边
    CGFloat maxScale = frame.size.height / imageF.size.height;

    maxScale = frame.size.width / imageF.size.width > maxScale ? frame.size.width / imageF.size.width : maxScale;
    // 超过了设置的最大的才算数
    maxScale = maxScale > self.maxZoomScale ? maxScale : self.maxZoomScale;
    
    if (maxScale < 2) {
        maxScale = 2;
    }
    
    // 初始化
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = maxScale;
    self.picture.status.maximumZoomScale = maxScale;
}


#pragma mark - Private Methods
- (void)initialize {
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.imageView.backgroundColor = [UIColor clearColor];
    
}

#pragma mark - Event Methods
- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.picture.status.offset = scrollView.contentOffset;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    [self.tagContainerView eventTagHidden:YES animation:NO];
    [self.tagContainerView eventTagRelocate];
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    self.contentView.center = [self centerOfScrollViewContent:scrollView];
    self.picture.status.zoomScale = scrollView.zoomScale;
    self.tagContainerView.zoomScale = scrollView.zoomScale;
    self.tagContainerView.ct_size = CGSizeMake(self.picture.status.imageViewSize.width * scrollView.zoomScale, self.picture.status.imageViewSize.height * scrollView.zoomScale);
    self.tagContainerView.center = self.imageView.center;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    !self.zoomEnded ? : self.zoomEnded(self, scrollView.zoomScale);
    self.tagContainerView.zoomScale = scrollView.zoomScale;
    self.tagContainerView.ct_size = CGSizeMake(self.picture.status.imageViewSize.width * scrollView.zoomScale, self.picture.status.imageViewSize.height * scrollView.zoomScale);
    self.tagContainerView.center = self.contentView.center;
    [self.tagContainerView eventTagHidden:NO animation:YES];
    [self.tagContainerView eventTagRelocate];
}

- (void)cancelCurrentImageLoad {
    [self.imageView sd_cancelCurrentImageLoad];
}

- (void)dealloc {
    [self cancelCurrentImageLoad];
}

+ (BOOL)isLongImage:(UIImage *)image {
    
    if (image) {
        
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        CGFloat newScal = 1.0f;
        if (width > 0 && height > 0) {
            
            newScal = width / height;
        }
        if (newScal < 0.37f) {
            return YES;
        }
        
    }
    
    
    return NO;
    
}

#pragma mark - Setter And Getter Methods
- (void)setPicture:(DRPICPicture *)picture {
    _picture = picture;
    
}

- (void)setShowTagsReady:(BOOL)showTagsReady {
    _showTagsReady = showTagsReady;
    if (showTagsReady == YES) {
        [self processTagContainerView];
    }
}

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
        scrollView.delegate = self;
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
        loadingView.frame = CGRectMake(0, 0, 40, 40);
        loadingView.hidden = YES;
        _loadingView = loadingView;
    }
    return _loadingView;
}


@end
