//
//  DRLTimeLineStaticManager.m
//  Renren-Log
//
//  Created by 陈文昌 on 2020/2/11.
//

#import "DRLTimeLineStaticManager.h"
#import "AFNetworkReachabilityManager.h"

#import "DRLTimeLineRecordNetWorkManager.h"
#import "DRLTimeLineStaticModel.h"
#import "DRLRecordSafeMutableArray.h"

#import "DRLTimeLineDBManager.h"
#import "DNBaseMacro.h"
#import "DNHandyCategory.h"

#ifdef __IPHONE_10_0

#import <CallKit/CXCallObserver.h>
#import <CallKit/CXCall.h>

#endif

#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>


#import "HLNetWorkReachability.h"



#define TimeLineLock() dispatch_semaphore_wait(self->_timeLineLock, DISPATCH_TIME_FOREVER)
#define TimeLineUnlock() dispatch_semaphore_signal(self->_timeLineLock)

static NSString * const TimeLineSecret = @"wx3a7f4dccb04d86c7";



static NSString * const timelineBaseUrlTest = @"http://recommand-report-test.alg.renren.com/report/v1";// 测试


static NSString * const timelineBaseUrlFinall = @"http://recommand-report.alg.renren.com/report/v1";// 正式



static NSInteger const maxCachTime = 30*60*1000;// 毫秒

static DRLTimeLineStaticManager *manager = nil;


@interface DRLTimeLineStaticManager ()<CXCallObserverDelegate>
// 当前待提交的数据数组 线程安全数组
@property (nonatomic, strong) DRLRecordSafeMutableArray *recordArr;

/**
 监听来电话和挂断
 */
@property (nonatomic, strong) CXCallObserver *myCallObserver API_AVAILABLE(ios(10.0));


/**
 监听来电话和挂断
 */
@property (nonatomic, strong) CTCallCenter *myCallCenter;

/**
 标记已经接通
 */
@property (nonatomic, assign) BOOL isConnect;

/**
 *  网络监测
 */
@property (nonatomic, strong) HLNetWorkReachability *hostReachability;

/// 当前的网络状态
@property (nonatomic, assign) HLNetWorkStatus netStatus;

/**
 *  网络状态
 *  1
wifi 网络
2
2G 移动网络
3
3G 移动网络
4
4G 移动网络
5
5G 移动网络
6
其他移动网络
7
其他网络(非 wifi 并且也非移动网络)
8
unknown，如纯 H5 产品获取不了网络状况
 *
 */
@property (nonatomic, strong) NSNumber *recordNetStatus;

/**
 上报基础l地址
 */
@property (nonatomic, copy) NSString *timelineBaseUrl;

@end

@implementation DRLTimeLineStaticManager {
    
    dispatch_semaphore_t _timeLineLock;// 保证线程安全
    dispatch_queue_t _queue;// 队列
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        _timeLineLock = dispatch_semaphore_create(1);
        _queue = dispatch_queue_create("timeline_record_update", NULL);
        
        [self conFigCallObsever];
        
        _recordNetStatus = @(4);// 默认4G
        
        _timelineBaseUrl = timelineBaseUrlFinall;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kNetWorkReachabilityChangedNotification object:nil];
        
    }
    
    return self;
}

+ (DRLTimeLineStaticManager *)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DRLTimeLineStaticManager alloc] init];
        
        [[DRLTimeLineDBManager shareManager].hasRecordTable deleteObjectWithOutOffTime];
        
    });
    
    return manager;
}

- (void)startRecommendRecord {
    
    [self.hostReachability startNotifier];
    
}

