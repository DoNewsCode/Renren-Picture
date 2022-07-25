//
//  UIDevice+DRNNetwork.h
//  Renren-Network
//
//  Created by 陈金铭 on 2019/11/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (DRNNetwork)


+ (NSString *)ct_machineModel;
+ (NSString *)ct_carrierCode;
+ (NSString *)ct_machineModelName;

@end

NS_ASSUME_NONNULL_END
