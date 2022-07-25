//
//  DRMEAVSEExportCommand.h
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/8.
//

#import "DRMEAVSECommand.h"
#import <AssetsLibrary/AssetsLibrary.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRMEAVSEExportCommand : DRMEAVSECommand


@property (nonatomic , strong)AVAssetExportSession *exportSession;

/**
 只有在开启画布的时候并且不是自动分辩率下才有效
 */
@property (nonatomic , assign) NSInteger videoQuality;

- (void)performSaveByPath:(NSString *)path;

- (void)performSaveAsset:(AVAsset *)asset byPath:(NSString *)path;


@end

NS_ASSUME_NONNULL_END
