//
//  DRLLog.h
//  Renren-Library
//
//  Created by 陈金铭 on 2019/8/10.
//  处理LOG

#import <Foundation/Foundation.h>
#import "DRLLogMessage.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DRLLogType) {//物料类型
    DRLLogTypeNormal = 0,//常规
    DRLLogTypeStatistic,//统计事件
    DRLLogTypeAPINormal,//接口类统计
    DRLLogTypeAPIError,//接口报错类
};

typedef NS_ENUM(NSInteger, DRLLogOrder) {//物料类型
    DRLLogOrderAsc = 0,//正序
    DRLLogOrderDesc,//倒序
};


@protocol DRLLogDelegate <NSObject>

@optional
- (void)newLogMessage:(DRLLogMessage *)logMessage;

- (void)updateLogMessage:(DRLLogMessage *)logMessage;

- (void)deleteLogMessage:(DRLLogMessage *)logMessage;

- (void)deleteLogMessages:(NSArray<DRLLogMessage *> *)logMessages;

@end

typedef void(^DRLLogResultBlock)(NSArray<DRLLogMessage *> *messages);
typedef void(^DRLLogCompletionBlock)(DRLLogMessage *message);

@interface DRLLog : NSObject


/** 本地保存日志条数限制 默认10000条 */
@property(nonatomic, assign) NSUInteger saveLimit;
@property(nonatomic, weak) id<DRLLogDelegate> delegate;
@property(nonatomic, weak) id<DRLLogDelegate> masterDelegate;

+ (instancetype)sharedLog;

//- (void)setLogEnabled:(BOOL)enabled;

- (void)addLog:(nonnull NSString *)content;
- (void)addLogWithType:(DRLLogType)type content:(nullable NSString *)content;
- (void)addLogWithType:(DRLLogType)type title:(nullable NSString *)title content:(nullable NSString *)content;
- (void)addLogWithType:(DRLLogType)type title:(nullable NSString *)title desc:(nullable NSString *)desc content:(nullable NSString *)content;
- (void)addLogWithType:(DRLLogType)type title:(nullable NSString *)title desc:(nullable NSString *)desc content:(nullable NSString *)content remark:(nullable NSString *)remark;

/// 添加日志
/// @param type 日志类型
/// @param title 标题（通常在1、统计类型中该字段为向后端传递的事件名称；2、在接口类统计中为接口名称）
/// @param desc 描述（通常在1、统计类型中该字段为向后端传递的事件类型；2、在接口类统计中为接口请求参数）
/// @param content 内容（通常在1、统计类型中该字段为向后端传递的附加内容；2、在接口类统计中为接口返回参数）
/// @param remark  备注（通常在1、统计类型中该字段为向后端传递的备注信息可忽略；2、在接口类统计中为请求时长，异常情况等）
/// @param completion 完成回调
- (void)addLogWithType:(DRLLogType)type title:(nullable NSString *)title desc:(nullable NSString *)desc content:(nullable NSString *)content remark:(nullable NSString *)remark completion:(nullable DRLLogCompletionBlock)completion;


/// 日志更新（仅支持对content,remark,desc字段的更改）
/// @param message 日志模型
- (void)updateLogWith:(DRLLogMessage *)message;

- (void)obtainAllMessagesWithResultBlock:(DRLLogResultBlock)resultBlock;
- (void)obtainMessagesWithResultBlock:(DRLLogResultBlock)resultBlock;
- (void)obtainMessagesWithCurrentMessage:(nullable DRLLogMessage *)currentMessage resultBlock:(DRLLogResultBlock)resultBlock;
- (void)obtainMessagesWithCurrentMessage:(nullable DRLLogMessage *)currentMessage limit:(NSUInteger)limit resultBlock:(DRLLogResultBlock)resultBlock;
- (void)obtainMessagesWithCurrentMessage:(nullable DRLLogMessage *)currentMessage limit:(NSUInteger)limit order:(DRLLogOrder)order resultBlock:(DRLLogResultBlock)resultBlock;

/**
 获取日志

 @param currentMessage 当前日志
 @param limit 限制条数，默认50
 @param order 排序
 @param type 类型
 @param resultBlock 返回结果
 */
- (void)obtainMessagesWithCurrentMessage:(nullable DRLLogMessage *)currentMessage limit:(NSUInteger)limit order:(DRLLogOrder)order type:(DRLLogType)type resultBlock:(DRLLogResultBlock)resultBlock;



@end

NS_ASSUME_NONNULL_END
