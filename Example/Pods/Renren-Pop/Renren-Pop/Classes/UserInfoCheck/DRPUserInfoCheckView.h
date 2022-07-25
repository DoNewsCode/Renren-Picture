
#import <UIKit/UIKit.h>
#import "DRPPopConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRPUserInfoCheckView : UIView

- (instancetype)initWithCheckType:(DRPCheckType)checkType
                   checkTypeState:(DRPCheckTypeState)checkTypeState
              clickCheckTypeBlock:(void(^)(DRPCheckType checkType))clickCheckTypeBlock
               clickContinueBlock:(void(^)(void))clickContinueBlock;

@end

NS_ASSUME_NONNULL_END
