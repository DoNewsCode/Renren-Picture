//
//  DRPCitysSheetAction.m
//  DNPop
//
//  Created by 李晓越 on 2019/8/31.
//

#import "DRPCitysSheetAction.h"
#import "DRPCitysSheetView.h"

@implementation DRPCitysSheetAction

+ (instancetype)actionWith:(NSString *)selectProvince
                selectCity:(NSString *)selectCity
                  cityList:(NSArray *)cityList
                 doneBlock:(void(^)(NSString *provinceName,
                                    NSString *cityName,
                                    NSString *provinceId,
                                    NSString *cityId,
                                    NSString *result))doneBlock
               cancelBlock:(void (^)(void))cancelBlock
{
    DRPCitysSheetAction *customAlertAction = [[DRPCitysSheetAction alloc] init];
    
    DRPCitysSheetView *citiesSheetView = [[DRPCitysSheetView alloc] initWith:selectProvince selectCity:selectCity cityList:cityList doneBlock:doneBlock cancelBlock:cancelBlock];
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = citiesSheetView;
    
    return customAlertAction;
}

@end
