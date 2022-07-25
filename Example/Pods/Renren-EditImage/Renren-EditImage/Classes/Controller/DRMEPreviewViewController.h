//
//  DRMEPreviewViewController.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/4/23.
//

#import "DRMEBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRMEPreviewViewController : DRMEBaseViewController

@property(nonatomic,strong) UIImage *originImage;

@property(nonatomic,copy) void(^previewDoneBlock)(void);

@end

NS_ASSUME_NONNULL_END
