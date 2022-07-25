//
//  DRNURLConfig.m
//  Renren-Network
//
//  Created by 陈金铭 on 2019/8/5.
//

#import "DRNURLConfig.h"
#import "YYModel.h"

/** 文件名称 */
static NSString *const DRNAPISettingFile = @"APIConfig";

@interface DRNURLConfigFilePath : NSObject

@property(nonatomic, copy) NSString *filePath;

@end

@implementation DRNURLConfigFilePath
//单例对象
static DRNURLConfigFilePath *_instance = nil;
//单例
+ (instancetype)sharedManager {
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
     _filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:DRNAPISettingFile];
    }
    return self;
}
@end

@interface DRNURLConfig ()

@end

@implementation DRNURLConfig

+ (instancetype)config {
    DRNURLConfig *config = [DRNURLConfig yy_modelWithJSON:[NSKeyedUnarchiver unarchiveObjectWithFile:[DRNURLConfigFilePath sharedManager].filePath]];
    if (config == nil || ![config.version isEqualToString:@"1.2.3"]) {// 若为空或版本不是最新的版本则重新赋值，更新配置时需升级版本进行重新赋值
        config = [DRNURLConfig new];
        [config createInitialConfig];
        [config upload];
    }
    return config;
}

+ (instancetype)configWithConfigInitDictionary:(NSDictionary *)configInitDictionary {
    DRNURLConfig *config = [DRNURLConfig yy_modelWithJSON:[NSKeyedUnarchiver unarchiveObjectWithFile:[DRNURLConfigFilePath sharedManager].filePath]];
    DRNURLConfig *configInit = [DRNURLConfig yy_modelWithDictionary:configInitDictionary];
    if (config == nil || ![config.version isEqualToString:configInit.version]) {// 若为空或版本不是最新的版本则重新赋值，更新配置时需升级版本进行重新赋值
        config = configInit;
        [config createInitialConfig];
        [config upload];
    }
    return config;
}

+ (instancetype)configWithConfig:(DRNURLConfig *)config {
    
    DRNURLConfig *configInit = [DRNURLConfig yy_modelWithJSON:[NSKeyedUnarchiver unarchiveObjectWithFile:[DRNURLConfigFilePath sharedManager].filePath]];
    if (configInit == nil || ![configInit.version isEqualToString:config.version]) {// 若为空或版本不是最新的版本则重新赋值，更新配置时需升级版本进行重新赋值
        configInit = config;
        [configInit createInitialConfig];
        [configInit upload];
    }
    return configInit;
}

- (void)upload {
    [NSKeyedArchiver archiveRootObject:[self yy_modelToJSONData] toFile:[DRNURLConfigFilePath sharedManager].filePath];
}

