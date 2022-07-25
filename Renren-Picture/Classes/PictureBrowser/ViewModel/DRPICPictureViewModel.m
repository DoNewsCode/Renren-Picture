//
//  DRPICPictureViewModel.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/17.
//

#import "DRPICPictureViewModel.h"

#import "DRPICWebImageProtocol.h"
#import "DRPICWebImageManager.h"
//#import "UIImage+GIF.h"
#import "UIView+CTLayout.h"
#import "UIImage+RenrenPicture.h"
#import "DRPICPictureManager.h"

static Class DRPICImageManagerClass = nil;

@interface DRPICPictureViewModel ()<UIScrollViewDelegate>


@property(nonatomic, strong) id<DRPICWebImageProtocol> imageProtocol;

@end

@implementation DRPICPictureViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        if (!DRPICImageManagerClass) {
            DRPICImageManagerClass = [DRPICWebImageManager class];
        }
        self.imageProtocol = [DRPICImageManagerClass new];
    }
    return self;
}


#pragma mark - Override Methods

-(void)dealloc {
    
}
#pragma mark - Intial Methods
- (instancetype)initWithPictureViewFrame:(CGRect)frame {
    self = [self init];
    if (self) {
        self.pictureView.frame = frame;
    }
    return self;
}

#pragma mark - Create Methods

#pragma mark - Process Methods

