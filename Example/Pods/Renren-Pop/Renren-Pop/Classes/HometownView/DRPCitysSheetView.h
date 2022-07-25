//
//  TCProfessionSheetView.h
//  Characters
//
//  Created by LiYue on 2018/4/23.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRPCitysSheetView : UIView


/**
 @param selectProvince 当外部已经选择过或定位到后，需要传入 省份
 @param selectCity 当外部已经选择过或定位到后，需要传入 城市
 */
- (instancetype)initWith:(NSString *)selectProvince
              selectCity:(NSString *)selectCity
                cityList:(NSArray *)cityList
               doneBlock:(void(^)(NSString *provinceName,
                                  NSString *cityName,
                                  NSString *provinceId,
                                  NSString *cityId,
                                  NSString *result))doneBlock
             cancelBlock:(void (^)(void))cancelBlock;

@end
