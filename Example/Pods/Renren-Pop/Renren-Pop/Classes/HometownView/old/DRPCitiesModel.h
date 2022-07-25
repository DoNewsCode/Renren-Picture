//
//  DRPCitiesModel.h
//  RenRenRecallModule
//
//  Created by donews on 2019/1/23.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPCityModel : NSObject

@property(nonatomic,copy) NSString *cityID;
@property(nonatomic,copy) NSString *cityName;


@end

@interface DRPCitiesModel : NSObject

@property(nonatomic,strong) NSArray *cities;
@property(nonatomic,copy) NSString *province;

@end

NS_ASSUME_NONNULL_END
