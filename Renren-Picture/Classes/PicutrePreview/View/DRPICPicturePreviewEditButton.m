//
//  DRPICPicturePreviewEditButton.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/20.
//

#import "DRPICPicturePreviewEditButton.h"

#import "UIView+CTLayout.h"
#import "UIImage+RenrenPicture.h"
#import "UIColor+CTHex.h"
#import "UIFont+DRBFont.h"

@implementation DRPICPicturePreviewEditButton

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
    self.titleLabel.ct_x = 0;
}

#pragma mark - Intial Methods
- (void)initialize {
    [self createContent];
}

#pragma mark - Create Methods
- (void)createContent {
    [self setTitleColor:[UIColor ct_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont fontWithFontName:@"PingFangSC-Regular" size:15];
    [self setTitle:@"编辑" forState:UIControlStateNormal];
}

#pragma mark - Process Methods

#pragma mark - Event Methods

#pragma mark - Public Methods

#pragma mark - Setter And Getter Methods
@end
