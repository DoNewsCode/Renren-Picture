//
//  DRPSetPwdOneViewAction.h
//  Pods
//
//  Created by 李晓越 on 2019/8/15.
//

#import <DNPop/DNPop.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPSetPwdOneViewAction : DNPopAction

+ (instancetype)actionWithToSetupBlock:(void(^)(void))toSetupBlock
                       laterSetupBlock:(void(^)(void))laterSetupBlock
                            closeBlock:(void(^)(void))closeBlock;

@end

NS_ASSUME_NONNULL_END
