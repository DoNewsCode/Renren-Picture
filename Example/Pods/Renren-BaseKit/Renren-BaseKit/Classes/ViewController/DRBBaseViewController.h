//
//  DRBBaseViewController.h
//  Pods-Renren-BaseKit_Example
//
//  Created by Ming on 2019/4/10.
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

#import "UIImage+DRBBaseKit.h"
#import "UIImage+DRRResourceKit.h"
#import "DRBNavigationBar.h"

#import "DRBBaseView.h"

#import "DRBBaseNavigationController.h"
#import "DNBaseMacro.h"

NS_ASSUME_NONNULL_BEGIN


@interface DRBBaseViewController : UIViewController

/** 是否含有返回按钮 默认YES*/
@property (nonatomic, assign) BOOL haveBack;

 /// 子类根据需要设置此
@property(nonatomic, assign) BOOL navigationControl;
/** 大标题 */
@property (nonatomic, copy) NSString *largeTitle;
/** 大标题按钮 */
@property (nonatomic, strong) UIButton *largeTitleButton;

- (void)createDefaultNavigation;
/// 子类若自定义LeftBar需重写此方法
- (void)createLeftBar;

/// 创建 LeftBarButtonItem
/// @param leftType 类型
/// @param image 仅在 leftType = DRBNavigationBarLeftTypeCustom 时生效
/// @param target target
/// @param action action
- (void)createLeftBarButtonItem:(DRBNavigationBarLeftType)leftType image:(nullable UIImage *)image target:(nullable id)target action:(nullable SEL)action;

- (void)createRightBarButtonItem:(DRBNavigationBarRightType)rightType image:(nullable UIImage *)image target:(nullable id)target action:(nullable SEL)action;


/** 配合createLeftBar使用,点击返回事件，子类可重写 */
- (void)eventLeftLeftBarButtonClick:(UIButton *)button;

@end

NS_ASSUME_NONNULL_END
