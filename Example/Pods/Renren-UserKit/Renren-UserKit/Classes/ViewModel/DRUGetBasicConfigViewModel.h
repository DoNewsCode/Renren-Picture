//
//  DRUGetBasicConfigViewModel.h
//  AFNetworking
//
//  Created by 李晓越 on 2019/6/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRUGetBasicConfigViewModel : NSObject


/**
 获取当前登录用户的主隐私

 @param successBlock isSuccess:是否成功; has_right:当has_right=0时 封闭隐私，当has_right=99时 是开放隐私
 @param failureBlock 错误信息
 */
- (void)loadDataGetBasicConfigWithSession_key:(NSString *)session_key
                                          uid:(NSString *)uid
                                 successBlock:(void(^)(BOOL isSuccess, NSInteger has_right))successBlock
                                 failureBlock:(void(^)(NSString *errorStr))failureBlock;


@end

NS_ASSUME_NONNULL_END
