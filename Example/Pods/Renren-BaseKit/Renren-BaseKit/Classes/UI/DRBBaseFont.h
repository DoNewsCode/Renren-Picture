//
//  DRBBaseFont.h
//  Pods-Renren-BaseKit_Example
//
//  Created by Ming on 2019/3/23.
//  字体管理类

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const DRBNotice_MutableFontDidChange;//字体发生改变

@interface DRBBaseFont : NSObject

/** 字体缩放系数,默认0 标准 */
@property (nonatomic, assign ,readonly) CGFloat coefficient;


+ (instancetype)sharedInstance;

/**
 改变可变字体系数(取值范围：-10～10)
 
 @param coefficient 字体系数
 */
+ (void)createCoefficient:(CGFloat)coefficient;


/**
 获取当前字体缩放系数

 @return 字体缩放系数
 */
+ (CGFloat)currentCoefficient;

@end

NS_ASSUME_NONNULL_END
