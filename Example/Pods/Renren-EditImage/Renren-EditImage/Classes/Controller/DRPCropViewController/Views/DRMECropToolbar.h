//
//  DRMECropToolbar.h
//
//  包含 旋转 还原 取消 确定 功能的 tool bar view

#import <UIKit/UIKit.h>

@interface DRMECropToolbar : UIView

@property (nullable, nonatomic, copy) void (^rotateButtonButtonTapped)(void);
@property (nullable, nonatomic, copy) void (^resetButtonButtonTapped)(void);
@property (nullable, nonatomic, copy) void (^sureButtonButtonTapped)(void);
@property (nullable, nonatomic, copy) void (^cancelButtonButtonTapped)(void);

@property(nonatomic,assign) BOOL resetButtonEnabled;

@end
