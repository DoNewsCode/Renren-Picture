//
//  DRRFile.m
//  Renren-ResourceKit
//
//  Created by 陈金铭 on 2019/8/5.
//

#import "DRRFile.h"
#import <SDWebImage/SDWebImage.h>
/** 配置文件 */
static NSString *const DRRFileConfigFile = @"Config";
/** 用户文件 */
static NSString *const DRRFileUserFile = @"User";

/** App组 */
static NSString *const DRRFileGroupName = @"group.com.donews.app";

@interface DRRFile ()
/** App组路径 */
@property(nonatomic, copy, readwrite) NSURL *appGroupURL;

/** App组 配置文件路径 */
@property(nonatomic, copy, readwrite) NSURL *appGroupConfigURL;

/** iCloud路径 */
@property(nonatomic, copy, readwrite) NSURL *iCloudURL;
/** iCloud 配置文件路径 */
@property(nonatomic, copy, readwrite) NSURL *iCloudConfigURL;

/** 用户文件夹 */
@property(nonatomic, copy, readwrite) NSString *userFilePath;
/** 当前用户文件夹 */
@property(nonatomic, copy, readwrite) NSString *currentUserFilePath;

/** 原有当前用户文件夹 */
@property(nonatomic, copy, readwrite) NSString *oldCurrentUserFilePath;
/** 配置文件夹 */
@property(nonatomic, copy, readwrite) NSString *configFilePath;

@end

@implementation DRRFile

static DRRFile *_instance = nil;
//单例
+ (instancetype)sharedFile
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _configFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:DRRFileConfigFile];
    _userFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:DRRFileUserFile];
    [self createFolderWithFile:_configFilePath];
    [self createFolderWithFile:_userFilePath];
    //获取App Group的共享目录
    _appGroupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:DRRFileGroupName];
    _appGroupConfigURL = [_appGroupURL URLByAppendingPathComponent:DRRFileConfigFile];
    
    NSURL *url = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    if (url == nil) {
        return;
    }
    _iCloudURL = [url URLByAppendingPathComponent:@"Documents"];
    _iCloudConfigURL = [_iCloudURL URLByAppendingPathComponent:DRRFileConfigFile];
    
}

- (void)createFolderWithFile:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL isExit = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    
    if (!isExit || !isDir) {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (NSUInteger)totalDiskCacheSize {
    return [[SDImageCache sharedImageCache] totalDiskSize];
}

- (void)calculateSizeWithCompletionBlock:(nullable DRRFileCacheCalculateSizeBlock)completionBlock {
    [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        if (completionBlock) {
            completionBlock(fileCount,totalSize);
        }
    }];
}

- (void)clearDiskOnCompletion:(nullable DRRFileNoParamsBlock)completion {
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        if (completion) {
            completion();
        }
    }];
}

- (void)craeteCurrentUserFilePathWithUserid:(nullable NSString *)userid {
    if (userid == nil) {
        self.currentUserFilePath = [self.userFilePath stringByAppendingPathComponent:@"0"];
        self.oldCurrentUserFilePath = [self.userFilePath stringByAppendingString:@"0"];
        
        return;
    }
    self.currentUserFilePath = [self.userFilePath stringByAppendingPathComponent:userid];
    self.oldCurrentUserFilePath = [self.userFilePath stringByAppendingString:userid];
    [self createFolderWithFile:self.currentUserFilePath];
    [self createFolderWithFile:self.oldCurrentUserFilePath];
}

@end
