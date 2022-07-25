//
//  DRMEAVSEImageMixCommand.h
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/8.
//

#import "DRMEAVSECommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRMEAVSEImageMixCommand : DRMEAVSECommand

@property (nonatomic , assign) BOOL imageBg;

@property (nonatomic , strong) UIImage *image;

@property (nonatomic , strong) NSURL *fileUrl;

// 传回要放的图片位置
- (void)imageLayerRectWithVideoSize:(CGRect (^) (CGSize videoSize))imageLayerRect;


@end

NS_ASSUME_NONNULL_END
