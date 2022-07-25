//
//  DRPICPicturePreviewLevitateView.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/20.
//

#import "DRPICPicturePreviewLevitateView.h"

#import "UIView+CTLayout.h"
#import "UIImage+RenrenPicture.h"
#import "UIColor+CTHex.h"
#import "UIFont+DRBFont.h"

@implementation DRPICPicturePreviewLevitateView

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
    self.effectView.frame = self.bounds;
    self.contentView.frame = (CGRect){0.,0.,self.ct_width,49.};
    self.editButton.frame = (CGRect){15.,0.,45.,self.contentView.ct_height};
    
    CGFloat orginButtonX = (self.contentView.ct_width - self.orginalButton.ct_width) * 0.5;
    CGFloat orginButtonY = (self.contentView.ct_height - self.orginalButton.ct_height) * 0.5;
    self.orginalButton.frame = (CGRect){orginButtonX,orginButtonY,self.orginalButton.ct_width,self.orginalButton.ct_height};
    
    CGFloat nextStepButtonWidth = self.nextStepButton.ct_width;
    CGFloat nextStepButtonX = self.contentView.ct_width - nextStepButtonWidth - 15;
    CGFloat nextStepButtonY = (self.contentView.ct_height - self.nextStepButton.ct_height) * 0.5;
    self.nextStepButton.frame = (CGRect){nextStepButtonX,nextStepButtonY,self.nextStepButton.ct_size};
}

#pragma mark - Intial Methods
- (void)initialize {
    [self createContent];
}

#pragma mark - Create Methods
- (void)createContent {
    [self addSubview:self.effectView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.editButton];
    [self.contentView addSubview:self.orginalButton];
    [self.contentView addSubview:self.nextStepButton];
    
    self.backgroundColor = [UIColor clearColor];
//    self.contentView.backgroundColor = [UIColor systemRedColor];
}

#pragma mark - Process Methods

#pragma mark - Event Methods
- (void)eventTouchUpInsideForOrginalButton:(DRPICPicturePickerPickingOriginalButton *)orginalButton {
    
}

#pragma mark - Public Methods

#pragma mark - Setter And Getter Methods
- (void)setSize:(NSString *)size {
    _size = size;
    self.orginalButton.size = size;
}

- (void)setCount:(NSInteger)count {
    _count = count;
    
    self.nextStepButton.count = count;
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

- (DRPICPicturePreviewEditButton *)editButton {
    if (!_editButton) {
        DRPICPicturePreviewEditButton *editButton = [DRPICPicturePreviewEditButton buttonWithType:UIButtonTypeCustom];
        
        _editButton = editButton;
    }
    return _editButton;
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

- (DRPICPicturePickerNextStepButton *)nextStepButton {
    if (!_nextStepButton) {
        DRPICPicturePickerNextStepButton *nextStepButton = [DRPICPicturePickerNextStepButton buttonWithType:UIButtonTypeCustom];
        _nextStepButton = nextStepButton;
    }
    return _nextStepButton;
}


@end
