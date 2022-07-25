//
//  DRPScoreView.h
//  DNPop
//
//  Created by 李晓越 on 2019/8/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPSetPwdTwoView : UIView

- (instancetype)initWithIknowBlock:(void(^)(void))iknowBlock
                        closeBlock:(void(^)(void))closeBlock;

@end

NS_ASSUME_NONNULL_END
