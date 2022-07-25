//
//  DRMEFilterOptionView.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/3/16.
//

#import <UIKit/UIKit.h>

@class DRMEFilterOptionView;
@class DRFTFilterModel;

NS_ASSUME_NONNULL_BEGIN

@protocol DRMEFilterOptionViewDelegate <NSObject>

@optional

/// 点击了关闭
- (void)filterOptionViewClickCancel;
/// 点击了完成
- (void)filterOptionViewClickSure;
/// 从接口加载滤镜列表成功
- (void)filterLodaSuccess:(NSInteger)filterCount;
/// 点击了某一个滤镜
- (void)filterOptionView:(DRMEFilterOptionView *)filterOptionView
        clickFilterIndex:(NSInteger)index
             filterModel:(DRFTFilterModel *)filterModel;
/// 点击了滤镜上的参数设置按钮
- (void)filterOptionIntensityDidClick;

@end

@interface DRMEFilterOptionView : UIView

@property(nonatomic,weak) id<DRMEFilterOptionViewDelegate> delegate;

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;

@property(nonatomic,weak) UIButton *cancelBtn;
@property(nonatomic,weak) UIButton *sureBtn;


- (void)loadFilterData;

@end

NS_ASSUME_NONNULL_END
