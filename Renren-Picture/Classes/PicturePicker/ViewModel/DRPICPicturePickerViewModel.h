//
//  DRPICPicturePickerViewModel.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/11.
//

#import <Foundation/Foundation.h>

#import "DRPICPicturePickerModel.h"

#import "DRPICPicturePickerLevitateView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^DRPICPicturePickerViewModelCompleteBlock)(BOOL success);

@interface DRPICPicturePickerViewModel : NSObject

@property (nonatomic, strong) DRPICPicturePickerModel *model;

/// 功能及预览功能浮窗
@property (nonatomic, strong) DRPICPicturePickerLevitateView *levitateView;

- (void)createAlbumComplete:(DRPICPicturePickerViewModelCompleteBlock)complete;

- (BOOL)processSelectedPicture:(DRPICPicture *)picture;
- (BOOL)processCancelSelectedPicture:(DRPICPicture *)picture;

@end

NS_ASSUME_NONNULL_END
