//
//  DRUTip.h
//  Renren-UserKit
//
//  Created by 陈金铭 on 2019/8/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DRUTipType) {//提示类型
    DRUTipTypeDetailedValue,//详细数值
    DRUTipTypeFuzzyValue,//模糊数值
};

@interface DRUTip : NSObject

/** 提示类型 */
@property(nonatomic, assign, readonly) DRUTipType type;
/** 服务端返回的用户数据 */
@property (nonatomic, assign, readonly) NSInteger count;

- (instancetype)initWithFileName:(NSString *)fileName;

- (void)processChange:(DRUTipType )type count:(NSInteger )count;

@end

NS_ASSUME_NONNULL_END
