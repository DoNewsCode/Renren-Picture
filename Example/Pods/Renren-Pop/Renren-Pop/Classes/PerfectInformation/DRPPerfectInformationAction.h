//
//  DRPPerfectInformationAction.h
//  Pods
//

#import "DNPopAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRPPerfectInformationAction : DNPopAction

+ (instancetype)actionWithHandlerBlock:(void(^)(void))handlerBlock
                            closeBlock:(void(^)(void))closeBlock;

@end

NS_ASSUME_NONNULL_END
