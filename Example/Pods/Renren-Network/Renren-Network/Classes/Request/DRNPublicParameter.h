//
//  DRNPublicParameter.h
//  AFNetworking
//
//  Created by Ming on 2020/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 公共参数类型
typedef NS_ENUM(NSUInteger, DRNPublicParameterType) {
    DRNPublicParameterTypeClient,
    DRNPublicParameterTypeUnique,
};


@interface DRNPublicParameter : NSObject

/// sessionKey （socket联接成功后下发）
@property(nonatomic, copy) NSString *sessionKey;
/// uniqKey（登陆成功后下发）
@property(nonatomic, copy) NSString *uniqKey;
/// 密钥（登陆成功后下发）
@property(nonatomic,copy) NSString *uniqID;
/// 用户的密钥 （登陆前使用默认的，登陆后由登录接口下发）
@property(nonatomic,copy) NSString *secretKey;

/// GZip压缩返回值
@property(nonatomic,copy) NSString *gz;

/// 以下参数无需赋值
/// GlobalParameterType
@property(nonatomic, assign, readonly) DRNPublicParameterType type;
/// appID
@property(nonatomic,copy, readonly) NSString *appID;
/// 客户端信息 clientInfo
@property(nonatomic,copy, readonly) NSString *clientInfo;

@end

NS_ASSUME_NONNULL_END
