//
//  DRUClientLogoutRequest.h
//  AFNetworking
//
//  Created by lixiaoyue on 2019/6/6.
//

#import "DRUUserBaseGlobalRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRUClientLogoutRequest : DRUUserBaseGlobalRequest

@property(nonatomic,copy) NSString *session_key;
@property(nonatomic,copy) NSString *session_id;
@property(nonatomic,assign) NSInteger push_type;


@end

NS_ASSUME_NONNULL_END