- (void)processPictureViewWithPicture:(DRPICPicture *)picture {
    self.picture = picture;
    ///初始化容器
    for (UIView *subView in self.pictureView.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    self.pictureView.imageView = nil;
    self.pictureView.animatedImageView = nil;
    self.pictureView.videoView = nil;
    self.pictureView.tagContainerView = nil;
    self.pictureView.contentView = nil;
    
    /// 根据来源类型进行处理
    if (self.picture.source.type == DRPICPictureSourceTypeWeb) { //网络
        [self processPictureWebSource];
    } else if (self.picture.source.type == DRPICPictureSourceTypeEdited) { //网络
        [self processPictureEditSource];
    } else { //本地
        [self processPictureLocalSource];
    }
    
    /// 标签容器
    if (self.picture.tags && self.picture.tags.count > 0) {
        self.pictureView.tagContainerView.tags = self.picture.tags;
        [self.pictureView.scrollView addSubview:self.pictureView.tagContainerView];
    }
    
}

- (void)processPictureEditSource {
    /// 决定需要展示的Content容器
    __weak typeof(self) weakSelf = self;
    switch (self.picture.source.mediaType) {
        case DRPICPictureMediaTypeImage:// 图片
        {
            if (self.picture.source.mediaSubtypes & DRPICPictureMediaSubtypePhotoGIF) { // GIF图
                [self processPictureLocalGif];
            } else {//普通图片
                [self.pictureView.scrollView addSubview:self.pictureView.imageView];
                self.pictureView.contentView = self.pictureView.imageView;
                self.pictureView.imageView.contentMode = UIViewContentModeScaleAspectFit;
                weakSelf.pictureView.imageView.image = weakSelf.picture.source.editedImage;
                [weakSelf processContentScaleAspectFit];
            }
        }
            break;
        case DRPICPictureMediaTypeVideo:// 视频
            [self processPictureLocalVideo];
            break;
        case DRPICPictureMediaTypeAudio:// 音频
            
            break;
            
        default:
            break;
    }
}

- (void)processPictureWebSource {
    switch (self.picture.source.extension) {
        case DRPICPictureExtensionPNG:
        case DRPICPictureExtensionJPEG:
            [self processPictureWebImage];
            break;
            
        case DRPICPictureExtensionGIF:
            [self processPictureWebGif];
            break;
            
        case DRPICPictureExtensionWEBP:
            
            break;
            
        case DRPICPictureExtensionMPEG4:
            [self processPictureWebVideo];
            break;
        default:
            break;
    }
    
}

- (void)processPictureLocalSource {
    /// 决定需要展示的Content容器
    switch (self.picture.source.mediaType) {
        case DRPICPictureMediaTypeImage:// 图片
        {
            if (self.picture.source.mediaSubtypes & DRPICPictureMediaSubtypePhotoGIF) { // GIF图
                [self processPictureLocalGif];
            } else {//普通图片
                [self processPictureLocalImage];
            }
        }
            break;
        case DRPICPictureMediaTypeVideo:// 视频
            [self processPictureLocalVideo];
            break;
        case DRPICPictureMediaTypeAudio:// 音频
            
            break;
            
        default:
            break;
    }
    
}

/// 处理网络图片类加载
- (void)processPictureWebImage {
    [self.pictureView.scrollView addSubview:self.pictureView.imageView];
    self.pictureView.contentView = self.pictureView.imageView;
    /// 加载展示缩略图
    NSString *thumbnailUrlString = self.picture.source.thumbnailUrlString;
    UIImage *thumbnailImage = [self.imageProtocol imageFromMemoryForURL:[NSURL URLWithString:thumbnailUrlString]];
    if (thumbnailImage) {
        self.pictureView.imageView.image = thumbnailImage;
        self.picture.source.showImage = thumbnailImage;
        self.picture.status.loadStatus = DRPICPictureLoadStatusFinished;
    } else {
        self.picture.status.loadStatus = DRPICPictureLoadStatusLoading;
        [self.pictureView processLoading:YES animated:YES];
        __weak typeof(self) weakSelf = self;
        [self.imageProtocol loadImageWithURL:[NSURL URLWithString:self.picture.source.thumbnailUrlString] progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            weakSelf.picture.status.receivedSize = receivedSize;
            weakSelf.picture.status.expectedSize = expectedSize;
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (weakSelf.picture.status.originLoadStatus != DRPICPictureLoadStatusLoading) {//此逻辑用于规避加载状态展示异常
                [weakSelf.pictureView processLoading:NO animated:YES];
            }
            if (image == nil) {
                weakSelf.picture.status.loadStatus = DRPICPictureLoadStatusFailed;
                return ;
            }
            weakSelf.picture.source.thumbnailImage = image;
            weakSelf.picture.status.loadStatus = DRPICPictureLoadStatusFinished;
            if (weakSelf.picture.source.originImage && weakSelf.picture.source.showImage) {//此逻辑用于阻止在加载了原图后缩略图覆盖原图
                return;
            }
            weakSelf.picture.source.showImage = image;
            weakSelf.pictureView.imageView.image = image;
            [weakSelf processContentSizeWithSize:image.size];
        }];
    }
    ///加载展示原图
    NSString *originUrlString = self.picture.source.thumbnailUrlString;
    if (originUrlString == nil) {
        return;
    }
    UIImage *originImage = [self.imageProtocol imageFromMemoryForURL:[NSURL URLWithString:originUrlString]];
    if (originImage) {
        self.pictureView.imageView.image = originImage;
        self.picture.source.showImage = originImage;
        self.picture.status.originLoadStatus = DRPICPictureLoadStatusFinished;
    } else {
        self.picture.status.originLoadStatus = DRPICPictureLoadStatusLoading;
        [self.pictureView processLoading:YES animated:YES];
        __weak typeof(self) weakSelf = self;
        [self.imageProtocol loadImageWithURL:[NSURL URLWithString:self.picture.source.originUrlString] progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            weakSelf.picture.status.receivedSize = receivedSize;
            weakSelf.picture.status.expectedSize = expectedSize;
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            [weakSelf.pictureView processLoading:NO animated:YES];
            if (image == nil) {
                weakSelf.picture.status.originLoadStatus = DRPICPictureLoadStatusFailed;
                return ;
            }
            weakSelf.picture.source.originImage = image;
            weakSelf.picture.source.showImage = image;
            weakSelf.picture.status.originLoadStatus = DRPICPictureLoadStatusFinished;
            weakSelf.pictureView.imageView.image = image;
            [weakSelf processContentSizeWithSize:image.size];
        }];
    }
    
    [self.pictureView.scrollView addSubview:self.pictureView.tagContainerView];
    
}

/// 处理网络GIF图片类加载
- (void)processPictureWebGif {
    [self.pictureView.scrollView addSubview:self.pictureView.animatedImageView];
    self.pictureView.contentView = self.pictureView.animatedImageView;
    
    /// 加载展示缩略图
    NSString *thumbnailUrlString = self.picture.source.thumbnailUrlString;
    NSData *thumbnailImageData = [self.imageProtocol imageDataFromDiskForURL:[NSURL URLWithString:thumbnailUrlString]];
    if (thumbnailImageData) {
        FLAnimatedImage *animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:thumbnailImageData];
        self.pictureView.animatedImageView.animatedImage = animatedImage;
        self.picture.status.loadStatus = DRPICPictureLoadStatusFinished;
    } else {
        self.picture.status.loadStatus = DRPICPictureLoadStatusLoading;
        [self.pictureView processLoading:YES animated:YES];
        
        __weak typeof(self) weakSelf = self;
        [self.imageProtocol loadImageWithURL:[NSURL URLWithString:self.picture.source.thumbnailUrlString] progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            weakSelf.picture.status.receivedSize = receivedSize;
            weakSelf.picture.status.expectedSize = expectedSize;
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (weakSelf.picture.status.originLoadStatus != DRPICPictureLoadStatusLoading) {//此逻辑用于规避加载状态展示异常
                [weakSelf.pictureView processLoading:NO animated:YES];
            }
            if (data == nil) {
                weakSelf.picture.status.loadStatus = DRPICPictureLoadStatusFailed;
                return ;
            }
            weakSelf.picture.source.thumbnailImage = image;
            weakSelf.picture.status.loadStatus = DRPICPictureLoadStatusFinished;
            if (weakSelf.picture.source.originImage && weakSelf.picture.source.showImage) {//此逻辑用于阻止在加载了原图后缩略图覆盖原图
                return;
            }
            FLAnimatedImage *animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:data];
            weakSelf.pictureView.animatedImageView.animatedImage = animatedImage;
        }];
    }
}

