//
//  DRIVideoModel.m
//  RenRen-ImagePicker
//
//  Created by 张健康 on 2020/2/11.
//

#import "DRIVideoModel.h"

@implementation DRIVideoModel

- (instancetype)initWithVideoData:(NSData *)data{
    if (self = [super init]) {
        NSString *path = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat: @"temp-video-%f.mp4",[[NSDate date] timeIntervalSince1970]]];
        NSURL *videoUrl = [NSURL fileURLWithPath:path];
        BOOL success = [data writeToURL:videoUrl atomically:YES];
        if (!success) {return nil;}
        self.videoURL = videoUrl;
    }
    return self;
}
@end
