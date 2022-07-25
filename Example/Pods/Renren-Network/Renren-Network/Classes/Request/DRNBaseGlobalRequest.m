//
//  DRNBaseGlobalRequest.m
//  Pods-Renren-Network_Example
//
//  Created by Ming on 2019/3/21.
//

#import "DRNBaseGlobalRequest.h"

#import "NSString+CTDate.h"
#import "DRNNetwork.h"

@implementation DRNBaseGlobalRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.v = @"1.0";
    }
    return self;
}


- (void)startWithSuccess:(DNRequestSuccessBlock)success failure:(DNRequestFailureBlock)failure {

//    NSAssert(((self.uniq_key != nil || self.client_info != nil)), @"DeBug Error：请检查参数完整性，登陆前接口需携带client_info；登陆后接口需携带uniq_key；");
    [super startWithSuccess:success failure:failure];
    
}

- (NSString *)call_id
{
    return [NSString ct_timeStampForNow];
}

@end
