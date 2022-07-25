//
//  DRLTimeLineDBManager.h
//  Renren-Log
//
//  Created by 陈文昌 on 2020/2/11.
//

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>

#import "DRLTimeLineHasRecordDBTable.h"
#import "DRLTimeLineFailRecordDBTable.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRLTimeLineDBManager : NSObject

/**
 *  数据库
 */
@property (nonatomic, strong) WCTDatabase *dataBase;

/**
 *  y已经记录上报的数据
 */
@property (nonatomic, strong) DRLTimeLineHasRecordDBTable *hasRecordTable;
/**
 *  上报失败需要重新上报的数据
 */
@property (nonatomic, strong) DRLTimeLineFailRecordDBTable *failRecodTable;

+ (DRLTimeLineDBManager *)shareManager;


/// 获取当前的毫秒时间
- (long long)curentTimemm;

@end

NS_ASSUME_NONNULL_END
