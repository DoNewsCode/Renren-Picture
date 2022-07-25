//
//  DRUClientLogoutViewModel.m
//  AFNetworking
//
//  Created by lixiaoyue on 2019/6/6.
//

#import "DRUClientLogoutViewModel.h"
#import "DRUClientLogoutRequest.h"
#import "DRUAccountManager.h"

@interface DRUClientLogoutViewModel ()

@property(nonatomic,strong) DRUClientLogoutRequest *clientLogoutRequest;

@end

@implementation DRUClientLogoutViewModel

- (DRUClientLogoutRequest *)clientLogoutRequest
{
    if (!_clientLogoutRequest) {
        _clientLogoutRequest = [[DRUClientLogoutRequest alloc] init];
    }
    return _clientLogoutRequest;
}

- (void)loadDataClientLogoutWithSession_id:(NSString *)session_id
                              successBlock:(void(^)(BOOL isLogoutSuccess))successBlock
                              failureBlock:(void(^)(NSString *errorMsg))failureBlock
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleID = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    
    NSInteger push_type = 39;
    if ([bundleID isEqualToString:@"com.donews.renrenNet.ios"]) {
        push_type = 39;
    } else if ([bundleID isEqualToString:@"com.donews.renren.iose"]){
        push_type = 40;
    }
    
    self.clientLogoutRequest.session_key = [DRUAccountManager sharedInstance].currentUser.userLoginInfo.session_key;
    self.clientLogoutRequest.session_id = session_id;
    self.clientLogoutRequest.push_type = push_type;

    [self.clientLogoutRequest lodaDataWithSuccessBlock:^(id  _Nonnull response) {
        NSLog(@"-- %s, %d", __func__, __LINE__);
        
        if (successBlock) {
            successBlock(YES);
        }
        
    } faileBlock:^(NSString * _Nonnull error_msg, id  _Nonnull response) {
        
        if (failureBlock) {
            failureBlock(error_msg);
        }
        
    }];
}

@end
