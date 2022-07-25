//
//  DRLTimeLineStaticModel.h
//  Renren-Log
//
//  Created by 陈文昌 on 2020/2/12.
//

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRLTimeLineStaticModel : NSObject<WCTTableCoding>

/// 事件发生的时间
@property (nonatomic, assign) long long event_time;
/**
 *  透传下发对应UGC的pack,接口获取
 */
@property (nonatomic, copy) NSString *pack;
/**
 *  上报事件类型1:疑似点击 2:展示 3:点击 4: 停留时 长 5:完成度
 */
@property (nonatomic, assign) NSInteger event_id;
/// event_id 为 4 和 5 时，该字段为必传(4:停留时长 5:完成度)，event_id 为其他时，不用传该字段。ev ent_id=4 时，数值单位为 s;event_id=5 时，-1 表示打开/播放失败，数值为 1-100,100 表示看了 1 00%的内容
@property (nonatomic, assign) NSInteger value;

/**
 *  已看图片数组
 */
@property (nonatomic, strong) NSArray *imageIDArr;

/**
 *  主键、去重使用
 */
@property (nonatomic, copy) NSString *event_key;

WCDB_PROPERTY(event_time)
WCDB_PROPERTY(pack)
WCDB_PROPERTY(event_id)
WCDB_PROPERTY(value)
WCDB_PROPERTY(imageIDArr)
WCDB_PROPERTY(event_key)

@end

NS_ASSUME_NONNULL_END
