//
//  DRPICPicturePreviewLevitateView.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/20.
//

#import <UIKit/UIKit.h>

#import "DRPICPicturePreviewEditButton.h"
#import "DRPICPicturePickerNextStepButton.h"
#import "DRPICPicturePickerPickingOriginalButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRPICPicturePreviewLevitateView : UIView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIBlurEffect *blurEffect;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) DRPICPicturePreviewEditButton *editButton;
@property (nonatomic, strong) DRPICPicturePickerPickingOriginalButton *orginalButton;
@property (nonatomic, strong) DRPICPicturePickerNextStepButton *nextStepButton;

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString *size;

@end

NS_ASSUME_NONNULL_END
