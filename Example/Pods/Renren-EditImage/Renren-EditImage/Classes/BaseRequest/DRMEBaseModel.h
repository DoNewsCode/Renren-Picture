//
//  DRMEBaseModel.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRMEBaseModel : NSObject

/// code 网络状态 0成功，1失败
@property(nonatomic,assign) NSInteger code;
/// code 网络状态 1成功，其它失败
@property(nonatomic,assign) NSInteger result;
/// message  提示信息
@property(nonatomic,copy) NSString *message;

/// 接口返回 有时code， 有时 error_code
@property(nonatomic,assign) NSInteger error_code;
@property(nonatomic,copy) NSString *error_msg;

@property(nonatomic,copy) NSString *error;

@property(nonatomic,strong) id data;


@end

NS_ASSUME_NONNULL_END
