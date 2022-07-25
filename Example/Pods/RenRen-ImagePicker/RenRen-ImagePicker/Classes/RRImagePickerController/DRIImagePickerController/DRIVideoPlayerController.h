//
//  DRIVideoPlayerController.h
//  DRIImagePickerController
//
//  Created by 谭真 on 16/1/5.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DRIAssetModel,DRIPictureBrowseInteractiveAnimatedTransition,DRIVideoModel;
@interface DRIVideoPlayerController : UIViewController

@property (nonatomic, strong) DRIAssetModel *model;
@property (nonatomic, strong) DRIPictureBrowseInteractiveAnimatedTransition *animatedTransition;
@property (nonatomic, strong) DRIVideoModel *videoModel;
@end
