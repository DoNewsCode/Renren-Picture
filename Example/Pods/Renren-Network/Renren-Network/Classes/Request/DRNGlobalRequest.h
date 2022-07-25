//
//  DRNGlobalRequest.h
//  Renren-Network
//
//  Created by Ming on 2019/12/16.
//  须知：sig无需实现parametersDictionary 继承此类的 sig统一生成 公共参数统一生成无需赋值，该类配合DRUserKit使用，具体参照DRNNetwork 中规定；

#import "DRNBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRNGlobalRequest : DRNBaseRequest

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


/** sig */
@property(nonatomic,copy, readonly) NSString *gz;
/** sig */
@property(nonatomic,copy, readonly) NSString *format;
/** sig */
@property(nonatomic,copy, readonly) NSString *clientInfo;
/** sig */
@property(nonatomic,copy, readonly) NSString *uniqKey;

@end

NS_ASSUME_NONNULL_END
