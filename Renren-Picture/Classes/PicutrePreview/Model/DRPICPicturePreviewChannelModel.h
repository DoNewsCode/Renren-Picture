//
//  DRPICPicturePreviewChannelModel.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/17.
//

#import <Foundation/Foundation.h>

#import "DRPICPicture.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRPICPicturePreviewChannelModel : NSObject

/// 当前图像
@property (nonatomic, strong) DRPICPicture *currentPicture;
/// 图像数组
@property (nonatomic, strong) NSMutableArray<DRPICPicture *> *pictures;

@end

NS_ASSUME_NONNULL_END
