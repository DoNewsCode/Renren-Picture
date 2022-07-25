//
//  DRNPublicBatchRequest.m
//  AFNetworking
//
//  Created by Ming on 2020/6/10.
//

#import "DRNPublicBatchRequest.h"

@implementation DRNPublicBatchRequest

- (NSMutableArray *)infoRequestList
{
    if (!_infoRequestList) {
        _infoRequestList = [NSMutableArray array];
    }
    return _infoRequestList;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sync = 0;
    }
    return self;
}

- (NSString *)requestUrl
{
    return MCS_HOST(@"/gateway/sub/v1/batchRun");
}

#pragma mark - Create Methods
- (void)createMethodWith:(NSArray<DRNPublicRequest *> *)requestArray {
    
    for (DRNPublicRequest *request in requestArray) {
        
        NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
        
        NSMutableDictionary *requestParameters = [NSMutableDictionary dictionaryWithDictionary:[request parametersDictionary]];
        
        
        // 区分get\post， 请求参数位置不同
        if (request.requestMethod == DNRequestMethodGET) {

            // 请求方法类型，get和post
            NSString *method = @"get";
            [requestDict setObject:method forKey:@"method"];
            
            // 请求完整的url
            NSString *url = request.requestUrl;
            
            // get请求，将参数是拼接到url后
            NSString *params = [self processRequestStringWith:requestParameters];
            
            url = [url stringByAppendingFormat:@"?%@", params];
            
            if (url) {
                [requestDict setObject:url forKey:@"url"];
            }
            
        } else if (request.requestMethod == DNRequestMethodPost)  {

            // 请求方法类型，get和post
            NSString *method = @"post";
            [requestDict setObject:method forKey:@"method"];
            
            // 请求完整的url
            NSString *url = request.requestUrl;
            
            // body  post方法请求的请求体
            // post 请求，设置body为请求参数
            NSString *body = requestParameters.yy_modelToJSONString;
            if (body) {
                [requestDict setObject:body forKey:@"body"];
            }
            
            if (url) {
                [requestDict setObject:url forKey:@"url"];
            }
            
        }
        
        /// headers  请求方法的请求头
        NSDictionary *headerDict = @{@"Content-Type": @"application/json"};
        [requestDict setObject:headerDict forKey:@"headers"];
       
        [self.infoRequestList addObject:requestDict];
    }
    
}


- (NSString *)processRequestStringWith:(NSDictionary *)dict {
    
    NSMutableString* buffer = [[NSMutableString alloc] initWithCapacity:0];
    for (id key in dict) {
        NSString* value = [NSString stringWithFormat:@"%@",[dict objectForKey:key]];
        value =  [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [buffer appendString:[NSString stringWithFormat:@"&%@=%@", key, value]];
    }
    if (buffer.length > 0) {
        NSString* ret = [buffer substringFromIndex:1];
        
        return ret;
    }
    return nil;
    
}

@end

