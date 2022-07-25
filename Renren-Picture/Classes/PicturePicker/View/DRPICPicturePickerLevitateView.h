//
//  DRPICPicturePickerLevitateView.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/11.
//

#import <UIKit/UIKit.h>

#import "DRPICPicturePickerPreviewButton.h"

#import "DRPICPicturePickerNextStepButton.h"
#import "DRPICPicturePickerPickingOriginalButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRPICPicturePickerLevitateView : UIView
@property (nonatomic, strong) DRPICPicturePickerPreviewButton *previewButton;
@property (nonatomic, strong) DRPICPicturePickerNextStepButton *nextStepButton;
@property (nonatomic, strong) DRPICPicturePickerPickingOriginalButton *orginalButton;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIBlurEffect *blurEffect;
@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, assign) NSInteger count;

- (void)setHidden:(BOOL)hidden animaed:(BOOL)animaed;

@end

NS_ASSUME_NONNULL_END
