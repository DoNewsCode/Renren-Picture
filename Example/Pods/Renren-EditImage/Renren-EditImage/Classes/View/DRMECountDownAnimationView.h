

#import <UIKit/UIKit.h>

@class DRMECountDownAnimationView;

@protocol DRMECountDownAnimationViewDelegate <NSObject>

@optional
- (void)countDownAnimationStopAnimationView:(DRMECountDownAnimationView *)countDownAnimationView;

@end


@interface DRMECountDownAnimationView : UIView

@property (nonatomic, weak) id<DRMECountDownAnimationViewDelegate> delegate;

- (void)startAnimation;

@end

