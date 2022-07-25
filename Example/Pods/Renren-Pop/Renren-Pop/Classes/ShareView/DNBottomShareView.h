//
//  DNMoreActionViewController.h
//  Pods
//
//  Created by 李晓越 on 2019/7/8.
//

#import <UIKit/UIKit.h>
#import "DRPPopConstant.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickButtonBlock)(kMoreActionButtonType moreActionButtonType);

@interface DNBottomShareView : UIView

/// 点击了具体按钮的block，返回给控制器，去执行代理事件
@property(nonatomic,copy) ClickButtonBlock clickButtonBlock;

/// 这个是根据 运算符 得出要添加哪些按钮
- (instancetype)initWithMoreActionType:(kMoreActionType)moreActionType
                  moreActionButtonType:(kMoreActionButtonType)moreActionButtonType
                              popTitle:(NSString *)popTitle;

/// 这个是根据 数组内容 得出要添加哪些按钮
- (instancetype)initWithMoreActionType:(kMoreActionType)moreActionType
                            shareTypes:(NSArray *)shareTypes
                           optionTypes:(NSArray *)optionTypes
                              popTitle:(NSString *)popTitle;

@end

NS_ASSUME_NONNULL_END
