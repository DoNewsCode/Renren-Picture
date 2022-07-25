//
//  DRMEAddressViewController.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/11/21.
//

#import <UIKit/UIKit.h>

@class DRMETagModel;

NS_ASSUME_NONNULL_BEGIN

@interface DRMEAddressViewController : UIViewController

@property(nonatomic,copy) void(^selectAddressBlock)(DRMETagModel *tagModel);

@end

NS_ASSUME_NONNULL_END
