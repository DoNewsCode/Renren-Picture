//
//  DRMEFilterOptionCell.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/3/16.
//

#import <UIKit/UIKit.h>
#import "DRFTFilterModel.h"

@class DRMEFilterOptionCell;

NS_ASSUME_NONNULL_BEGIN

@protocol DRMEFilterOptionCellDelegate <NSObject>

@optional
/// 当点击了滤镜的参数设置按钮时调用
- (void)filterOptionCellDidClick:(DRMEFilterOptionCell *)cell;

@end

@interface DRMEFilterOptionCell : UICollectionViewCell

+ (instancetype)filterOptionCellWithCollectionView:(UICollectionView *)collectionView
                                     atIndexPath:(NSIndexPath *)indexPath;

@property(nonatomic,strong) DRFTFilterModel *filterModel;

@property(nonatomic,weak) id<DRMEFilterOptionCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
