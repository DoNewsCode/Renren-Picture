//
//  DRMEAVSEVideoMixCommand.h
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/8.
//

#import "DRMEAVSECommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRMEAVSEVideoMixCommand : DRMEAVSECommand

- (void)performWithAsset:(AVAsset *)asset mixAsset:(AVAsset *)mixAsset;

- (void)performWithAssets:(NSArray *)assets;

@end

NS_ASSUME_NONNULL_END
