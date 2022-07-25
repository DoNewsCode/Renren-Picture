//
//  DRLTimeLineStaticManager.h
//  Renren-Log
//
//  Created by 陈文昌 on 2020/2/11.
//

#import <Foundation/Foundation.h>

static NSString * _Nullable const DRTCallRecordEvent_DRL_endCall = @"DRTCallRecordEvent_DRL_endCall";// 挂断的通知
static NSString * _Nullable const DRTCallRecordEvent_DRL_startCall = @"DRTCallRecordEvent_DRL_startCall";// 来电的通知

typedef NS_ENUM(NSInteger, DRLRecordTimeLineType) {//事件类型
    DRLRecordTimeLineTypeMayClick = 1,//疑似点击
    DRLRecordTimeLineTypeShow,//展示
    DRLRecordTimeLineTypeClick,//点击
    DRLRecordTimeLineTypeStayTime,//停留时间
    DRLRecordTimeLineTypeProgress,// 完成度
};

NS_ASSUME_NONNULL_BEGIN

@interface DRLTimeLineStaticManager : NSObject

/// 初始化
+ (DRLTimeLineStaticManager *)shareManager;

/// 开启推荐统计
- (void)startRecommendRecord;

/// 修改上报地址
/// @param isTest 是否是测试
- (void)changeUpdateHostIsTest:(BOOL)isTest;


/// 推荐统计
/// @param eventID 事件类型
/// @param sourceID 推荐sourceID
/// @param ugcType 推荐条目类型与现有新鲜事类型一样
- (void)addRecordWithEventID:(DRLRecordTimeLineType)eventID sourceID:(NSString *)sourceID ugcType:(NSString *)ugcType pack:(NSString *)pack userID:(NSString *)userID value:(CGFloat)value showImageArr:(nonnull NSArray *)imageIDArr allCount:(NSInteger)allPhotoCount;

@end

NS_ASSUME_NONNULL_END
