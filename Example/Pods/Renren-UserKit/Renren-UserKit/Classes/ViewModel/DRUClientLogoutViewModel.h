//
//  DNClientLogoutViewModel.h
//  AFNetworking
//
//  Created by lixiaoyue on 2019/6/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRUClientLogoutViewModel : NSObject

- (void)loadDataClientLogoutWithSession_id:(NSString *)session_id
                            successBlock:(void(^)(BOOL isLogoutSuccess))successBlock
                            failureBlock:(void(^)(NSString *errorMsg))failureBlock;

@end

NS_ASSUME_NONNULL_END
