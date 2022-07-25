//
//  DRPICTagContainerView.m
//  Renren-Picture
//
//  Created by 陈金铭 on 2019/9/27.
//

#import "DRPICTagContainerView.h"

#import "DRPICTagView.h"
#import "UIView+CTLayout.h"

@interface DRPICTagContainerView ()

@end

@implementation DRPICTagContainerView

#pragma mark - Override Methods
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.zoomScale = 1.0f;
        
    }
    return self;
}

#pragma mark - Intial Methods

#pragma mark - Event Methods

#pragma mark - Public Methods
- (void)processLoadTag {
    for (DRPICTagView *tagView in self.tagViews) {
        if (tagView.loaded == NO) {
            tagView.loaded = YES;
            [UIView animateWithDuration:0.25
                                  delay:0
                 usingSpringWithDamping:0.7
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 tagView.alpha = 1;
                             }
                             completion:^(BOOL finished) {
                                 [self processLoadTag];
                             }];
            return;
        }
    }
}

- (void)processAddTag:(DRPICPictureTag *)tag {
    [self.tags addObject:tag];
    DRPICTagView *tagView = [self createTagViewWith:tag];
    [self addSubview:tagView];
    [self.tagViews addObject:tagView];
}

- (void)eventTagHidden:(BOOL)tagHidden animation:(BOOL)animation{
    for (DRPICTagView *tagView in self.tagViews) {
           if (animation == YES) {
               [UIView animateWithDuration:0.25
                                     delay:0
                    usingSpringWithDamping:0.7
                     initialSpringVelocity:0
                                   options:UIViewAnimationOptionCurveEaseInOut
                                animations:^{
                                    tagView.alpha = !tagHidden;
                                }
                                completion:^(BOOL finished) {
                   tagView.alpha = !tagHidden;
                                }];
           } else {
               tagView.alpha = !tagHidden;
           }
       }
}

- (void)eventTagRelocate {
    for (NSInteger i = 0; i < self.tags.count; i++) {
           DRPICPictureTag *tag = self.tags[i];
           DRPICTagView *tagView = self.tagViews[i];
        
        CGPoint point = CGPointMake(tag.point.x/1000, tag.point.y/1000);
        CGPoint absolutePoint = CGPointMake(point.x * self.ct_size.width/self.zoomScale, point.y * self.ct_size.height/self.zoomScale);
        
       tagView.ct_left = absolutePoint.x * self.zoomScale - tagView.tagPositionImageView.ct_width/2;
       tagView.ct_top = absolutePoint.y * self.zoomScale - tagView.tagPositionImageView.ct_height/2;
       
       if (tag.direction == DRPICPictureTagDirectionLeft) {
           
           tagView.ct_left = absolutePoint.x * self.zoomScale + tagView.tagPositionImageView.ct_width/2 - tagView.ct_width;
           tagView.ct_top = absolutePoint.y * self.zoomScale - tagView.tagPositionImageView.ct_height/2;
           
       }
       }
}

- (void)returnTagEventBlock:(DRPICTagContainerViewTagEventBlock)tagEventBlock {
    self.tagEventBlock = tagEventBlock;
}

- (void)eventTouchUpInsideForTagView:(UITapGestureRecognizer *)tagView {
    if (self.tagEventBlock) {
        self.tagEventBlock((DRPICTagView *)tagView.view);
    }
}


#pragma mark - Private Methods
- (DRPICTagView *)createTagViewWith:(DRPICPictureTag *)tag {
    DRPICTagView *tagView = [[DRPICTagView alloc] initWithPictureTag:tag];
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eventTouchUpInsideForTagView:)];
            singleTap.numberOfTapsRequired = 1;
            [tagView addGestureRecognizer:singleTap];
            tagView.alpha = 1;
    
    
    CGPoint point = CGPointMake(tag.point.x/1000, tag.point.y/1000);
    CGPoint absolutePoint = CGPointMake(point.x * self.ct_size.width/self.zoomScale, point.y * self.ct_size.height/self.zoomScale);
    
    tagView.ct_left = absolutePoint.x * self.zoomScale - tagView.tagPositionImageView.ct_width/2;
    tagView.ct_top = absolutePoint.y * self.zoomScale - tagView.tagPositionImageView.ct_height/2;
    
    if (tag.direction == DRPICPictureTagDirectionLeft) {
        
        tagView.ct_left = absolutePoint.x * self.zoomScale + tagView.tagPositionImageView.ct_width/2 - tagView.ct_width;
        tagView.ct_top = absolutePoint.y * self.zoomScale - tagView.tagPositionImageView.ct_height/2;
        
    }
    
    return tagView;
}

#pragma mark - Setter And Getter Methods
- (void)setZoomScale:(CGFloat)zoomScale {
    _zoomScale = zoomScale;
}

- (void)setTags:(NSMutableArray<DRPICPictureTag *> *)tags {
    _tags = tags;
    if (tags == nil && tags.count < 1) {
        return;
    }
    //先清空
    if (self.tagViews.count > 0) {
        for (DRPICTagView *tagView in self.tagViews) {
            [tagView removeFromSuperview];
        }
        [self.tagViews removeAllObjects];
    }
    //再添加
    for (NSInteger i = 0; i < tags.count; i++) {
        DRPICPictureTag *tag = tags[i];
        DRPICTagView *tagView = [self createTagViewWith:tag];
        
        
        
        [self addSubview:tagView];
        [self.tagViews addObject:tagView];
    }
}

- (NSMutableArray<DRPICTagView *> *)tagViews {
    if (!_tagViews) {
        NSMutableArray<DRPICTagView *> *tagViews = [NSMutableArray<DRPICTagView *> array];
        _tagViews = tagViews;
    }
    return _tagViews;
}
@end
