//
//  DRPICPicturePickerAlbumTableViewCell.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/11.
//

#import "DRPICPicturePickerAlbumTableViewCell.h"

#import "UIView+CTLayout.h"
#import "UIFont+DRBFont.h"
#import "UIColor+CTHex.h"

@implementation DRPICPicturePickerAlbumTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initialize];
    }
    return self;
}

- (void)layoutSubviews {
    self.previewIamgeView.frame = (CGRect){10.,(self.contentView.ct_height - 58.) * 0.5,58.,58.};
    
    CGSize titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width, 30.) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.titleLabel.font} context:nil].size;
    CGSize countSize = [self.countLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width, 30.) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.countLabel.font} context:nil].size;
    self.titleLabel.frame = (CGRect){CGRectGetMaxX(self.previewIamgeView.frame) + 5,(self.contentView.ct_height - titleSize.height) * 0.5,titleSize};
    self.countLabel.frame = (CGRect){CGRectGetMaxX(self.titleLabel.frame),(self.contentView.ct_height - countSize.height) * 0.5,countSize};
}

#pragma mark - Intial Methods
- (void)initialize {
    [self createContent];
}

#pragma mark - Create Methods
- (void)createContent {
    [self.contentView addSubview:self.previewIamgeView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.countLabel];
}

#pragma mark - Process Methods

#pragma mark - Event Methods

#pragma mark - Public Methods

#pragma mark - LazyLoad Methods
- (UIImageView *)previewIamgeView {
    if (!_previewIamgeView) {
        UIImageView *previewIamgeView = [UIImageView new];
        previewIamgeView.contentMode = UIViewContentModeScaleAspectFill;
        previewIamgeView.layer.masksToBounds = YES;
        _previewIamgeView = previewIamgeView;
    }
    return _previewIamgeView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont fontWithFontName:@"PingFangSC-Regular" size:16];
        titleLabel.textColor = [UIColor ct_colorWithHexString:@"#333333"];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        UILabel *countLabel = [UILabel new];
        countLabel.font = [UIFont fontWithFontName:@"PingFangSC-Regular" size:16];
        countLabel.textColor = [UIColor ct_colorWithHexString:@"#333333"];
        _countLabel = countLabel;
    }
    return _countLabel;
}
@end
