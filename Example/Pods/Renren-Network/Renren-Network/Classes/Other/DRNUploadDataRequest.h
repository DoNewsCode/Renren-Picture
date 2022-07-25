//
//  DRNUploadDataRequest.h
//  Renren-Network
//
//  Created by Ming on 2019/12/16.
//

#import "DNUploadDataRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRNUploadDataRequest : DNUploadDataRequest

/** api key */
@property(nonatomic,copy) NSString *api_key;
/** api版本 */
@property(nonatomic,copy) NSString *v;
/** version */
@property(nonatomic,copy) NSString *version;
/** misc */
@property(nonatomic,copy) NSString *misc;

/** app id */
@property(nonatomic,copy, readonly) NSString *app_id;
/** call id */
@property(nonatomic,copy, readonly) NSString *call_id;
/** session_key */
@property(nonatomic,copy, readonly) NSString *session_key;
/** uniq_id */
@property(nonatomic,copy, readonly) NSString *uniq_id;
/** uniq_key */
@property(nonatomic,copy, readonly) NSString *uniq_key;
/** client_info */
@property(nonatomic,copy, readonly) NSString *client_info;
/** sig */
@property(nonatomic,copy, readonly) NSString *sig;

@end

NS_ASSUME_NONNULL_END
