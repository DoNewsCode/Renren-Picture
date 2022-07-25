//
//  DNPopItem.h
//  DNPop
//
//  Created by 陈金铭 on 2019/7/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DNPopItem : UIView

/** Title */
@property (nonatomic, strong) UILabel *titleLabel;

/** currentSelectedView */
@property (nonatomic, strong) CALayer *bottomLine;

@property(nonatomic, copy) NSString *title;

@property (nonatomic, copy) void (^handler)(void);

- (void)returnHandler:(void (^ __nullable)(void))handler;
- (void)createContent;

@end


NS_ASSUME_NONNULL_END
