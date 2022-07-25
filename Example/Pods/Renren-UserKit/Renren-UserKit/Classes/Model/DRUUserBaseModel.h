//
//  DRUUserBaseModel.h
//  RenRenRecallModule
//
//  Created by donews on 2019/1/18.
//  Copyright © 2019年 donews. All rights reserved.
//  接口返回数据时，统一处理的 BaseModel

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRUUserBaseModel : NSObject

/// code 网络状态 0成功，1失败
@property(nonatomic,assign) NSInteger code;
/// message  提示信息
@property(nonatomic,copy) NSString *message;
//@property(nonatomic,copy) NSString *error_msg;
//@property(nonatomic,copy) NSString *error;

/// 接口返回 有时code， 有时 error_code
@property(nonatomic,assign) NSInteger error_code;



@property(nonatomic,strong) id data;

@end

NS_ASSUME_NONNULL_END