/// 处理网络视频类加载
- (void)processPictureWebVideo {
    [self.pictureView.scrollView addSubview:self.pictureView.videoView];
    self.pictureView.contentView = self.pictureView.videoView;
}

/// 处理本地图片类加载
- (void)processPictureLocalImage {
    [self.pictureView.scrollView addSubview:self.pictureView.imageView];
    self.pictureView.contentView = self.pictureView.imageView;
    self.pictureView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //加载缩略图
    if (self.picture.source.thumbnailImage) {
        self.pictureView.imageView.image = self.picture.source.thumbnailImage;
    }
    
    // 加载原图
    [self.pictureView processLoading:YES animated:YES];
    __weak typeof(self) weakSelf = self;
    [[DRPICPictureManager sharedPictureManager] obtainOrginImageWithAsset:self.picture.source.asset completion:^(NSData * _Nonnull imageData, UIImageOrientation orientation, NSDictionary * _Nonnull info, BOOL isDegraded) {
        UIImage *image = [UIImage imageWithData:imageData];
        weakSelf.pictureView.imageView.image = image;
        [weakSelf processContentScaleAspectFit];
        [weakSelf.pictureView processLoading:NO animated:YES];
    } progress:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
        
    } networkAccessAllowed:YES];
    
}

/// 处理本地GIF图片类加载
- (void)processPictureLocalGif {
    [self.pictureView.scrollView addSubview:self.pictureView.animatedImageView];
    self.pictureView.contentView = self.pictureView.animatedImageView;
    self.pictureView.animatedImageView.contentMode = UIViewContentModeScaleAspectFit;
    //加载缩略图
    if (self.picture.source.thumbnailImage) {
        self.pictureView.animatedImageView.image = self.picture.source.thumbnailImage;
    }
    // 加载原图
    [self.pictureView processLoading:YES animated:YES];
    __weak typeof(self) weakSelf = self;
    
    [[DRPICPictureManager sharedPictureManager] obtainOriginalPhotoDataWithAsset:self.picture.source.asset progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
        
    } completion:^(NSData * _Nonnull data, NSDictionary * _Nonnull info, BOOL isDegraded) {
        
        if (!isDegraded) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.pictureView.animatedImageView.image = [UIImage sd_dri_animatedGIFWithData:data];
                [weakSelf processContentScaleAspectFit];
                [weakSelf.pictureView processLoading:NO animated:YES];
            });
        }
    }];
}

/// 处理本地视频类加载
- (void)processPictureLocalVideo {
    [self.pictureView.scrollView addSubview:self.pictureView.videoView];
    self.pictureView.contentView = self.pictureView.videoView;
    self.pictureView.contentView.contentMode = UIViewContentModeScaleAspectFit;
    //加载缩略图
    if (self.picture.source.thumbnailImage) {
        //            self.pictureView.videoView.image = self.picture.source.thumbnailImage;
    }
    
    // 加载原图
    [self.pictureView processLoading:YES animated:YES];
    __weak typeof(self) weakSelf = self;
    [[DRPICPictureManager sharedPictureManager] obtainVideoWithAsset:self.picture.source.asset progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
        
    } completion:^(AVPlayerItem * _Nonnull playerItem, NSDictionary * _Nonnull info) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf processContentScaleAspectFit];
            weakSelf.pictureView.videoView.player = [AVPlayer playerWithPlayerItem:playerItem];
            weakSelf.pictureView.videoView.playerLayer = [AVPlayerLayer playerLayerWithPlayer:weakSelf.pictureView.videoView.player];
            weakSelf.pictureView.videoView.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
            weakSelf.pictureView.videoView.playerLayer.frame = weakSelf.pictureView.videoView.bounds;
            [weakSelf.pictureView.videoView.layer addSublayer:weakSelf.pictureView.videoView.playerLayer];
            [weakSelf.pictureView.videoView configPlayButton];
        });
    }];
}

