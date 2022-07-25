//
//  DRPPop.h
//  Renren-Pop
//
//  Created by 陈金铭 on 2019/7/4.
//

#import <Foundation/Foundation.h>
#import <DNPop/DNPop.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "DRPPopConstant.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^__nullable HudCompleteAction)(void);

@interface DRPPop : NSObject


/// 显示一个普通的提醒 　弹窗
/// @param title 标题
/// @param message 内容
/// @param enterBlock 按钮回调
+ (void)showTipWithTitle:(NSString *)title
                 message:(NSString *)message
              enterBlock:(void (^ __nullable)(void))enterBlock;


/// 显示账号异常提醒　弹窗
/// @param title 标题
/// @param message 内容
/// @param btnString 右侧按钮文字
/// @param showBackBtn 是否显示返回按钮
/// @param enterBlock 回调
+ (void)showTipWithTitle:(NSString *)title
                 message:(NSString *)message
               btnString:(NSString *)btnString
             showBackBtn:(BOOL)showBackBtn
              enterBlock:(void (^ __nullable)(void))enterBlock;

/**
 显示底部弹出的提示控件 -- 只有一排按钮的提示框

 @param message 提示内容
 @param doneTitle 提示框 确定 按钮文字
 */
+ (void)showBottomTipViewWithMessage:(NSString *)message
                           doneTitle:(NSString *)doneTitle;


/**
 显示底部弹出的提示控件 -- 只有两排按钮的提示框
 
 @param title   提示标题
 @param message 提示内容
 @param doneTitle 提示框 确定 按钮文字
 */
+ (void)showBottomTipViewWithTitle:(NSString *)title
                           message:(NSString *)message
                         doneTitle:(NSString *)doneTitle
                       cancelTitle:(NSString *)cancelTitle
                       handleBlock:(void(^)(NSString *title))handleBlock;


/**
 显示底部弹出的提示控件 -- 只有两排按钮的提示框
 
 @param title   提示标题
 @param message 提示内容
 @param doneTitle 提示框 确定 按钮文字
 @param fromViewController 从这个控制器弹出控件
 */
+ (void)showBottomTipViewWithTitle:(NSString *)title
                           message:(NSString *)message
                         doneTitle:(NSString *)doneTitle
                       cancelTitle:(NSString *)cancelTitle
                       fromViewController:(UIViewController *)fromViewController
                       handleBlock:(void(^)(NSString *title))handleBlock;

/**
 显示底部弹出的 ActionSheetView

 @param title       标题
 @param message     消息
 @param titleArray  一堆标题内容
 @param lastBtnShowRedFont 最后一个标题是否为红色
 @param handleBlock 回调事件，返回标题文字
 */
+ (void)showBottomActionSheetWithTitle:(nullable NSString *)title
                               message:(NSString *)message
                            titleArray:(NSArray *)titleArray
                    lastBtnShowRedFont:(BOOL)lastBtnShowRedFont
                           handleBlock:(void(^)(NSString *title))handleBlock;


/**
 显示底部弹出的 ActionSheetView

 @param title       标题
 @param message     消息
 @param titleArray  一堆标题内容
 @param firstBtnShowRedFont 第一个标题是否为红色
 @param handleBlock 回调事件，返回标题文字
 */
+ (void)showBottomActionSheetWithTitle:(NSString *)title
                               message:(NSString *)message
                            titleArray:(NSArray *)titleArray
                   firstBtnShowRedFont:(BOOL)firstBtnShowRedFont
                           handleBlock:(void(^)(NSString *title))handleBlock;


/**
 显示底部弹出的 ActionSheetView，从指定控制器弹出
 
 @param title       标题
 @param message     消息
 @param titleArray  一堆标题内容
 @param lastBtnShowRedFont 最后一个标题是否为红色
 @param fromViewController 从这个控制器弹出控件
 @param handleBlock 回调事件，返回标题文字
 */
+ (void)showBottomActionSheetWithTitle:(NSString *)title
                               message:(NSString *)message
                            titleArray:(NSArray *)titleArray
                    lastBtnShowRedFont:(BOOL)lastBtnShowRedFont
                    fromViewController:(UIViewController *)fromViewController
                           handleBlock:(void(^)(NSString *title))handleBlock;



