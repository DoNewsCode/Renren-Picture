//
//  DRUBatchgetRequest.h
//  Renren-UserKit
//
//  Created by 李晓越 on 2020/7/3.
//  批量获取用户设置信息

#import "DRUUserBaseGlobalRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRUBatchgetRequest : DRUUserBaseGlobalRequest

@property(nonatomic,strong) NSArray *userConfigTypeList;

@property(nonatomic,strong) NSArray *userId;

@end

NS_ASSUME_NONNULL_END
