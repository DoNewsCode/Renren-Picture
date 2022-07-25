//
//  DRUGetBindInfoRequest.h
//  Renren-Personal
//
//  Created by 李晓越 on 2019/9/5.
//

#import "DRUUserBaseGlobalRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRUGetBindInfoRequest : DRUUserBaseGlobalRequest
/**
 当前登录用户ID
 */
@property (nonatomic, copy) NSString *userId;
@end

NS_ASSUME_NONNULL_END
