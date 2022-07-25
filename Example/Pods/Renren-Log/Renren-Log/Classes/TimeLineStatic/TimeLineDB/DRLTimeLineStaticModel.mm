//
//  DRLTimeLineStaticModel.m
//  Renren-Log
//
//  Created by 陈文昌 on 2020/2/12.
//

#import "DRLTimeLineStaticModel.h"

@implementation DRLTimeLineStaticModel

WCDB_IMPLEMENTATION(DRLTimeLineStaticModel)    //该宏实现绑定到表

WCDB_SYNTHESIZE(DRLTimeLineStaticModel, event_time)    //该宏实现绑定到表的字段
WCDB_SYNTHESIZE(DRLTimeLineStaticModel, pack)
WCDB_SYNTHESIZE(DRLTimeLineStaticModel, event_id)
WCDB_SYNTHESIZE(DRLTimeLineStaticModel, value)
WCDB_SYNTHESIZE(DRLTimeLineStaticModel, imageIDArr)
WCDB_SYNTHESIZE(DRLTimeLineStaticModel, event_key)


// 约束宏定义数据库的主键
WCDB_PRIMARY(DRLTimeLineStaticModel, event_key)

@end
