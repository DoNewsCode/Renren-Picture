//
//  DRBBaseImageView.m
//  DNCommonKit
//
//  Created by Ming on 2019/5/6.
//

#import "DRBBaseImageView.h"

@interface DRBBaseImageView ()

@property(nonatomic, strong) UIImageView *placeholderImageView;

@end

@implementation DRBBaseImageView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self createInit];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createInit];
    }
    return self;
}

- (void)createInit {
    self.sd_imageTransition =  [SDWebImageTransition fadeTransition];
           self.backgroundColor = [UIColor ct_colorWithHexString:@"#F8F8F8"];
           UIImage *placeholderImage = [UIImage ct_imageResourceKitWithNamed:@"placeholder_image_normal_default"];
           UIImageView *placeholderImageView = [[UIImageView alloc] initWithImage:placeholderImage];
           self.placeholderImageView = placeholderImageView;
           [self addSubview:placeholderImageView];
}

- (void)setImage:(UIImage *)image {
    [super setImage:image];
    self.placeholderImageView.hidden = image == nil ? NO : YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat placeholderImageViewWidth = 100;
    CGFloat placeholderImageViewHeight = 65;
    CGFloat aspectRatio = 0.65;
    if (self.ct_width <= 71 && self.ct_width >= 0) {
        placeholderImageViewWidth = 34;
        placeholderImageViewHeight = placeholderImageViewWidth * aspectRatio;
    } else if (self.ct_width <= 125 && self.ct_width > 71) {
        placeholderImageViewWidth = 55;
        placeholderImageViewHeight = placeholderImageViewWidth * aspectRatio;
    }
    
    CGFloat placeholderImageViewX = (self.ct_width - placeholderImageViewWidth) * 0.5;
    CGFloat placeholderImageViewY = (self.ct_height - placeholderImageViewHeight) * 0.5;
    self.placeholderImageView.frame = (CGRect){placeholderImageViewX,placeholderImageViewY,placeholderImageViewWidth,placeholderImageViewHeight};
}

@end
