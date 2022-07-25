//
//  DRMEAddressCell.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/2/26.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapCommonObj.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRMEAddressCell : UITableViewCell

+ (instancetype)addressCellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong) AMapPOI *poi;

@end

NS_ASSUME_NONNULL_END
