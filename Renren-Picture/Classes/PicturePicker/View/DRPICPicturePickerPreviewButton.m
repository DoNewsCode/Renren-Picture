//
//  DRPICPicturePickerPreviewButton.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/12.
//

#import "DRPICPicturePickerPreviewButton.h"
#import "UIView+CTLayout.h"
#import "UIFont+DRBFont.h"
#import "UIImage+RenrenPicture.h"
#import "UIColor+CTHex.h"

@implementation DRPICPicturePickerPreviewButton
#pragma mark - Override Methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage ct_imageRenrenPictureUIWithNamed:@"btn_image_preview_normal"] forState:UIControlStateNormal];
        [self setTitle:@"预览" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor ct_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fontWithFontName:@"PingFangSC-Regular" size:13];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat imageViewHeight = self.imageView.ct_height;
    CGFloat titleLabelHeight = self.titleLabel.ct_height;
    CGFloat margin = 10;
    CGFloat titleLabelX = (self.ct_width - self.titleLabel.ct_width) * 0.5;
    CGFloat imageViewX = (self.ct_width - self.imageView.ct_width) * 0.5;
    self.imageView.ct_y = (self.ct_height - imageViewHeight - titleLabelHeight - margin) * 0.5;
    self.titleLabel.ct_y = CGRectGetMaxY(self.imageView.frame) + margin;
    self.titleLabel.ct_x = titleLabelX;
    self.imageView.ct_x = imageViewX;
}

@end