/**
 显示底部弹出的 ActionSheetView，从指定控制器弹出
 
 @param title       标题
 @param message     消息
 @param numberOfLines 消息文字行数
 @param titleArray  一堆标题内容
 @param lastBtnShowRedFont 最后一个标题是否为红色
 @param fromViewController 从这个控制器弹出控件
 @param handleBlock 回调事件，返回标题文字
 */
+ (void)showBottomActionSheetWithTitle:(NSString *)title
                               message:(NSString *)message
                         numberOfLines:(NSInteger)numberOfLines
                            titleArray:(NSArray *)titleArray
                    lastBtnShowRedFont:(BOOL)lastBtnShowRedFont
                    fromViewController:(UIViewController *)fromViewController
                           handleBlock:(void(^)(NSString *title))handleBlock;

/**
 显示底部弹出的分享控件

 @param moreActionType 显示几排按钮
 @param moreActionButtonType 每排按钮的具体类型
 @param popTitle 控件标题
 @param handleBlock 点击具体按钮后的回调整事件
 */
+ (void)showBottomShareViewWithMoreActionType:(kMoreActionType)moreActionType
                         moreActionButtonType:(kMoreActionButtonType)moreActionButtonType
                                     popTitle:(NSString *)popTitle
                                  handleBlock:(void(^)(kMoreActionButtonType moreActionButtonType))handleBlock;


/**
 显示底部弹出的分享控件， 需要指定从哪个控制器弹出
 
 @param moreActionType 显示几排按钮
 @param moreActionButtonType 每排按钮的具体类型
 @param popTitle 控件标题
 @param fromViewController 从这个控制器弹出分享控件
 @param handleBlock 点击具体按钮后的回调整事件
 */
+ (void)showBottomShareViewWithMoreActionType:(kMoreActionType)moreActionType
                         moreActionButtonType:(kMoreActionButtonType)moreActionButtonType
                                     popTitle:(NSString *)popTitle
                           fromViewController:(UIViewController *)fromViewController
                                  handleBlock:(void(^)(kMoreActionButtonType moreActionButtonType))handleBlock;

/**
 显示底部弹出的分享控件，按数组顺序排序按钮

 @param moreActionType 显示几排按钮
 @param shareTypes 分享类型的按钮 第一排
 @param optionTypes 选项类型的按钮 第二排
 @param popTitle 控件标题
 @param handleBlock 点击具体按钮后的回调整事件
 */
+ (void)showBottomShareViewWithMoreActionType:(kMoreActionType)moreActionType
                                   shareTypes:(NSArray *)shareTypes
                                  optionTypes:(NSArray *)optionTypes
                                     popTitle:(NSString *)popTitle
                                  handleBlock:(void(^)(kMoreActionButtonType moreActionButtonType))handleBlock;



/**
 显示底部弹出的 PickerView 选择控件

 @param title 标题 -- 功能暂不支持
 @param cancelTitle 取消按钮文字
 @param doneTitle 确定按钮文字
 @param listArray 列表数据源、元素必须是DRPPickerModel模型
 
 @param handlerBlock 回调选中的文字和下标
 */
+ (void)showBottomPickerViewWithTitle:(NSString *)title
                          cancelTitle:(NSString *)cancelTitle
                            doneTitle:(NSString *)doneTitle
                            listArray:(NSArray *)listArray
                         handlerBlock:(void(^)(NSInteger index, NSString * _Nonnull title))handlerBlock;



/**
 显示职业认证时的入职时间控件

 @param title 标题
 @param cancelTitle 取消按钮
 @param doneTitle 完成按钮
 @param isEndTime 是否是选择结束时间
 @param startYear 当 isEndTime 为YES时，需要传入职年份过来
 @param handlerBlock 回调结果
 */
+ (void)showJobPickerViewWithTitle:(NSString *)title
                       cancelTitle:(NSString *)cancelTitle
                         doneTitle:(NSString *)doneTitle
                         isEndTime:(BOOL)isEndTime
                         startYear:(NSInteger)startYear
                      handlerBlock:(void(^)(NSString * _Nonnull resultString))handlerBlock;


/**
 添加好友时的弹窗

 @param sendBlock 回调，发送的内容
 */
+ (void)showAddFriendViewWithSendBlock:(void(^)(NSString *text))sendBlock;



