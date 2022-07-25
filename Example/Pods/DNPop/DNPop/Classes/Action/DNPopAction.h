//
//  DNPopAction.h
//  DNPop
//
//  Created by 陈金铭 on 2019/7/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DNPopActionStyle) {
    DNPopActionStyleDefault = 0,
    DNPopActionStyleCancel,
    DNPopActionStyleCustom
} NS_ENUM_AVAILABLE_IOS(8_0);


@interface DNPopAction : NSObject

@property (nonatomic, readonly) void (^handler)(void);

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, assign) DNPopActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;
@property(nonatomic, strong) UIView *item;

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(DNPopActionStyle)style handler:(void (^ __nullable)(void))handler;

@end

NS_ASSUME_NONNULL_END
