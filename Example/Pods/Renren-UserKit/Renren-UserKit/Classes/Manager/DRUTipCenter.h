//
//  DRUTipCenter.h
//  Renren-UserKit
//
//  Created by 陈金铭 on 2019/8/5.
//

#import <Foundation/Foundation.h>

#import "DRUTip.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRUTipCenter : NSObject

/** app图标提示 */
@property(nonatomic, strong, readonly) DRUTip *appTip;
/** 首页Tab提示 */
@property(nonatomic, strong, readonly) DRUTip *tabHomeTip;
/** 聊天Tab提示 */
@property(nonatomic, strong, readonly) DRUTip *tabChatTip;
/** 发现Tab提示 */
@property(nonatomic, strong, readonly) DRUTip *tabFindTip;
/** 用户Tab提示 */
@property(nonatomic, strong, readonly) DRUTip *tabUserTip;
/** 消息提示 */
@property(nonatomic, strong, readonly) DRUTip *messageTip;
/** App升级提示 */
@property(nonatomic, strong, readonly) DRUTip *appUpdateTip;
/** TestFlight App升级提示 */
@property(nonatomic, strong, readonly) DRUTip *testFlightAppUpdateTip;

/** 好友添加和关注提示*/
@property(nonatomic, strong, readonly) DRUTip *friendsAddTip;
/** 人人运动消息提示*/
@property(nonatomic, strong, readonly) DRUTip *sportsMessageTip;



+ (instancetype)sharedTipCenter;

@end

NS_ASSUME_NONNULL_END
