//
//  DRIVideoModel.h
//  RenRen-ImagePicker
//
//  Created by 张健康 on 2020/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRIVideoModel : NSObject
@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) UIImage *coverImage;
- (instancetype)initWithVideoData:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
