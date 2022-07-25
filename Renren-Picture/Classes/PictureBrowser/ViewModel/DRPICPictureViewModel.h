//
//  DRPICPictureViewModel.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/17.
//

#import <Foundation/Foundation.h>

#import "DRPICPicturePreviewView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRPICPictureViewModel : NSObject

/// 图像视图
@property (nonatomic, strong) DRPICPicturePreviewView *pictureView;
/// 图像模型
@property (nonatomic, strong) DRPICPicture *picture;

- (instancetype)initWithPictureViewFrame:(CGRect)frame;

- (void)processPictureViewWithPicture:(DRPICPicture *)picture;

@end

NS_ASSUME_NONNULL_END
