//
//  DRPVertionTipView.h
//  DNPop
//
//  Created by 李晓越 on 2019/8/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPVertionTipView : UIView

- (instancetype)initWithTitle:(NSString *)title
                    tipString:(NSString *)tipString
              upgradeNowBlock:(void(^)(void))upgradeNowBlock
               noUpgradeBlock:(void(^)(void))noUpgradeBlock;


@end

NS_ASSUME_NONNULL_END
