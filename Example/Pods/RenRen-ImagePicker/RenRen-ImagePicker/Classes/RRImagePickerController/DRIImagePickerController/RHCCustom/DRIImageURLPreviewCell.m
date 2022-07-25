//
//  DRIImageURLPreviewCell.m
//  RenrenOfficial-iOS-Concept
//
//  Created by 张健康 on 2019/6/11.
//  Copyright © 2019 renren. All rights reserved.
//

#import "DRIImageURLPreviewCell.h"
#import <DNCommonKit/UIView+CTLayout.h>
#import <SDWebImage/SDWebImage.h>
#import "SDAutoLayout.h"
#import "DRIImagePreviewTagsView.h"
#import "UIImage+tags.h"
#import "DRIImageURLPreviewModel.h"
#import "UIView+DRIViewController.h"
#import "DRIProgressView.h"
#import "DRITagsScrollView.h"
#import "YYWebImage.h"
#import "YYAnimatedImageView.h"
@interface DRIImageURLPreviewView ()<UIScrollViewDelegate>
@property (nonatomic, copy)   NSString *imageURL;
- (void)recoverSubviews;
@end

@implementation DRIImageURLPreviewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self configSubviews];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoPreviewCollectionViewDidScroll) name:@"photoPreviewCollectionViewDidScroll" object:nil];
    }
    return self;
}

- (void)configSubviews {
    self.previewView = [[DRIImageURLPreviewView alloc] initWithFrame:self.bounds];
//    self.previewView.backgroundColor = [UIColor blueColor];
    [self addSubview:self.previewView];
}

- (void)setModel:(DRIImageURLPreviewModel *)model{
    _model = model;
    self.previewView.model = model;
}

- (void)setShowTag:(BOOL)showTag{
    _showTag = showTag;
    self.previewView.showTag = self.showTag;
}

- (void)setNeed_Scroll:(BOOL)need_Scroll{
    _need_Scroll = need_Scroll;
    self.previewView.need_Scroll = need_Scroll;
}

- (void)setSingleTapGestureBlock:(void (^)(void))singleTapGestureBlock{
    self.previewView.singleTapGestureBlock = singleTapGestureBlock;
}

- (void)setImageProgressUpdateBlock:(void (^)(double))imageProgressUpdateBlock{
    self.previewView.imageProgressUpdateBlock = imageProgressUpdateBlock;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)recoverSubviews{
    [self.previewView recoverSubviews];
}

#pragma mark - Notification

- (void)photoPreviewCollectionViewDidScroll {
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end



@implementation DRIImageURLPreviewView{
    BOOL _isScrolling;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[DRITagsScrollView alloc] init];
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 3.f;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = YES;
        _scrollView.canCancelContentTouches = NO;
        _scrollView.alwaysBounceVertical = NO;
        if (@available(iOS 11, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self addSubview:_scrollView];
        
        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = YES;
        _imageContainerView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:_imageContainerView];
        
        _imageView = [[YYAnimatedImageView alloc] init];
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        [_imageContainerView addSubview:_imageView];
        
        
        _tagsView = [[DRIImagePreviewTagsView alloc] initWithFrame:_imageContainerView.frame];
        _tagsView.zoomScale = self.scrollView.zoomScale;
        [_scrollView addSubview:_tagsView];
        //        [self.imageContainerView bringSubviewToFront:_tagsView];
        self.imageContainerView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [_tagsView addGestureRecognizer:tap];
        _tagsView.hidden = !self.showTag;
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
        
        [self configProgressView];
    }
    return self;
}

- (void)configProgressView {
    _progressView = [[DRIProgressView alloc] init];
    _progressView.hidden = YES;
    [self addSubview:_progressView];
}

- (void)setModel:(DRIImageURLPreviewModel *)model{
    _model = model;
    [self setImageURL:model.urlStr];
}

- (void)setImageURL:(NSString *)imageURL {
    _imageURL = imageURL;
    [_scrollView setZoomScale:1.f animated:NO];
    [_imageView yy_setImageWithURL:[NSURL URLWithString:imageURL] placeholder:self.model.image options:(YYWebImageOptionShowNetworkActivity) progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *received = [NSString stringWithFormat:@"%ld",receivedSize];
            double progress = received.doubleValue/expectedSize;
            progress = progress > 0.02 ? progress : 0.02;
            self.progressView.progress = progress;
            if (progress >= 1) {
                self.progressView.hidden = YES;
            } else {
                if (self.imageProgressUpdateBlock)
                    self.imageProgressUpdateBlock(progress);
                self.progressView.hidden = NO;
            }
        });
    } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        return image;
    } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
        }
        [self resizeSubviews];
        
        
        self.progressView.hidden = YES;
        image.tagsArray = [NSMutableArray arrayWithArray:self.model.image.tagsArray];
        self.model.image = image;
        CGFloat aspectRatio = image.size.width / (CGFloat)image.size.height;
        // 优化超宽图片的显示
        //        if (aspectRatio > 1.5) {
        //            self.scrollView.maximumZoomScale *= aspectRatio / 4.f;
        //        }
        if (self.imageProgressUpdateBlock) {
            self.imageProgressUpdateBlock(1);
        }
    }];
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:self.model.image options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            double progress = receivedSize/expectedSize;
//            progress = progress > 0.02 ? progress : 0.02;
//            self.progressView.progress = progress;
//            if (progress >= 1) {
//                self.progressView.hidden = YES;
//            } else {
//                self.progressView.hidden = NO;
//            }
//        });
//    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        if (error) {
//            NSLog(@"%@",error);
//        }
//        [self resizeSubviews];
//
//
//        self.progressView.hidden = YES;
//        image.tagsArray = [NSMutableArray arrayWithArray:self.model.image.tagsArray];
//        self.model.image = image;
//        CGFloat aspectRatio = image.size.width / (CGFloat)image.size.height;
//        // 优化超宽图片的显示
////        if (aspectRatio > 1.5) {
////            self.scrollView.maximumZoomScale *= aspectRatio / 4.f;
////        }
//        //                             if (self.imageProgressUpdateBlock) {
//        //                                 self.imageProgressUpdateBlock(1);
//        //                                 self.imageProgressUpdateBlock = nil;
//        //                             }
//    }];
    [self configMaximumZoomScale];
}

