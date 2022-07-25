//
//  DRMEFilterIntensityView.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/3/16.
//

#import <UIKit/UIKit.h>

@class DRMEFilterIntensityView;

NS_ASSUME_NONNULL_BEGIN

@protocol DRMEFilterIntensityViewDelegate <NSObject>

@optional
/// 滑动滑杆时的实时范围
- (void)filterSliderValueDidChanged:(CGFloat)value;

/// 滑杆视图动画消失完成
- (void)filterSliderHideComplete:(DRMEFilterIntensityView *)filterIntensityView;

@end

@interface DRMEFilterIntensityView : UIView

@property(nonatomic,weak) id<DRMEFilterIntensityViewDelegate> delegate;

@property(nonatomic,copy) NSString *filterName;
@property(nonatomic,assign) CGFloat currentIntensity;
@property(nonatomic,weak) UISlider *slider;

@end

NS_ASSUME_NONNULL_END
