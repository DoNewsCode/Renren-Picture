//
//  DRNBatchRequest.h
//  AFNetworking
//
//  Created by Ming on 2020/5/8.
//

//  批处理请求
#import "DRNGlobalRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRNBatchRequest : DRNGlobalRequest

/// JSON array格式的字符串,每一个元素是一个的method完整请求参数, 该array最多包含15个元素。Example: [“uids=&method=&sig=&title=” ,””]
@property (nonatomic, copy) NSString *method_feed;


/// 使用子请求构建批处理请求
/// @param requestArray 子请求数组
- (void)createMethodWith:(NSArray<DRNGlobalRequest *> *)requestArray;

@end

NS_ASSUME_NONNULL_END