/**
 显示实名认证控件

 @param doneBlock 去认证的事件回调
 @param afterDoneBlock  稍后认证回调
 
 */
+ (void)showRealAuthViewWithTipString:(NSString *)tipString
                            doneBlock:(void(^)(void))doneBlock
                       afterDoneBlock:(void(^)(void))afterDoneBlock;


/**
 显示新版本升级控件

 @param tipString 升级描述信息
 @param upgradeNowBlock 立即升级回调
 */
+ (void)showVersionTipViewWithTitle:(NSString *)title
                          tipString:(NSString *)tipString
                    upgradeNowBlock:(void(^)(void))upgradeNowBlock;


/**
 显示 获得内测资格  -- 立即体验 控件

 @param title 标题
 @param tipString 信息
 @param nowExperienceBlock 立即体验按钮回调
 */
+ (void)showNowExperienceViewWithTitle:(NSString *)title
                             tipString:(NSString *)tipString
                    nowExperienceBlock:(void(^)(void))nowExperienceBlock;


/**
 显示评分控件

 @param goScoreBlock 去评分回调
 @param feedbackBlock 反馈问题回调
 */
+ (void)showScoreViewWithGoScoreBlock:(void(^)(void))goScoreBlock
                        feedbackBlock:(void(^)(void))feedbackBlock;


/**
 选择日期控件，适用于选择生日页面

 @param cancelTitle 取消文字
 @param doneTitle 确定文字
 @param selectDateStr  的格式为 @"1990年10年18日"
 @param handlerBlock 回调事件
 */
+ (void)showDatePickerViewWithCancelTitle:(NSString *)cancelTitle
                                doneTitle:(NSString *)doneTitle
                            selectDateStr:(NSString *)selectDateStr
                             handlerBlock:(void(^)(NSString * _Nonnull dateString))handlerBlock;

/**
 选择日期控件，适用于选择生日页面

 @param cancelTitle 取消文字
 @param doneTitle 确定文字
 @param selectDateStr  的格式为 @"1990年10年18日"
 @param handlerBlock 回调事件
 */
+ (void)showDatePickerViewWithCancelTitle:(NSString *)cancelTitle
                                doneTitle:(NSString *)doneTitle
                            startDateStr:(NSString *)startDateStr
                            selectDateStr:(NSString *)selectDateStr
                             handlerBlock:(void(^)(NSString * _Nonnull dateString))handlerBlock;


/**
 显示选择家乡或选择所在地的控件

 @param doneBlock 家乡信息等等
 */
+ (void)showHomeTownViewWithSelectProvince:(NSString *)selectProvince
                                selectCity:(NSString *)selectCity
                                 doneBlock:(void(^)(NSString *province,
                                                    NSString *cityName,
                                                    NSString *cityId,
                                                    NSString *result))doneBlock;


/**
 显示选择家乡或选择所在地的控件 —— 重构后使用这个

 @param doneBlock 家乡信息等等
 */
+ (void)showCityListWith:(NSString *)selectProvince
              selectCity:(NSString *)selectCity
                cityList:(NSArray *)cityList
               doneBlock:(void(^)(NSString *provinceName,
                                  NSString *cityName,
                                  NSString *provinceId,
                                  NSString *cityId,
                                  NSString *result))doneBlock;

/// 显示职位列表
+ (void)showPositionViewWithResultBlock:(void(^)(NSString *classification,
                                                 NSString *positionName,
                                                 NSString *positionId))resultBlock;

/// 显示职位列表 ——— 重构后使用这个
+ (void)showPositionList:(NSArray *)positionList
             resultBlock:(void(^)(NSString *classification,
                                  NSString *positionName,
                                  NSString *positionId))resultBlock;

/// 显示隐私设置弹窗
+ (void)showPrivateSetingViewWithTitle:(NSString *)title
                            attrString:(NSMutableAttributedString *)attrString
                             btnString:(NSString *)btnString
                          toSetUpBlock:(void(^)(void))toSetUpBlock
                        clickLinkBlock:(void(^)(NSURL *URL))clickLinkBlock;

/// 显示活动弹窗
/// @param image 需要展示的活动图片
/// @param handlerBlock 点击回调事件
+ (void)showActivityViewWith:(UIImage *)image
                handlerBlock:(void(^)(void))handlerBlock;


