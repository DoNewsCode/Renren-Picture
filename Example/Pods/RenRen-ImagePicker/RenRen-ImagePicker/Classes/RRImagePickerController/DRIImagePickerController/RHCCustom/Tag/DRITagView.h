//
//  DRITagView.h
//  RenrenOfficial-iOS-Concept
//
//  Created by 张健康 on 2019/3/18.
//  Copyright © 2019 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    DRITagViewDirectionRight = 0,
    DRITagViewDirectionLeft = 1,
} DRITagViewDirection;

@interface DRITagView : UIView
@property (nonatomic, assign) BOOL canMove;
@property (nonatomic, strong) NSMutableDictionary *tagData;
@property (nonatomic, assign) CGFloat zoomScale;
@property (nonatomic, assign) DRITagViewDirection direction;
@property (nonatomic, copy) NSString *title;
@property(nonatomic, assign) CGPoint tapAbsolutePosition;
@property(nonatomic, assign) CGPoint tapRelativePosition;
@property (nonatomic, copy) void(^clickBlock)(DRITagView *tagView);
@property (nonatomic, copy) void(^tagViewMovedBlock)(DRITagView *tagView,CGRect currentRect);
@property (nonatomic, copy) void(^tagViewMoveEndBlock)(DRITagView *tagView, CGSize offset);

/// 标记的顶点
@property (nonatomic, strong) UIImageView *pointView;

/// 显示文字的背景图
@property (nonatomic, strong) UIImageView *imageView;

/// 显示文字
@property (nonatomic, strong) UILabel *titleLabel;
/**
 显示的横线
 */
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) CGRect originFrame;
@property (assign, nonatomic) CGRect beganRect;


- (instancetype)initWithPoint:(CGPoint)point
                    direction:(DRITagViewDirection)direction;

+ (CGPoint)relativePositionForPoint:(CGPoint)point containerSize:(CGSize)size;
+ (CGPoint)absolutePositionForPoint:(CGPoint)point containerSize:(CGSize)size;

- (void)cancelMoved;
- (void)movedSuccess:(CGSize)offset;
- (NSMutableDictionary *)getTagData;
@end

NS_ASSUME_NONNULL_END
