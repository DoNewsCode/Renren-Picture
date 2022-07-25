//
//  DRMEAVSEExportCommand.m
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/8.
//

#import "DRMEAVSEExportCommand.h"

@interface DRMEAVSEExportCommand ()

@property (nonatomic , assign) CGFloat ratioParam;

@end


@implementation DRMEAVSEExportCommand

- (instancetype)initWithComposition:(DRMEAVSEComposition *)composition{
    if (self = [super initWithComposition:composition]) {
        self.videoQuality = 0;
    }
    return self;
}

- (void)dealloc{
    
}

- (void)performSaveAsset:(AVAsset *)asset byPath:(NSString *)path{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    // Remove Existing File
    [manager removeItemAtPath:path error:nil];
    
    // Step 2
    if (self.composition.presetName.length == 0) {
        self.composition.presetName = AVAssetExportPresetHighestQuality;
    }
    
    if (!self.composition.fileType) {
        self.composition.fileType = AVFileTypeMPEG4;
    }
    
    self.exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:self.composition.presetName];
   
    self.exportSession.shouldOptimizeForNetworkUse = YES;
    self.exportSession.videoComposition = self.composition.mutableVideoComposition;
    self.exportSession.audioMix = self.composition.mutableAudioMix;
    
    self.exportSession.timeRange = CMTimeRangeMake(kCMTimeZero, [self.composition duration]);
    
    self.exportSession.outputURL = [NSURL fileURLWithPath:path];
    self.exportSession.outputFileType = self.composition.fileType;
    
    if (self.videoQuality) {
        
        if ([self.composition.presetName isEqualToString:AVAssetExportPreset640x480]) {
            self.ratioParam = 0.02 ;
        }
        
        if ([self.composition.presetName isEqualToString:AVAssetExportPreset960x540]) {
            self.ratioParam = 0.04 ;
        }
        
        if ([self.composition.presetName isEqualToString:AVAssetExportPreset1280x720]) {
            self.ratioParam = 0.08 ;
        }
        
        if (self.ratioParam) {
            self.exportSession.fileLengthLimit = CMTimeGetSeconds(self.composition.duration) * self.ratioParam * self.composition.videoQuality * 1024 * 1024;
        }
        
    }
    
  
    [self.exportSession exportAsynchronouslyWithCompletionHandler:^(void){

        switch (self.exportSession.status) {
            case AVAssetExportSessionStatusCompleted:
                 [[NSNotificationCenter defaultCenter] postNotificationName:DRMEAVSEExportCommandCompletionNotification object:self];
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog(@"%@",self.exportSession.error);
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:DRMEAVSEExportCommandCompletionNotification
                 object:self userInfo:@{DRMEAVSEExportCommandError:self.exportSession.error}];
                break;
            case AVAssetExportSessionStatusCancelled:
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:DRMEAVSEExportCommandCompletionNotification
                 object:self userInfo:@{DRMEAVSEExportCommandError:[NSError errorWithDomain:AVFoundationErrorDomain code:-10000 userInfo:@{NSLocalizedFailureReasonErrorKey:@"User cancel process!"}]}];
                break;
            default:
                break;
        }
        
    }];
}

- (void)performSaveByPath:(NSString *)path{
    [self performSaveAsset:self.composition.mutableComposition byPath:path];
}




@end
