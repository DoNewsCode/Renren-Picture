//
//  DRUProfileGetInfoViewModel.h
//  AFNetworking
//
//  Created by lixiaoyue on 2019/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRUProfileGetInfoViewModel : NSObject


- (void)loadDataProfileGetInfoWithUserid:(NSString *)uid
                             session_key:(NSString *)session_key
                                 successBlock:(void(^)(id  _Nonnull response))successBlock
                                 failureBlock:(void(^)(NSString *errorMsg))failureBlock;

@end

NS_ASSUME_NONNULL_END
