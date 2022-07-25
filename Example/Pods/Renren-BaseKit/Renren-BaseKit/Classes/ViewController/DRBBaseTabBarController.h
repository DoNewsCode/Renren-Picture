//
//  DRBBaseTabBarController.h
//  Pods
//
//  Created by Ming on 2019/4/16.
//

#import <UIKit/UIKit.h>

#import "DRBBaseFont.h"
#import "DRBBaseColor.h"
#import "DRBBaseTheme.h"

#import "UIColor+CTHex.h"

#import "UIFont+DRBFont.h"

#import "DNRouter.h"

#import "UIView+CTLayout.h"
#import "DNHandyCategory.h"

#import "DRBTabbar.h"
#import "DRBTabbarItem.h"

#import "DRBBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRBBaseTabBarController : UITabBarController<DRBTabbarDelegate>

@property(nonatomic, strong) DRBTabbar *customTabbar;


/**
 若自定义tabbarItem时 请在控制器内重写此方法；
 */
- (void)createCustomTabbarItem;

@end

NS_ASSUME_NONNULL_END