- (void)changeUpdateHostIsTest:(BOOL)isTest {
    
    if (isTest) {
        self.timelineBaseUrl = timelineBaseUrlTest;
    }else {
        self.timelineBaseUrl = timelineBaseUrlFinall;
    }
    
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    HLNetWorkReachability *curReach = [notification object];
    HLNetWorkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus) {
        case HLNetWorkStatusNotReachable:
            NSLog(@"网络不可用");
            self.netStatus = HLNetWorkStatusNotReachable;
            break;
        case HLNetWorkStatusUnknown:
            NSLog(@"未知网络");
            self.netStatus = HLNetWorkStatusUnknown;
            self.recordNetStatus = @(6);
            break;
        case HLNetWorkStatusWWAN2G:
            NSLog(@"2G网络");
            self.netStatus = HLNetWorkStatusWWAN2G;
            self.recordNetStatus = @(2);
            break;
        case HLNetWorkStatusWWAN3G:
            NSLog(@"3G网络");
            self.netStatus = HLNetWorkStatusWWAN3G;
            self.recordNetStatus = @(3);
            break;
        case HLNetWorkStatusWWAN4G:
            NSLog(@"4G网络");
            self.netStatus = HLNetWorkStatusWWAN4G;
            self.recordNetStatus = @(4);
            break;
        case HLNetWorkStatusWiFi:
            NSLog(@"WiFi");
            self.netStatus = HLNetWorkStatusWiFi;
            self.recordNetStatus = @(1);
            break;
            
        default:
            break;
    }
}

#pragma mark = 来电检测,来电类似推入后台,挂断类似进入前台处理

- (void)conFigCallObsever {
    
    
    
    if (@available(iOS 10.0, *)) {
        [self.myCallObserver setDelegate:self queue:dispatch_get_main_queue()];
    } else {
        
        __weak typeof(self) weakSelf = self;
        
        self.myCallCenter.callEventHandler = ^(CTCall *call) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([call.callState isEqualToString:CTCallStateDialing]) {
                    NSLog(@"电话主动拨打电话");
                } else if ([call.callState isEqualToString:CTCallStateConnected]) {
                    NSLog(@"电话接通");
                    
                    [weakSelf postNotificationWithName:DRTCallRecordEvent_DRL_startCall];
                    
                    weakSelf.isConnect = YES;
                    
                } else if ([call.callState isEqualToString:CTCallStateDisconnected]) {
                    NSLog(@"电话挂断");
                    if (weakSelf.isConnect) {
                       [weakSelf postNotificationWithName:DRTCallRecordEvent_DRL_endCall];
                        weakSelf.isConnect = NO;
                    }
                    
                    
                } else if ([call.callState isEqualToString:CTCallStateIncoming]) {
                    NSLog(@"电话被叫");
                } else {
                    NSLog(@"电话其他状态");
                }
            });
        };
        
    }
    
}

- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call  API_AVAILABLE(ios(10.0)){
    
    if (call.hasConnected && !call.hasEnded) {// 接通
        [self postNotificationWithName:DRTCallRecordEvent_DRL_startCall];
        
        NSLog(@"我这边接通了========");
        
    }else if (call.hasEnded && call.hasConnected) {// 接通并挂断
        [self postNotificationWithName:DRTCallRecordEvent_DRL_endCall];
        
        NSLog(@"我这边挂断了了========");
        
    }
    
}


- (void)postNotificationWithName:(NSString *)notificationName {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
        
    });
    
}


#pragma mark = 统计提交核心

