//
//  DRPICPicturePickerPickingOriginalButton.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/11.
//

#import "DRPICPicturePickerPickingOriginalButton.h"

#import "UIView+CTLayout.h"
#import "UIImage+RenrenPicture.h"
#import "UIColor+CTHex.h"
#import "UIFont+DRBFont.h"

@implementation DRPICPicturePickerPickingOriginalButton
#pragma mark - Override Methods
- (instancetype)initWithFrame:(CGRect)frame
{
    frame = (CGRect){0.,0.,300.,30};
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = (CGRect){0,(self.ct_height - 21) * 0.5,21,21};
    self.titleLabel.ct_x = self.imageView.ct_width + 5;
}

#pragma mark - Intial Methods
- (void)initialize {
    [self createContent];
}

#pragma mark - Create Methods
- (void)createContent {
    
    [self setImage:[UIImage ct_imageRenrenPictureUIWithNamed:@"btn_image_photoOrginal_normal"] forState:UIControlStateNormal];
    [self setImage:[UIImage ct_imageRenrenPictureUIWithNamed:@"btn_image_photoOrginal_selected"] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor ct_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont fontWithFontName:@"PingFangSC-Regular" size:16];
    self.title = @"原图";
}

#pragma mark - Process Methods

#pragma mark - Event Methods

#pragma mark - Public Methods

#pragma mark - Setter And Getter Methods
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
}

- (void)setSize:(NSString *)size {
    _size = size;
    
    if (size == nil || size.length == 0) {
         [self setTitle:self.title forState:UIControlStateNormal];
    } else  {
        [self setTitle:[NSString stringWithFormat:@"%@(%@)",self.title,size] forState:UIControlStateNormal];
    }
    CGSize titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.titleLabel.font} context:nil].size;
    
    self.ct_width = self.imageView.ct_width + 5 + titleSize.width;
    self.titleLabel.ct_size = titleSize;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if (self.size == nil || self.size.length == 0) {
         [self setTitle:title forState:UIControlStateNormal];
    } else  {
        [self setTitle:[NSString stringWithFormat:@"%@(%@)",title,self.size] forState:UIControlStateNormal];
    }
    CGSize titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.titleLabel.font} context:nil].size;
    self.ct_width = self.imageView.ct_width + 5 + titleSize.width;
    self.titleLabel.ct_size = titleSize;
}

@end
