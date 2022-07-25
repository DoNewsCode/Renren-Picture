//
//  DRPICTestPictureViewController.h
//  Renren-Picture_Example
//
//  Created by 陈金铭 on 2019/8/26.
//  Copyright © 2019 418589912@qq.com. All rights reserved.
//

#import "DRBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DRPICTestPictureViewControllerType) {
    DRPICTestPictureViewControllerTypePush,
    DRPICTestPictureViewControllerTypePresent,
    DRPICTestPictureViewControllerTypeTimeLine
};

@interface DRPICTestPictureViewController : DRBBaseViewController
@property(nonatomic, assign) DRPICTestPictureViewControllerType type;
@end

NS_ASSUME_NONNULL_END
