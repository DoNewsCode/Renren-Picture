//
//  DRMEAddressCell.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/2/26.
//

#import "DRMEAddressCell.h"

@interface DRMEAddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation DRMEAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)addressCellWithTableView:(UITableView *)tableView
{
    static NSString *cellIndentifer = @"DRMEAddressCell";
    DRMEAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setPoi:(AMapPOI *)poi
{
    _poi = poi;
    self.titleLabel.text = poi.name;
    self.subTitleLabel.text = poi.address;
}

@end
