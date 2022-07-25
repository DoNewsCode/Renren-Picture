//
//  DRMEAVSECommand.h
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/8.
//

#import <Foundation/Foundation.h>
#import "DRMEAVSEComposition.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString* const DRMEAVSEExportCommandCompletionNotification;

extern NSString* const DRMEAVSEExportCommandError;


@interface DRMEAVSECommand : NSObject

- (instancetype)initWithComposition:(DRMEAVSEComposition *)composition;


@property (nonatomic , strong) DRMEAVSEComposition *composition;

/**
 视频信息初始化

 @param asset asset
 */
- (void)performWithAsset:(AVAsset *)asset;

/**
 视频融合器初始化
 */
- (void)performVideoCompopsition;

/**
 音频融合器初始化
 */
- (void)performAudioCompopsition;

 /**
  计算旋转角度
  
  @param transForm transForm
  @return 角度
  */
- (NSUInteger)degressFromTransform:(CGAffineTransform)transForm;

@end


NS_ASSUME_NONNULL_END
