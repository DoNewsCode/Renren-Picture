//
//  DRPCitysSheetAction.h
//  DNPop
//
//  Created by 李晓越 on 2019/8/31.
//

#import <DNPop/DNPopAction.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPCitysSheetAction : DNPopAction


+ (instancetype)actionWith:(NSString *)selectProvince
                selectCity:(NSString *)selectCity
                  cityList:(NSArray *)cityList
                 doneBlock:(void(^)(NSString *provinceName,
                                    NSString *cityName,
                                    NSString *provinceId,
                                    NSString *cityId,
                                    NSString *result))doneBlock
               cancelBlock:(void (^)(void))cancelBlock;
@end

NS_ASSUME_NONNULL_END
