//
//  DRNPublicResult.h
//  AFNetworking
//
//  Created by Ming on 2020/6/3.
//

#import <Foundation/Foundation.h>

#import "YYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRNPublicResult : NSObject

/// 错误码
@property (nonatomic, assign) NSInteger errorCode;
/// 错误信息
@property (nonatomic, copy) NSString *errorMsg;
/// 数据
@property (nonatomic, strong) id data;

@end

NS_ASSUME_NONNULL_END
