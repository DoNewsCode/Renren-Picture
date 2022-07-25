//
//  DRLTimeLineFailRecordDBTable.h
//  Renren-Log
//
//  Created by 陈文昌 on 2020/2/12.
//

#import "DRLTimeLineBaseDBTable.h"

@class DRLTimeLineStaticModel;

NS_ASSUME_NONNULL_BEGIN

@interface DRLTimeLineFailRecordDBTable : DRLTimeLineBaseDBTable

/// 获取历史
/// @param eventKey 主见
-(DRLTimeLineStaticModel *)getOneObjectWithEventKey:(NSString *)eventKey;

/// 上报成功删除一个数据
/// @param eventKey 主键
-(BOOL)deleteObjectWithEventKey:(NSString *)eventKey;

@end

NS_ASSUME_NONNULL_END