- (void)addRecordWithEventID:(DRLRecordTimeLineType)eventID sourceID:(NSString *)sourceID ugcType:(NSString *)ugcType pack:(nonnull NSString *)pack userID:(nonnull NSString *)userID value:(CGFloat)value showImageArr:(nonnull NSArray *)imageIDArr allCount:(NSInteger)allPhotoCount {
    
    if (![self needRemoveSame:eventID] && value == 0.0f) {
        return;
    }
    
    NSString *key = [NSString stringWithFormat:@"%@_%@_%@_%@",sourceID,ugcType,@(eventID),userID];
    
    DRLTimeLineStaticModel *hasStaticModel = [[DRLTimeLineDBManager shareManager].hasRecordTable getOneObjectWithEventKey:key];
    
    if (hasStaticModel && ![self isOutMaxTime:hasStaticModel.event_time] && [self needRemoveSame:eventID]){
        return;
    }
    
    if (eventID == DRLRecordTimeLineTypeMayClick) {// 上报疑似点击,若是30分钟内已上报点击,则不上报疑似点击
        
        NSString *mayKey = [NSString stringWithFormat:@"%@_%@_%@_%@",sourceID,ugcType,@(DRLRecordTimeLineTypeClick),userID];
        
        DRLTimeLineStaticModel *hasStaticModel1 = [[DRLTimeLineDBManager shareManager].hasRecordTable getOneObjectWithEventKey:mayKey];
        
        if (hasStaticModel1 && ![self isOutMaxTime:hasStaticModel1.event_time] && [self needRemoveSame:eventID]){
            return;
        }
        
    }
    
    
    if (sourceID.length == 0 || ugcType.length == 0 || pack.length == 0) {
        return;
    }else if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        
        NSLog(@"==============目前无网络=====无网络");
        // 不可重复添加
        DRLTimeLineStaticModel *hasStaticModel1 = [[DRLTimeLineDBManager shareManager].failRecodTable getOneObjectWithEventKey:key];
        
        if (hasStaticModel1 && ![self isOutMaxTime:hasStaticModel1.event_time] && [self needRemoveSame:eventID]){
            return;
        }
        
        
        DRLTimeLineStaticModel *model = [self screteDBModelEventID:eventID sourceID:sourceID ugcType:ugcType pack:pack userID:userID value:value showImageArr:imageIDArr allCount:allPhotoCount];
        
        [[DRLTimeLineDBManager shareManager].failRecodTable insertOrReplaceObject:model];
        
        return;
    }
        
    
    if ([self.recordArr containsObject:key] && [self needRemoveSame:eventID]) {
        return;
    }else {
        [self.recordArr addObject:key];
    }
    
    dispatch_async(self->_queue, ^{
        
            TimeLineLock();
            
        NSLog(@"=========%@",key);
        
            NSLog(@"此时我正在有条不紊的进行着");
            
        
        if (eventID == DRLRecordTimeLineTypeMayClick) {// 上报疑似点击,若是30分钟内已上报点击,则不上报疑似点击
            
            NSString *mayKey = [NSString stringWithFormat:@"%@_%@_%@_%@",sourceID,ugcType,@(DRLRecordTimeLineTypeClick),userID];
            
            DRLTimeLineStaticModel *hasStaticModel1 = [[DRLTimeLineDBManager shareManager].hasRecordTable getOneObjectWithEventKey:mayKey];
            
            if (hasStaticModel1 && ![self isOutMaxTime:hasStaticModel1.event_time] && [self needRemoveSame:eventID]){
                
                TimeLineUnlock();
                
                return;
            }
            
        }
        
        
        
        DRLTimeLineStaticModel *model = [self screteDBModelEventID:eventID sourceID:sourceID ugcType:ugcType pack:pack userID:userID value:value showImageArr:imageIDArr allCount:allPhotoCount];
        
//            DRLTimeLineStaticModel *hasStaticModel = [[DRLTimeLineDBManager shareManager].hasRecordTable getOneObjectWithEventKey:model.event_key];
//
//            if (hasStaticModel && ![self isOutMaxTime:hasStaticModel.event_time]) {
//                [self.recordArr removeObject:model.event_key];
//                TimeLineUnlock();
//            }else {
                
                NSDictionary *dic = [self dicWithStaticModel:model];
                
                NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
                
                NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                
                NSString *tk = [TimeLineSecret stringByAppendingString:jsonString].ct_MD5String;
                
                NSDictionary *param = @{@"tk":tk};

                NSString *url = [self.timelineBaseUrl stringByAppendingString:[NSString stringWithFormat:@"?tk=%@",tk]];

                [DRLTimeLineRecordNetWorkManager POST:url params:param body:data completionBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
                
                    [self.recordArr removeObject:model.event_key];
                
                    NSLog(@"上报数据=======response= %@", responseObject);
                    NSNumber *code = responseObject[@"code"];
                
                    /*
                     
                     101 上报参数错误，如:服务端校验客户端上报请求 event_id 无效。
                     103 服务器繁忙(用于限制客户端频繁发送请求)
                     104 服务器其他错误，Msg 返回 Exceiption 信息
                     105 请求 tk 非法
                     200 ok
                     201 客户端加密错误
                     
                     */
                    
                    if (code.integerValue == 200 && ([self needRemoveSame:(DRLRecordTimeLineType)model.event_id] || (model.event_id == 5 && model.imageIDArr.count > 0))) {
                        
                        [[DRLTimeLineDBManager shareManager].hasRecordTable insertOrReplaceObject:model];
                        
                    }
                    
                    if (code.integerValue == 103 || code.integerValue == 104) {
                        [[DRLTimeLineDBManager shareManager].failRecodTable insertOrReplaceObject:model];
                    }
                    
                    NSLog(@"看到这里就h过去了，过去了，就这样");
                    
                    // cache数据再次上报
                    [self updateCacheRecord];
                    
                    TimeLineUnlock();
                    
                }];
                
//            }
        
    });
    
    
    
    
}

