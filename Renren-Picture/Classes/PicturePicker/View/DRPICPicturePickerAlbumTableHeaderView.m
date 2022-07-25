//
//  DRPICPicturePickerAlbumTableHeaderView.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/11.
//

#import "DRPICPicturePickerAlbumTableHeaderView.h"
#import "UIView+CTLayout.h"
#import "UIFont+DRBFont.h"
#import "UIColor+CTHex.h"
#import "UIImage+RenrenPicture.h"

@implementation DRPICPicturePickerAlbumTableHeaderView

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
    CGSize titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width, 30.) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.titleLabel.font} context:nil].size;
    
    self.titleLabel.frame = (CGRect){15.,(self.ct_height - titleSize.height) * 0.5,titleSize};
    self.iconImageView.ct_x = 15 + self.titleLabel.ct_width + 5;
    self.iconImageView.ct_y = (self.ct_height - self.iconImageView.ct_height) * 0.5;
    if (self.expand) {
        self.iconImageView.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        self.iconImageView.transform = CGAffineTransformIdentity;
    }
}

#pragma mark - Intial Methods
- (void)initialize {
    [self createContent];
}

#pragma mark - Create Methods
- (void)createContent {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconImageView];
}

#pragma mark - Process Methods

#pragma mark - Event Methods

#pragma mark - Public Methods

#pragma mark - LazyLoad Methods
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage ct_imageRenrenPictureUIWithNamed:@"view_image_arrowDown_defalut"]];
        _iconImageView = iconImageView;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont fontWithFontName:@"PingFangSC-Regular" size:28];
        titleLabel.textColor = [UIColor ct_colorWithHexString:@"#323232"];
//        titleLabel.text = @"";
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

@end
