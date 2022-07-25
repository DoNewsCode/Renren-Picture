
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRMEPhotoEditAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) UINavigationControllerOperation operation;
@property (nonatomic, strong) UIImage *animatImage;
@property (nonatomic, assign) CGRect   fromRect;
@property (nonatomic, assign) CGRect   toRect;

@end

NS_ASSUME_NONNULL_END
