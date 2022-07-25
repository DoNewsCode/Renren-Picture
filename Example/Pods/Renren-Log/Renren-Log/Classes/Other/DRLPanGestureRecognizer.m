//
//  DRLPanGestureRecognizer.m
//  Renren-Log
//
//  Created by 陈金铭 on 2019/12/9.
//

#import "DRLPanGestureRecognizer.h"

int const static DRLDirectionPanThreshold = 5;

@interface DRLPanGestureRecognizer()

@property (nonatomic, assign) BOOL dragging;

@property (nonatomic, assign) int   moveX;

@property (nonatomic, assign) int   moveY;

@end

@implementation DRLPanGestureRecognizer

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) return;
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    _moveX += prevPoint.x - nowPoint.x;
    _moveY += prevPoint.y - nowPoint.y;
    if (!self.dragging) {
        if (abs(_moveX) > DRLDirectionPanThreshold) {
            if (_direction == DRLPanGestureRecognizerDirectionVertical) {
                self.state = UIGestureRecognizerStateFailed;
            }else {
                _dragging = YES;
            }
        }else if (abs(_moveY) > DRLDirectionPanThreshold) {
            if (_direction == DRLPanGestureRecognizerDirectionHorizontal) {
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
