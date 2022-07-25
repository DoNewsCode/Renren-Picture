//
//  DRPActivityViewAction.h
//  Pods
//

#import "DNPopAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRPActivityViewAction : DNPopAction

+ (instancetype)actionWithImage:(UIImage *)image
                   handlerBlock:(void(^)(void))handlerBlock
                     closeBlock:(void(^)(void))closeBlock;

@end

NS_ASSUME_NONNULL_END
