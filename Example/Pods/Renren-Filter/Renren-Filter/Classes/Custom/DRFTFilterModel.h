//
//  DRFTFilterModel.h
//  Renren-Filter
//
//  Created by 张健康 on 2020/3/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 "id": 4
 "name": "拿坡里黄",
 "icon": "http://xxx.png",
 "intensity": 1.f,
 */

@interface DRFTFilterModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) CGFloat intensity;
@property (nonatomic, assign) CGFloat maxIntensity;
@property (nonatomic, copy) NSString *desc;

@end

NS_ASSUME_NONNULL_END
