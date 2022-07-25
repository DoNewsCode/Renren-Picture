//
//  DRNBaseEarRequest.h
//  Renren-Network
//
//  Created by 陈金铭 on 2019/11/27.
//

#import "DRNBaseRequest.h"


NS_ASSUME_NONNULL_BEGIN

@interface DRNBaseEarRequest : DRNBaseRequest


- (void)lodaDataWithSuccessBlock:(void(^)(id response))successBlock
                      faileBlock:(void(^)(NSString *error_msg))failureBlock;

@end

NS_ASSUME_NONNULL_END
