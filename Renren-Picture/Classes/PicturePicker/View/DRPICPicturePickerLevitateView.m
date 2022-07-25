//
//  DRPICPicturePickerLevitateView.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/11.
//

#import "DRPICPicturePickerLevitateView.h"

#import "UIView+CTLayout.h"
#import "UIImage+RenrenPicture.h"
#import "UIColor+CTHex.h"
#import "UIFont+DRBFont.h"

@implementation DRPICPicturePickerLevitateView

#pragma mark - Override Methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //    self.visualEffectView.frame = self.bounds;
    self.effectView.frame = self.bounds;
    CGFloat previewButtonWidth = 50;
    CGFloat previewButtonHeight = previewButtonWidth;
    CGFloat previewButtonX = 8;
    CGFloat previewButtonY = (self.contentView.ct_height - previewButtonHeight) * 0.5;
    self.previewButton.frame = (CGRect){previewButtonX,previewButtonY,previewButtonWidth,previewButtonHeight};
    
    CGFloat orginButtonX = (self.contentView.ct_width - self.orginalButton.ct_width) * 0.5;
    CGFloat orginButtonY = (self.contentView.ct_height - self.orginalButton.ct_height) * 0.5;
    self.orginalButton.frame = (CGRect){orginButtonX,orginButtonY,self.orginalButton.ct_width,self.orginalButton.ct_height};
    
    CGFloat nextStepButtonX = self.contentView.ct_width - 15 - self.nextStepButton.ct_width;
    CGFloat nextStepButtonY = (self.contentView.ct_height - self.nextStepButton.ct_height) * 0.5;
    self.nextStepButton.ct_origin = CGPointMake(nextStepButtonX, nextStepButtonY);
}

#pragma mark - Intial Methods
- (void)initialize {
    [self createContent];
}

#pragma mark - Create Methods
- (void)createContent {
    [self addSubview:self.effectView];
    self.contentView.frame = (CGRect){0.,0.,self.ct_width,82};
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.previewButton];
    [self.contentView addSubview:self.orginalButton];
    [self.contentView addSubview:self.nextStepButton];
    self.nextStepButton.count = 1;
}

#pragma mark - Process Methods
- (void)setHidden:(BOOL)hidden animaed:(BOOL)animaed {
    if (animaed == NO) {
        self.hidden = hidden;
        return;
    }
    
    [UIView animateWithDuration:0.618 animations:^{
        
        self.hidden = hidden;
    }completion:^(BOOL finished) {
        
    }];
}
#pragma mark - Event Methods
- (void)eventTouchUpInsideForOrginalButton:(DRPICPicturePickerPickingOriginalButton *)orginalButton {
    
}

#pragma mark - Public Methods

#pragma mark - LazyLoad Methods
- (void)setCount:(NSInteger)count {
    _count = count;
    [self.nextStepButton setCount:count];
    CGFloat nextStepButtonX = self.contentView.ct_width - 15 - self.nextStepButton.ct_width;
    CGFloat nextStepButtonY = (self.contentView.ct_height - self.nextStepButton.ct_height) * 0.5;
    self.nextStepButton.ct_origin = CGPointMake(nextStepButtonX, nextStepButtonY);
}
//- (UIVisualEffectView *)visualEffectView {
//    if (!_visualEffectView) {
//        UIVisualEffectView *visualEffectView = [UIVisualEffectView new];
//        _visualEffectView = visualEffectView;
//    }
//    return _visualEffectView;
//}

- (DRPICPicturePickerPreviewButton *)previewButton {
    if (!_previewButton) {
        DRPICPicturePickerPreviewButton *previewButton = [DRPICPicturePickerPreviewButton buttonWithType:UIButtonTypeCustom];
        _previewButton = previewButton;
    }
    return _previewButton;
}

- (DRPICPicturePickerNextStepButton *)nextStepButton {
    if (!_nextStepButton) {
        DRPICPicturePickerNextStepButton *nextStepButton = [DRPICPicturePickerNextStepButton buttonWithType:UIButtonTypeCustom];
        _nextStepButton = nextStepButton;
    }
    return _nextStepButton;
}

- (DRPICPicturePickerPickingOriginalButton *)orginalButton {
    if (!_orginalButton) {
        DRPICPicturePickerPickingOriginalButton *orginalButton = [DRPICPicturePickerPickingOriginalButton buttonWithType:UIButtonTypeCustom];
        [orginalButton addTarget:self action:@selector(eventTouchUpInsideForOrginalButton:) forControlEvents:UIControlEventTouchUpInside];
        orginalButton.title = @"原图";
        _orginalButton = orginalButton;
    }
    return _orginalButton;
}

- (UIView *)contentView {
    if (!_contentView) {
        UIView *contentView = [UIView new];
        _contentView = contentView;
    }
    return _contentView;
}

- (UIBlurEffect *)blurEffect {
    if (!_blurEffect) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _blurEffect = blurEffect;
    }
    return _blurEffect;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:self.blurEffect];
        effectView.alpha = 0.9;
        _effectView = effectView;
    }
    return _effectView;
}

@end
