//
//  DRMEAVSERotateCommand.h
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/8.
//

#import "DRMEAVSECommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRMEAVSERotateCommand : DRMEAVSECommand

- (void)performWithAsset:(AVAsset *)asset degress:(NSUInteger)degress;

@end

NS_ASSUME_NONNULL_END
