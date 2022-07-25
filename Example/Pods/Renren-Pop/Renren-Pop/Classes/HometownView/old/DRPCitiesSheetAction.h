//
//  DRPCitiesSheetAction.h
//  DNPop
//
//  Created by 李晓越 on 2019/8/31.
//

#import <DNPop/DNPopAction.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPCitiesSheetAction : DNPopAction


+ (instancetype)actionWithSelectProvince:(NSString *)selectProvince
                              selectCity:(NSString *)selectCity
                               doneBlock:(void(^)(NSString *province,
                                                  NSString *cityName,
                                                  NSString *cityId,
                                                  NSString *result))doneBlock
                             cancelBlock:(void (^)(void))cancelBlock;
@end

NS_ASSUME_NONNULL_END
