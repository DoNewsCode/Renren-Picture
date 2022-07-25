//
//  DNPopViewController.h
//  DNPop
//
//  Created by 陈金铭 on 2019/7/3.
//

#import <UIKit/UIKit.h>

#import "DNPopAction.h"

#import "DNPopAlertPresentAnimator.h"
#import "DNPopAlertDismissAnimator.h"

#import "DNPopActionSheetView.h"
#import "DNPopStyle.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DNPopViewControllerStyle) {
    DNPopViewControllerStyleActionSheet = 0,//暂仅支持此样式
    DNPopViewControllerStyleAlert
} NS_ENUM_AVAILABLE_IOS(8_0);


@interface DNPopViewController : UIViewController

@property (nonatomic, readonly) NSArray<DNPopAction *> *actions;

@property (nonatomic, strong, nullable) DNPopAction *preferredAction NS_AVAILABLE_IOS(9_0);

@property (nonatomic, strong, nullable) DNPopStyle *alertStyle;

@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;

//@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;
/** present 转场风格 */
@property (nonatomic, assign)DNPopPresentStyle presentStyle;
/** dismiss 转场风格 */
@property (nonatomic, assign)DNPopDismissStyle dismissStyle;
/** alert 视图 */
@property (nonnull, nonatomic, strong)UIView *alertView;
/** 半透明背景 */
@property (nonnull, nonatomic, strong)UIView *backgroundView;

/**
 是否允许点击背景取消弹窗，默认：Yes
 */
@property(nonatomic, assign) BOOL backgroundCancel;
/**
 有弹窗时是否可以在背景中进行用户交互，默认：NO
 */
//@property(nonatomic, assign) BOOL backgroundUserInteractionEnabled;

@property (nonatomic, readonly) DNPopViewControllerStyle preferredStyle;


/** 取消弹窗的回调 */
@property (nonatomic, copy) void (^handler)(DNPopViewController * _Nonnull alertController);

+ (instancetype)alertControllerWithPreferredStyle:(DNPopViewControllerStyle )preferredStyle;

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(DNPopViewControllerStyle )preferredStyle;


- (void)addAction:(DNPopAction *)action;

- (void)addActions:(NSArray<DNPopAction *> *)actions;

- (void)returnHandler:(void (^ __nullable)(DNPopViewController *alertController))handler;

@end

NS_ASSUME_NONNULL_END
