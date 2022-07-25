//
//  DRNBatchRequest.m
//  AFNetworking
//
//  Created by Ming on 2020/5/8.
//

#import "DRNBatchRequest.h"

@implementation DRNBatchRequest
#pragma mark - Override Methods

#pragma mark - Intial Methods
- (NSString *)requestUrl{
    return MCS_HOST(@"/batch/run");
}


#pragma mark - Create Methods
- (void)createMethodWith:(NSArray<DRNGlobalRequest *> *)requestArray {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (DRNGlobalRequest *request in requestArray) {
        NSMutableDictionary *realTimeTimeLineRequestParameters = [NSMutableDictionary dictionaryWithDictionary:[request parametersDictionary]];
        NSString *host = [DRNAPIManager sharedManager].MCSBaseUrl;
        if ([request.completeUrl containsString:host]) {
            NSString *method = @"";
            NSUInteger index = host.length;
            method = [request.completeUrl substringFromIndex:index];
            [realTimeTimeLineRequestParameters setValue:method forKey:@"method"];
        }
        [tempArray addObject:realTimeTimeLineRequestParameters];
    }
    
    NSString *methodFeed = [self processBatchMethodFeed:tempArray];
    self.method_feed = methodFeed;
}


#pragma mark - Process Methods
- (NSString *)processBatchMethodFeed:(NSArray<NSDictionary *> *)dicArr {
    
    NSMutableString* buffer = [[NSMutableString alloc] initWithCapacity:0];
    for (NSDictionary *query in dicArr) {
        [buffer appendString:[NSString stringWithFormat:@",\"%@\"", [self processRequestStringWith:query]]];
    }
    NSString* methodFeed = [NSString stringWithFormat:@"[%@]", [buffer substringFromIndex:1]];
    
    return methodFeed;
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
