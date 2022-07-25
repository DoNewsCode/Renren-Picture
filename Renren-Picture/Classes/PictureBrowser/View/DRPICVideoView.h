//
//  DRPICVideoView.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/17.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPICVideoView : UIView

@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

- (void)configPlayButton;

@end

NS_ASSUME_NONNULL_END
