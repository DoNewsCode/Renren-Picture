//
//  DRLLogMessage+WCTTableCoding.h
//  Renren-Library
//
//  Created by 陈金铭 on 2019/8/12.
//

#import "DRLLogMessage.h"
#import "WCDB/WCDB.h"


@interface DRLLogMessage (WCTTableCoding) <WCTTableCoding>

// 需要绑定到表中的字段在这里声明，在.mm中去绑定
WCDB_PROPERTY(localID)
WCDB_PROPERTY(type)
WCDB_PROPERTY(title)
WCDB_PROPERTY(desc)
WCDB_PROPERTY(content)
WCDB_PROPERTY(remark)
WCDB_PROPERTY(appVersion)
WCDB_PROPERTY(appBuild)
WCDB_PROPERTY(createTime)
WCDB_PROPERTY(modifiedTime)


@end

