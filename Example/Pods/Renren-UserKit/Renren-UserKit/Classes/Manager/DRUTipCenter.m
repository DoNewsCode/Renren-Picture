//
//  DRUTipCenter.m
//  Renren-UserKit
//
//  Created by 陈金铭 on 2019/8/5.
//

#import "DRUTipCenter.h"

#import "DRUAccountManager.h"

/** 文件名称 */
static NSString *const DRUTipCenterFile = @"TipCenter";

@interface DRUTipCenter ()

/** app图标提示 */
@property(nonatomic,strong, readwrite) DRUTip *appTip;
/** 首页Tab提示 */
@property(nonatomic,strong, readwrite) DRUTip *tabHomeTip;
/** 聊天Tab提示 */
@property(nonatomic,strong, readwrite) DRUTip *tabChatTip;
/** 发现Tab提示 */
@property(nonatomic,strong, readwrite) DRUTip *tabFindTip;
/** 用户Tab提示 */
@property(nonatomic,strong, readwrite) DRUTip *tabUserTip;
/** 消息提示 */
@property(nonatomic,strong, readwrite) DRUTip *messageTip;
/** App升级提示 */
@property(nonatomic, strong, readwrite) DRUTip *appUpdateTip;
/** TestFlight App升级提示 */
@property(nonatomic, strong, readwrite) DRUTip *testFlightAppUpdateTip;

/** 好友添加和关注提示*/
@property(nonatomic, strong, readwrite) DRUTip *friendsAddTip;
/** 人人运动消息提示*/
@property(nonatomic, strong, readwrite) DRUTip *sportsMessageTip;

@property(nonatomic, strong) DRUAccountManager *accountManager;
@property(nonatomic, strong) NSMutableDictionary *tipCenter;
@property(nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation DRUTipCenter

//单例对象
static DRUTipCenter *_instance = nil;
//单例
+ (instancetype)sharedTipCenter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [_instance initialization];
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
    self.accountManager = [DRUAccountManager sharedInstance];
    [self.accountManager addObserver:self forKeyPath:@"currentUser" options:NSKeyValueObservingOptionNew context:nil];
    self.defaults = [NSUserDefaults standardUserDefaults];

    self.appTip = [[DRUTip alloc] initWithFileName:@"appTip"];
    self.tabHomeTip = [[DRUTip alloc] initWithFileName:@"tabHomeTip"];
    self.tabChatTip = [[DRUTip alloc] initWithFileName:@"tabChatTip"];
    self.tabFindTip = [[DRUTip alloc] initWithFileName:@"tabFindTip"];
    self.tabUserTip = [[DRUTip alloc] initWithFileName:@"tabUserTip"];
    self.messageTip = [[DRUTip alloc] initWithFileName:@"messageTip"];
    self.appUpdateTip = [[DRUTip alloc] initWithFileName:@"appUpdateTip"];
    self.testFlightAppUpdateTip = [[DRUTip alloc] initWithFileName:@"testFlightAppUpdateTip"];
    
    self.friendsAddTip = [[DRUTip alloc] initWithFileName:@"friendsAddTip"];
    self.sportsMessageTip = [[DRUTip alloc] initWithFileName:@"sportsMessageTip"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.accountManager && [keyPath isEqualToString:@"currentUser"]) {
        
    }
}

@end
