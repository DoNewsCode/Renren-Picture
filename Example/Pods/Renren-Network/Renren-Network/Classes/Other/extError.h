//
//  RRError.h
//  xiaonei
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 人人Rest接口错误返回代码定义.
 */
typedef NS_ENUM(NSInteger, RRErrorCode){
	RRErrorCodeSuccess						= 99999999,// 自定义,表示成功.
	RRErrorCodeUnknowError					= 1, // 未知错误
	RRErrorCodeServiceUnavailable			= 2, // 服务临时不可用，请您稍候再试
	RRErrorCodeUnknowMethodError            = 3, // 未知方法错误
	RRErrorCodeRequestTooFast				= 4, // 操作过于频繁
	RRErrorCodeRequestXOAError				= 5, // XOA服务异常，请稍候重试（依赖接口问题）
    RRErrorCodeLocationTimeout              = 6, // 定位超时
    RRErrorCodeLocationCacheNotFound        = 7, // 在缓存内没有找到经纬度
    RRErrorCodeLocationDeny                 = 8, // 不能访问用户的定位服务
    RRErrorCodeAntispam						= 10, // 发布内容不合法（antispam统一返回数据）
    RRErrorCodeBlackListForbidde			= 20006, // 黑名单限制访问
    RRErrorCodeEcShareSourceForbidden		= 20300, // 用户权限禁止分享
    RRErrorCodePrivacyLimit					= 200, // 由于对方的隐私设置，您没有权限执行该操作
    RRErrorCodeCountWordLimit               = 20002, //发布的字数超过限制;
    RRErrorCodeGroupFeedAntispam            = 27415, //群feed发状态含违禁词
    RRErrorCodeGroupFeedCommentAntispam     = 29003, //群feed评论含违禁词
    RRErrorCodeSchoolPagePublishForbidden   = 31115, // 校园论坛被禁言
    RRErrorCodeRequestParamsError           = 10207, // 请求参数错误
    RRErrorCodeNetworkError                 = -1009,
    RRErrorCodeNotFount                     = 20001,//不存在
    RRErrorCodegroupNotExist                = 27100,//群组不存在
    RRErrorCodeNotExist                     = 29010,//不存在
    RRErrorCodeVideoNotExist                = 2201
} ;

typedef NS_ENUM(NSInteger, LoginErrorType) {
    ELoginSessionKeyError = 102,
    ELoginInvalidSIError = 104,
    ELoginAccessTokenError = 106,
    ELoginUserAudit = 10003,
    ELoginUserBand = 10004,
    ELoginUserSuicide = 10005,
};

@interface extError : NSError {
	
}

/**
 * 返回用于展现给用户的错误提示标题
 */
- (NSString*)titleForError;

/**
 * 返回由Rest接口错误信息构建的错误对象.
 */
+ (extError*)errorWithRestInfo:(NSDictionary*)restInfo;

/**
 * 返回由NSError构建的错误对象.
 */
+ (extError*)errorWithNSError:(NSError*)error;

/**
 * 构造RRError错误。
 *
 * @param code 错误代码
 * @param errorMessage 错误信息
 *
 * 返回错误对象.
 */
+ (extError*)errorWithCode:(NSInteger)code errorMessage:(NSString*)errorMessage;

/**
 * 返回调用Rest Api 的 method字段的值.
 */
- (NSString*)methodForRestApi;

+ (BOOL)isNeedLoginAgainError:(NSInteger)errCode;

@end
