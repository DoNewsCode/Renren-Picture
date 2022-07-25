//
//  DRMEGPUImageMovie.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/3/20.
//

#import "GPUImageMovie.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRMEGPUImageMovie : GPUImageMovie

@property(nonatomic, copy) void (^onProcessMovieFrameDone)(GPUImageMovie *, CMTime);

@end

NS_ASSUME_NONNULL_END
