//
//  DRMEAVSEExtractSoundCommand.m
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/8.
//

#import "DRMEAVSEExtractSoundCommand.h"

@implementation DRMEAVSEExtractSoundCommand

- (void)performWithAsset:(AVAsset *)asset
{
    [super performWithAsset:asset];
   
    NSArray *natureTrackAry = [[self.composition.mutableComposition tracksWithMediaType:AVMediaTypeVideo] copy];
    
    for (AVCompositionTrack *track in natureTrackAry) {
        [self.composition.mutableComposition removeTrack:track];
    }
    self.composition.fileType = AVFileTypeAppleM4A;
    self.composition.presetName = AVAssetExportPresetAppleM4A;
    
}
@end
