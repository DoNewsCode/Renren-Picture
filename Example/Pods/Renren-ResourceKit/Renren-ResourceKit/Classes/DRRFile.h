//
//  DRRFile.h
//  Renren-ResourceKit
//
//  Created by 陈金铭 on 2019/8/5.
//  文件管理

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DRRFileCacheCalculateSizeBlock)(NSUInteger fileCount, NSUInteger totalSize);
typedef void(^DRRFileNoParamsBlock)(void);
@interface DRRFile : NSObject

/** App组路径 */
@property(nonatomic, copy, readonly) NSURL *appGroupURL;

/** App组 配置文件路径 */
@property(nonatomic, copy, readonly) NSURL *appGroupConfigURL;

/** iCloud路径 */
@property(nonatomic, copy, readonly) NSURL *iCloudURL;
/** iCloud 配置文件路径 */
@property(nonatomic, copy, readonly) NSURL *iCloudConfigURL;

/** 用户文件夹 */
@property(nonatomic, copy, readonly) NSString *userFilePath;
/** 当前用户文件夹 */
@property(nonatomic, copy, readonly) NSString *currentUserFilePath;

/** 原有当前用户文件夹 */
@property(nonatomic, copy, readonly) NSString *oldCurrentUserFilePath;
/** 配置文件夹 */
@property(nonatomic, copy, readonly) NSString *configFilePath;


+ (instancetype)sharedFile;

/**
 异步获取磁盘文件大小

 @param completionBlock 返回的Block
 */
- (void)calculateSizeWithCompletionBlock:(nullable DRRFileCacheCalculateSizeBlock)completionBlock;

/**
 异步清理磁盘文件

 @param completion 完成的Block
 */
- (void)clearDiskOnCompletion:(nullable DRRFileNoParamsBlock)completion;


/**
 更改当前用户文件夹

 @param userid 当前用户id
 */
- (void)craeteCurrentUserFilePathWithUserid:(nullable NSString *)userid;

@end

NS_ASSUME_NONNULL_END
