//
//  DRPNowExperienceAction.h
//  Pods
//
//  Created by 李晓越 on 2019/8/15.
//

#import <DNPop/DNPop.h>
#import "DRPUserInfoCheckView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRPUserInfoCheckViewAction : DNPopAction



+ (instancetype)actionWithCheckType:(DRPCheckType)checkType
                     checkTypeState:(DRPCheckTypeState)checkTypeState
                clickCheckTypeBlock:(void(^)(DRPCheckType checkType))clickCheckTypeBlock
                 clickContinueBlock:(void(^)(void))clickContinueBlock;
@end

NS_ASSUME_NONNULL_END
