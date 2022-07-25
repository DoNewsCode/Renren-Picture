//
//  DRPActivityView.h
//  Pods
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPActivityView : UIView

- (instancetype)initWithWithImage:(UIImage *)image
                     handlerBlock:(void(^)(void))handlerBlock
                       closeBlock:(void(^)(void))closeBlock;

@end

NS_ASSUME_NONNULL_END
