//
//  UIView+DRPICCorner.h
//  Renren-Picture
//
//  Created by Luis on 2020/3/4.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DRPICCornerPosition){
    DRPICCornerPositionTop,
    DRPICCornerPositionLeft,
    DRPICCornerPositionBottom,
    DRPICCornerPositionRight,
    DRPICCornerPositionAll
};

@interface UIView (DRPICCorner)

@property(nonatomic, assign)DRPICCornerPosition drpic_cornerPosition;
@property(nonatomic, assign)CGFloat drpic_cornerRadius;

- (void)drpic_setCornerOnTopWithRadius:(CGFloat)radius;
- (void)drpic_setCornerOnLeftWithRadius:(CGFloat)radius;
- (void)drpic_setCornerOnBottomWithRadius:(CGFloat)radius;
- (void)drpic_setCornerOnRightWithRadius:(CGFloat)radius;
- (void)drpic_setAllCornerWithRadius:(CGFloat)radius;
- (void)drpic_setNoneCorner;



@end


