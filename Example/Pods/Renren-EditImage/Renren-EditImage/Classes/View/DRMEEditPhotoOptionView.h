//
//  DRMEEditPhotoOptionView.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/10/22.
//

#import <UIKit/UIKit.h>
@class DRMEEditPhotoOptionView;
@class DRMEEditOptionModel;

NS_ASSUME_NONNULL_BEGIN

@protocol DRMEEditPhotoOptionViewDelegate <NSObject>

@optional
/// 点击了第一个选项按钮
- (void)editPhotoOptionView:(DRMEEditPhotoOptionView *)editPhotoOptionView
           clickOptionModel:(DRMEEditOptionModel *)optionModel;

@end

@interface DRMEEditPhotoOptionView : UIView


- (instancetype)initWithIsFromChat:(BOOL)isFromChat;

@property(nonatomic,weak) id<DRMEEditPhotoOptionViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
