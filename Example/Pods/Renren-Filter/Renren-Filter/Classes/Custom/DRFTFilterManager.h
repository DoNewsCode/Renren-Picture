//
//  DRFTFilterManager.h
//  Renren-FilterSDK
//
//  Created by 张健康 on 2020/3/9.
//  Copyright © 2020 Donews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
@class DRFTFilterModel,GLKView;

@interface DRFTFilterManager : NSObject
@property (nonatomic, assign) BOOL debug;

@property (nonatomic, strong, readonly) NSArray <DRFTFilterModel *>*filterArray;
@property (nonatomic, strong, readonly) NSArray <DRFTFilterModel *>*cameraFilterArray;
@property (nonatomic, assign, readonly) NSInteger filterVersion;
+ (instancetype)manager;

- (void)clear;

- (void)refreshFilterListSuccess:(void(^)(void))success     failureBlock:(void(^)(NSString *errorStr))failure;

/// 设置ContentMode
/// @param contentMode UIViewContentMode
- (void)setViewDisplayMode:(UIViewContentMode)contentMode;

@end

@interface DRFTFilterManager (Image)
/// 设置glView并添加图片绘制
/// @param glkView <#glkView description#>
/// @param image <#image description#>
- (void)setGlkView:(GLKView *)glkView image:(UIImage *)image;

/// 设置滤镜图片
/// @param image 图片
- (void)setUIImage:(UIImage *)image;

/// 设置滤镜强度
/// @param value 强度
- (void)setImageFilterIntensity:(float)value;


/// 设置滤镜，以数组下标设置
/// @param index 选择的滤镜数组下标
- (void)setFilterIndex:(NSInteger)index;

/// 获取当前图片
- (UIImage *)currentImage;

- (void)clearImageHandler;

@end

@interface DRFTFilterManager (camera)



/// 设置glkView并设置摄像头分辨率
/// @param glkView
/// @param sessionPreset 分辨率
/// @param authorization 是否验证权限，nil为不验证
- (BOOL)setGlkView:(GLKView *)glkView sessionPreset:(AVCaptureSessionPreset)sessionPreset
authorizationFailed:(void (^__nullable)(void) )authorization;

- (BOOL)checkAuthorization;
/// 摄像头是否在运行 YES运行中 NO暂停
- (BOOL)captureIsRunning;

/// 开始摄像头运行
/// @param start YES运行 NO 暂停
- (void)startCameraCapture:(BOOL)start;

/// 点按对焦
/// @param point 范围 [0, 1]， focus位置在显示区域的相对位置
- (BOOL)focusPoint:(CGPoint)point;

/// 是否开启默认美颜功能
/// @param enable 是否开启
/// 美颜功能是全局滤镜，与手动设置的滤镜不冲突，呈互相叠加状态
- (void)enableFaceBeautify:(BOOL)enable;


/// 拍摄照片

- (UIImage *)takeShot;

- (void)takePicture:(NSInteger)index intensity:(CGFloat)intensity completion:(void (^)(UIImage *image))completionHandler;


/// 设置滤镜
- (BOOL)setCameraFilterIndex:(NSInteger)index;

/// 设置滤镜强度
/// @param value 吕静强度
- (void)setCameraFilterIntensity:(float)value;

/// 切换摄像头，前置后置互相切换
/// @param isFrontCameraMirrored 是否需要镜像（左右镜像）
- (BOOL)switchCamera:(BOOL)isFrontCameraMirrored;

/// 当前是前置还是后置摄像头；
- (AVCaptureDevicePosition)cameraPosition;

/// 设置🔦手电筒模式
/// @param torchMode 手电筒模式
- (BOOL)setTorchMode:(AVCaptureTorchMode)torchMode;

/// 设置📸闪光灯模式
/// @param flashMode 闪光灯模式
- (BOOL)setCameraFlashMode :(AVCaptureFlashMode)flashMode;

#pragma mark -- 录像相关接口

- (void)startRecording :(NSURL*)videoURL size:(CGSize)videoSize;

- (void)endRecording :(void (^)(void))completionHandler;
- (void)endRecording :(void (^)(void))completionHandler withCompressionLevel:(int)level;//level 取值范围为 [0, 3], 0为不压缩， 1 清晰度较高，

- (void)cancelRecording;
- (BOOL)isRecording;

/// 退出时调用
- (void)clearCameraHandler;

@end
