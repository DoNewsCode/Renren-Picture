//
//  DRLTimeLineRecordNetWorkManager.h
//  Renren-Log
//
//  Created by 陈文昌 on 2020/2/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRLTimeLineRecordNetWorkManager : NSObject

/**
 设置请求超时时间:默认为15S
 @param time 时长
 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

/**
 POST 请求 目前接口仅支持post

 @param url 请求的url字符串
 @param params 请求的参数
 @param completionBlock 结果回调（同上）
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)url params:(NSDictionary *)params body:(NSData *)body completionBlock:(void(^)(id  _Nullable responseObject, NSError * _Nullable error))completionBlock;

@end

NS_ASSUME_NONNULL_END
