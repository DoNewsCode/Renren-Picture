//
//  DRLTimeLineRecordNetWorkManager.m
//  Renren-Log
//
//  Created by 陈文昌 on 2020/2/12.
//

#import "DRLTimeLineRecordNetWorkManager.h"
#import "AFNetworking.h"
#import "AFNetworkReachabilityManager.h"
#import "AFNetworkActivityIndicatorManager.h"

static AFHTTPSessionManager *httpSessionManager;

@implementation DRLTimeLineRecordNetWorkManager

+ (void)load {
    
    httpSessionManager =  [[AFHTTPSessionManager manager] initWithBaseURL:nil];
    httpSessionManager.requestSerializer.timeoutInterval = 15.f;
    httpSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    // Accept代表发送端（客户端）希望接受的数据类型
    [httpSessionManager.requestSerializer setValue:@"*/*" forHTTPHeaderField:@"Accept"]; //需改告诉后台可以接受
    [httpSessionManager.requestSerializer setValue:@"*/*" forHTTPHeaderField:@"Content-Type"];
    httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    httpSessionManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}

+ (void)setRequestTimeoutInterval:(NSTimeInterval)time {
    
    httpSessionManager.requestSerializer.timeoutInterval = time;
    
}

+ (NSURLSessionTask *)POST:(NSString *)url params:(NSDictionary *)params body:(NSData *)body completionBlock:(void (^)(id _Nullable, NSError * _Nullable))completionBlock {
    
    
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    request.timeoutInterval= 15.0;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:body];
    
     NSURLSessionTask *sessionTask = [httpSessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
         
         completionBlock?completionBlock(responseObject,error):nil;
    }];
    [sessionTask resume];
    return sessionTask;
    
}


@end
