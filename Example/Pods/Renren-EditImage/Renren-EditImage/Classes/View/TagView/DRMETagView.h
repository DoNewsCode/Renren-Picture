//
//  DRMETagView.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/1/2.
//

#import <UIKit/UIKit.h>
@class DRMETagModel;
@class DRMETagView;

NS_ASSUME_NONNULL_BEGIN


@protocol DRMETagViewDelegate <NSObject>

@optional
/// 拖拽文字时的回调
- (void)tagView:(DRMETagView*)tagView panGestureRecognizer:(UIPanGestureRecognizer *)gesture;

@end

@interface DRMETagView : UIView

- (instancetype)initWithPoint:(CGPoint)point
                     tagModel:(DRMETagModel*)tagModel;


@property(nonatomic,strong) UILabel *tagLabel;

@property(nonatomic,weak) id<DRMETagViewDelegate> delegate;

@property(nonatomic,strong,readonly) DRMETagModel *tagModel;

@property (nonatomic, assign) CGFloat zoomScale;

/// 是否是假视图
@property(nonatomic,assign,getter=isFalseView) BOOL falseView;


// 文字朝右布局
- (void)layoutRight;

// 文字朝左布局
- (void)layoutLeft;

/** 这个属性只用在手势判断处 */
@property(nonatomic,strong) NSDictionary *tagDict;


/// 绝对 位置
@property(nonatomic, assign) CGPoint tapAbsolutePosition;
/// 相对 于父视图的 位置
@property(nonatomic, assign) CGPoint tapRelativePosition;

+ (CGPoint)relativePositionForPoint:(CGPoint)point containerSize:(CGSize)size;
+ (CGPoint)absolutePositionForPoint:(CGPoint)point containerSize:(CGSize)size;

/// 转为服务器需要的上传的格式的数据
- (NSMutableDictionary *)getTagData;

@end

NS_ASSUME_NONNULL_END
