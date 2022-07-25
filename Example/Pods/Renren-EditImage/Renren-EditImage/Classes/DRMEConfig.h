//
//  DRPPersonalConfig.h
//  RenrenOfficial-iOS-Concept
//
//  Created by donews on 2019/1/23.
//  Copyright © 2019年 renren. All rights reserved.
//

#ifndef DNRecallConfig_h
#define DNRecallConfig_h

#import <DNCommonKit/DNBaseMacro.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <YYCategories/YYCategories.h>
#import "NSBundle+DRMEExtension.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import <YYModel/YYModel.h>
#import "UIImage+DRMEExtension.h"
#import "DRMEVideoManager.h"
#import "DRPPop.h"


// 0.弱引用/强引用
#define WeakSelf(type) __weak typeof(type) weak##type = type;
#define StrongSelf(type) __strong typeof(type) type = weak##type;

#define RandomColor ([UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1])

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

// 3.常用对象
#define kApplication [UIApplication sharedApplication]
#define kAppDelegate ([UIApplication sharedApplication].delegate)
#define kNotificationCenter [NSNotificationCenter defaultCenter]
#define kUserDefault [NSUserDefaults standardUserDefaults]

// 4.判断系统版本
#define kiOS6OrLater ([[UIDevice currentDevice].systemVersion doubleValue] >= 6.0)
#define kiOS7OrLater ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define kiOS8OrLater ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define kiOS9OrLater ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)
#define kiOS10OrLater ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)

// 5.判断手机型号
#define kIsIphone4                         ([UIScreen mainScreen].bounds.size.height == 480)
#define kIsIphone5                         ([UIScreen mainScreen].bounds.size.height == 568)
#define kIsIphone6                         ([UIScreen mainScreen].bounds.size.height == 667)
#define kIsIphone6p                        ([UIScreen mainScreen].bounds.size.height == 736)
#define kIsIphonePlush                     ([UIScreen mainScreen].bounds.size.width == 414)
// 判断是否为iPhone X 系列  这样写消除了在Xcode10上的警告
#define kIsIPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

// 字体
#define kSizeScale              (kScreenWidth / 414) // 设计图按414设置的，按比例设置字号吧
#define kFontSize(value)        kFontRegularSize(value)


#define kFontRegularSize(value) [UIFont fontWithName:@"PingFangSC-Regular" size:value * kSizeScale]
#define kFontThinSize(value)    [UIFont fontWithName:@"PingFangSC-Thin" size:value * kSizeScale]
#define kFontMediumSize(value)  [UIFont fontWithName:@"PingFangSC-Medium" size:value * kSizeScale]
#define kFontLightSize(value)   [UIFont fontWithName:@"PingFangSC-Light" size:value * kSizeScale]


// 屏幕尺寸
#ifdef kScreenWidth
#else
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#endif

#ifdef kScreenHeight
#else
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#endif


// 状态栏高度
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
// 导航+状态栏高度
#define kNavigationHeight (kStatusBarHeight + 44)
// tabbar安全高度
#define kSafeAreaHeight (kIsIPhoneX ? 34 : 0)
// tabbar高度
#define kTabbarHeight (49 + kSafeAreaHeight)

// 底部按钮中文字 靠下 的偏移距离
#define kBottomSafeAreaHeight (kIsIPhoneX ? 20 : 0)

// 7.测试的时候打印语句，发布程序的时候自动去除打印语句
// NSLog 的宏定义
#ifdef DEBUG
#define DNLog(fmt, ...) NSLog((@"\n#####%s-》%s [line %d]\n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DNLog(...);
#define DNLogError(...);
#endif

// *************************** 单利 ***************************
// .h文件
#define SNSingletonH(name) + (instancetype) shared ## name;

// .m文件
#define SNSingletonM(name) \
static id _instance = nil; \
+ (id) allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (instancetype) shared ## name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
- (id) copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}

// 适配 iOS 11 重写 adjustsScrollViewInsets
#define adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)



#endif
