//
//  DRNAPIManager.h
//  Renren-Network
//
//  Created by 张健康 on 2019/6/3.
//

#import <Foundation/Foundation.h>

#import "DRNURLConfig.h"

#import "DRNMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRNAPIManager : NSObject
/// 
@property (nonatomic, copy) NSString *MCSBaseUrl;

/// 重构接口使用
@property (nonatomic, copy) NSString *host;


//单例
+ (instancetype)sharedManager;



@end

NS_ASSUME_NONNULL_END