- (CGPoint)processCenterOfScrollViewContent:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

- (void)processContentScaleAspectFit {
    // 设置图片的frame
    self.pictureView.contentView.frame = self.pictureView.scrollView.frame;
    self.pictureView.scrollView.contentSize = self.pictureView.contentView.frame.size;
    
    // 初始化
    self.pictureView.scrollView.minimumZoomScale = 1.0;
    self.pictureView.scrollView.maximumZoomScale = 3;
    self.picture.status.maximumZoomScale = 3;
}

- (void)processContentSizeWithSize:(CGSize)size {
    CGSize imageSize = size;
    
    CGRect frame = self.pictureView.scrollView.frame;
    CGRect imageF = (CGRect){{0, 0}, imageSize};
    
    // 图片的宽度 = 屏幕的宽度
    CGFloat ratio = frame.size.width / imageF.size.width;
    imageF.size.width  = frame.size.width;
    imageF.size.height = ratio * imageF.size.height;
    
    // 默认情况下，显示出的图片的宽度 = 屏幕的宽度
    // 如果kIsFullWidthForLandSpace = NO，需要把图片全部显示在屏幕上
    // 此时由于图片的宽度已经等于屏幕的宽度，所以只需判断图片显示的高度>屏幕高度时，将图片的高度缩小到屏幕的高度即可
    
    // 设置图片的frame
    self.pictureView.contentView.frame = imageF;
    self.pictureView.scrollView.contentSize = self.pictureView.contentView.frame.size;
    if (imageF.size.height <= self.pictureView.scrollView.bounds.size.height) {
        self.pictureView.contentView.center = CGPointMake(self.pictureView.scrollView.bounds.size.width * 0.5, self.pictureView.scrollView.bounds.size.height * 0.5);
    } else {
        self.pictureView.contentView.center = CGPointMake(self.pictureView.scrollView.bounds.size.width * 0.5, imageF.size.height * 0.5);
    }
    // 根据图片大小找到最大缩放等级，保证最大缩放时候，不会有黑边
    CGFloat maxScale = frame.size.height / imageF.size.height;
    
    maxScale = frame.size.width / imageF.size.width > maxScale ? frame.size.width / imageF.size.width : maxScale;
    // 超过了设置的最大的才算数
    //     maxScale = maxScale > self.maxZoomScale ? maxScale : self.maxZoomScale;
    // 初始化
    self.pictureView.scrollView.minimumZoomScale = 1.0;
    self.pictureView.scrollView.maximumZoomScale = maxScale;
    self.picture.status.maximumZoomScale = maxScale;
}

#pragma mark - Event Methods

#pragma mark - Public Methods

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.picture.status.offset = scrollView.contentOffset;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.pictureView.contentView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    [self.pictureView.tagContainerView eventTagHidden:YES animation:NO];
    [self.pictureView.tagContainerView eventTagRelocate];
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    self.pictureView.contentView.center = [self processCenterOfScrollViewContent:scrollView];
    self.picture.status.zoomScale = scrollView.zoomScale;
    self.pictureView.tagContainerView.zoomScale = scrollView.zoomScale;
    self.pictureView.tagContainerView.ct_size = CGSizeMake(self.picture.status.imageViewSize.width * scrollView.zoomScale, self.picture.status.imageViewSize.height * scrollView.zoomScale);
    self.pictureView.tagContainerView.center = self.pictureView.imageView.center;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    !self.pictureView.zoomEnded ? : self.pictureView.zoomEnded(self.pictureView, scrollView.zoomScale);
    self.pictureView.tagContainerView.zoomScale = scrollView.zoomScale;
    self.pictureView.tagContainerView.ct_size = CGSizeMake(self.picture.status.imageViewSize.width * scrollView.zoomScale, self.picture.status.imageViewSize.height * scrollView.zoomScale);
    self.pictureView.tagContainerView.center = self.pictureView.contentView.center;
    [self.pictureView.tagContainerView eventTagHidden:NO animation:YES];
    [self.pictureView.tagContainerView eventTagRelocate];
}

#pragma mark - LazyLoad Methods
- (void)setPicture:(DRPICPicture *)picture {
    _picture = picture;
}

- (DRPICPicturePreviewView *)pictureView {
    if (!_pictureView) {
        DRPICPicturePreviewView *pictureView = [DRPICPicturePreviewView new];
        pictureView.scrollView.delegate = self;
        _pictureView = pictureView;
    }
    return _pictureView;
}



@end
