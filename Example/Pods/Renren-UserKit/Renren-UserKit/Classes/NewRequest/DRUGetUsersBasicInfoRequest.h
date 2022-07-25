//
//  DRUGetUsersBasicInfoRequest.h
//  Renren-UserKit
//
//  Created by 李晓越 on 2020/6/9.
//

#import "DRUUserBaseGlobalRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRUGetUsersBasicInfoRequest : DRUUserBaseGlobalRequest

/// 访问的用户id
@property(nonatomic,copy) NSString *userId;

@end

NS_ASSUME_NONNULL_END