- (DRLTimeLineStaticModel *)screteDBModelEventID:(DRLRecordTimeLineType)eventID sourceID:(NSString *)sourceID ugcType:(NSString *)ugcType pack:(nonnull NSString *)pack userID:(nonnull NSString *)userID value:(CGFloat)value showImageArr:(nonnull NSArray *)imageIDArr allCount:(NSInteger)allPhotoCount {
    
    DRLTimeLineStaticModel *model = [[DRLTimeLineStaticModel alloc] init];
    //    model
        model.pack = pack;
        model.event_id = eventID;
    if (eventID == DRLRecordTimeLineTypeProgress) {
        model.value = [NSString stringWithFormat:@"%.0f",value*100].integerValue;
    }else if (eventID == DRLRecordTimeLineTypeStayTime) {
        model.value = (NSInteger)value;
    }
        
        model.event_key = [NSString stringWithFormat:@"%@_%@_%@_%@",sourceID,ugcType,@(eventID),userID];
        model.event_time = [[DRLTimeLineDBManager shareManager] curentTimemm];
        
    if (eventID == 5 && imageIDArr.count > 0) {
        
        DRLTimeLineStaticModel *hasStaticModel = [[DRLTimeLineDBManager shareManager].hasRecordTable getOneObjectWithEventKey:model.event_key];
        
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObjectsFromArray:hasStaticModel.imageIDArr];
        
        if (hasStaticModel && ([[DRLTimeLineDBManager shareManager] curentTimemm] - hasStaticModel.event_time <= 10*60*1000)) {
            
            for (NSInteger i = 0; i < imageIDArr.count; i ++) {
                NSString *addImageID = imageIDArr[i];
                BOOL needAdd = YES;
                for (NSInteger j = 0; j < hasStaticModel.imageIDArr.count; j ++) {
                    
                    NSString *imageID = hasStaticModel.imageIDArr[j];
                    if ([addImageID isEqualToString:imageID]) {
                        needAdd = NO;
                        break;
                    }
                    
                }
                
                if (needAdd) {
                    [arr addObject:addImageID];
                }
            }
            
            model.imageIDArr = arr;
            
            CGFloat changeValue = (CGFloat)(model.imageIDArr.count)/(CGFloat)allPhotoCount;
            
            model.value = [NSString stringWithFormat:@"%.0f",changeValue*100].integerValue;
        }else {
            model.imageIDArr = imageIDArr;
        }
        
    }
    
    return model;
}


- (void)updateCacheRecord {
    
    NSArray *cacheArr = [[DRLTimeLineDBManager shareManager].failRecodTable getAllObjects];
    
    if (cacheArr.count > 0 && self.recordArr.count == 0) {
        
        [self failCacheRecordNetWork:[cacheArr mutableCopy]];
        
    }
    
}

