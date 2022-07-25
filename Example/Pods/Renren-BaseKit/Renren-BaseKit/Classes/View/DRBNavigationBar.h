//
//  DRBNavigationBar.h
//  Renren-BaseKit
//
//  Created by 陈金铭 on 2019/7/26.
//

#import "DRBBaseView.h"

#import "DRBBaseButton.h"

typedef NS_ENUM(NSInteger, DRBNavigationBarLeftType) {
    DRBNavigationBarLeftTypeNormal,
    DRBNavigationBarLeftTypeWhite,
    DRBNavigationBarLeftTypeBlack,
    DRBNavigationBarLeftTypeCustom,
};

typedef NS_ENUM(NSInteger, DRBNavigationBarRightType) {
    DRBNavigationBarRightTypeMoreNormal,
    DRBNavigationBarRightTypeMoreWhite,
    DRBNavigationBarRightTypeMoreBlack,
    DRBNavigationBarRightTypeCustom,
};

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, DRBNavigationBarButtonContentAlignment) {
    DRBNavigationBarButtonContentAlignmentLeft,
    DRBNavigationBarButtonContentAlignmentCenter,
    DRBNavigationBarButtonContentAlignmentRight,
};
@interface DRBNavigationBarButton : DRBBaseButton

@property(nonatomic, assign) DRBNavigationBarButtonContentAlignment contentAlignment;
@end

@interface DRBNavigationBar : DRBBaseView

@property(nonatomic, strong) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
