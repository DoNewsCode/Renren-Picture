//
//  DRPRequestManger.h
//  Renren-Personal
//
//  Created by 李晓越 on 2019/10/16.
//

#import <Foundation/Foundation.h>
#import "DRMEBaseGlobalRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRMERequestManger : NSObject

/**
 管理网络请求类，防止多次请求

 @return 单例
 */
+ (DRMERequestManger *)shareManager;

/**
 是否包含网络类型

 @return yes no
 */
- (BOOL)hasRequestClass:(DRMEBaseGlobalRequest *)request;

/**
 添加a网络记录
 */
- (void)addRequest:(DRMEBaseGlobalRequest *)request;

/**
 移出记录
 */
- (void)removeRequest:(DRMEBaseGlobalRequest *)request;

@end

NS_ASSUME_NONNULL_END
