//
//  DRMEFilterOptionCell.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/3/16.
//

#import "DRMEFilterOptionCell.h"
#import <UIButton+WebCache.h>
#import "DRBBaseImageView.h"
#import "DRFTFilterModel+DRMEExtension.h"

@interface DRMEFilterOptionCell()

@property (weak, nonatomic) IBOutlet DRBBaseImageView *filterImg;
@property (weak, nonatomic) IBOutlet UILabel *filterNameLabel;
@property (weak, nonatomic) IBOutlet UIView *seletedView;

@end

@implementation DRMEFilterOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.filterImg.layer.cornerRadius = 2;
}

+ (instancetype)filterOptionCellWithCollectionView:(UICollectionView *)collectionView
                                     atIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIndentifer = @"DRMEFilterOptionCell";
    DRMEFilterOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer
                                                                         forIndexPath:indexPath];
    return cell;
}

- (void)setFilterModel:(DRFTFilterModel *)filterModel
{
    _filterModel = filterModel;
    
    [self.filterImg sd_setImageWithURL:[NSURL URLWithString:filterModel.icon]];
    self.filterNameLabel.text = filterModel.name;

    if (filterModel.isSelected) {
        self.seletedView.hidden = NO;
    } else {
        self.seletedView.hidden = YES;
    }
}

- (IBAction)clickButton:(id)sender {
    
    if (self.filterModel.isOriginalImage) {
        // 原图不需要弹出范围选择视图
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(filterOptionCellDidClick:)]) {
        [self.delegate filterOptionCellDidClick:self];
    }
    
}


@end
