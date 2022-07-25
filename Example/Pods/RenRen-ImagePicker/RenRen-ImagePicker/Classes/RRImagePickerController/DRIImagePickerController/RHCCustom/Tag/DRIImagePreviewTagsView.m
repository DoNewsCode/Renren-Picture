//
//  DRIImagePreviewTagsView.m
//  RenrenOfficial-iOS-Concept
//
//  Created by 张健康 on 2019/3/18.
//  Copyright © 2019 renren. All rights reserved.
//

#import "DRIImagePreviewTagsView.h"
#import "DRIImagePickerController.h"
#import "SDAutoLayout.h"
#import "UIView+DRIViewController.h"
#import "DRITagView.h"
#import <DNCommonKit/DNBaseMacro.h>
#import <DNCommonKit/UIColor+CTHex.h>
#import "UIView+DRIViewController.h"
@interface DRIImagePreviewTagsView(){
    CGFloat _zoomScale;
}

@property (nonatomic, strong) UIImageView *tagPointView;

@end
@implementation DRIImagePreviewTagsView
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    self.animate = YES;
    self.backgroundColor = [UIColor clearColor];
    [self addGesture];
    [self addSubview:self.deleteButton];
    [self addSubview:self.tagPointView];
}

- (void)addGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTag:)];
    tap.delegate = self;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

- (void)addTag:(UITapGestureRecognizer *)tap{
    if (!self.deleteButton.hidden) {
        self.currentTagView = nil;
        [self.deleteButton setHidden:YES];
        return;
    }
    CGPoint point = [tap locationInView:self];
    if (self.addTag) {
        self.addTag(point);
    }
}

- (void)showPointView:(CGPoint)point{
    self.tagPointView.hidden = NO;
    self.tagPointView.center = point;
}
- (void)hidePointView{
    self.tagPointView.hidden = YES;
}

- (void)refreshAllTagsView{
    if (!_animate) {
        return;
    }
    [self.tagViews enumerateObjectsUsingBlock:^(DRITagView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.zoomScale = self.zoomScale;
    }];
}
- (void)addNewTag:(CGPoint)point text:(NSString *)text{
    DRITagView *tagView = [[DRITagView alloc] initWithPoint:point direction:(point.x>(self.width/2))?DRITagViewDirectionLeft:DRITagViewDirectionRight];
    tagView.zoomScale = self.zoomScale;
    tagView.canMove = self.canMove;
    tagView.tapAbsolutePosition = CGPointMake(point.x/self.zoomScale, point.y/self.zoomScale);
    tagView.tapRelativePosition = [DRITagView relativePositionForPoint:point containerSize:self.size];
    tagView.title = text;
    @weakify(self)
    tagView.clickBlock = ^(DRITagView * _Nonnull tagView) {
        [weak_self addDeleteButton:tagView];
    };
    tagView.tagViewMovedBlock = ^(DRITagView * _Nonnull tagView, CGRect currentRect) {
        if (!weak_self.deleteButton.hidden) {
            weak_self.deleteButton.hidden = YES;
        }
        
        CGPoint convertPt = [weak_self convertPoint:tagView.pointView.center fromView:tagView];
        
        NSLog(@"%@",NSStringFromCGPoint(convertPt));
//        tagView.tapRelativePosition = [DRITagView relativePositionForPoint:convertPt containerSize:self.size ];
        if ([weak_self.delegate respondsToSelector:@selector(tagsViewDidMoveTag:)]) {
            [weak_self.delegate tagsViewDidMoveTag:tagView];
        }
    };
    tagView.tagViewMoveEndBlock = ^(DRITagView * _Nonnull tagView, CGSize offset) {
        [tagView setNeedsLayout];
        if ([weak_self.delegate respondsToSelector:@selector(tagsViewDidEndMoveTag:)]) {
            [weak_self.delegate tagsViewDidEndMoveTag:tagView];
        }
//        if (!weak_self.deleteButton.hidden) {
//            weak_self.deleteButton.hidden = YES;
//        }
//
        [tagView movedSuccess:offset];
//        tagView.tapRelativePosition = [DRITagView relativePositionForPoint:convertPt containerSize:self.size ];
//        [tagView setNeedsLayout];
    };
    
    [self addSubview:tagView];
    [self.tagViews addObject:tagView];
    [tagView layoutSubviews];
    if ([self.delegate respondsToSelector:@selector(tagsViewDidAddNewTag:)]) {
        [self.delegate tagsViewDidAddNewTag:[tagView getTagData]];
    }
}

