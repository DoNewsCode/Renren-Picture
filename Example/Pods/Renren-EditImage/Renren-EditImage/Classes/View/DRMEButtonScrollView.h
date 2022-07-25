//
//  DRMEButtonScrollView.h
//  TestPod
//
//  Created by 李晓越 on 2020/3/30.
//  Copyright © 2020 李晓越. All rights reserved.
//  拍照和摄像按钮的滚动视图
//  可以扩展成，传一个按钮数组进来，就完美了

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class DRMEButtonScrollView;

typedef NS_ENUM(NSUInteger, DRMEButtonType) {
    DRMEButtonTypeTakePhoto = 0,    // 拍照
    DRMEButtonTypeCamera            // 摄像
};

@protocol DRMEButtonScrollViewDelegate <NSObject>

@optional

/// 选中了哪个按钮的回调
/// @param buttonScrollView 视图
/// @param buttonType DRMEButtonType类型
- (void)buttonScrollView:(DRMEButtonScrollView *)buttonScrollView
      scrollToButtonType:(DRMEButtonType)buttonType;

@end

@interface DRMEButtonScrollView : UIView

@property(nonatomic,weak) id<DRMEButtonScrollViewDelegate> delegate;
@property(nonatomic,assign,readonly) DRMEButtonType buttonType;

/// 只拍照
@property(nonatomic,assign) BOOL onlyTakePhoto;
/// 只拍摄
@property(nonatomic,assign) BOOL onlyTakeVideo;

@end

NS_ASSUME_NONNULL_END
