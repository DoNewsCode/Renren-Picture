//
//  DRLTimeLineBaseDBTable.h
//  Renren-Log
//
//  Created by 陈文昌 on 2020/2/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRLTimeLineBaseDBTable : NSObject

/** 列表名字,子类进行赋值*/
@property (nonatomic, copy) NSString *tableName;

/** 模型类，子类进行赋值*/
@property (nonatomic, strong) Class modelClass;

/// 创建表，子类重写
- (void)creatRecordTable;

#pragma mark 增 / 改
- (BOOL)insertObject:(id)object;
- (BOOL)insertObjects:(NSArray *)objects;
- (BOOL)insertOrReplaceObject:(id )object;
- (BOOL)insertOrReplaceObjects:(NSArray *)objects;


#pragma mark 删
- (BOOL)deleteAllObjects;

#pragma mark 查
-(NSArray *)getAllObjects;

@end

NS_ASSUME_NONNULL_END
