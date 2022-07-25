//
//  DRMEEditOptionCell.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/10/22.
//

#import "DRMEEditOptionCell.h"

@interface DRMEEditOptionCell ()

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation DRMEEditOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (instancetype)editOptionCellWithCollectionView:(UICollectionView *)collectionView
                                     atIndexPath:(NSIndexPath *)indexPath;
{
    
    static NSString *cellIndentifer = @"DRMEEditOptionCell";
    DRMEEditOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer
                                                                         forIndexPath:indexPath];
    return cell;
}

- (void)setEditOptionModel:(DRMEEditOptionModel *)editOptionModel
{
    _editOptionModel = editOptionModel;
    
    [self.iconBtn setImage:[UIImage me_imageWithName:editOptionModel.imageStr]
                  forState:UIControlStateNormal];
    self.titleLabel.text = editOptionModel.titleStr;
}

@end
