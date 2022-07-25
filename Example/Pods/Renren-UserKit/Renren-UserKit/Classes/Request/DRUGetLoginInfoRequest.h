//
//  DRUGetLoginInfoRequest.h
//  Renren-UserKit
//
//  Created by 李晓越 on 2020/4/22.
//

#import "DRUUserBaseGlobalRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRUGetLoginInfoRequest : DRNBaseRequest

/** app id */
@property(nonatomic,copy) NSString *app_id;
/** api key */
@property(nonatomic,copy) NSString *api_key;
@property(nonatomic,strong) NSString *session_key;
@property(nonatomic,strong) NSString *secret_key;
@property(nonatomic,strong) NSString *client_info;
@property(nonatomic,strong) NSString *version;
@property(nonatomic,strong) NSString *v;

@property(nonatomic,copy) NSString *call_id;

@end

NS_ASSUME_NONNULL_END
