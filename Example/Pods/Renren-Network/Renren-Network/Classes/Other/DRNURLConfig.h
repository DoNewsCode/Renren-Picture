//
//  DRNURLConfig.h
//  Renren-Network
//
//  Created by 陈金铭 on 2019/8/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DRNURLSectionConfig, DRNURLItemConfig;

@interface DRNURLConfig : NSObject

/** 组 */
@property(nonatomic, strong) NSMutableArray<DRNURLSectionConfig *> *sections;

/// 版本
@property (nonatomic, copy) NSString *version;

+ (instancetype)configWithConfigInitDictionary:(NSDictionary *)configInitDictionary;
+ (instancetype)configWithConfig:(DRNURLConfig *)config;

+ (instancetype)config;

- (void)upload;

@end


@interface DRNURLSectionConfig : NSObject

/** 组名称 */
@property(nonatomic, copy) NSString *title;

/** 块 */
@property(nonatomic, strong) NSMutableArray<DRNURLItemConfig *> *items;

@property(nonatomic, getter=isClose) BOOL close;

/** 当前块 */
@property(nonatomic, strong) DRNURLItemConfig *currentItem;

@end


@interface DRNURLItemConfig : NSObject

/** 名称 */
@property(nonatomic, copy) NSString *title;
/** 内容 */
@property(nonatomic, copy) NSString *content;

@end

NS_ASSUME_NONNULL_END
