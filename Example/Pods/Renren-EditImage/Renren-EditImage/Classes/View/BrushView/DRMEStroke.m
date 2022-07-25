//
//  DRMEStroke.m
//

#import "DRMEStroke.h"

@implementation DRMEStroke

- (void)strokeWithContext:(CGContextRef)context {
    
    CGContextSetStrokeColorWithColor(context, [_lineColor CGColor]);
    CGContextSetFillColorWithColor(context, [_lineColor CGColor]);
    CGContextSetLineWidth(context, _strokeWidth);
    CGContextSetBlendMode(context, _blendMode);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextBeginPath(context);
    CGContextAddPath(context, _path);
    CGContextStrokePath(context);
}


@end
