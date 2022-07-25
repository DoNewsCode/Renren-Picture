//
//  DRNUploadImageRequest.h
//  Renren-Network
//
//  Created by 张健康 on 2019/7/29.
//

#import "DNUploadImageRequest.h"

#import "NSString+DRNNetwork.h"
#import "NSString+SafeKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRNUploadImageRequest : DNUploadImageRequest

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
