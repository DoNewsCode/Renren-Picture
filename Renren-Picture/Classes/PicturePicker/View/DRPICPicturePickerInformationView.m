//
//  DRPICPicturePickerInformationView.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/16.
//

#import "DRPICPicturePickerInformationView.h"

#import "UIView+CTLayout.h"
#import "UIImage+RenrenPicture.h"
#import "UIColor+CTHex.h"
#import "UIFont+DRBFont.h"

@implementation DRPICPicturePickerInformationView

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
}

#pragma mark - Intial Methods
- (void)initialize {
    [self createContent];
}

#pragma mark - Create Methods
- (void)createContent {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.editedImageView];
    [self addSubview:self.gifTitleLabel];
    [self addSubview:self.videoImageView];
    [self addSubview:self.audioImageView];
    [self addSubview:self.titleLabel];
    [self processSubViewInitialState];
}

#pragma mark - Process Methods
/// 处理子视图展示效果重置
- (void)processSubViewInitialState {
    self.backgroundColor = [UIColor clearColor];
    self.editedImageView.alpha = 0;
    self.gifTitleLabel.alpha = 0;
    self.videoImageView.alpha = 0;
    self.audioImageView.alpha = 0;
    self.titleLabel.alpha = 0;
    
    CGFloat imageViewX = 5;
    CGFloat editedImageViewY = (self.ct_height - self.editedImageView.ct_height) * 0.5;
    self.editedImageView.ct_origin = (CGPoint){imageViewX,editedImageViewY};
    
    CGFloat gifTitleLabelY = (self.ct_height - self.gifTitleLabel.ct_height) * 0.5;
    self.gifTitleLabel.ct_origin = (CGPoint){imageViewX,gifTitleLabelY};
    
    CGFloat videoImageViewY = (self.ct_height - self.videoImageView.ct_height) * 0.5;
    self.videoImageView.ct_origin = (CGPoint){imageViewX,videoImageViewY};
    
    CGFloat audioImageViewY = (self.ct_height - self.audioImageView.ct_height) * 0.5;
    self.audioImageView.ct_origin = (CGPoint){imageViewX,audioImageViewY};
    
    CGSize titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width, 30.) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.titleLabel.font} context:nil].size;
    CGFloat titleLabelX = self.ct_width - 5 - titleSize.width;
    CGFloat titleLabelY = (self.ct_height - titleSize.height) * 0.5;
    self.titleLabel.frame = (CGRect){titleLabelX, titleLabelY, titleSize};
}

#pragma mark - Event Methods

#pragma mark - Public Methods

#pragma mark - Setter And Getter Methods
- (void)setType:(DRPICPicturePickerInformationType)type {
    _type = type;
    [self processSubViewInitialState];
    switch (self.type) {
        case DRPICPicturePickerInformationTypeNone:
            [self processSubViewInitialState];
            break;
        case DRPICPicturePickerInformationTypeEdited:
            self.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.5];
            self.editedImageView.alpha = 1;
            
            break;
        case DRPICPicturePickerInformationTypeGif:
            self.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.5];
            self.gifTitleLabel.alpha = 1;
            
            break;
        case DRPICPicturePickerInformationTypeVideo:
            self.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.5];
            self.videoImageView.alpha = 1;
            self.titleLabel.alpha = 1;
            
            break;
        case DRPICPicturePickerInformationTypeAudio:
            self.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.5];
            self.audioImageView.alpha = 1;
            break;
            
        default:
            break;
    }
}

- (UIImageView *)editedImageView {
    if (!_editedImageView) {
        UIImageView *editedImageView = [UIImageView new];
        _editedImageView = editedImageView;
    }
    return _editedImageView;
}

- (UILabel *)gifTitleLabel {
    if (!_gifTitleLabel) {
        UILabel *gifTitleLabel = [UILabel new];
        gifTitleLabel.textColor = [UIColor ct_colorWithHexString:@"#FFFFFF"];
        gifTitleLabel.text = @"GIF";
        gifTitleLabel.font = [UIFont fontWithFontName:@"PingFangSC-Medium" size:13];
        CGSize gifTitleLabelSize = [gifTitleLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width, 30.) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : gifTitleLabel.font} context:nil].size;
        gifTitleLabel.ct_size = gifTitleLabelSize;
        _gifTitleLabel = gifTitleLabel;
    }
    return _gifTitleLabel;
}

- (UIImageView *)videoImageView {
    if (!_videoImageView) {
        UIImageView *videoImageView = [[UIImageView alloc] initWithImage:[UIImage ct_imageRenrenPictureUIWithNamed:@"view_image_video_default"]];
        _videoImageView = videoImageView;
    }
    return _videoImageView;
}

- (UIImageView *)audioImageView {
    if (!_audioImageView) {
        UIImageView *audioImageView = [UIImageView new];
        _audioImageView = audioImageView;
    }
    return _audioImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.textColor = [UIColor ct_colorWithHexString:@"#FFFFFF"];
        titleLabel.font = [UIFont fontWithFontName:@"PingFangSC-Regular" size:11];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

@end
