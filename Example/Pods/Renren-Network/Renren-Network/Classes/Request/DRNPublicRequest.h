//
//  DRNPublicRequest.h
//  AFNetworking
//
//  Created by Ming on 2020/6/3.
//

#import "DRNBaseRequest.h"

#import "DRNPublicResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRNPublicRequest : DRNBaseRequest


/** api key */
@property(nonatomic,copy) NSString *appKey;
/** api版本 */
@property(nonatomic,copy) NSString *callId;
/** version */
@property(nonatomic,copy) NSString *sessionKey;
/** version */
@property(nonatomic,copy) NSString *sig;

/** gz */
@property(nonatomic,copy, readonly) NSString *gz;
/** format */
@property(nonatomic,copy, readonly) NSString *format;
/** clientInfo */
@property(nonatomic,copy, readonly) NSString *clientInfo;
/** uniqKey */
@property(nonatomic,copy, readonly) NSString *uniqKey;

@end

NS_ASSUME_NONNULL_END
