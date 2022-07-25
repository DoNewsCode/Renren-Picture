//
//  DRLTimeLineHasRecordDBTable.h
//  Renren-Log
//
//  Created by 陈文昌 on 2020/2/11.
//

#import "DRLTimeLineBaseDBTable.h"

@class DRLTimeLineStaticModel;

NS_ASSUME_NONNULL_BEGIN

@interface DRLTimeLineHasRecordDBTable : DRLTimeLineBaseDBTable

/// 根据eventKey获取是否存在相同的记录
/// @param eventKey 查重标识
-(DRLTimeLineStaticModel *)getOneObjectWithEventKey:(NSString *)eventKey;

/// 根据需求删除30分钟以上的数据，提高查找效率
-(BOOL)deleteObjectWithOutOffTime;

@end

NS_ASSUME_NONNULL_END
