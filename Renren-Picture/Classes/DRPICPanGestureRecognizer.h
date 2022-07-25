//
//  DRPICPanGestureRecognizer.h
//  Renren-Picture
//
//  Created by 陈金铭 on 2019/9/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DRPICPanGestureRecognizerDirection) {
    DRPICPanGestureRecognizerDirectionVertical,
    DRPICPanGestureRecognizerDirectionHorizontal
};

@interface DRPICPanGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic, assign) DRPICPanGestureRecognizerDirection   direction;

@end

NS_ASSUME_NONNULL_END
