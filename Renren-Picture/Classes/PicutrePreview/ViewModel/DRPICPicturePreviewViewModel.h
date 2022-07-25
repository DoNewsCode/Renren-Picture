//
//  DRPICPicturePreviewViewModel.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/17.
//

#import <Foundation/Foundation.h>

#import "DRPICPicturePreviewModel.h"

#import "DRPICPicturePreviewLevitateView.h"

#import "DRPICPicturePreviewChannelViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRPICPicturePreviewViewModel : NSObject

@property (nonatomic, strong) DRPICPicturePreviewModel *model;

@property (nonatomic, strong) DRPICPicturePreviewLevitateView *levitateView;

/// 预览引导视图
@property (nonatomic, strong) DRPICPicturePreviewChannelViewController *previewChannelViewController;

- (BOOL)processSelectedPicture:(DRPICPicture *)picture;
- (BOOL)processCancelSelectedPicture:(DRPICPicture *)picture;
- (void)processContent;
@end

NS_ASSUME_NONNULL_END
