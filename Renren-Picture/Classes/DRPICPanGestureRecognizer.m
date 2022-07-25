//
//  DRPICPanGestureRecognizer.m
//  Renren-Picture
//
//  Created by 陈金铭 on 2019/9/27.
//

#import "DRPICPanGestureRecognizer.h"

int const static kDirectionPanThreshold = 5;

@interface DRPICPanGestureRecognizer()

@property (nonatomic, assign) BOOL dragging;

@property (nonatomic, assign) int   moveX;

@property (nonatomic, assign) int   moveY;

@end

@implementation DRPICPanGestureRecognizer

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) return;
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    _moveX += prevPoint.x - nowPoint.x;
    _moveY += prevPoint.y - nowPoint.y;
    if (!self.dragging) {
        if (abs(_moveX) > kDirectionPanThreshold) {
            if (_direction == DRPICPanGestureRecognizerDirectionVertical) {
                self.state = UIGestureRecognizerStateFailed;
            }else {
                _dragging = YES;
            }
        }else if (abs(_moveY) > kDirectionPanThreshold) {
            if (_direction == DRPICPanGestureRecognizerDirectionHorizontal) {
                self.state = UIGestureRecognizerStateFailed;
            }else {
                _dragging = YES;
            }
        }
    }
}

- (void)reset {
    [super reset];
    _dragging = NO;
    _moveX = 0;
    _moveY = 0;
}

@end
