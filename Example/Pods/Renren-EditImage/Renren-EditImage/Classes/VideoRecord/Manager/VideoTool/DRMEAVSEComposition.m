//
//  DRMEAVSEComposition.m
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/8.
//

#import "DRMEAVSEComposition.h"

@implementation DRMEAVSEComposition

- (NSMutableArray<AVMutableAudioMixInputParameters *> *)audioMixParams{
    if (!_audioMixParams) {
        _audioMixParams = [NSMutableArray array];
    }
    return _audioMixParams;
}

- (NSMutableArray<AVMutableVideoCompositionInstruction *> *)instructions{
    if (!_instructions) {
        _instructions = [NSMutableArray array];
    }
    return _instructions;
}

@end
