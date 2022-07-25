//
//  DNVertifyAlertView.h
//  MinePage
//
//  Created by donews on 2019/4/4.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DNVertifyAlertView : UIView

/// 点击发送的回调
@property (nonatomic, copy) void(^clickSendEventBlock)(NSString *text);
/// 点击取消的回调
@property (nonatomic, copy) void(^clickCancelEventBlock)(void);

- (instancetype)initWithTitle:(NSString *)title desc:(NSString *)desc placeholder:(NSString *)placeholder;

@end

NS_ASSUME_NONNULL_END
