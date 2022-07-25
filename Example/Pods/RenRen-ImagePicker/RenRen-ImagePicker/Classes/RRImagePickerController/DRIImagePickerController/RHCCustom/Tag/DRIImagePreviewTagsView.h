//
//  DRIImagePreviewTagsView.h
//  RenrenOfficial-iOS-Concept
//
//  Created by 张健康 on 2019/3/18.
//  Copyright © 2019 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class DRITagView;

@protocol DRIImagePreviewTagsViewDelegate <NSObject>

- (void)tagsViewDidAddNewTag:(NSDictionary *)tag;

- (void)tagsViewDidDeleteNewTag:(NSDictionary *)tag;

- (BOOL)tagsViewShouldAddDeleteButton:(DRITagView *)tagView;

- (void)tagsViewDidMoveTag:(DRITagView *)tagView;

- (void)tagsViewDidEndMoveTag:(DRITagView *)tagView;

@end

@interface DRIImagePreviewTagsView : UIView
@property (nonatomic, weak  ) id <DRIImagePreviewTagsViewDelegate> delegate;
@property (nonatomic, assign) BOOL animate;
@property (nonatomic, strong) NSMutableArray *tagViews;
@property (nonatomic, copy) void(^addTag)(CGPoint tagPoint);
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, assign) CGFloat zoomScale;
@property (nonatomic, strong) DRITagView *currentTagView;
@property (nonatomic, assign) BOOL canMove;
- (void)refreshAllTagsView;
- (NSMutableArray *)getAllTagsDic;
- (void)showPointView:(CGPoint)point;
- (void)hidePointView;
- (void)addNewTag:(CGPoint)point text:(NSString *)text;
- (void)addNewTagWithDict:(NSDictionary *)dict;
- (void)addNewTagWithTagsArray:(NSArray <NSDictionary *>*)array;
- (void)deleteTagView:(DRITagView *)tagView;
- (void)deleteAllTagView;
@end

NS_ASSUME_NONNULL_END
