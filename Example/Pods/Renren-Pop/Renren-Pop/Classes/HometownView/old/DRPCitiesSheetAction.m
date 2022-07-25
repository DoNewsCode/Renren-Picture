//
//  DRPCitiesSheetAction.m
//  DNPop
//
//  Created by 李晓越 on 2019/8/31.
//

#import "DRPCitiesSheetAction.h"
#import "DRPCitiesSheetView.h"

@implementation DRPCitiesSheetAction

+ (instancetype)actionWithSelectProvince:(NSString *)selectProvince
                              selectCity:(NSString *)selectCity
                               doneBlock:(void(^)(NSString *province,
                                                  NSString *cityName,
                                                  NSString *cityId,
                                                  NSString *result))doneBlock
                             cancelBlock:(void (^)(void))cancelBlock
{
    DRPCitiesSheetAction *customAlertAction = [[DRPCitiesSheetAction alloc] init];
    
    DRPCitiesSheetView *citiesSheetView = [[DRPCitiesSheetView alloc] initWithSelectProvince:selectProvince selectCity:selectCity doneBlock:doneBlock cancelBlock:cancelBlock];
    customAlertAction.style = DNPopActionStyleCustom;
    customAlertAction.item = citiesSheetView;
    
    return customAlertAction;
}

@end
