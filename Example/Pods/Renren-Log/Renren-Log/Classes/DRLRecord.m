//
//  DRLRecord.m
//  Renren-Service
//
//  Created by Ming on 2019/5/28.
//

#import "DRLRecord.h"

#import "DRLLog.h"
#import <DNStatisticKit/DNStatisticKit.h>

@interface DRLRecord ()

/**
 是否附加日志
 */
@property(nonatomic, assign) BOOL additionalLog;

@end

@implementation DRLRecord
#pragma mark - Override Methods

#pragma mark - Intial Methods
static DRLRecord *_instance = nil;
//单例
+ (instancetype)sharedRecord {
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
        [self initialization];
    }
    return self;
}


#pragma mark - Public Methods
+ (void)start {
    NSLog(@"初始化埋点统计服务");
    //    [DNStatisticSDK registSDKWithAppKey:[DRLRecord sharedInstance].appKey channelId:[DRLRecord sharedInstance].channelId policy:SEND_REALTIME];
    [DNStatisticSDK registSDKWithAppKey:[DRLRecord sharedRecord].appKey policy:SEND_REALTIME];
    
    [[DRLTimeLineStaticManager shareManager] startRecommendRecord];
    
}

+ (void)setAdditionalLog:(BOOL)additionalLog {
    [[DRLRecord sharedRecord] setAdditionalLog:additionalLog];
}


+ (void)addRecordWithEventName:(NSString *)eventName {
    [[DRLRecord sharedRecord] addRecordWithEventName:eventName];
}


+ (void)addRecordType:(DRLRecordType)type eventName:(NSString *)eventName {
    [[DRLRecord sharedRecord] addRecordWithEventName:eventName];
}

+ (void)addRecordType:(DRLRecordType)type eventName:(NSString *)eventName parameters:(NSDictionary *)parameters {
    [[DRLRecord sharedRecord] addRecordType:type eventName:eventName parameters:parameters];
}

+ (void)createUserIdentifier:(NSString *)userIdentifier {
    [[DRLRecord sharedRecord] createUserIdentifier:userIdentifier];
}

+ (void)createUserAccount:(NSString *)account {
    [[DRLRecord sharedRecord] createUserAccount:account];
}

#pragma mark - Private Methods
- (void)initialization {
    _additionalLog = YES;
    _channelId = @"AppStore";
}

- (void)setAdditionalLog:(BOOL)additionalLog {
    self.additionalLog = additionalLog;
}


- (void)addRecordWithEventName:(NSString *)eventName {
    [self addRecordType:DRLRecordTypeNormal eventName:eventName parameters:nil];
}


- (void)addRecordType:(DRLRecordType)type eventName:(NSString *)eventName {
    
    [self addRecordType:type eventName:eventName parameters:nil];
}

- (void)addRecordType:(DRLRecordType)type eventName:(NSString *)eventName parameters:(NSDictionary *)parameters {
    [DNStatisticSDK eventWithBulider:^(DNStatisticEventBuilder * _Nonnull builder) {
        builder.extParams = parameters;
        builder.eventName = eventName;
    }];
    if (_additionalLog == NO) {
        return;
    }
    
    NSString *string = nil;
    if (parameters) {
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&parseError];
        string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSString *desc = nil;
    switch (type) {
        case DRLRecordTypeClick:
            desc = @"点击事件";
            break;
            
        case DRLRecordTypeEnter:
            desc = @"进入事件";
            break;
        default:
            desc = @"常规事件";
            break;
    }
    [[DRLLog sharedLog] addLogWithType:DRLLogTypeStatistic title:eventName desc:desc content:string];
}


- (void)createUserIdentifier:(NSString *)userIdentifier {
    [DNStatisticSDK setUserId:userIdentifier];
}

- (void)createUserAccount:(NSString *)account {
    [DNStatisticSDK setAccount:account];
}

+ (void)createUserAge:(NSString *)age {
    [DNStatisticSDK setAge:age.intValue];
}

#pragma 推荐统计

+ (void)addRecordWithEventID:(DRLRecordTimeLineType)eventID sourceID:(NSString *)sourceID ugcType:(NSString *)ugcType pack:(nonnull NSString *)pack userID:(nonnull NSString *)userID value:(CGFloat)value showImageArr:(nonnull NSArray *)imageIDArr allCount:(NSInteger)allPhotoCount{
    
    [[DRLTimeLineStaticManager shareManager] addRecordWithEventID:eventID sourceID:sourceID ugcType:ugcType pack:pack userID:userID value:value showImageArr:imageIDArr allCount:allPhotoCount];
    
}

@end
