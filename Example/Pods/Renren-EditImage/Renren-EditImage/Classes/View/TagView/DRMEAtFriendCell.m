//
//  DRMEAtFriendCell.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/11/20.
//

#import "DRMEAtFriendCell.h"
#import <DRBBaseImageView.h>

@interface DRMEAtFriendCell ()

@property(nonatomic,strong) DRBBaseImageView *avatarImgView;

@property(nonatomic,strong) UILabel *nameLabel;

@end

@implementation DRMEAtFriendCell

- (DRBBaseImageView *)avatarImgView
{
    if (!_avatarImgView) {
        _avatarImgView = [[DRBBaseImageView alloc] init];
        _avatarImgView.layer.cornerRadius = 23.f;
    }
    return _avatarImgView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kFontMediumSize(16);
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.text = @"我是名称我是名称我是名称我是名称我是名称我是名称我是名称";
    }
    return _nameLabel;
}

+ (instancetype)atFriendCellWithTableView:(UITableView *)tableView
{
    NSString *ID = @"DRMEAtFriendCell";
    DRMEAtFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[DRMEAtFriendCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.avatarImgView];
        [self.contentView addSubview:self.nameLabel];
        
        self.avatarImgView.sd_layout.centerYEqualToView(self.contentView)
        .leftSpaceToView(self.contentView, 15)
        .widthIs(46).heightIs(46);
        
        self.nameLabel.sd_layout.topEqualToView(self.contentView)
        .leftSpaceToView(self.avatarImgView, 10)
        .bottomEqualToView(self.contentView)
        .rightSpaceToView(self.contentView, 10);
        
        
    }
    return self;
}

@end
