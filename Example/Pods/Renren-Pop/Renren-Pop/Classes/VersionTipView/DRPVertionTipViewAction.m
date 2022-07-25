//
//  DRPVertionTipViewAction.m
//  Pods
//
//  Created by 李晓越 on 2019/8/15.
//

#import "DRPVertionTipViewAction.h"
#import "DRPVertionTipView.h"

@implementation DRPVertionTipViewAction

+ (instancetype)actionWithTitle:(NSString *)title
                      tipString:(NSString *)tipString
                upgradeNowBlock:(void(^)(void))upgradeNowBlock
                 noUpgradeBlock:(void(^)(void))noUpgradeBlock
{
    DRPVertionTipViewAction *customAlertAction = [[DRPVertionTipViewAction alloc] init];
    
    DRPVertionTipView *realNameView = [[DRPVertionTipView alloc] initWithTitle:title tipString:tipString upgradeNowBlock:upgradeNowBlock noUpgradeBlock:noUpgradeBlock];
    
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = realNameView;
    
    return customAlertAction;
}

@end
