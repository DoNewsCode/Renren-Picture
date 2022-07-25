//
//  DRUUser+WCTTableCoding.h
//  Renren-UserKit
//
//  Created by 李晓越 on 2020/3/3.
//

#import "DRUUser.h"
#import "WCDB/WCDB.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRUUser (WCTTableCoding)<WCTTableCoding>

WCDB_PROPERTY(loginAccountInfo)
WCDB_PROPERTY(userLoginInfo)
//WCDB_PROPERTY(userInfo)
WCDB_PROPERTY(userData)
WCDB_PROPERTY(status)

@end

NS_ASSUME_NONNULL_END
