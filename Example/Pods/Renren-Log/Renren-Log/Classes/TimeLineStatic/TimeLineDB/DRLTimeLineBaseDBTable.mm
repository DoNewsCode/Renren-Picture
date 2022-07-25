//
//  DRLTimeLineBaseDBTable.m
//  Renren-Log
//
//  Created by 陈文昌 on 2020/2/12.
//

#import "DRLTimeLineBaseDBTable.h"
#import <WCDB/WCDB.h>

#import "DRLTimeLineDBManager.h"

@implementation DRLTimeLineBaseDBTable

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self creatRecordTable];
        
    }
    
    return self;
}


- (void)creatRecordTable {
    
    //创建表  注：该接口使用的是IF NOT EXISTS的SQL，因此可以用重复调用。不需要在每次调用前判断表或索引是否已经存在。
        BOOL result = [[DRLTimeLineDBManager shareManager].dataBase createTableAndIndexesOfName:self.tableName withClass:self.modelClass];
        
    //    //旧数据进行迁移
    //    if (isNewPath) {
    //        [self migrateOldData:oldUserPath];
    //    }
        
        if (!result) {
            NSLog(@"创建数据表失败tableName = %@",self.tableName);
            
        }else {
            NSLog(@"创建数据表成功tableName = %@",self.tableName);
        }
        
    
}

- (BOOL)insertObject:(id )object{

    return [[DRLTimeLineDBManager shareManager].dataBase insertObject:object into:self.tableName];
}

- (BOOL)insertObjects:(NSArray<id > *)objects
{
    return [[DRLTimeLineDBManager shareManager].dataBase insertObjects:objects into:self.tableName];
}

- (BOOL)insertOrReplaceObject:(id )object
{
    return [[DRLTimeLineDBManager shareManager].dataBase insertOrReplaceObject:object into:self.tableName];
}

- (BOOL)insertOrReplaceObjects:(NSArray *)objects{
    return [[DRLTimeLineDBManager shareManager].dataBase insertOrReplaceObjects:objects into:self.tableName];
}
#pragma mark 删

- (BOOL)deleteAllObjects{
    return [[DRLTimeLineDBManager shareManager].dataBase deleteAllObjectsFromTable:self.tableName];
}

#pragma mark 查
-(NSArray *)getAllObjects{
    
    return [[DRLTimeLineDBManager shareManager].dataBase getAllObjectsOfClass:self.modelClass fromTable:self.tableName];
    
}

@end
