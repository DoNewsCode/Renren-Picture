//
//  DRPNewPositionViewAction.h
//  Renren-Pop
//
//  Created by 李晓越 on 2019/9/3.
//

#import <DNPop/DNPop.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPNewPositionViewAction : DNPopAction

+ (instancetype)actionWithPositionList:(NSArray *)positionList
                           resultBlock:(void(^)(NSString *classification,
                                                NSString *positionName,
                                                NSString *positionId))resultBlock
                           handleBlock:(void(^)(NSString *title))handleBlock;
@end

NS_ASSUME_NONNULL_END
