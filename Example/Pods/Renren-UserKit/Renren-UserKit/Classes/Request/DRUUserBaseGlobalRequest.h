//
//  DRUUserBaseGlobalRequest.h
//  RenRenRecallModule
//
//  Created by donews on 2019/1/15.
//  Copyright © 2019年 donews. All rights reserved.
//  网络请求的基类，模块中所有的请求都应该继续这个类
//  有些必传的参数在基类里，如 api_key secretKey v call_id
//  这是一个 带有 请求参数 api_key secretKey v call_id 的基类，继承自 DNBaseRequest


//#import "DRNBaseGlobalRequest.h"

//#import "DRNGlobalRequest.h"
#import "DRNPublicRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRUUserBaseGlobalRequest : DRNPublicRequest

/**
 针对召回模块的网络返回数据单独进行了处理，所以请求统一调用这个方法，
 内部调用 startWithSuccess 后，对返回的数据进行了处理
 @param successBlock 中 response 为对应的 data，直接对 response 进行转模型处理
 @param failureBlock 中 errorStr 返回一个错误信息，直接「吐司」展示，有的地方还需要根据 baseModel 中的 code 或 error_code 做对应处理
 */
- (void)lodaDataWithSuccessBlock:(void(^)(id response))successBlock
                      faileBlock:(void(^)(NSString *error_msg, id response))failureBlock;

@end

NS_ASSUME_NONNULL_END
