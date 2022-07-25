//
//  DRFTFilterNetworkHelper.m
//  Renren-Filter
//
//  Created by 张健康 on 2020/3/10.
//

#import "DRFTFilterNetworkHelper.h"
#import "DRFTFilterManager+Private.h"

#define filter_url_debug @"http://xyoss.g.com.cn/static/appupgrade/renren_filters_d.json"

#define filter_url @"http://xyoss.g.com.cn/static/appupgrade/renren_filters.json"
@implementation DRFTFilterNetworkHelper

+ (void)loadFilterListSuccess:(void (^)(NSDictionary *dict))success failureBlock:(void (^)(NSError *error))failure{
    
    NSString *urlStr;
    if ([DRFTFilterManager manager].debug) {
        urlStr = filter_url_debug;
    }else{
        urlStr = filter_url;
    }
    //如果想要设置网络超时的时间的话，可以使用下面的方法：
    urlStr = [urlStr stringByAppendingFormat:@"?v=%ld&t=%ld",[[DRFTFilterManager manager] filterVersion],(NSInteger)[[NSDate date] timeIntervalSince1970]*1000];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    //设置请求类型
    request.HTTPMethod = @"GET";
    NSLog(@"POST-Header:%@",request.allHTTPHeaderFields);
    
    //把参数放到请求体内
//    NSString *postStr = [self parseParams:@{@"v":[NSString stringWithFormat:@"%ld",[[DRFTFilterManager manager] filterVersion]],@"t":@([[NSDate date] timeIntervalSince1970]*1000)}];
//    request.HTTPBody = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) { //请求失败
            failure(error);
        } else {  //请求成功
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            success(dic);
        }
    }];
    [dataTask resume];  //开始请求
}

//重新封装参数 加入app相关信息
//重新封装参数 加入app相关信息
+ (NSString *)parseParams:(NSDictionary *)params
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:params];
//    [parameters setValue:@"ios" forKey:@"client"];
//    [parameters setValue:@"请替换版本号" forKey:@"auth_version"];
//    NSString* phoneModel = @"获取手机型号" ;
//    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];//ios系统版本号
//    NSString *system = [NSString stringWithFormat:@"%@(%@)",phoneModel, phoneVersion];
//    [parameters setValue:system forKey:@"system"];
//    NSDate *date = [NSDate date];
//    NSTimeInterval timeinterval = [date timeIntervalSince1970];
//    [parameters setObject:[NSString stringWithFormat:@"%.0lf",timeinterval] forKey:@"auth_timestamp"];//请求时间戳
//    NSString *devicetoken = @"请替换DeviceToken";
//    [parameters setValue:devicetoken forKey:@"uuid"];
    NSLog(@"请求参数:%@",parameters);

    NSString *keyValueFormat;
    NSMutableString *result = [NSMutableString new];
    //实例化一个key枚举器用来存放dictionary的key
   
   //加密处理 将所有参数加密后结果当做参数传递
   //parameters = @{@"i":@"加密结果 抽空加入"};
   
    NSEnumerator *keyEnum = [parameters keyEnumerator];
    id key;
    while (key = [keyEnum nextObject]) {
        keyValueFormat = [NSString stringWithFormat:@"%@=%@&", key, [params valueForKey:key]];
        [result appendString:keyValueFormat];
    }
    return result;
}
@end
