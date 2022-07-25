//
//  DRUVideoStatus.m
//  Renren-UserKit
//
//  Created by 陈金铭 on 2019/9/6.
//

#import "DRUVideoStatus.h"

#import "DRRFile.h"

/** 文件名称 */
static NSString *const DRUVideoStatusFile = @"VideoStatus";

@interface DRUVideoStatus ()

@property(nonatomic, copy) NSString *filePath;
@property(nonatomic, strong) NSMutableDictionary *videoStatus;
@property(nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation DRUVideoStatus

//单例对象
static DRUVideoStatus *_instance = nil;
//单例
+ (instancetype)sharedVideoStatus {
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initialization {
    self.filePath = [[DRRFile sharedFile].configFilePath stringByAppendingPathComponent:DRUVideoStatusFile];
    self.defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *videoStatus = [self.defaults objectForKey:DRUVideoStatusFile];
    if (videoStatus == nil) {
        NSDictionary *tempVideoStatus = @{@"autoPlayForWiFi" : [NSNumber numberWithBool:YES],
                                          @"watermark" : [NSNumber numberWithBool:YES],
                                          @"sharpness" : [NSNumber numberWithInteger:DRUVideoSharpnessHD]
                                          };
        videoStatus = tempVideoStatus;
        [self.defaults setObject:videoStatus forKey:DRUVideoStatusFile];
        [self.defaults synchronize];
        
    }
    self.videoStatus = [NSMutableDictionary dictionaryWithDictionary:videoStatus];
    self.autoPlayForWiFi = [[self.videoStatus objectForKey:@"autoPlayForWiFi"] boolValue];
    self.watermark = [[self.videoStatus objectForKey:@"watermark"] boolValue];
    self.sharpness = [[self.videoStatus objectForKey:@"sharpness"] integerValue];
}

- (void)setAutoPlayForWiFi:(BOOL)autoPlayForWiFi {
    _autoPlayForWiFi = autoPlayForWiFi;
    if (autoPlayForWiFi == [[self.videoStatus objectForKey:@"autoPlayForWiFi"] boolValue]) {
        return;
    }
    [self.videoStatus setObject:[NSNumber numberWithBool:autoPlayForWiFi] forKey:@"autoPlayForWiFi"];
    [self.defaults setObject:self.videoStatus forKey:DRUVideoStatusFile];
    [self.defaults synchronize];
    
}

- (void)setWatermark:(BOOL)watermark {
    _watermark = watermark;
    if (watermark == [[self.videoStatus objectForKey:@"watermark"] boolValue]) {
        return;
    }
    [self.videoStatus setObject:[NSNumber numberWithBool:watermark] forKey:@"watermark"];
    [self.defaults setObject:self.videoStatus forKey:DRUVideoStatusFile];
    [self.defaults synchronize];
}

- (void)setSharpness:(DRUVideoSharpness)sharpness {
    _sharpness = sharpness;
    if (sharpness == [[self.videoStatus objectForKey:@"sharpness"] integerValue]) {
        return;
    }
    [self.videoStatus setObject:[NSNumber numberWithInteger:sharpness] forKey:@"sharpness"];
    [self.defaults setObject:self.videoStatus forKey:DRUVideoStatusFile];
    [self.defaults synchronize];
}

@end
