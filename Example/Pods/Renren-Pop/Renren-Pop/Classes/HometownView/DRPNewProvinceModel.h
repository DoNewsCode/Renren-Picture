//
//  DRPNewProvinceModel.h
//  RenRenRecallModule
//
//  Created by donews on 2019/1/23.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPNewRegionModel : NSObject

/// 城市id
@property (nonatomic , copy) NSString * _id;
/// 省份id
@property (nonatomic , copy) NSString * provinceId;
@property (nonatomic , assign) NSInteger count;
/// 城市名称
@property (nonatomic , copy) NSString * name;

@end

@interface DRPNewProvinceModel : NSObject

/// 省份名称id?
@property (nonatomic , copy) NSString * _id;
/// 城市列表
@property (nonatomic , copy) NSArray<DRPNewRegionModel *> * regionList;
/// 国家id
@property (nonatomic , copy) NSString * countryId;
/// 省份名称
@property (nonatomic , copy) NSString * name;

@end

NS_ASSUME_NONNULL_END
