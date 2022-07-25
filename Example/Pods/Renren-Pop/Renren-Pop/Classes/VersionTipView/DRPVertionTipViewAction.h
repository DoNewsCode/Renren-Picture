//
//  DRPVertionTipViewAction.h
//  Pods
//
//  Created by 李晓越 on 2019/8/15.
//

#import <DNPop/DNPop.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPVertionTipViewAction : DNPopAction

+ (instancetype)actionWithTitle:(NSString *)title
                      tipString:(NSString *)tipString
                upgradeNowBlock:(void(^)(void))upgradeNowBlock
                 noUpgradeBlock:(void(^)(void))noUpgradeBlock;

@end

NS_ASSUME_NONNULL_END
