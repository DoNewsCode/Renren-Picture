//
//  DRPICPicturePickerViewController.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/10.
//

#import <UIKit/UIKit.h>

#import "DRPICPicturePickerViewModel.h"

#import "DRPICLoadingView.h"
#import "DRPICPicturePickerAlbumViewController.h"
#import "DRPICPicturePickerPickingOriginalButton.h"

NS_ASSUME_NONNULL_BEGIN



typedef void(^DRPICPicturePickerViewControllerEventBlock)(id eventObject);

@interface DRPICPicturePickerViewController : UIViewController

@property (nonatomic, strong) DRPICPicturePickerViewModel *viewModel;

@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;

/// 加载视图
@property (nonatomic, strong) DRPICLoadingView *loadingView;
/// 原图选择切换按钮
@property (nonatomic, strong) DRPICPicturePickerPickingOriginalButton *orginalButton;
/// 功能及预览功能浮窗
//@property (nonatomic, strong) DRPICPicturePickerLevitateView *levitateView;

/// 相册切换功能控制器
@property (nonatomic, strong) DRPICPicturePickerAlbumViewController *albumViewController;

/// 选中图像数组最大个数
@property (nonatomic, assign) NSInteger selectedPicturesMaxCount;

/// 选中事件的Block
@property (nonatomic, copy) DRPICPicturePickerViewControllerEventBlock eventBlock;

- (void)eventForEventBlock:(DRPICPicturePickerViewControllerEventBlock)eventBlock;

@end

NS_ASSUME_NONNULL_END