- (void)createInitialConfig {
    self.version = @"1.2.3";
    DRNURLSectionConfig *sectionConfig0 = [DRNURLSectionConfig new];
    sectionConfig0.title = @"通用环境切换";
    
    DRNURLItemConfig *itemConfig00 = [DRNURLItemConfig new];
    itemConfig00.title = @"正式环境";
    itemConfig00.content = @"http://api.m.renren.com/api";
    DRNURLItemConfig *itemConfig01 = [DRNURLItemConfig new];
    itemConfig01.title = @"测试环境1（MCS1）";
    itemConfig01.content = @"http://mc1.test.renren.com/api";
    DRNURLItemConfig *itemConfig02 = [DRNURLItemConfig new];
    itemConfig02.title = @"测试环境2（MCS2）";
    itemConfig02.content = @"http://mc2.test.renren.com/api";
    DRNURLItemConfig *itemConfig03 = [DRNURLItemConfig new];
    itemConfig03.title = @"测试环境3（MCS3）";
    itemConfig03.content = @"http://mc3.test.renren.com/api";
    
    DRNURLItemConfig *itemConfig000 = [DRNURLItemConfig new];
    itemConfig000.title = @"待启用正式环境";
    itemConfig000.content = @"http://rrwapi.renren.com";
    DRNURLItemConfig *itemConfig001 = [DRNURLItemConfig new];
    itemConfig001.title = @"待启用测试环境1（MCS1）";
    itemConfig001.content = @"http://rrwapi-test.renren.com";
    DRNURLItemConfig *itemConfig002 = [DRNURLItemConfig new];
    itemConfig002.title = @"待启用测试环境2（MCS2）";
    itemConfig002.content = @"http://rrwapi-test2.renren.com";
    
    [sectionConfig0.items addObject:itemConfig00];
    [sectionConfig0.items addObject:itemConfig01];
    [sectionConfig0.items addObject:itemConfig02];
    [sectionConfig0.items addObject:itemConfig03];
    
    
    [sectionConfig0.items addObject:itemConfig000];
    [sectionConfig0.items addObject:itemConfig001];
    [sectionConfig0.items addObject:itemConfig002];
    
    sectionConfig0.currentItem = itemConfig00;
    [self.sections addObject:sectionConfig0];
    
    DRNURLSectionConfig *sectionConfig1 = [DRNURLSectionConfig new];
    sectionConfig1.title = @"Web环境切换";
    
    DRNURLItemConfig *itemConfig10 = [DRNURLItemConfig new];
    itemConfig10.title = @"正式环境";
    itemConfig10.content = @"https://renren.com";
    DRNURLItemConfig *itemConfig11 = [DRNURLItemConfig new];
    itemConfig11.title = @"测试环境1（1）";
    itemConfig11.content = @"http://dnactivity.renren.com";
    DRNURLItemConfig *itemConfig12 = [DRNURLItemConfig new];
    itemConfig12.title = @"测试环境2（MCS2）";
    itemConfig12.content = @"http://mc2.test.renren.com/api";
    
    [sectionConfig1.items addObject:itemConfig10];
    [sectionConfig1.items addObject:itemConfig11];
    [sectionConfig1.items addObject:itemConfig12];
    
    sectionConfig1.currentItem = itemConfig10;
    [self.sections addObject:sectionConfig1];
    
    
    DRNURLSectionConfig *sectionConfig2 = [DRNURLSectionConfig new];
    sectionConfig2.title = @"广告环境切换";
    
    DRNURLItemConfig *itemConfig13 = [DRNURLItemConfig new];
    itemConfig13.title = @"正式环境";
    itemConfig13.content = @"https://renren.com";
    DRNURLItemConfig *itemConfig14 = [DRNURLItemConfig new];
    itemConfig14.title = @"测试环境1（1）";
    itemConfig14.content = @"http://dnactivity.renren.com";
    
    [sectionConfig2.items addObject:itemConfig13];
    [sectionConfig2.items addObject:itemConfig14];
    
    sectionConfig2.currentItem = itemConfig13;
    [self.sections addObject:sectionConfig2];
    
    DRNURLSectionConfig *sectionConfig3 = [DRNURLSectionConfig new];
    sectionConfig3.title = @"活动弹窗环境切换";
    
    DRNURLItemConfig *itemConfig30 = [DRNURLItemConfig new];
    itemConfig30.title = @"正式环境";
    itemConfig30.content = @"https://renren.com";
    DRNURLItemConfig *itemConfig31 = [DRNURLItemConfig new];
    itemConfig31.title = @"测试环境1（1）";
    itemConfig31.content = @"http://dnactivity.renren.com";
    
    [sectionConfig3.items addObject:itemConfig30];
    [sectionConfig3.items addObject:itemConfig31];
    
    sectionConfig3.currentItem = itemConfig30;
    [self.sections addObject:sectionConfig3];
    
    DRNURLSectionConfig *sectionConfig4 = [DRNURLSectionConfig new];
    sectionConfig4.title = @"推荐埋点环境切换";
    
    DRNURLItemConfig *itemConfig40 = [DRNURLItemConfig new];
    itemConfig40.title = @"正式环境";
    itemConfig40.content = @"http://recommand-report.alg.renren.com";
    DRNURLItemConfig *itemConfig41 = [DRNURLItemConfig new];
    itemConfig41.title = @"测试环境1（1）";
    itemConfig41.content = @"http://recommand-report-test.alg.renren.com";
    
    [sectionConfig4.items addObject:itemConfig40];
    [sectionConfig4.items addObject:itemConfig41];
    
    sectionConfig4.currentItem = itemConfig40;
    [self.sections addObject:sectionConfig4];
    
    DRNURLSectionConfig *sectionConfig5 = [DRNURLSectionConfig new];
    sectionConfig5.title = @"埋点环境切换";
    
    DRNURLItemConfig *itemConfig50 = [DRNURLItemConfig new];
    itemConfig50.title = @"正式环境";
    itemConfig50.content = @"apprenrenwang";
    DRNURLItemConfig *itemConfig51 = [DRNURLItemConfig new];
    itemConfig51.title = @"测试环境1（1）";
    itemConfig51.content = @"apprenrenwang-test";
    
    [sectionConfig5.items addObject:itemConfig50];
    [sectionConfig5.items addObject:itemConfig51];
    
    sectionConfig5.currentItem = itemConfig50;
    [self.sections addObject:sectionConfig5];
    
    DRNURLSectionConfig *sectionConfig6 = [DRNURLSectionConfig new];
    sectionConfig6.title = @"聊天Host切换";
    
    DRNURLItemConfig *itemConfig60 = [DRNURLItemConfig new];
    itemConfig60.title = @"正式环境";
    itemConfig60.content = @"talk.m.renren.com";
    DRNURLItemConfig *itemConfig61 = [DRNURLItemConfig new];
    itemConfig61.title = @"测试环境1（1）";
    itemConfig61.content = @"talk.test.renren.com";
    
    [sectionConfig6.items addObject:itemConfig60];
    [sectionConfig6.items addObject:itemConfig61];
    
    sectionConfig6.currentItem = itemConfig60;
    [self.sections addObject:sectionConfig6];
    
    DRNURLSectionConfig *sectionConfig7 = [DRNURLSectionConfig new];
    sectionConfig7.title = @"聊天Port切换";
    
    DRNURLItemConfig *itemConfig70 = [DRNURLItemConfig new];
    itemConfig70.title = @"正式环境";
    itemConfig70.content = @"25553";
    DRNURLItemConfig *itemConfig71 = [DRNURLItemConfig new];
    itemConfig71.title = @"测试环境1（1）";
    itemConfig71.content = @"2903";
    
    [sectionConfig7.items addObject:itemConfig70];
    [sectionConfig7.items addObject:itemConfig71];
    
    sectionConfig7.currentItem = itemConfig70;
    [self.sections addObject:sectionConfig7];
    
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"sections" : @"DRNURLSectionConfig"
             };
}

- (NSMutableArray<DRNURLSectionConfig *> *)sections {
    if (!_sections) {
        NSMutableArray<DRNURLSectionConfig *> *sections = [NSMutableArray<DRNURLSectionConfig *>  array];
        _sections = sections;
    }
    return _sections;
}

@end

@implementation DRNURLSectionConfig

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"items" : @"DRNURLItemConfig"
             };
}

- (NSMutableArray<DRNURLItemConfig *> *)items {
    if (!_items) {
        NSMutableArray<DRNURLItemConfig *> *items = [NSMutableArray<DRNURLItemConfig *>  array];
        _items = items;
    }
    return _items;
}

@end

@implementation DRNURLItemConfig

@end
