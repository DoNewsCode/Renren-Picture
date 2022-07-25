//
//  DNPopView.h
//  DNPop
//
//  Created by 陈金铭 on 2019/7/3.
//

#import <UIKit/UIKit.h>
#import "DNPopAction.h"
#import "DNPopStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface DNPopView : UIView
@property (nonatomic,readonly) NSArray<UIView *> *alertItems;
@property (nonatomic, readonly) NSArray<DNPopAction *> *alertActions;

@property(nonatomic, strong) DNPopStyle *alertStyle;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

- (instancetype)initWithStyle:(DNPopStyle *)style alertActions:(NSArray<DNPopAction *> *)alertActions;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message style:(DNPopStyle *)style alertActions:(NSArray<DNPopAction *> *)alertActions;

- (void)addAlertAction:(DNPopAction *)alertAction;

@end

NS_ASSUME_NONNULL_END
