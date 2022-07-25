//
//  DRPNowExperienceAction.h
//  Pods
//
//  Created by 李晓越 on 2019/8/15.
//

#import <DNPop/DNPop.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPNowExperienceAction : DNPopAction


+ (instancetype)actionWithTitle:(NSString *)title
                      tipString:(NSString *)tipString
             nowExperienceBlock:(void(^)(void))nowExperienceBlock
                     closeBlock:(void(^)(void))closeBlock;

@end

NS_ASSUME_NONNULL_END
