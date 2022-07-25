//
//  DRPICTagContainerView.h
//  Renren-Picture
//
//  Created by 陈金铭 on 2019/9/27.
//  标签容器视图

#import <UIKit/UIKit.h>

#import "DRPICTagView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^DRPICTagContainerViewTagEventBlock)(DRPICTagView *tagView);

@interface DRPICTagContainerView : UIView

/// 缩放比
@property(nonatomic) CGFloat zoomScale;
/// 标签模型
@property(nonatomic, strong) NSMutableArray<DRPICPictureTag *> *tags;

/// 标签视图
@property(nonatomic, strong) NSMutableArray<DRPICTagView *> *tagViews;

@property (nonatomic, copy) DRPICTagContainerViewTagEventBlock tagEventBlock;

- (void)returnTagEventBlock:(DRPICTagContainerViewTagEventBlock)tagEventBlock;

- (void)processLoadTag;

/// 添加标签
/// @param tag 标签模型
- (void)processAddTag:(DRPICPictureTag *)tag;

/// 标签隐藏
/// @param tagHidden 是否隐藏
/// @param animation 动画
- (void)eventTagHidden:(BOOL)tagHidden animation:(BOOL)animation;

/// 标签位置重新定位
- (void)eventTagRelocate;

@end

NS_ASSUME_NONNULL_END
