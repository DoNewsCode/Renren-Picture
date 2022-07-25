//
//  DRMEAVSEReplaceSoundCommand.h
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/8.
//

#import "DRMEAVSECommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRMEAVSEReplaceSoundCommand : DRMEAVSECommand

- (void)performWithAsset:(AVAsset *)asset replaceAsset:(AVAsset *)replaceAsset;

@end

NS_ASSUME_NONNULL_END
