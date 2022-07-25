//
//  DRMEEditVideoOptionView.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/10/22.
//

#import <UIKit/UIKit.h>
@class DRMEEditVideoOptionView;
@class DRMEEditOptionModel;

NS_ASSUME_NONNULL_BEGIN

@protocol DRMEEditVideoOptionViewDelegate <NSObject>

@optional
/// 点击了第一个选项按钮
- (void)editPhotoOptionView:(DRMEEditVideoOptionView *)editPhotoOptionView
           clickOptionModel:(DRMEEditOptionModel *)optionModel;

@end

@interface DRMEEditVideoOptionView : UIView

@property(nonatomic,weak) id<DRMEEditVideoOptionViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
