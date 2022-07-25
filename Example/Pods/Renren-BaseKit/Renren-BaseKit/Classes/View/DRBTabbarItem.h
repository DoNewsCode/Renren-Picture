//
//  DRBTabbarItem.h
//  Renren-BaseKit
//
//  Created by 陈金铭 on 2019/7/24.
//

#import "DRBBaseView.h"

#import <Lottie/Lottie.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DRBTabbarItemStatus) {//物料类型
    DRBTabbarItemStatusNormal = 0,//常规
    DRBTabbarItemStatusSelected,//选中
};

typedef NS_ENUM(NSInteger, DRBTabbarTipBadgeType) {//类型
    DRBTabbarTipBadgeTypeDetailedValue = 0,//详细数值
    DRBTabbarTipBadgeTypeFuzzyValue,//模糊数值
};

@interface DRBTabbarTipBadgeView : UILabel

@property(nonatomic, assign) DRBTabbarTipBadgeType type;

@end

@interface DRBTabbarItem : DRBBaseView

@property(nonatomic, strong) DRBTabbarTipBadgeView *tipBadge;
@property(nonatomic, assign) DRBTabbarItemStatus status;
@property(nonatomic, strong) LOTAnimationView *animationView;

@property(nonatomic, strong) UIImageView *imageView;

@property(nonatomic, copy) NSString *normalAnimationName;
@property(nonatomic, copy) NSString *selectedAnimationName;
    
@property(nonatomic, strong) UIImage *normalImage;
@property(nonatomic, strong) UIImage *selectedImage;

@end

NS_ASSUME_NONNULL_END
