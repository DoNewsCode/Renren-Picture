//
//  DNPopStyle.h
//  DNPop
//
//  Created by 陈金铭 on 2019/7/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// Action 排列方式
typedef NS_ENUM(NSUInteger, DNPopStyleActionSort) {
    DNPopStyleActionSortByVertical,   // 垂直
    DNPopStyleActionSortByHorizontal,      // 水平
};

@interface DNPopStyle : NSObject
/// Action 排列方式 默认垂直（DNPopStyleActionSortByVertical）
@property(nonatomic, assign) DNPopStyleActionSort actionSort;

/** 两侧圆角，默认：CGSizeMake(20, 20) */
@property(nonatomic, assign) CGSize cornerRadii;

/** 水平间距,默认：15. */
@property(nonatomic, assign) CGFloat horizontalSpacing;
/** 垂直间距,默认：10. */
@property(nonatomic, assign) CGFloat verticalVSpacing;

/** UIEdgeInsetsMake(30., 20., 30., 20.); */
@property(nonatomic, assign) UIEdgeInsets headerEdge;
/** 标题与文本垂直间距,默认：5. */
@property(nonatomic, assign) CGFloat headerInsetsMargin;

/** Alert宽度 仅在非未添加Custom的Action状态下生效，包含自定义的Action时其宽度跟随自定义Action中的Item宽度 默认：270 */
@property(nonatomic, assign) CGFloat alertWidth;
/** Alert最小高度 仅在非未添加Custom的Action状态下生效，包含自定义的Action时其宽度跟随自定义Action中的Item高度 默认：0  自适应 */
@property(nonatomic, assign) CGFloat alertheight;

/** 背景颜色,默认：[UIColor whiteColor]; */
@property(nonatomic, copy) UIColor *backgroundColor;
/** 分割线颜色,默认：[UIColor grayColor]; */
@property(nonatomic, copy) UIColor *dividingLineColor;

/** 分割线是否展示 默认：YES */
@property(nonatomic, assign) BOOL dividingLine;

/** 分割线左侧间距 默认：15 */
@property(nonatomic, assign) CGFloat dividingLineRightMargin;

/** 分割线右侧间距 默认：15 */
@property(nonatomic, assign) CGFloat dividingLineLeftMargin;

/** 分割线高度 默认：1 */
@property(nonatomic, assign) CGFloat dividingLineHeight;


/** 头部分割线是否展示 默认：YES */
@property(nonatomic, assign) BOOL headerLine;

/** 头部分割线左侧间距 默认：15 */
@property(nonatomic, assign) CGFloat headerLineRightMargin;

/** 头部分割线右侧间距 默认：15 */
@property(nonatomic, assign) CGFloat headerLineLeftMargin;

/** 头部分割线高度 默认：1 */
@property(nonatomic, assign) CGFloat headerLineHeight;

/** 标题颜色,默认：[UIColor blackColor]; */
@property(nonatomic, copy) UIColor *titleTextColor;

/** 消息颜色,默认：[UIColor grayColor]; */
@property(nonatomic, copy) UIColor *messageTextColor;

/** 标题字体,默认：[UIFont systemFontOfSize:16.] */
@property(nonatomic, copy) UIFont *titleFont;
/** 消息字体,默认：[UIFont systemFontOfSize:14.] */
@property(nonatomic, copy) UIFont *messageFont;



/** 默认颜色,默认：[UIColor blackColor]; */
@property(nonatomic, copy) UIColor *defaultTextColor;
/** 默认字体,默认：[UIFont systemFontOfSize:14.] */
@property(nonatomic, copy) UIFont *defaultFont;

/** 取消颜色,默认：[UIColor redColor]; */
@property(nonatomic, copy) UIColor *cancelTextColor;
/** 取消字体,默认：[UIFont systemFontOfSize:14.] */
@property(nonatomic, copy) UIFont *cancelFont;

@end

NS_ASSUME_NONNULL_END
