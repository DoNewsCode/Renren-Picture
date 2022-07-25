//
//  DRPICPicturePIckerSelectButton.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/12.
//

#import "DRPICPicturePIckerSelectButton.h"

#import "UIView+CTLayout.h"
#import "UIFont+DRBFont.h"
#import "UIColor+CTHex.h"
#import "UIImage+RenrenPicture.h"

@implementation DRPICPicturePIckerSelectButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        self.titleLabel.frame = CGRectMake((self.ct_width - self.titleLabel.ct_width) * 0.5, (self.ct_height - self.titleLabel.ct_height) * 0.5, self.titleLabel.ct_width, self.titleLabel.ct_height);
        self.imageView.frame = CGRectMake((self.ct_width - self.imageView.ct_width) * 0.5, (self.ct_height - self.imageView.ct_height) * 0.5, self.imageView.ct_width, self.imageView.ct_height);
        self.imageView.hidden = NO;
        self.titleLabel.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.imageView.hidden = self.selected;
    self.titleLabel.hidden = !self.selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    self.selected = selected;
    if (animated == NO) {
        return;
    }
    if (self.selected) {
        CGFloat titleLabelWidth = 25;
        CGFloat titleLabelMaxWidth = titleLabelWidth * 1.3;
        self.titleLabel.frame = CGRectMake((self.ct_width - titleLabelMaxWidth) * 0.5, (self.ct_height - titleLabelMaxWidth) * 0.5, titleLabelMaxWidth, titleLabelMaxWidth);
        self.titleLabel.layer.cornerRadius = titleLabelMaxWidth * 0.5;
               
        [UIView animateWithDuration:0.618
                              delay:0
             usingSpringWithDamping:0.2
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            self.titleLabel.frame = CGRectMake((self.ct_width - titleLabelWidth) * 0.5, (self.ct_height - titleLabelWidth) * 0.5, titleLabelWidth, titleLabelWidth);
            self.titleLabel.layer.cornerRadius = titleLabelWidth * 0.5;
        }completion:nil];
    } else {
        CGFloat imageViewWidth = self.imageView.ct_width;
        CGFloat imageViewMaxWidth = imageViewWidth * 1.2;
        self.imageView.frame = CGRectMake((self.ct_width - imageViewMaxWidth) * 0.5, (self.ct_height - imageViewMaxWidth) * 0.5, imageViewMaxWidth, imageViewMaxWidth);
        [UIView animateWithDuration:0.618
                              delay:0
             usingSpringWithDamping:0.2
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            self.imageView.frame = CGRectMake((self.ct_width - imageViewWidth) * 0.5, (self.ct_height - imageViewWidth) * 0.5, imageViewWidth, imageViewWidth);
        }completion:nil];
    }
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    self.titleLabel.text = [NSString stringWithFormat:@"%ld",index];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage ct_imageRenrenPictureUIWithNamed:@"btn_image_photoStatus_normal"]];
        _imageView = imageView;
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        titleLabel.textColor = [UIColor ct_colorWithHexString:@"#FFFFFF"];
        titleLabel.backgroundColor = [UIColor ct_colorWithHexString:@"#3580F9"];
        titleLabel.layer.cornerRadius = titleLabel.ct_width * 0.5;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont fontWithFontName:@"PingFangSC-Regular" size:12];
        titleLabel.clipsToBounds = YES;
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

@end
