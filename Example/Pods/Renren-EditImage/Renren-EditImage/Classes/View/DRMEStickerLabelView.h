//
//  DRMEStickerLabelView.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/11/8.
//

#import <UIKit/UIKit.h>
@class DRMEStickerLabelView;
NS_ASSUME_NONNULL_BEGIN

@protocol DRMEStickerLabelViewDelegate <NSObject>

@optional
/// 拖拽文字时的回调
- (void)stickerLabelView:(DRMEStickerLabelView*)stickerLabelView    panGestureRecognizer:(UIPanGestureRecognizer *)gesture;

@end

@interface DRMEStickerLabelView : UIView

@property(nonatomic,weak) id<DRMEStickerLabelViewDelegate> delegate;

@property (nonatomic, strong) UILabel *contentLabel;

- (instancetype)initWithLabelSize:(CGSize)labelSize;

@property(nonatomic,copy) void(^singleTapBlock)(void);
@property(nonatomic,copy) void(^doubleTapBlock)(void);

/** 当点击label时，显示边框，并2s后消失边框 */
- (void)showBorderWhenClicked;
/** 当拖拽label时，显示边框 */
- (void)showBorderWhenDragging;
/** 隐藏边框 */
- (void)hideBorder;
/** 开始倒计时，2秒后，删除边框 */
- (void)startCountDown;

@end

NS_ASSUME_NONNULL_END
