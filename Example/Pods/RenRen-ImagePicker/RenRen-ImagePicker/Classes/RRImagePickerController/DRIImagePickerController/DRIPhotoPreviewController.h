//
//  DRIPhotoPreviewController.h
//  DRIImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DRIPictureBrowseInteractiveAnimatedTransition;

@interface DRIPhotoPreviewController : UIViewController

@property (nonatomic, strong) NSMutableArray *models;                  ///< All photo models / 所有图片模型数组
@property (nonatomic, strong) NSMutableArray *photos;              ///< All photoUrls  / 所有图片数组
@property (nonatomic, assign) NSInteger currentIndex;           ///< Index of the photo user click / 用户点击的图片的索引
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;       ///< If YES,return original photo / 是否返回原图
@property (nonatomic, assign) BOOL isCropImage;

/**
 是否隐藏编辑按钮
 */
@property (nonatomic, assign) BOOL isHiddenEdit;

/// Return the new selected photos / 返回最新的选中图片数组
@property (nonatomic, copy) void (^backButtonClickBlock)(BOOL isSelectOriginalPhoto);
@property (nonatomic, copy) void (^doneButtonClickBlock)(BOOL isSelectOriginalPhoto);
@property (nonatomic, copy) void (^doneButtonClickBlockCropMode)(UIImage *cropedImage,id asset);
@property (nonatomic, copy) void (^doneButtonClickBlockWithPreviewType)(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto);


////动画过渡转场
//@property (nonatomic, strong) RHCTransitionAnimationPush * pushTransitionAnimation;
//
////手势过渡转场
//@property (nonatomic, strong) RHCTransitionInteractivePop * popTransitionInteractive;
//
////动画过渡转场
//@property (nonatomic, strong) RHCTransitionAnimationPresent * presentTransitionAnimation;

@property (nonatomic, strong) DRIPictureBrowseInteractiveAnimatedTransition *animatedTransition;
@end
