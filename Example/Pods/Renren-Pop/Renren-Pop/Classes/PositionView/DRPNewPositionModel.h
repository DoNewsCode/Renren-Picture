//
//  DRPNewPositionModel.h
//  Renren-Pop
//
//  Created by 李晓越 on 2019/9/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPNewPositionList :NSObject

/// 职位id
@property (nonatomic , copy) NSString * _id;
/// 职位名称
@property (nonatomic, copy) NSString * name;

@end

@interface DRPNewPositionModel :NSObject

/// 职位类型id
@property (nonatomic , copy) NSString * _id;
/// 职位类型名称
@property (nonatomic, copy) NSString * type;
/// 具体职位列表
@property (nonatomic, copy) NSArray<DRPNewPositionList *> * positionList;

@end

NS_ASSUME_NONNULL_END
