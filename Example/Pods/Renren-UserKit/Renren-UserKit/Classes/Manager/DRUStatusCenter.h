//
//  DRUStatusCenter.h
//  Renren-UserKit
//
//  Created by 陈金铭 on 2019/9/6.
//  状态中心

#import <Foundation/Foundation.h>

#import "DRUVideoStatus.h"
#import "DRUPushStatus.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRUStatusCenter : NSObject

/// 视频状态
@property(nonatomic, strong) DRUVideoStatus *videoStatus;
/// 推送状态
@property(nonatomic, strong) DRUPushStatus *pushStatus;

+ (instancetype)sharedStatusCenter;


@end

NS_ASSUME_NONNULL_END
