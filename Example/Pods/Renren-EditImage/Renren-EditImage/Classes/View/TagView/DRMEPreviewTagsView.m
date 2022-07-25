//
//  DRMEPreviewTagsView.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/1/9.
//

#import "DRMEPreviewTagsView.h"

@implementation DRMEPreviewTagsView


//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] &&
//            [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
//}


- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    
    if (!self.isHitTest) {
        return hitView;
    }
    
    /// isHitTest：YES， 这里是为了能让文字视图响应事件
    if (hitView == self) {
        return nil;
    }
    return hitView;
}

@end
