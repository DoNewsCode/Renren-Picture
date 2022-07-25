//
//  DRMEBrushViewController.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/4/9.
//

#import "DRMEBaseViewController.h"
#import "DRMEPhotoEditAnimation.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRMEBrushViewController : DRMEBaseViewController<UINavigationControllerDelegate>

@property(nonatomic,strong) UIImage *originImage;

@property(nonatomic,copy) void(^brushSuccessBlock)(UIImage *brushImage);

@property(nonatomic,strong) DRMEPhotoEditAnimation *animation;

@end

NS_ASSUME_NONNULL_END
