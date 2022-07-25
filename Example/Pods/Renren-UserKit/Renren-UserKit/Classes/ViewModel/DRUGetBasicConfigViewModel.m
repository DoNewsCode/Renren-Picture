//
//  DRUGetBasicConfigViewModel.m
//  AFNetworking
//
//  Created by 李晓越 on 2019/6/24.
//

#import "DRUGetBasicConfigViewModel.h"
#import "DRUGetBasicConfigRequest.h"

@interface DRUGetBasicConfigViewModel ()

@property(nonatomic,strong) DRUGetBasicConfigRequest *getBasicConfigRequest;

@end

@implementation DRUGetBasicConfigViewModel

- (DRUGetBasicConfigRequest *)getBasicConfigRequest
{
    if (!_getBasicConfigRequest) {
        _getBasicConfigRequest = [[DRUGetBasicConfigRequest alloc] init];
    }
    return _getBasicConfigRequest;
}

- (void)loadDataGetBasicConfigWithSession_key:(NSString *)session_key
                                          uid:(NSString *)uid
                                 successBlock:(void (^)(BOOL, NSInteger))successBlock
                                 failureBlock:(void (^)(NSString * _Nonnull))failureBlock
{
    self.getBasicConfigRequest.session_key = session_key;
    self.getBasicConfigRequest.uid = uid;
    [self.getBasicConfigRequest lodaDataWithSuccessBlock:^(id  _Nonnull response) {
        
        NSInteger hasRight = [[response objectForKey:@"has_right"] integerValue];
        
        if (successBlock) {
            successBlock(YES, hasRight);
        }
        
    } faileBlock:^(NSString * _Nonnull error_msg, id  _Nonnull response) {
        if (failureBlock) {
            failureBlock(error_msg);
        }
    }];
}

@end
