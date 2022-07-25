//
//  DRMEStroke.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef struct CGPath *CGMutablePathRef;
typedef enum CGBlendMode CGBlendMode;

@interface DRMEStroke : NSObject

@property (nonatomic) CGMutablePathRef path;
@property (nonatomic, assign) CGBlendMode blendMode;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, strong) UIColor *lineColor;
- (void)strokeWithContext:(CGContextRef)context;
@end
