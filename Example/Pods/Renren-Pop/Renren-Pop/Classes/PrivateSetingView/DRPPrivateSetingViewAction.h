//
//  DRPPrivateSetingViewAction.h
//  Renren-Pop
//
//  Created by 李晓越 on 2019/11/5.
//

#import <DNPop/DNPop.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPPrivateSetingViewAction : DNPopAction

+ (instancetype)actionWithTitle:(NSString *)title
                     attrString:(NSMutableAttributedString *)attrString
                      btnString:(NSString *)btnString
                   toSetUpBlock:(void(^)(void))toSetUpBlock
                 clickLinkBlock:(void(^)(NSURL *URL))clickLinkBlock
                     closeBlock:(void(^)(void))closeBlock;

@end

NS_ASSUME_NONNULL_END
