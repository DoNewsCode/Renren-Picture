//
//  DRPJoinGroupAction.h
//  Renren-Pop
//
//  Created by 李晓越 on 2019/11/15.
//

#import <DNPop/DNPop.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPJoinGroupAction : DNPopAction

+ (instancetype)actionWith:(NSString *)groupName
                 groupDesc:(NSString *)groupDesc
              groupIconUrl:(NSString *)groupIconUrl
               placeholder:(NSString *)placeholder
                 joinBlock:(void (^)(NSString *joinReason))joinBlock
                closeBlock:(void(^)(void))closeBlock;

@end

NS_ASSUME_NONNULL_END
