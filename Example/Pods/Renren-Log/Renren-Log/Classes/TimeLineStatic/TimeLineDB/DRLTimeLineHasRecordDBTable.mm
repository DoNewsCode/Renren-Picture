//
//  DRLTimeLineHasRecordDBTable.m
//  Renren-Log
//
//  Created by 陈文昌 on 2020/2/11.
//

#import "DRLTimeLineHasRecordDBTable.h"
#import "DRLTimeLineDBManager.h"
#import <WCDB/WCDB.h>
#import "DRLTimeLineStaticModel.h"

static NSString * const kTimeLine_HasRecordTable = @"kTimeLine_HasRecordTable";

@implementation DRLTimeLineHasRecordDBTable

#pragma mark = 表的操作

- (void)creatRecordTable {
    self.tableName = kTimeLine_HasRecordTable;
    self.modelClass = [DRLTimeLineStaticModel class];
    
    [super creatRecordTable];
    
}


-(DRLTimeLineStaticModel *)getOneObjectWithEventKey:(NSString *)eventKey{
    
  return   [[DRLTimeLineDBManager shareManager].dataBase getOneObjectOfClass:self.modelClass fromTable:self.tableName where: DRLTimeLineStaticModel.event_key == eventKey];
}

-(BOOL)deleteObjectWithOutOffTime{
    
    long long levelTime = 30*60*1000;
    
    
    
    return  [[DRLTimeLineDBManager shareManager].dataBase deleteObjectsFromTable:self.tableName where: DRLTimeLineStaticModel.event_time < ([DRLTimeLineDBManager shareManager].curentTimemm-levelTime)];
}


@end
