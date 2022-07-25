//
//  DRIPhotoPreviewCell.h
//  DRIImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DRIAssetModel,DRIImagePreviewTagsView;
@interface DRIAssetPreviewCell : UICollectionViewCell
@property (nonatomic, strong) DRIAssetModel *model;
@property (nonatomic, copy) void (^singleTapGestureBlock)(void);
- (void)configSubviews;
- (void)photoPreviewCollectionViewDidScroll;
@end


@class DRIAssetModel,DRIProgressView,DRIPhotoPreviewView;
@interface DRIPhotoPreviewCell : DRIAssetPreviewCell

@property (nonatomic, copy) void (^imageProgressUpdateBlock)(double progress);

@property (nonatomic, strong) DRIPhotoPreviewView *previewView;


@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) BOOL allowCrop;
@property (nonatomic, assign) CGRect cropRect;

- (void)recoverSubviews;

@end


@interface DRIPhotoPreviewView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) DRIProgressView *progressView;

@property (nonatomic, assign) BOOL allowCrop;
@property (nonatomic, assign) CGRect cropRect;

@property (nonatomic, strong) DRIAssetModel *model;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) id asset;
@property (nonatomic, strong) DRIImagePreviewTagsView *tagsView;
@property (nonatomic, copy) void (^singleTapGestureBlock)(void);
@property (nonatomic, copy) void (^imageProgressUpdateBlock)(double progress);

@property (nonatomic, assign) int32_t imageRequestID;

- (void)recoverSubviews;
@end


@class AVPlayer, AVPlayerLayer;
@interface DRIVideoPreviewCell : DRIAssetPreviewCell
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UIImage *cover;
@property (nonatomic, strong) NSURL *videoURL;
- (void)pausePlayerAndShowNaviBar;
@end


@interface DRIGifPreviewCell : DRIAssetPreviewCell
@property (strong, nonatomic) DRIPhotoPreviewView *previewView;
@end
