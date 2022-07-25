//
//  DRBBaseTheme.h
//  Pods-Renren-BaseKit_Example
//
//  Created by Ming on 2019/3/23.
//  主题管理

#import <Foundation/Foundation.h>

#import "DRBThemeModel.h"

NS_ASSUME_NONNULL_BEGIN

// 默认每个Group的Item中都需使用默认主题方案及夜间主题方案
/** 默认主题方案名称 */
static NSString *const DRBThemeProgramDefault = @"DefaultTheme";
/** 夜间主题方案名称 */
static NSString *const DRBThemeProgramNight = @"NightTheme";

/** 通知名称：主题方案发生改变 */
static NSString *const DRBNotificationThemeProgramHasChanged = @"DRBNotificationThemeProgramHasChanged";


/**
 主题方案改变Block

 @param success 是否已经改变
 @param progress 进度（暂不可用）
 */
typedef void (^DRBBaseThemeProgressBlock)(BOOL success,CGFloat progress);

/**
 添加主题方案Block

 @param needAdd 是否需要添加（需对应使用其addThemeGroup:方法进行添加）
 */
typedef void (^DRBBaseThemeAddBlock)(BOOL needAdd);

@interface DRBBaseTheme : NSObject

/**
 单例

 @return 返回单例对象
 */
+ (instancetype)sharedInstance;

/**
 获取当前主题方案
 
 @param groupName 主题集合名称
 @param itemName 主题块名称
 @return 主题方案
 */
+ (DRBThemeModelProgram *)obtainProgram:(NSString *__nonnull)groupName itemName:(NSString *__nonnull)itemName;

/**
 配置切换主体方案

 @param programName 方案名称
 */
+ (void)configurationThemeWithProgramName:(NSString *__nonnull)programName withProgressBlock:(DRBBaseThemeProgressBlock)progressBlock;


/**
 添加主题集合
 （该方法适用于在个业务组件中的load方法中使用，进行初始化配置）
 @param themeGroup 主题集合模型
 */
+ (void)addThemeGroup:(DRBThemeModelGroup *__nonnull)themeGroup;


/**
 添加主题集合
 （该方法适用于在个业务组件中的load方法中使用，进行初始化配置，在检测到首次开启等需要配置主题集合时，会执行Block，需在Block中使用addThemeGroup:方法进行添加）
 @param name 主题集合名称
 @param themeAddBlock 添加block
 */
+ (void)addThemeGroupWithName:(NSString *)name themeAddBlock:(DRBBaseThemeAddBlock)themeAddBlock;

@end

NS_ASSUME_NONNULL_END