- (void)recoverSubviews {
    [self resizeSubviews];
}

- (void)resizeSubviews {
    _scrollView.zoomScale = 1.f;
//    _imageContainerView.origin = CGPointZero;
//    _imageContainerView.height = self.scrollView.height;
    
    UIImage *image = _imageView.image;
    _imageContainerView.width = self.scrollView.width;
    if (image.size.width != 0) {
        _imageContainerView.height = image.size.height / image.size.width * _imageContainerView.width;
    }
    
//
//    if (image.size.height / image.size.width > self.height / self.scrollView.width) {
//        _imageContainerView.width = floor(image.size.width / (image.size.height / self.scrollView.height));
//    } else {
//        CGFloat height = image.size.height / image.size.width * self.scrollView.width;
//        if (height < 1 || isnan(height)) height = self.height;
//        height = floor(height);
//        _imageContainerView.height = height;
//        _imageContainerView.width = self.scrollView.width;
//        _imageContainerView.centerY = self.height / 2;
//    }
//    if (_imageContainerView.height > self.height) {
//        _imageContainerView.height = self.height;
//    }
    
    NSLog(@"_imageContainerView = %@",_imageContainerView);
    CGFloat contentSizeH = MAX(_imageContainerView.height, self.height);
    _scrollView.contentSize = CGSizeMake(self.scrollView.width, _imageContainerView.height);
    //    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.height <= self.height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
    _tagsView.frame = _imageContainerView.frame;
//    [self refreshImageContainerViewCenter];
    
    UIImage *dataImage = self.model.image;
    [_tagsView deleteAllTagView];
    if (dataImage.tagsArray) {
        self.imageContainerView.userInteractionEnabled = YES;
        [_tagsView addNewTagWithTagsArray:dataImage.tagsArray];
    }else{
        self.imageContainerView.userInteractionEnabled = NO;
    }
    
    static CGFloat progressWH = 40;
    CGFloat progressX = (self.width - progressWH) / 2;
    CGFloat progressY = (self.height - progressWH) / 2;
    _progressView.frame = CGRectMake(progressX, progressY, progressWH, progressWH);
    
    
    CGFloat scale = self.width/self.imageContainerView.width;
//    _imageContainerView.origin = CGPointMake(0, fabsf((_imageContainerView.height - _scrollView.height)) / 2);
    self.imageContainerView.frame = CGRectMake(0, 0, _imageContainerView.width, _imageContainerView.height);
    
    [self refreshImageContainerViewCenter];

    [self->_scrollView scrollRectToVisible:self.bounds animated:YES];
//    [self->_scrollView setZoomScale:scale animated:NO];
//    if (_imageContainerView.height < _scrollView.height){
//        [self->_scrollView setContentOffset:CGPointMake(0, (_imageContainerView.height - _scrollView.height) / 2)  animated:NO];
//    }
//    if (_need_Scroll) {
//        [self->_scrollView setContentOffset:CGPointMake(0, (_imageContainerView.height - _scrollView.height) / 2)  animated:NO];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (!_isScrolling && _imageContainerView.height > _scrollView.height) {
//                [self->_scrollView scrollRectToVisible:CGRectMake(0, 0, self->_scrollView.width, self->_scrollView.height) animated:YES];
//            }
//            _need_Scroll = NO;
//        });
//    }
}

- (void)configMaximumZoomScale {
    _scrollView.maximumZoomScale = 3.f;
}

- (void)setShowTag:(BOOL)showTag{
    _showTag = showTag;
//    [self layoutSubviews];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(0, 0, self.width, self.height);
    
    [self recoverSubviews];
}

#pragma mark - UITapGestureRecognizer Event

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        _scrollView.contentInset = UIEdgeInsetsZero;
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self refreshImageContainerViewCenter];
    self.tagsView.zoomScale = scrollView.zoomScale;
//    self.tagsView.frame = CGRectMake(self.imageContainerView.frame.origin.x, self.imageContainerView.frame.origin.y, self.imageContainerView.frame.size.width, self.imageContainerView.frame.size.height);
//    _tagsView.frame = self.imageContainerView.bounds;
//    _tagsView.zoomScale = scrollView.zoomScale;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

        [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.3];

        //NSLog(@"滑动中");

        _isScrolling = YES ;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{

    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    //NSLog(@"滑动停止（animation）");

    _isScrolling = NO ;

}
#pragma mark - Private

- (void)refreshImageContainerViewCenter {
    CGFloat offsetX = (_scrollView.width > _scrollView.contentSize.width) ? ((_scrollView.width - _scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_scrollView.height > _scrollView.contentSize.height) ? ((_scrollView.height - _scrollView.contentSize.height) * 0.5) : 0.0;
    self.imageContainerView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
    self.tagsView.frame = self.imageContainerView.frame;
}

- (void)resetZoomScale:(CGFloat)zoomScale{
    [self.scrollView setZoomScale:zoomScale animated:NO];
}
@end
