//
//  DRPUserInfoManager.h
//  Renren-Pop
//
//  Created by 李晓越 on 2020/4/15.
//

#import <Foundation/Foundation.h>
#import "DRPCheckTypeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRPUserInfoManager : NSObject


+ (instancetype)sharedInstance;

@property(nonatomic,assign) BOOL isCompleteCheck;

@end

NS_ASSUME_NONNULL_END
