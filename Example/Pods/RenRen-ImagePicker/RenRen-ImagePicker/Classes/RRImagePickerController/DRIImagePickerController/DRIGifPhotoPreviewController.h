//
//  DRIGifPhotoPreviewController.h
//  DRIImagePickerController
//
//  Created by ttouch on 2016/12/13.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DRIAssetModel, DRIPictureBrowseInteractiveAnimatedTransition;
@interface DRIGifPhotoPreviewController : UIViewController
@property (nonatomic, copy) void (^backButtonClickBlock)();
@property (nonatomic, copy) void (^doneButtonClickBlock)();
@property (nonatomic, copy) void (^doneButtonClickBlockWithPreviewType)(NSArray<UIImage *> *photos,NSArray *assets);
@property (nonatomic, strong) DRIAssetModel *model;
@property (nonatomic, strong) NSMutableArray *photos; 
@property (nonatomic, strong) DRIPictureBrowseInteractiveAnimatedTransition *animatedTransition;
@end
