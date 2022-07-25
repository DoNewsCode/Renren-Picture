//
//  DRNPublicBatchRequest.h
//  AFNetworking
//
//  Created by Ming on 2020/6/10.
//

#import "DRNPublicRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRNPublicBatchRequest : DRNPublicRequest

/// 要请求的具体接口
@property(nonatomic,strong) NSMutableArray *infoRequestList;

/// 是否同步请求，1：是；0：否
@property(nonatomic,assign) NSInteger sync;

/// 使用子请求构建 infoRequestList 所需参数
/// @param requestArray 子请求数组
- (void)createMethodWith:(NSArray<DRNPublicRequest *> *)requestArray;

@end

NS_ASSUME_NONNULL_END
