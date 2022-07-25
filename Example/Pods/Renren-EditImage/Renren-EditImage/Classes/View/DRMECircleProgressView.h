//
//  DRMECircleProgressView.h
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRMECircleProgressView : UIView

@property (nonatomic, strong) UIColor *progressColor; /**< 进度条颜色 默认红色*/
@property (nonatomic, strong) UIColor *progressBackgroundColor; /**< 进度条背景色 默认灰色*/
@property (nonatomic, assign) CGFloat progressWidth; /**< 进度条宽度 默认3*/
@property (nonatomic, assign) float percent; /**< 进度条进度 0-1*/
@property (nonatomic, assign) BOOL clockwise; /**< 0顺时针 1逆时针*/

@property (nonatomic, strong) UILabel *centerLabel; /**< 记录进度的Label*/
@property (nonatomic, strong) UIColor *labelbackgroundColor; /**<Label的背景色 默认clearColor*/
@property (nonatomic, strong) UIColor *textColor; /**<Label的字体颜色 默认黑色*/
@property (nonatomic, strong) UIFont *textFont; /**<Label的字体大小 默认15*/


@end

NS_ASSUME_NONNULL_END
