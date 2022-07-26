//
//  DRIPhotoPickerController.h
//  DRIImagePickerController
//
//  Created by 谭真 on 15/12/24.
//  Copyright © 2015年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DRIAlbumModel;
@interface DRIPhotoPickerController : UIViewController

@property (nonatomic, assign) BOOL isFirstAppear;
@property (nonatomic, assign) NSInteger columnNumber;
@property (nonatomic, strong) DRIAlbumModel *model;

/**
 拍照后是否隐藏编辑按钮
 */
@property (nonatomic, assign) BOOL isHiddenEdit;

@end


@interface DRICollectionView : UICollectionView

@end
