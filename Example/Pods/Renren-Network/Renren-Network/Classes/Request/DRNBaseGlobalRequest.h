//
//  DRNBaseGlobalRequest.h
//  Pods-Renren-Network_Example
//
//  Created by Ming on 2019/3/21.
//  全局属性处理，如请求不需全局属性处理则可直接继承自DRNBaseRequest

#import "DRNBaseRequest.h"

#import "DRNMacro.h"

NS_ASSUME_NONNULL_BEGIN

/// 对于
@interface DRNBaseGlobalRequest : DRNBaseRequest

/** app id */
@property(nonatomic,copy) NSString *app_id;
/** api key */
@property(nonatomic,copy) NSString *api_key;
/** api版本 */
@property(nonatomic,copy) NSString *v;
/** call id */
@property(nonatomic,copy) NSString *call_id;
/** uniq_id */
@property(nonatomic,copy) NSString *uniq_id;
/** uniq_key */
@property(nonatomic,copy) NSString *uniq_key;
/** version */
@property(nonatomic,copy) NSString *version;
/** client_info */
@property(nonatomic,copy) NSString *client_info;
/** misc */
@property(nonatomic,copy) NSString *misc;
/** sig */
@property(nonatomic,copy) NSString *sig;
@end

NS_ASSUME_NONNULL_END
