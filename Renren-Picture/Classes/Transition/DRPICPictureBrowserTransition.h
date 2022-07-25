//
//  DRPICPictureBrowserTransition.h
//  Renren-Picture
//
//  Created by Ming on 2020/2/18.
//

#import <UIKit/UIKit.h>

#import "DRPICPictureBrowserPercentDrivenInteractiveTransition.h"
#import "DRPICPictureBrowserDismissDrivenInteractiveTransition.h"
#import "DRPICPictureBrowserPopDrivenInteractiveTransition.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DRPICPictureBrowserTransitionType) {//转场类型
    DRPICPictureBrowserTransitionTypeNone,//无导航
    DRPICPictureBrowserTransitionTypeNavigation,//有导航
};



@interface DRPICPictureBrowserTransition : NSObject<UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>

@property (nonatomic, assign) DRPICPictureBrowserTransitionType type;
@property (nonatomic, assign) BOOL interaction;
@property (nonatomic, strong) DRPICPictureBrowserDismissDrivenInteractiveTransition *dismissInteractiveTransition;

@property (nonatomic, strong) DRPICPictureBrowserPopDrivenInteractiveTransition *popInteractiveTransition;

@end

NS_ASSUME_NONNULL_END
