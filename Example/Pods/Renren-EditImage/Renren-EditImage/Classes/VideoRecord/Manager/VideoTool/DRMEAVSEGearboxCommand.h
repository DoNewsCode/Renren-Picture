//
//  WAAVSEGearboxCommand.h
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/8.
//

#import "DRMEAVSECommand.h"

@class DRMEAVSEGearboxCommandModel;

NS_ASSUME_NONNULL_BEGIN

@interface DRMEAVSEGearboxCommand : DRMEAVSECommand

- (void)performWithAsset:(AVAsset *)asset scale:(CGFloat)scale;

- (void)performWithAsset:(AVAsset *)asset models:(NSArray <DRMEAVSEGearboxCommandModel *> *)gearboxModels;

@end

NS_ASSUME_NONNULL_END
