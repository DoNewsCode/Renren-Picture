//
//  DNVertifyAlertViewAction.h
//  Pods
//
//  Created by 李晓越 on 2019/8/12.
//

#import <DNPop/DNPop.h>

NS_ASSUME_NONNULL_BEGIN

@interface DNVertifyAlertViewAction : DNPopAction

+ (instancetype)actionWithTipString:(NSString *)tipString
                          sendBlock:(void(^)(NSString *text))sendBlock
                         cancelBlock:(void(^)(void))cancelBlock;


@end

NS_ASSUME_NONNULL_END
