//
//  DRPCheckTypeView.h
//  Renren-Pop
//
//  Created by 李晓越 on 2020/3/11.
//

#import <UIKit/UIKit.h>
#import "DRPPopConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRPCheckTypeView : UIView

+ (instancetype)checkTypeView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

// 计算自己的高度
@property(nonatomic,assign) CGFloat selfHeight;
@property(nonatomic,assign) DRPCheckType checkType;

@property(nonatomic,assign) BOOL isCompleteCheck;

@property(nonatomic,copy) void(^clickButton)(DRPCheckType checkType);

// 修改为已处理情况下的内容
- (void)setCompletedUI;

@end

NS_ASSUME_NONNULL_END
