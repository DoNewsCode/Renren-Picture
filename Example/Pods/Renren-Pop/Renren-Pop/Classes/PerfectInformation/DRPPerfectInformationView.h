//
//  DRPPerfectInformationView.h
//  Pods
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPPerfectInformationView : UIView

- (instancetype)initWithHandlerBlock:(void(^)(void))handlerBlock
                          closeBlock:(void(^)(void))closeBlock;

@end

NS_ASSUME_NONNULL_END
