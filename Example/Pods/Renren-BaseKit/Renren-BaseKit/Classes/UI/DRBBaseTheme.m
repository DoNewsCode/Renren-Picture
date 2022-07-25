//
//  DRBBaseTheme.m
//  Pods-Renren-BaseKit_Example
//
//  Created by Ming on 2019/3/23.
//

#import "DRBBaseTheme.h"

@interface DRBBaseTheme ()

/** 主题模型 */
@property(nonatomic, strong) DRBThemeModel *themeModel;
/** 文件地址 */
@property (nonatomic, copy) NSString *filePath;
/** 磁盘缓存字典 */
@property (nonatomic, strong) NSMutableDictionary *diskCacheDict;

@end

// 单例对象
static DRBBaseTheme *_instance = nil;

@implementation DRBBaseTheme
#pragma mark - Intial Methods

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        
    });
    return _instance;
}

#pragma mark - Override Methods
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - Public Methods
+ (void)configurationThemeWithProgramName:(NSString *__nonnull)programName withProgressBlock:(DRBBaseThemeProgressBlock)progressBlock {
    [[DRBBaseTheme sharedInstance] configurationThemeWithProgramName:programName withProgressBlock:progressBlock];
}

+ (void)addThemeGroupWithName:(NSString *)name themeAddBlock:(DRBBaseThemeAddBlock)themeAddBlock {
    if (name == nil || name.length == 0) {
        return;
    }
    
    if ([[DRBBaseTheme sharedInstance].themeModel.version isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] || [[DRBBaseTheme sharedInstance].themeModel.build isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]) {
        for (DRBThemeModelGroup *group in [DRBBaseTheme sharedInstance].themeModel.groups) {
            if ([group.name isEqualToString:name]) {
                return;
            }
        }
    }
    themeAddBlock(YES);
}

+ (void)addThemeGroup:(DRBThemeModelGroup *__nonnull)themeGroup {
    if (themeGroup.name != nil) {
        [[DRBBaseTheme sharedInstance].themeModel addGroup:themeGroup];
        // 循环设置默认主题方案
        for (DRBThemeModelItem *item in themeGroup.items) {
            [item configurationProgramWithName:DRBThemeProgramDefault];
        }
    }
}

+ (DRBThemeModelProgram *)obtainProgram:(NSString *__nonnull)groupName itemName:(NSString *__nonnull)itemName {
    if (groupName == nil || groupName.length == 0 || itemName == nil || itemName.length == 0) {
        return nil;
    }
    DRBThemeModelGroup *themeGroup = nil;
    DRBThemeModelItem *themeItem = nil;
    DRBBaseTheme *baseTheme = [DRBBaseTheme sharedInstance];
    themeGroup = [baseTheme.themeModel obtainGroupWithName:groupName];
    if (themeGroup != nil) {
        themeItem = [themeGroup obtainItemsWithName:itemName];
        if (themeItem != nil) {
            return [themeItem obtaincurrentProgram];
        }
    }

    return nil;
}

#pragma mark - Private Methods
- (void)initialize {
    self.filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:[NSString stringWithFormat:@"/renrenTheme.plist"]];
    
    NSMutableDictionary *diskCacheDict = [[NSMutableDictionary alloc]initWithDictionary: [NSKeyedUnarchiver unarchiveObjectWithFile:self.filePath]];
    if (diskCacheDict == nil) {
        NSDictionary *tempDiskCacheDict = [NSDictionary dictionary];
        [NSKeyedArchiver archiveRootObject:tempDiskCacheDict toFile:self.filePath];
        diskCacheDict = [[NSMutableDictionary alloc]initWithDictionary:tempDiskCacheDict];
    }
    self.diskCacheDict = diskCacheDict;
    DRBThemeModel *themeModel = [NSKeyedUnarchiver unarchiveObjectWithData:self.diskCacheDict[@"renrenTheme"]];//逆归档
    if (themeModel == nil) {
        themeModel = [DRBThemeModel new];
        themeModel.bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        themeModel.version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];//获取项目版本号
        themeModel.build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    }
    self.themeModel = themeModel;
}

- (void)configurationThemeWithProgramName:(NSString *__nonnull)programName withProgressBlock:(DRBBaseThemeProgressBlock)progressBlock {
    NSMutableArray<DRBThemeModelItem *> *array = [NSMutableArray array];
    for (DRBThemeModelGroup *group in self.themeModel.groups) {
        for (DRBThemeModelItem *item in group.items) {
            [array addObject:item];
        }
    }
    NSInteger total = array.count;
    CGFloat progress = 0;
    CGFloat current = 0;
    
    for (DRBThemeModelItem *item in array) {
        current ++;
        [item configurationProgramWithName:programName];
        progress = current / total;
        if (current >= total) {
            progressBlock(NO,progress);
        } else {
        }
    }
    [self createThemeModel:self.themeModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:DRBNotificationThemeProgramHasChanged object:nil];
    progressBlock(YES,1);
}

- (void)createThemeModel:(DRBThemeModel *)model {
    NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:model];//归档
    [self.diskCacheDict setObject:modelData forKey:@"renrenTheme"];
    [self.diskCacheDict setObject:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] forKey:@"diskTime"];
    [NSKeyedArchiver archiveRootObject:self.diskCacheDict.copy toFile:self.filePath];
}

@end
