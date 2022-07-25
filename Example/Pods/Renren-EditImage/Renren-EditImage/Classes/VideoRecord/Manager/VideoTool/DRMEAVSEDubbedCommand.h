//
//  DRMEAVSEDubbedCommand.h
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/8.
//  配音

#import "DRMEAVSECommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRMEAVSEDubbedCommand : DRMEAVSECommand

- (void)performWithAsset:(AVAsset *)asset mixAsset:(AVAsset *)mixAsset;

/**
 插入时间
 */
@property (nonatomic , assign) CMTime insertTime;

/**
 原音频音量 0.0~1.0
 */
@property (nonatomic , assign) float audioVolume;

/**
 配音音量 0.0~1.0
 */
@property (nonatomic , assign) float mixVolume;


@end

NS_ASSUME_NONNULL_END
