//
//  DRMEAVSERangeCommand.h
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/8.
//

#import "DRMEAVSECommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRMEAVSERangeCommand : DRMEAVSECommand


- (void)performWithAsset:(AVAsset *)asset timeRange:(CMTimeRange)range;


@end

NS_ASSUME_NONNULL_END
