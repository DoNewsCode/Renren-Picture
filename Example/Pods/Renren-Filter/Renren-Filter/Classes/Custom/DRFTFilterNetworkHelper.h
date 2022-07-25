//
//  DRFTFilterNetworkHelper.h
//  Renren-Filter
//
//  Created by 张健康 on 2020/3/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRFTFilterNetworkHelper : NSObject
+ (void)loadFilterListSuccess:(void (^)(NSDictionary *dict))success failureBlock:(void (^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
