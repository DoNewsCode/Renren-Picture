//
//  DRLRecord.h
//  Renren-Service
//
//  Created by Ming on 2019/5/28.
//  埋点的记录与上报 (统一对App内埋点数据上报记录等进行管理，对第三方等埋点服务进行封装)

#import <Foundation/Foundation.h>
#import "DRLTimeLineStaticManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DRLRecordType) {//事件类型
    DRLRecordTypeNormal = 0,//常规
    DRLRecordTypeClick,//点击事件
    DRLRecordTypeEnter,//进入统计
    DRLRecordTypePipe,//通道事件统计（Web小程序H5等其他途径传递来的统计事件）
};



@interface DRLRecord : NSObject

@property(nonatomic, copy) NSString *appKey;
@property(nonatomic, copy) NSString *channelId;

//单例
+ (instancetype)sharedRecord;
/** 启动埋点统计 （初始化埋点统计服务） */
+ (void)start;


/**
 设置是否附加日志的记录功能 默认为YES

 @param additionalLog 是否附加日志的记录功能
 */
+ (void)setAdditionalLog:(BOOL)additionalLog;

+ (void)addRecordWithEventName:(NSString *)eventName;

+ (void)addRecordType:(DRLRecordType)type eventName:(NSString *)eventName;


/**
 添加统计事件

 @param type 统计事件类型
 @param eventName 统计事件传递给服务端的名称
 @param parameters 附加参数
 */
+ (void)addRecordType:(DRLRecordType)type eventName:(NSString *)eventName parameters:(NSDictionary *)parameters;


/**
 设置用户id
 （在用户切换时调用此方法进行设置）
 @param userIdentifier 用户id
 */
+ (void)createUserIdentifier:(NSString *)userIdentifier;


/// 设置用户登陆账号
/// （在用户切换时调用此方法进行设置）
/// @param account 用户登陆账号
+ (void)createUserAccount:(NSString *)account;

/// 设置用户年龄
/// （在用户切换时调用此方法进行设置）
/// @param age 用户年龄
+ (void)createUserAge:(NSString *)age;

/// 推荐统计
/// @param eventID 事件类型
/// @param sourceID 推荐sourceID
/// @param ugcType 推荐条目类型与现有新鲜事类型一样
/// @param pack 服务端下发相应条目的pack
/// @param userID 自己
/// @param value 进度或是停留时间
/// @param imageIDArr 所有有效时间段内查看的进度总和 eventID==5 且是图片进度是有效
+ (void)addRecordWithEventID:(DRLRecordTimeLineType)eventID sourceID:(NSString *)sourceID ugcType:(NSString *)ugcType pack:(NSString *)pack userID:(NSString *)userID value:(CGFloat)value showImageArr:(NSArray *)imageIDArr allCount:(NSInteger)allPhotoCount;


@end

NS_ASSUME_NONNULL_END
