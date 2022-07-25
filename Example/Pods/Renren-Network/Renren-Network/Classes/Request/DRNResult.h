//
//  DRNResult.h
//  AFNetworking
//
//  Created by Ming on 2020/4/16.
//

#import <Foundation/Foundation.h>

#import "YYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRNResult : NSObject

/// 错误码
@property (nonatomic, assign) NSInteger error_code;
/// 没有数据的标记1没有新鲜事 2没有特别关注好友 有值表示没有数据
@property (nonatomic, assign) NSInteger code;
/// 错误码
@property (nonatomic, assign) NSInteger rspcode;

/// 评论等提交结果 1 为成功
@property (nonatomic, copy) NSString *result;
/// 错误信息
@property (nonatomic, copy) NSString *error_msg;
/// 错误信息
@property (nonatomic, copy) NSString *errormsg;
/// 重复举报
@property (nonatomic, copy) NSString *message;

@end

NS_ASSUME_NONNULL_END
