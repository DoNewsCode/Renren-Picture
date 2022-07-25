//
//  DRUProfileGetInfoViewModel.m
//  AFNetworking
//
//  Created by lixiaoyue on 2019/6/3.
//

#import "DRUProfileGetInfoViewModel.h"
#import "DRUProfileGetInfoRequest.h"
#import <YYModel/YYModel.h>


@interface DRUProfileGetInfoViewModel ()

@property(nonatomic,strong) DRUProfileGetInfoRequest *profileGetInfoRequest;

@end

@implementation DRUProfileGetInfoViewModel

- (DRUProfileGetInfoRequest *)profileGetInfoRequest
{
    if (!_profileGetInfoRequest) {
        _profileGetInfoRequest = [[DRUProfileGetInfoRequest alloc] init];
    }
    return _profileGetInfoRequest;
}


- (void)loadDataProfileGetInfoWithUserid:(NSString *)uid
                             session_key:(NSString *)session_key
                            successBlock:(void(^)(id response))successBlock
                            failureBlock:(void(^)(NSString *errorMsg))failureBlock
{
    
    self.profileGetInfoRequest.uid = uid;
    self.profileGetInfoRequest.session_key = session_key;
    [self.profileGetInfoRequest lodaDataWithSuccessBlock:^(id  _Nonnull response) {
        
        if (successBlock) {
            successBlock(response);
        }

    } faileBlock:^(NSString * _Nonnull error_msg, id  _Nonnull response) {
        NSLog(@"error_msg == %@", error_msg);
        if (failureBlock) {
            failureBlock(error_msg);
        }
    }];
}

- (void)dealloc
{
    NSLog(@"-- %s, %d", __func__, __LINE__);

}
@end