- (void)addDeleteButton:(DRITagView *)tagView{
    if (self.currentTagView && !self.deleteButton.hidden) {
        self.deleteButton.hidden = YES;
        self.currentTagView = nil;
        return;
    }
    BOOL should = NO;
    if ([self.delegate respondsToSelector:@selector(tagsViewShouldAddDeleteButton:)]) {
        should = [self.delegate tagsViewShouldAddDeleteButton:tagView];
    }
    if (!should) {
        return;
    }
    self.currentTagView = tagView;
    CGRect deleteButtonFrame = CGRectMake(tagView.frame.origin.x, tagView.frame.origin.y, tagView.width, tagView.height);
//    self.deleteButton.center = deleteButtonFrame.center;
    self.deleteButton.frame = CGRectMake(deleteButtonFrame.origin.x + 10, deleteButtonFrame.origin.y + tagView.height * 1.5, self.deleteButton.width, self.deleteButton.height);
    self.deleteButton.hidden = NO;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 18)];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor ct_colorWithHex:0x3580F9] forState:UIControlStateNormal];
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _deleteButton.backgroundColor = [UIColor whiteColor];
        _deleteButton.layer.masksToBounds = YES;
        _deleteButton.layer.cornerRadius = 9;
        _deleteButton.hidden = YES;
        [_deleteButton addTarget:self action:@selector(deleteButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (NSMutableArray *)tagViews{
    if (!_tagViews) {
        _tagViews = [[NSMutableArray alloc] init];
    }
    return _tagViews;
}

- (void)deleteButtonDidClick:(id)sender{
    [self deleteTagView:self.currentTagView];
}

- (void)deleteTagView:(DRITagView *)tagView{
    if (tagView.tagData[@"tagID"]) {
        return;
    }
    [tagView removeFromSuperview];
    if ([self.tagViews containsObject:tagView]) {
        [self.tagViews removeObject:tagView];
    }
    NSMutableDictionary *dic = [tagView getTagData];
    tagView = nil;
    if ([self.delegate respondsToSelector:@selector(tagsViewDidDeleteNewTag:)]) {
        [self.delegate tagsViewDidDeleteNewTag:dic];
    }
    self.deleteButton.hidden = YES;
}

- (void)deleteAllTagView{
    [self.tagViews enumerateObjectsUsingBlock:^(DRITagView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[DRITagView class]]) {
            [obj removeFromSuperview];
        }
    }];
    [self.tagViews removeAllObjects];
}

- (void)addNewTagWithTagsArray:(NSArray<NSDictionary *> *)array{
    for (NSDictionary *dict in array) {
        [self addNewTagWithDict:dict];
    }
}

- (DRITagView *)addNewTagWithDict:(NSMutableDictionary *)dict{
    
    NSNumber *x = dict[@"center_left_to_photo"];
    NSNumber *y = dict[@"center_top_to_photo"];
    
    DRITagViewDirection direction = ((NSNumber *)dict[@"tagDirections"]).integerValue;
    CGPoint point = CGPointMake(x.floatValue/1000, y.floatValue/1000);
    CGPoint absolutePoint = [DRITagView absolutePositionForPoint:point containerSize:self.size];
    DRITagView *tagView = [[DRITagView alloc] initWithPoint:absolutePoint direction:direction];
    tagView.canMove = self.canMove;
    tagView.tapRelativePosition = [DRITagView relativePositionForPoint:absolutePoint containerSize:self.size ];
    tagView.title = dict[@"target_name"];
    tagView.tagData = dict;
    tagView.zoomScale = self.zoomScale;
    @weakify(self)
    tagView.clickBlock = ^(DRITagView * _Nonnull tagView) {
        [weak_self addDeleteButton:tagView];
    };
    tagView.tagViewMovedBlock = ^(DRITagView * _Nonnull tagView, CGRect currentRect) {
        if (!weak_self.deleteButton.hidden) {
            weak_self.deleteButton.hidden = YES;
        }
        
        CGPoint convertPt = [weak_self convertPoint:tagView.pointView.center fromView:tagView];
        NSLog(@"%@",NSStringFromCGPoint(convertPt));
        if ([weak_self.delegate respondsToSelector:@selector(tagsViewDidMoveTag:)]) {
            [weak_self.delegate tagsViewDidMoveTag:tagView];
        }
        //        tagView.tapRelativePosition = [DRITagView relativePositionForPoint:convertPt containerSize:self.size ];
    };
    tagView.tagViewMoveEndBlock = ^(DRITagView * _Nonnull tagView, CGSize offset) {
        [tagView setNeedsLayout];
        //        if (!weak_self.deleteButton.hidden) {
        //            weak_self.deleteButton.hidden = YES;
        //        }
        //
        [tagView movedSuccess:offset];
        //        tagView.tapRelativePosition = [DRITagView relativePositionForPoint:convertPt containerSize:self.size ];
        //        [tagView setNeedsLayout];
        if ([weak_self.delegate respondsToSelector:@selector(tagsViewDidEndMoveTag:)]) {
            [weak_self.delegate tagsViewDidEndMoveTag:tagView];
        }
    };
    [self addSubview:tagView];
    [self.tagViews addObject:tagView];
    return tagView;
}

- (NSMutableArray *)getAllTagsDic{
    NSMutableArray *tagData = [NSMutableArray array];
    for (DRITagView *tagView in self.tagViews) {
        [tagData addObject:[tagView getTagData]];
    }
    return tagData;
}

- (UIImageView *)tagPointView{
    if (!_tagPointView) {
        _tagPointView = [[UIImageView alloc] initWithImage:[UIImage dri_imageNamedFromMyBundle:@"Publish_image_tag_point"]];
        [_tagPointView sizeToFit];
        _tagPointView.hidden = YES;
    }
    return _tagPointView;
}

- (id)copy{
    NSData *tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

- (CGFloat)zoomScale{
    if (_zoomScale == 0.f) {
        return 1.f;
    }
    return _zoomScale;
}
- (void)setZoomScale:(CGFloat)zoomScale{
    _zoomScale = zoomScale;
    [self refreshAllTagsView];
}

@end