- (void)failCacheRecordNetWork:(NSMutableArray *)arr {
    
    if ([self.recordArr count] > 0 || arr.count == 0) {
        return;
    }
    
    DRLTimeLineStaticModel *model = arr[0];
    
    DRLTimeLineStaticModel *hasStaticModel = [[DRLTimeLineDBManager shareManager].hasRecordTable getOneObjectWithEventKey:model.event_key];
    
    if (hasStaticModel && ![self isOutMaxTime:hasStaticModel.event_time] && [self needRemoveSame:(DRLRecordTimeLineType)(model.event_id)]){
        
        [[DRLTimeLineDBManager shareManager].failRecodTable deleteObjectWithEventKey:model.event_key];
        
        [arr removeObject:model];
        
        [self failCacheRecordNetWork:arr];
        
        return;
    }
    
    
    NSDictionary *dic = [self dicWithStaticModel:model];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSString *tk = [TimeLineSecret stringByAppendingString:jsonString].ct_MD5String;
    
    NSString *url = [self.timelineBaseUrl stringByAppendingString:[NSString stringWithFormat:@"?tk=%@",tk]];
    
    NSDictionary *param = @{@"tk":tk};

    [DRLTimeLineRecordNetWorkManager POST:url params:param body:data completionBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
    
    
        NSLog(@"上报数据=======response= %@", responseObject);
        
        NSNumber *code = responseObject[@"code"];
        /*
        101 上报参数错误，如:服务端校验客户端上报请求 event_id 无效。
        103 服务器繁忙(用于限制客户端频繁发送请求)
        104 服务器其他错误，Msg 返回 Exceiption 信息
        105 请求 tk 非法
        200 ok
        201 客户端加密错误
        */
        if (code.integerValue == 200) {
            
            [[DRLTimeLineDBManager shareManager].failRecodTable deleteObjectWithEventKey:model.event_key];
            
            if ([self needRemoveSame:(DRLRecordTimeLineType)model.event_id] || (model.event_id == 5 && model.imageIDArr.count > 0)) {
                [[DRLTimeLineDBManager shareManager].hasRecordTable insertOrReplaceObject:model];
            }
            
            
            
        }else if (code.integerValue == 101 || code.integerValue == 105 || code.integerValue == 201) {
            [[DRLTimeLineDBManager shareManager].failRecodTable deleteObjectWithEventKey:model.event_key];
        }
        
        [arr removeObject:model];
        
        [self failCacheRecordNetWork:arr];
    
    }];
    
    
}

- (NSDictionary *)dicWithStaticModel:(DRLTimeLineStaticModel *)model {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (model.pack.length > 0) {
        [dic setObject:model.pack forKey:@"pack"];
    }
    
    
    [dic setObject:@(model.event_id) forKey:@"event_id"];
    
    
    [dic setObject:@([[DRLTimeLineDBManager shareManager] curentTimemm]) forKey:@"event_time"];
    if (model.event_id == DRLRecordTimeLineTypeStayTime || model.event_id == DRLRecordTimeLineTypeProgress) {
        if (model.value) {
            [dic setObject:@(model.value) forKey:@"value"];
        }
    }
    
    if (self.recordNetStatus) {
        [dic setObject:self.recordNetStatus forKey:@"network"];
    }
    
    return dic;
}

- (BOOL)needRemoveSame:(DRLRecordTimeLineType)type {
    
    if (type == DRLRecordTimeLineTypeProgress || type == DRLRecordTimeLineTypeStayTime) {
        return NO;
    }
    
    return YES;
    
}

- (BOOL)isOutMaxTime:(long long)time {
    
    return ([[DRLTimeLineDBManager shareManager] curentTimemm]-time) > maxCachTime;
    
}

#pragma mark = property

- (DRLRecordSafeMutableArray *)recordArr {
    
    if (!_recordArr) {
        _recordArr = [[DRLRecordSafeMutableArray alloc] init];
    }
    
    return _recordArr;
}




- (CXCallObserver *)myCallObserver  API_AVAILABLE(ios(10.0)){
    
    if (!_myCallObserver) {
        _myCallObserver = [[CXCallObserver alloc] init];
    }
    
    return _myCallObserver;
}


- (CTCallCenter *)myCallCenter {
    
    if (!_myCallCenter) {
        _myCallCenter = [[CTCallCenter alloc] init];
    }
    
    return _myCallCenter;
}

- (HLNetWorkReachability *)hostReachability {
    
    if (!_hostReachability) {
        _hostReachability = [HLNetWorkReachability reachabilityWithHostName:@"www.baidu.com"];
    }
    
    return _hostReachability;
    
}

@end
