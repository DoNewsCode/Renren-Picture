//
//  DRBNavigationBarView.h
//  Renren-BaseKit
//
//  Created by 陈金铭 on 2019/8/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DRBNavigationBarViewPosition) {
    DRBNavigationBarViewPositionLeft,
    DRBNavigationBarViewPositionRight
};


@interface DRBNavigationBarView : UIView

@property (nonatomic, assign) DRBNavigationBarViewPosition position;
@property (nonatomic, assign) BOOL applied;


@end

NS_ASSUME_NONNULL_END
