//
//  DRMEGetTopicsViewModel.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/2/21.
//

#import <Foundation/Foundation.h>
#import "DRMEGetTopicsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DRMEGetTopicsViewModel : NSObject

@property(nonatomic,strong) DRMEGetTopicsModel *topicsModel;

- (void)getTopicsWithSuccessBlock:(void(^)(void))successBlock
                     failureBlock:(void(^)(NSString *errorStr))failureBlock;

@end

NS_ASSUME_NONNULL_END
