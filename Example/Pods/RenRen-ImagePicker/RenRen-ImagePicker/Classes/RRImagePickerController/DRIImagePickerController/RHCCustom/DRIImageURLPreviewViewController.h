//
//  DRIImageURLPreviewViewController.h
//  RenrenOfficial-iOS-Concept
//
//  Created by 张健康 on 2019/6/11.
//  Copyright © 2019 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRIPushAnimationViewController.h"
#import "DRIImageURLPreviewModel.h"
#import "DRITagView.h"
NS_ASSUME_NONNULL_BEGIN
@interface DRIImageURLPreviewViewController : DRIPushAnimationViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>{
    UICollectionView *_collectionView;
}

@property (nonatomic,strong) NSArray <DRIImageURLPreviewModel *>*imageModelArray;

@property (nonatomic, copy) NSString *rightBarButtonTitle;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) BOOL showTag;

@property (nonatomic, assign) BOOL navBarHidden;

@property (nonatomic, assign) BOOL toolBarHidden;

@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) UIButton *tagPhotoButton;

- (void)backButtonClick;

- (void)doneButtonClick;

- (void)addTags:(NSArray *)tags toIndex:(NSInteger)index;

- (void)deleteTag:(NSMutableDictionary *)tag toIndex:(NSInteger)index;

- (void)showTagsViewWithTags:(NSArray *)tags;

/**
 开启标签编辑模式
 弹出标签编辑页面
 @param on true开启/false关闭
 */
- (void)editTagsMode:(BOOL)on;

/**
 继承方法，每当添加标签后调用

 @param tag 标签字典
 */
- (void)addTagAction:(NSDictionary *)tag;

/**
 继承方法，每当删除标签后调用

 @param tag 标签字典
 */
- (void)deleteTagAction:(NSDictionary *)tag;

/**
 继承方法，滚动到新的index后调用
 
 @param index 新的index
 */
- (void)scrollToIndex:(NSInteger)index;

/**
 继承方法，tagView关闭时调用

 @param okAction 是否是确定关闭，YES是确定，NO是取消/返回
 */
- (void)tagsViewDidDismiss:(BOOL)okAction;

/**
继承方法，cell上的图片加载完成时调用

@param index 图片的index
*/
- (void)didFinishLoadImage:(NSInteger)index;


- (void)reloadData;


- (void)didTapPreviewCell;

- (BOOL)tagsViewShouldAddDeleteButton:(DRITagView *)tagView;
@end

NS_ASSUME_NONNULL_END
