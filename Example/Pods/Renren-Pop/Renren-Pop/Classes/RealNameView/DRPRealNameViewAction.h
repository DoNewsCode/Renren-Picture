//
//  DRPRealNameViewAction.h
//  Pods
//
//  Created by 李晓越 on 2019/8/2.
//

#import "DNPopAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRPRealNameViewAction : DNPopAction

+ (instancetype)actionWithTipString:(NSString *)tipString doneBlock:(void(^)(void))doneBlock afterBlock:(void(^)(void))afterBlock;

@end

NS_ASSUME_NONNULL_END
