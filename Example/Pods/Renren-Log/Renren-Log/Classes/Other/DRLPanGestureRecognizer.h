//
//  DRLPanGestureRecognizer.h
//  Renren-Log
//
//  Created by 陈金铭 on 2019/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DRLPanGestureRecognizerDirection) {
    DRLPanGestureRecognizerDirectionVertical,
    DRLPanGestureRecognizerDirectionHorizontal
};

@interface DRLPanGestureRecognizer : UIPanGestureRecognizer
@property (nonatomic, assign) DRLPanGestureRecognizerDirection   direction;
@end

NS_ASSUME_NONNULL_END
