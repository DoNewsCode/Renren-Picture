//
//  DRIImageURLPreviewCell.h
//  RenrenOfficial-iOS-Concept
//
//  Created by 张健康 on 2019/6/11.
//  Copyright © 2019 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RenrenScrollView.h"
NS_ASSUME_NONNULL_BEGIN
@class DRIImageURLPreviewView,DRIImageURLPreviewModel,DRIImagePreviewTagsView,DRIProgressView;
@interface DRIImageURLPreviewCell : UICollectionViewCell
@property (nonatomic, copy) void (^imageProgressUpdateBlock)(double progress);
@property (nonatomic, assign)  BOOL need_Scroll;
@property (nonatomic, strong)   DRIImageURLPreviewModel *model;
@property (nonatomic, assign)  BOOL showTag;
@property (nonatomic, strong) DRIImageURLPreviewView *previewView;
@property (nonatomic, copy) void (^singleTapGestureBlock)(void);

- (void)recoverSubviews;

@end

@interface DRIImageURLPreviewView : UIView
@property (nonatomic, strong)   DRIImageURLPreviewModel *model;
@property (nonatomic, assign)  BOOL need_Scroll;
@property (nonatomic, assign)  BOOL showTag;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) DRIImagePreviewTagsView *tagsView;
@property (nonatomic, copy) void (^singleTapGestureBlock)(void);
@property (nonatomic, strong) DRIProgressView *progressView;

@property (nonatomic, copy) void (^imageProgressUpdateBlock)(double progress);
@end
NS_ASSUME_NONNULL_END
