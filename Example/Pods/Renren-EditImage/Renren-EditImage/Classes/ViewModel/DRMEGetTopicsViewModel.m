//
//  DRMEGetTopicsViewModel.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/2/21.
//

#import "DRMEGetTopicsViewModel.h"
#import "DRMEGetTopicsReqeust.h"

@implementation DRMEGetTopicsViewModel

- (void)getTopicsWithSuccessBlock:(void(^)(void))successBlock
                     failureBlock:(void(^)(NSString *errorStr))failureBlock
{
    
    DRMEGetTopicsReqeust *request = [[DRMEGetTopicsReqeust alloc] init];
    
    WeakSelf(self)
    [request lodaDataWithSuccessBlock:^(id  _Nonnull response) {
        
        DRMEGetTopicsModel *model = [DRMEGetTopicsModel yy_modelWithJSON:response];
        weakself.topicsModel = model;
        if (successBlock) {
            successBlock();
        }
    } faileBlock:^(NSString * _Nonnull error_msg, DRMEBaseModel * _Nonnull baseModel) {
        if (failureBlock) {
            failureBlock(error_msg);
        }
    }];
}

@end
