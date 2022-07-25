//
//  DRMEEditOptionCell.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/10/22.
//

#import <UIKit/UIKit.h>
#import "DRMEEditOptionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRMEEditOptionCell : UICollectionViewCell

+ (instancetype)editOptionCellWithCollectionView:(UICollectionView *)collectionView
                                     atIndexPath:(NSIndexPath *)indexPath;


@property(nonatomic,strong) DRMEEditOptionModel *editOptionModel;

@end

NS_ASSUME_NONNULL_END
