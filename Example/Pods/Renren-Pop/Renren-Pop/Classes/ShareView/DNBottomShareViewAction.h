//
//  DNBottomShareViewAction.h
//  Pods
//
//  Created by 李晓越 on 2019/7/10.
//

#import <DNPop/DNPopAction.h>
#import "DRPPopConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface DNBottomShareViewAction : DNPopAction

@property (nonatomic, copy) void (^customHandler)(kMoreActionButtonType moreActionButtonType);

+ (instancetype)actionWithTitle:(NSString *)title
                 moreActionType:(kMoreActionType)moreActionType
           moreActionButtonType:(kMoreActionButtonType)moreActionButtonType
                        handler:(void (^ __nullable)(kMoreActionButtonType moreActionButtonType))handler;

+ (instancetype)actionWithTitle:(NSString *)title
                 moreActionType:(kMoreActionType)moreActionType
                     shareTypes:(NSArray *)shareTypes
                    optionTypes:(NSArray *)optionTypes
                        handler:(void (^ __nullable)(kMoreActionButtonType moreActionButtonType))handler;;

@end

NS_ASSUME_NONNULL_END
