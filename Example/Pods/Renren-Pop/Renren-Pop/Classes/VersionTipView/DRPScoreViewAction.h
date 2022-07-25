//
//  DRPScoreViewAction.h
//  Pods
//
//  Created by 李晓越 on 2019/8/15.
//

#import <DNPop/DNPop.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPScoreViewAction : DNPopAction

+ (instancetype)actionWithGoScoreBlock:(void(^)(void))goScoreBlock
                         feedbackBlock:(void(^)(void))feedbackBlock
                            closeBlock:(void(^)(void))closeBlock;

@end

NS_ASSUME_NONNULL_END
