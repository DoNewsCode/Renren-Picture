//
//  DRPICVideoView.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/17.
//

#import "DRPICVideoView.h"
#import "UIImage+RenrenPicture.h"

@interface DRPICVideoView ()

@property (nonatomic, strong) UIButton *btnPlay;

@end

@implementation DRPICVideoView

- (UIButton *)btnPlay {
    if (!_btnPlay) {
        _btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPlay.frame = self.bounds;
        [_btnPlay setImage:[UIImage ct_imageRenrenPictureUIWithNamed:@"MMVideoPreviewPlay"] forState:UIControlStateNormal];
        [_btnPlay addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPlay;
}

- (void)playVideo {
    self.btnPlay.selected = !self.btnPlay.selected;
    NSString *imgStr = self.btnPlay.selected ? @"" : @"MMVideoPreviewPlay";
    [self.btnPlay setImage:[UIImage ct_imageRenrenPictureUIWithNamed:imgStr] forState:UIControlStateNormal];
    self.btnPlay.selected ? [self.player play] : [self.player pause];
}

- (void)configPlayButton {
    [self addSubview:self.btnPlay];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayerAndShowNaviBar) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)pausePlayerAndShowNaviBar {
    [self.player pause];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setPlayer:(AVPlayer *)player {
    _player = player;
    /// 非静音
    _player.muted = NO;
}

@end
