//
//  DRTBarView.h
//  RenrenOfficial-iOS-Concept
//
//  Created by 文昌  陈 on 2019/7/24.
//  Copyright © 2019 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SXBarViewPosition) {
    SXBarViewPositionLeft,
    SXBarViewPositionRight
};

@interface DRTBarView : UIView

@property (nonatomic, assign) SXBarViewPosition position;
@property (nonatomic, assign) BOOL applied;

@end

NS_ASSUME_NONNULL_END
