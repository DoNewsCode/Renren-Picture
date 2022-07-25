//
//  DRPICPicturePickerNextStepButton.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/12.
//

#import "DRPICPicturePickerNextStepButton.h"

#import "UIView+CTLayout.h"
#import "UIFont+DRBFont.h"
#import "UIImage+RenrenPicture.h"
#import "UIColor+CTHex.h"

@implementation DRPICPicturePickerNextStepButton

#pragma mark - Override Methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.backgroundColor = [UIColor ct_colorWithHexString:@"#2A73EB"];
        self.titleLabel.font = [UIFont fontWithFontName:@"PingFangSC-Medium" size:15];
        [self setTitleColor:[UIColor ct_colorWithHexString:@"#FFFFFF"] forState:UIControlStateSelected];
        [self setTitleColor:[UIColor ct_colorWithHexString:@"#FFFFFF"] forState:UIControlStateSelected];
        self.title = @"完成";
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.hidden = NO;
    self.imageView.frame = self.bounds;
    self.imageView.layer.cornerRadius = self.imageView.ct_height * 0.5;
    self.imageView.layer.masksToBounds = YES;
    self.titleLabel.ct_x = (self.ct_width - self.titleLabel.ct_width) * 0.5;
    self.titleLabel.ct_y = (self.ct_height - self.titleLabel.ct_height) * 0.5;
}

- (void)setTitle:(NSString *)title {
    _title = title;
      if (self.count <= 0) {
         [self setTitle:[NSString stringWithFormat:@"%@",title] forState:UIControlStateNormal];
     } else {
         [self setTitle:[NSString stringWithFormat:@"%@(%ld)",title,self.count] forState:UIControlStateNormal];
     }
    CGSize titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width, 30.) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.titleLabel.font} context:nil].size;
    self.titleLabel.ct_size = titleSize;
    CGFloat width = self.titleLabel.ct_width + 20;
       CGFloat height = 30;
    self.ct_size = CGSizeMake(width, height);
}

- (void)setCount:(NSInteger)count {
    _count = count;
       if (self.count <= 0) {
         [self setTitle:[NSString stringWithFormat:@"%@",self.title] forState:UIControlStateNormal];
     } else {
         [self setTitle:[NSString stringWithFormat:@"%@(%ld)",self.title,count] forState:UIControlStateNormal];
     }
    CGSize titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width, 30.) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.titleLabel.font} context:nil].size;
    self.titleLabel.ct_size = titleSize;
    CGFloat width = self.titleLabel.ct_width + 20;
       CGFloat height = 30;
    self.ct_size = CGSizeMake(width, height);
}

@end
