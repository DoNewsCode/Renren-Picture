//
//  DRMEVideoTrimView.h
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/13.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN
@protocol DRMEVideoTrimViewDelegate <NSObject>

- (void)trimControlDidChangeLeftValue:(double)leftValue rightValue:(double)rightValue;

@end


@interface DRMEVideoTrimView : UIView

@property (nonatomic, assign) float leftValue;
@property (nonatomic, assign) float rightValue;
@property (nonatomic, strong) UIImageView *maskImageView;
@property (nonatomic, assign) id <DRMEVideoTrimViewDelegate> delegate;


@property (nonatomic, strong) NSString *imagePath;

- (void)reloadImageWithCount:(NSInteger)count;
- (NSUInteger)getCurrentIndex;
- (id)initWithFrame:(CGRect)frame videoDuration:(float)duration;

- (void)setImageCount:(NSInteger)count;

- (NSInteger)setImagesWithVideo:(AVAsset *)video;

- (void)startPlayIndicateBarAnimationWithStartTime:(CGFloat)startTime;
- (void)stopPlayIndicateBarAnimation;

@end

NS_ASSUME_NONNULL_END
