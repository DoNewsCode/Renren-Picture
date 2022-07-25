//
//  DRUChangNickNameInfoRequest.h
//  Renren-UserKit
//
//  Created by 李晓越 on 2020/3/12.
//  只修改昵称

#import "DRUUserBaseGlobalRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRUChangNickNameInfoRequest : DRUUserBaseGlobalRequest

/// 新的昵称
@property(nonatomic,copy) NSString *nickName;

@end

NS_ASSUME_NONNULL_END
