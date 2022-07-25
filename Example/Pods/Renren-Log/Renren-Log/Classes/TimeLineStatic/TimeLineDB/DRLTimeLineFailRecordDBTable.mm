//
//  DRLTimeLineFailRecordDBTable.m
//  Renren-Log
//
//  Created by 陈文昌 on 2020/2/12.
//

#import "DRLTimeLineFailRecordDBTable.h"

#import "DRLTimeLineDBManager.h"
#import <WCDB/WCDB.h>
#import "DRLTimeLineStaticModel.h"

static NSString * const kTimeLine_FailRecordTable = @"kTimeLine_FailRecordTable";

@implementation DRLTimeLineFailRecordDBTable

#pragma mark = 表的操作

- (void)creatRecordTable {
    self.tableName = kTimeLine_FailRecordTable;
    self.modelClass = [DRLTimeLineStaticModel class];
    
    [super creatRecordTable];
    
}


-(DRLTimeLineStaticModel *)getOneObjectWithEventKey:(NSString *)eventKey{
    
  return   [[DRLTimeLineDBManager shareManager].dataBase getOneObjectOfClass:self.modelClass fromTable:self.tableName where: DRLTimeLineStaticModel.event_key == eventKey];
}

-(BOOL)deleteObjectWithEventKey:(NSString *)eventKey{
    
    return  [[DRLTimeLineDBManager shareManager].dataBase deleteObjectsFromTable:self.tableName where: DRLTimeLineStaticModel.event_key == eventKey];
}


-(BOOL)deleteObjectWithOutOffTime{
    
    long long levelTime = 30*60*1000;
    
    
    
    return  [[DRLTimeLineDBManager shareManager].dataBase deleteObjectsFromTable:self.tableName where: DRLTimeLineStaticModel.event_time < ([DRLTimeLineDBManager shareManager].curentTimemm-levelTime)];
}

@end
