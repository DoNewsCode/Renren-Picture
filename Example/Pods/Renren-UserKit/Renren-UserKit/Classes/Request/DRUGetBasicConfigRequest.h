//
//  DRUGetBasicConfigRequest.h
//  AFNetworking
//
//  Created by 李晓越 on 2019/6/24.
//

#import "DRUUserBaseGlobalRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRUGetBasicConfigRequest : DRUUserBaseGlobalRequest

@property(nonatomic,copy) NSString *session_key;
@property(nonatomic,copy) NSString *uid;

@end

NS_ASSUME_NONNULL_END
