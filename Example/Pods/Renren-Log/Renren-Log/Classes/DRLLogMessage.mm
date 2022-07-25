//
//  DRLLogMessage.m
//  Renren-Library
//
//  Created by 陈金铭 on 2019/8/10.
//

#import "DRLLogMessage.h"

#import <WCDB/WCDB.h>
#import "DRLLogMessage+WCTTableCoding.h"


@implementation DRLLogMessage

// 利用这个宏定义绑定到表的类
WCDB_IMPLEMENTATION(DRLLogMessage)

// 下面四个宏定义绑定到表中的字段
WCDB_SYNTHESIZE(DRLLogMessage, localID)
WCDB_SYNTHESIZE(DRLLogMessage, type)
WCDB_SYNTHESIZE(DRLLogMessage, title)
WCDB_SYNTHESIZE(DRLLogMessage, desc)
WCDB_SYNTHESIZE(DRLLogMessage, content)
WCDB_SYNTHESIZE(DRLLogMessage, remark)
WCDB_SYNTHESIZE(DRLLogMessage, appVersion)
WCDB_SYNTHESIZE(DRLLogMessage, appBuild)
WCDB_SYNTHESIZE(DRLLogMessage, createTime)
WCDB_SYNTHESIZE(DRLLogMessage, modifiedTime)

//WCDB_SYNTHESIZE_DEFAULT(DRLLogMessage, createTime, WCTDefaultTypeCurrentDate) //设置一个默认值

// 约束宏定义数据库的主键
WCDB_PRIMARY(DRLLogMessage, localID)

// 定义数据库的索引属性，它直接定义createTime字段为索引
// 同时 WCDB 会将表名 + "_index" 作为该索引的名称
WCDB_INDEX(DRLLogMessage, "_index", createTime)


@end
