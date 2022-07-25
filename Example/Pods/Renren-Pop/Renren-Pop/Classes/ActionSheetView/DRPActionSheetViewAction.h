//
//  DRPActionSheetViewAction.h
//  Pods
//
//  Created by 李晓越 on 2019/8/2.
//

#import <DNPop/DNPopAction.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPActionSheetViewAction : DNPopAction


+ (instancetype)actionWithTitleArray:(NSArray *)titleArray
                  lastBtnShowRedFont:(BOOL)lastBtnShowRedFont
                         handleBlock:(void(^)(NSString *title))handleBlock;


+ (instancetype)actionWithTitle:(NSString *)title
                        message:(NSString *)message
                  numberOfLines:(NSInteger)numberOfLines
                     titleArray:(NSArray *)titleArray
             lastBtnShowRedFont:(BOOL)lastBtnShowRedFont
                    handleBlock:(void(^)(NSString *title))handleBlock;

+ (instancetype)actionWithTitleArray:(NSArray *)titleArray
                     firstBtnShowRedFont:(BOOL)firstBtnShowRedFont
                             handleBlock:(void(^)(NSString *title))handleBlock;

@end

NS_ASSUME_NONNULL_END
