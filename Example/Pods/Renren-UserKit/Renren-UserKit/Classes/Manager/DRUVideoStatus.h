//
//  DRUVideoStatus.h
//  Renren-UserKit
//
//  Created by 陈金铭 on 2019/9/6.
//  视频状态

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DRUVideoSharpness) {//清晰度
    DRUVideoSharpnessNormal,//常规
    DRUVideoSharpnessHD,//高清
};

@interface DRUVideoStatus : NSObject

/** 无线网络下自动播放视频 */
@property(nonatomic, assign) BOOL autoPlayForWiFi;
/** 清晰度 */
@property(nonatomic, assign) DRUVideoSharpness sharpness;
/** 水印 */
@property(nonatomic, assign) BOOL watermark;

+ (instancetype)sharedVideoStatus;

@end

NS_ASSUME_NONNULL_END
