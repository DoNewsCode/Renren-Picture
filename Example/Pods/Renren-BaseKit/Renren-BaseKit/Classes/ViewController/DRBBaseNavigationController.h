//
//  DRBBaseNavigationController.h
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

#import "DRBNavigationBar.h"

#import "UINavigationBar+DRBLargeBar.h"

#import "UIImage+DRRResourceKit.h"

#import "DRBBaseView.h"

NS_ASSUME_NONNULL_BEGIN


@interface DRBBaseNavigationController : UINavigationController

@property(nonatomic, strong) DRBNavigationBar *customNavigationBar;

/**
 若要自定义Navigation请将此参数置为YES
 */
@property(nonatomic, assign) BOOL useCustom;

- (void)createLeftBarButtonItem:(DRBNavigationBarLeftType)leftType image:(nullable UIImage *)image target:(nullable id)target action:(nullable SEL)action;

- (void)createRightBarButtonItem:(DRBNavigationBarRightType)rightType image:(nullable UIImage *)image target:(nullable id)target action:(nullable SEL)action;

@end

NS_ASSUME_NONNULL_END
