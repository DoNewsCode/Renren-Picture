//
//  DRPNowExperienceAction.h
//  Pods
//
//  Created by 李晓越 on 2019/8/15.
//

#import <DNPop/DNPop.h>
#import "DRPUpdateSuccessView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRPUpdateSuccessViewAction : DNPopAction

+ (instancetype)actionWithClickSureBlock:(void(^)(void))clickSureBlock;

@end

NS_ASSUME_NONNULL_END
