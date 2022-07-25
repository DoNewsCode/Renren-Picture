//
//  DRMEAVSEReplaceSoundCommand.m
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/8.
//

#import "DRMEAVSEReplaceSoundCommand.h"

@implementation DRMEAVSEReplaceSoundCommand

- (void)performWithAsset:(AVAsset *)asset replaceAsset:(AVAsset *)replaceAsset{
    
    [super performWithAsset:asset];
    
    
    CMTime insertionPoint = kCMTimeZero;
    CMTime duration;
    NSError *error = nil;
    
    NSArray *natureTrackAry = [[self.composition.mutableComposition tracksWithMediaType:AVMediaTypeAudio] copy];
    
    for (AVCompositionTrack *track in natureTrackAry) {
        [self.composition.mutableComposition removeTrack:track];
    }
    
    duration = CMTimeMinimum([replaceAsset duration], self.composition.duration);
    
    for (AVAssetTrack *audioTrack in [replaceAsset tracksWithMediaType:AVMediaTypeAudio]) {
        AVMutableCompositionTrack *compositionAudioTrack = [self.composition.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, duration) ofTrack:audioTrack atTime:insertionPoint error:&error];
    }
    
}

@end
