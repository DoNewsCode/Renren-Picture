//
//  DRMEMosaicViewController.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/10/28.
//

#import <UIKit/UIKit.h>
#import "DRMEPhotoEditAnimation.h"
#import "DRMEBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^MosaicEditDoneBlock)(UIImage *mosaicImage);

@interface DRMEMosaicViewController : DRMEBaseViewController<UINavigationControllerDelegate>

@property(nonatomic,strong) UIImage *originImage;

@property(nonatomic,copy) MosaicEditDoneBlock mosaicEditDoneBlock;

@property(nonatomic,strong) DRMEPhotoEditAnimation *animation;

@end

NS_ASSUME_NONNULL_END
