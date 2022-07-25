//
//  DRPSetPwdOneView.h
//  DNPop
//
//  Created by 李晓越 on 2019/8/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPSetPwdOneView : UIView

- (instancetype)initWithToSetupBlock:(void(^)(void))toSetupBlock
                     laterSetupBlock:(void(^)(void))laterSetupBlock
                          closeBlock:(void(^)(void))closeBlock;

@end

NS_ASSUME_NONNULL_END
