//
//  DRIAlbumListPopCell.m
//  RenrenOfficial-iOS-Concept
//
//  Created by 张健康 on 2019/3/16.
//  Copyright © 2019 renren. All rights reserved.
//

#import "DRIAlbumListPopCell.h"
#import "DRIImageManager.h"
#import "SDAutoLayout.h"
#import <DNCommonKit/UIColor+CTHex.h>
@implementation DRIAlbumListPopCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.albumIcon];
        [self.contentView addSubview:self.albumNameLabel];
        [self.contentView addSubview:self.line];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setObject:(DRIAlbumModel *)model{
    [self.albumNameLabel setText:[NSString stringWithFormat:@"%@(%zd)",model.name,model.count]];
    [self.albumNameLabel sizeToFit];
    [[DRIImageManager manager] getPostImageWithAlbumModel:model completion:^(UIImage *postImage) {
        self.albumIcon.image = postImage;
    }];
    [self setNeedsLayout];
//    if (model.selectedCount) {
//        self.selectedCountButton.hidden = NO;
//        [self.selectedCountButton setTitle:[NSString stringWithFormat:@"%zd",model.selectedCount] forState:UIControlStateNormal];
//    } else {
//        self.selectedCountButton.hidden = YES;
//    }
}

- (UIImageView *)albumIcon{
    if (!_albumIcon) {
        _albumIcon = [[UIImageView alloc] init];
        _albumIcon.contentMode = UIViewContentModeScaleAspectFill;
        _albumIcon.clipsToBounds = YES;
        _albumIcon.size = CGSizeMake(50, 50);
    }
    return _albumIcon;
}

- (UILabel *)albumNameLabel{
    if (!_albumNameLabel) {
        _albumNameLabel = [[UILabel alloc] init];
        _albumNameLabel.textColor = [UIColor ct_colorWithHex:0x333333];
        _albumNameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _albumNameLabel;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor ct_colorWithHex:0xE6E6E6];
    }
    return _line;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _albumIcon.frame = CGRectMake(13, (self.height - 50)/2, 50, 50);
    _albumNameLabel.frame = CGRectMake(_albumIcon.right + 10, (self.height - _albumNameLabel.height) / 2, _albumNameLabel.width, _albumNameLabel.height);
    _line.frame = CGRectMake(0, self.height - 1, self.width, 1);
}
@end