/// 显示设置密码弹窗 一
/// @param toSetupBlock 去设置
/// @param laterSetupBlock 下次再说
+ (void)showSetPwdViewWithToSetupBlock:(void(^)(void))toSetupBlock
                       laterSetupBlock:(void(^)(void))laterSetupBlock
                            closeBlock:(void(^)(void))closeBlock;

/// 显示设置密码弹窗 二
/// @param iknowBlock 点击关闭或我知道了都会回调
+ (void)showSetPwdViewWithIknowBlock:(void(^)(void))iknowBlock;

/// 显示检测用户信息窗口
/// @param checkType 标识需要显示哪一项
/// @param checkTypeState 标识哪一项的状态是未处理或已完成
/// @param clickCheckTypeBlock 点击了哪一项的去处理
/// @param clickContinueBlock 点击了继续
+ (void)showCheckInfoViewWithCheckType:(DRPCheckType)checkType
                        checkTypeState:(DRPCheckTypeState)checkTypeState
                   clickCheckTypeBlock:(void(^)(DRPCheckType checkType))clickCheckTypeBlock
                    clickContinueBlock:(void(^)(void))clickContinueBlock;


/// 显示修改昵称弹窗
/// @param clickSureBlock 点击了确定
/// @param clickBackBlock 点击了返回
+ (void)showSetNickNameWith:(void(^)(NSString *nickName,
                                     DNPopViewController *alertController))clickSureBlock
             clickBackBlock:(void(^)(void))clickBackBlock;


/// 显示修改用户名弹窗
/// @param clickSureBlock 点击了确定
/// @param clickBackBlock 点击了返回
+ (void)showSetAccountWith:(NSString *)account
            clickSureBlock:(void(^)(NSString *userName,
                                    DNPopViewController *alertController))clickSureBlock
             clickBackBlock:(void(^)(void))clickBackBlock;

/// 显示账号信息更新成功弹窗
+ (void)showUpdateSuccessViewClickSureBlock:(void(^)(void))clickSureBlock;


/// 显示加入小组弹窗
/// @param groupName 小组名称
/// @param groupDesc 小组描述 ？
/// @param groupIconUrl 小组头像
/// @param placeholder 占位文字，默认：请输入您的申请理由，100字以内
/// @param joinBlock 点击申请加入回调
+ (void)showJoinGroupViewWith:(NSString *)groupName
                    groupDesc:(NSString *)groupDesc
                 groupIconUrl:(NSString *)groupIconUrl
                  placeholder:(NSString *)placeholder
                    joinBlock:(void (^)(NSString *joinReason))joinBlock;


/// 显示完善资料弹窗
/// @param handlerBlock 点击了完善资料
/// @param cancleBlock 点击了关闭
+ (void)showPerfectInformationViewWithHandlerBlock:(void(^)(void))handlerBlock
                                       cancleBlock:(void(^)(void))cancleBlock;

/**
 弹出自定义视图

 @param customView 自定义视图 由下到上弹出
 */
+ (void)showCustomView:(UIView *)customView;

/**
 自定义视图

 @param customView 自定义视图 中间位置弹出
 */
+ (void)showCenterCustomView:(UIView *)customView;

#pragma mark - hud
/**
 纯文字提示，2s后自动消失
 */
+ (void)showTextHUDWithMessage:(nonnull NSString *)message;

+ (void)showTextHUDWithMessage:(NSString *)message completion:(HudCompleteAction)completion;

/**
 加载中+文字提示（文字可为空）, 一直提示，需要手动消失
 */
+ (void)showLoadingHUDWithMessage:(nullable NSString *)message;
/**
 加载中+文字提示（文字可为空）, 一直提示，需要手动消失，可以设置垂直偏移
*/
+ (void)showLoadingHUDWithMessage:(nullable NSString *)message
                          offsetY:(CGFloat)offsetY;

/**
 失败提示，2s后自动消失，带图标 '错号'
 */
+ (void)showErrorHUDWithMessage:(nullable NSString *)message
                       completion:(HudCompleteAction)completion;
/**
 完成提示，2s后自动消失，带图标 '对号'
 */
+ (void)showCompletionHUDWithMessage:(nullable NSString *)message
                          completion:(HudCompleteAction)completion;

/**
 隐藏hud
 */
+ (void)hideLoadingHUD;



@end

NS_ASSUME_NONNULL_END
