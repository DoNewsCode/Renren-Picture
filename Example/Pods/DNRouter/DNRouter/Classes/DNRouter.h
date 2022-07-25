//
//  DNRouter.h
//  DNRouter
//
//  Created by Ming on 2019/3/12.
//  实现原理与MGJRouter一致

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Tip
/// 可在load方法中使用Register方法完成注册

/// 用于routerParameters中
extern NSString *const DNRouterParameterURL;
extern NSString *const DNRouterParameterCompletion;
extern NSString *const DNRouterParameterUserInfo;

/// routerParameters内置的几个参数会需要配合上面定义的string使用
typedef void(^DNRouterHandler)(NSDictionary *routerParameters);

/// 需要返回一个 object，配合 objectForURL: 使用
typedef id _Nullable (^DNRouterObjectHandler)(NSDictionary *routerParameters);
//
/// 需要返回一个 object，配合 objectForURL: 使用
typedef void(^DNRouterCompletion)(id __nullable result);

@interface DNRouter : NSObject

#pragma mark - Register
/// 注册 URLPattern 对应的 Handler，在 handler 中可以初始化 VC，然后对 VC 做各种操作
/// @param URLPattern URL键值；带上 scheme，如 renren://beauty/:id
/// @param handler 该 block 会传一个字典，包含了注册的 URL 中对应的变量。假如注册的 URL 为 renren://beauty/:id 那么，就会传一个 @{@"id": 4} 这样的字典过来
+ (void)registerURLPattern:(NSString *__nullable)URLPattern toHandler:(DNRouterHandler)handler;

/// 注册 URLPattern 对应的 ObjectHandler，需要返回一个 object 给调用方
/// @param URLPattern URL键值；带上 scheme，如 mgj://beauty/:id
/// @param handler 该 block 会传一个字典，包含了注册的 URL 中对应的变量。假如注册的 URL 为 renren://beauty/:id 那么，就会传一个 @{@"id": 4} 这样的字典过来,自带的 key 为 @"url" 和 @"completion" (如果有的话)
+ (void)registerURLPattern:(NSString *__nullable)URLPattern toObjectHandler:(DNRouterObjectHandler)handler;

#pragma mark - Cancel
/// 取消注册某个 URL Pattern

/// @param URLPattern URL键值
+ (void)deregisterURLPattern:(NSString *__nullable)URLPattern;

#pragma mark - Open

/// 打开此 URL
/// 会在已注册的 URL -> Handler 中寻找，如果找到，则执行 Handler
/// @param URL 带 Scheme，如 renren://beauty/3
+ (void)openURL:(NSString *__nullable)URL;

/// 打开此 URL，同时当操作完成时，执行额外的代码
/// @param URL        带 Scheme 的 URL，如 renren://beauty/4
/// @param completion URL 处理完成后的 callback，完成的判定跟具体的业务相关
+ (void)openURL:(NSString *__nullable)URL completion:(DNRouterCompletion)completion;

/// 打开此 URL，带上附加信息，同时当操作完成时，执行额外的代码

/// @param URL 带 Scheme 的 URL，如 renren://beauty/4
/// @param userInfo 附加参数
/// @param completion URL 处理完成后的 callback，完成的判定跟具体的业务相关
+ (void)openURL:(NSString *__nullable)URL withUserInfo:(NSDictionary *__nullable)userInfo completion:(DNRouterCompletion)completion;

#pragma mark - Find

/// 查找谁对某个 URL 感兴趣，如果有的话，返回一个 object

/// @param URL URL键值
/// @return 被查找对象
+ (id)objectForURL:(NSString *__nullable)URL;

/// 查找谁对某个 URL 感兴趣，如果有的话，返回一个 objec

/// @param URL URL键值
/// @param userInfo 附加信息
/// @return 被查找对象
+ (id)objectForURL:(NSString *__nullable)URL withUserInfo:(NSDictionary *__nullable)userInfo;


#pragma mark - Judge
/// 判断是否可以打开URL
/// @param URL URL键值
/// @return 是否可以
+ (BOOL)canOpenURL:(NSString *__nullable)URL;

#pragma mark - Other
/// 调用此方法来拼接 urlpattern 和 parameters
///  #define MGJ_ROUTE_BEAUTY @"beauty/:id"
/// [DNRouter generateURLWithPattern:MGJ_ROUTE_BEAUTY, @[@13]];
/// @param pattern  URL键值
/// @param parameters 一个数组，数量要跟 pattern 里的变量一致
/// @return URL键值
+ (NSString *)generateURLWithPattern:(NSString *__nullable)pattern parameters:(NSArray *__nullable)parameters;

@end

NS_ASSUME_NONNULL_END
