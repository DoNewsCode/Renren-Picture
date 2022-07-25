//
//  DNPopAction.m
//  DNPop
//
//  Created by 陈金铭 on 2019/7/4.
//

#import "DNPopAction.h"

#import "DNPopItem.h"

@interface DNPopAction ()

@property (nullable, nonatomic, copy) NSString *title;
@property (nonatomic, copy) void (^handler)(void);

@end

@implementation DNPopAction

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(DNPopActionStyle)style handler:(void (^ __nullable)(void))handler {
    DNPopAction *customAlertAction = [[DNPopAction alloc] init];
    customAlertAction.title = title;
    customAlertAction.style = style;
    customAlertAction.handler = handler;
    DNPopItem * alertBaseItem = [[DNPopItem alloc] init];
    alertBaseItem.title = title;
    [alertBaseItem returnHandler:^{
        handler();
    }];
    customAlertAction.item = alertBaseItem;
    return customAlertAction;
}

@end
