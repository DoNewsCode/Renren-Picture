//
//  DRBThemeModel.h
//  Pods-Renren-BaseKit_Example
//
//  Created by Ming on 2019/3/23.
//  主题模型

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DRBThemeModelGroup,DRBThemeModelItem,DRBThemeModelProgram,DRBThemeModelColorInfo,DRBThemeModelFontInfo,DRBThemeModelImageInfo;

#pragma mark - 主题模型
@interface DRBThemeModel : NSObject<NSCoding>

/** bundleIdentifier */
@property (nonatomic, copy) NSString *bundleIdentifier;
/** bundleIdentifier */
@property (nonatomic, copy) NSString *version;
/** bundleIdentifier */
@property (nonatomic, copy) NSString *build;
/** groups */
@property (nonatomic, strong) NSMutableArray<DRBThemeModelGroup *> *groups;

- (DRBThemeModelGroup *)obtainGroupWithName:(NSString *)name;

/**
 添加一个主题组

 @param group 组模型
 @return 是否添加成功
 */
- (BOOL)addGroup:(DRBThemeModelGroup *)group;

@end

#pragma mark - 主题集合模型
@interface DRBThemeModelGroup : NSObject<NSCoding>

/** name */
@property (nonatomic, copy) NSString *name;
/** sessions */
@property (nonatomic, strong) NSMutableArray<DRBThemeModelItem *> *items;


/**
 添加一个ThemeItem

 @param item ThemeItem
 */
- (void)addThemeItem:(DRBThemeModelItem *__nonnull)item;

/**
 获取一个主题组中的块

 @param name 块名称
 @return 块
 */
- (DRBThemeModelItem *)obtainItemsWithName:(NSString *)name;

@end

#pragma mark - 主题块模型
@interface DRBThemeModelItem : NSObject<NSCoding>

/** name */
@property (nonatomic, copy) NSString *name;
/** Programs */
@property (nonatomic, strong,readonly) NSMutableArray<DRBThemeModelProgram *> *programs;
/** 当前Program */
@property (nonatomic, strong,readonly) DRBThemeModelProgram *currentProgram;

/**
 添加方案
 
 @param program 方案
 @return 是否成功
 */
- (BOOL)addProgram:(DRBThemeModelProgram *)program;


/**
 配置/切换当前方案

 @param name 方案名称
 */
- (BOOL)configurationProgramWithName:(NSString *)name;

/**
 获取当前方案

 @return 方案
 */
- (DRBThemeModelProgram *)obtaincurrentProgram;

@end

#pragma mark - 主题方案模型
@interface DRBThemeModelProgram : NSObject<NSCoding>

/** 主题方案名称 */
@property (nonatomic, copy) NSString *name;
/** n */
@property (nonatomic, strong) DRBThemeModelColorInfo *colorInfo;
/** fontInfo */
@property (nonatomic, strong) DRBThemeModelFontInfo *fontInfo;
/** imageInfo */
@property (nonatomic, strong) DRBThemeModelImageInfo *imageInfo;

@end

#pragma mark - 颜色配置模型
@interface DRBThemeModelColorInfo : NSObject<NSCoding>

/** alpha */
@property (nonatomic, assign) CGFloat alpha;
/** 色值（十六进制） */
@property (nonatomic, copy) NSString *value;

/** 颜色 */
@property(nonatomic, copy) UIColor *color;

@end

#pragma mark - 字体配置模型
@interface DRBThemeModelFontInfo : NSObject<NSCoding>

/** size */
@property (nonatomic, assign) CGFloat size;
/** weight */
@property (nonatomic, assign) CGFloat weight;
/** 字形 */
@property (nonatomic, copy) NSString *glyph;

/** font */
@property(nonatomic, copy) UIFont *font;

@end

#pragma mark - 图片配置模型
@interface DRBThemeModelImageInfo : NSObject<NSCoding>

/** name */
@property (nonatomic, copy) NSString *name;
/** 下载链接 */
@property (nonatomic, copy) NSString *url;
/** width */
@property (nonatomic, assign) CGFloat width;
/** height */
@property (nonatomic, assign) CGFloat height;

/** image */
@property(nonatomic, copy) UIImage *image;

@end

NS_ASSUME_NONNULL_END
