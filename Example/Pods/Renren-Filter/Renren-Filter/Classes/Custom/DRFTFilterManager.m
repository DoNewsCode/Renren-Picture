//
//  DRFTFilterManager.m
//  Renren-FilterSDK
//
//  Created by 张健康 on 2020/3/9.
//  Copyright © 2020 Donews. All rights reserved.
//

#import "DRFTFilterManager.h"
#import "DRFTFilterModel.h"
#import "NSBundle+RRFilter.h"
#include <objc/runtime.h>
#import <YYModel/YYModel.h>
#import <Renren_FilterSDK/cgeImageViewHandler.h>
#import <Renren_FilterSDK/cgeVideoCameraViewHandler.h>
#import <Renren_FilterSDK/cgeVideoPlayerViewHandler.h>
#import "DRFTFilterNetworkHelper.h"
#import <Renren_FilterSDK/cgeUtilFunctions.h>
#import "DRFTFilterManager+Private.h"

UIImage* loadImageCallback(const char* name, void* arg)
{
    NSString* filename = [NSString stringWithUTF8String:name];
    NSString *imagePath = [[NSBundle drft_filterBundle] pathForResource:filename ofType:@""];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

void loadImageOKCallback(UIImage* img, void* arg)
{
    
}

@interface DRFTFilterModel (Private)
@property (nonatomic, copy) NSString *param;
@end
@implementation DRFTFilterModel (Private)
- (NSString *)param{
    return objc_getAssociatedObject(self, @selector(filterParam));
}

- (void)setParam:(NSString *)param{
    objc_setAssociatedObject(self, @selector(filterParam), param, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)filterParam{}

@end

@interface DRFTFilterManager()
@property (nonatomic, strong, readwrite) NSArray <DRFTFilterModel *>*filterArray;
@property (nonatomic) CGEImageViewHandler* imageViewHandler;
@property (nonatomic) CGECameraViewHandler *cameraViewHandler;
@property (nonatomic) CGEVideoPlayerViewHandler* videoPlayerHandler;

@property (nonatomic, assign, readwrite) NSInteger filterVersion;
@end

@implementation DRFTFilterManager
static DRFTFilterManager *manager;
static dispatch_once_t onceToken;

+ (instancetype)manager {
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        [manager setup];
    });
    return manager;
}

- (void)setup{
    self.debug = YES;
    //#if DEBUG
    cgeSetLoadImageCallback(loadImageCallback, loadImageOKCallback, nil);
}

- (void)setDebug:(BOOL)debug{
    _debug = debug;
    NSString *cacheKey;
    if (debug) {
        cacheKey = DRFT_FILTER_CACHE_KEY_DEBUG;
    }else{
        cacheKey = DRFT_FILTER_CACHE_KEY_RELESEA;
    }
    NSDictionary *filterDict = [[NSUserDefaults standardUserDefaults] objectForKey:cacheKey];
    //#else
    //    NSDictionary *filterDict = [[NSUserDefaults standardUserDefaults] objectForKey:DRFT_FILTER_CACHE_KEY_RELESEA];
    //#endif
    
    if (!filterDict.count) {
        [self loadFilterArrayFromLocal];
    }else{
        [self assembleParam:filterDict];
    }
}

- (void)loadFilterArrayFromLocal{
    NSError *error;
    NSString *_filterPath = [[NSBundle drft_filterBundle] pathForResource:@"renren_filters" ofType:@"json"];
    NSDictionary *_filterDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:_filterPath] options:NSJSONReadingMutableLeaves error:&error];
    [self assembleParam:_filterDic];
}

- (void)assembleParam:(NSDictionary *)filterDict{
    self.filterVersion = filterDict[@"ver"];
    //数组
    NSArray *_filterDicArray = [filterDict objectForKey:@"filters"];
    self.filterArray = [NSArray yy_modelArrayWithClass:[DRFTFilterModel class] json:_filterDicArray];
}

- (void)refreshFilterListSuccess:(void (^)(void))successed failureBlock:(void (^)(NSString * _Nonnull))failured{
    [DRFTFilterNetworkHelper loadFilterListSuccess:^(NSDictionary * _Nonnull dict) {
        NSString *cacheKey;
        if (self.debug) {
            cacheKey = DRFT_FILTER_CACHE_KEY_DEBUG;
        }else{
            cacheKey = DRFT_FILTER_CACHE_KEY_RELESEA;
        }
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:cacheKey];
        [self assembleParam:dict];
        dispatch_sync(dispatch_get_main_queue(), ^{
            successed();
        });
    } failureBlock:^(NSError * _Nonnull error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            failured(error.localizedDescription);
        });
    }];
}


- (void)setViewDisplayMode:(UIViewContentMode)contentMode{
    if (contentMode < UIViewContentModeRedraw) {
        CGEImageViewDisplayMode CGEMode = CGEImageViewDisplayModeDefault;
        switch (contentMode) {
            case UIViewContentModeScaleAspectFit:
                CGEMode = CGEImageViewDisplayModeAspectFit;
                break;
            case UIViewContentModeScaleToFill:
                CGEMode = CGEImageViewDisplayModeScaleToFill;
                break;
            case UIViewContentModeScaleAspectFill:
                CGEMode = CGEImageViewDisplayModeAspectFill;
                break;
        }
        if (_imageViewHandler) {
            [_imageViewHandler setViewDisplayMode:CGEMode];
        }
        if (_videoPlayerHandler) {
            [_videoPlayerHandler setViewDisplayMode:CGEMode];
        }
    }
}

- (void)clear{
    [self clearImageHandler];
    [self clearCameraHandler];
}

@end

@implementation DRFTFilterManager (Image)

- (void)setGlkView:(GLKView *)glkView image:(UIImage *)image{
    if (_imageViewHandler) [self clearImageHandler];
    _imageViewHandler = [[CGEImageViewHandler alloc] initWithGLKView:glkView withImage:image];
}

- (BOOL)setFilterIndex:(NSInteger)index{
    if (index <= self.filterArray.count) {
        DRFTFilterModel *model = self.filterArray[index];
        if (model) {
            [_imageViewHandler setFilterWithConfig:[model.param UTF8String] intensity:model.intensity];
            return YES;
        }
    }
    return NO;
}

- (void)setUIImage:(UIImage *)image{
    [_imageViewHandler setUIImage:image];
}

- (void)setImageFilterIntensity:(float)value
{
    [_imageViewHandler setFilterIntensity:value];
}

- (UIImage *)currentImage{
    return [_imageViewHandler resultImage];
}

- (void)clearImageHandler{
    [_imageViewHandler clear];
    _imageViewHandler = nil;
}

@end
@implementation DRFTFilterManager (camera)

- (BOOL)setGlkView:(GLKView *)glkView sessionPreset:(AVCaptureSessionPreset)sessionPreset
authorizationFailed:(void (^__nullable)(void) )authorization{
    if (self.cameraViewHandler) [self clearCameraHandler];
    _cameraViewHandler = [[CGECameraViewHandler alloc] initWithGLKView:glkView];
    if([_cameraViewHandler setupCamera:sessionPreset cameraPosition:AVCaptureDevicePositionFront isFrontCameraMirrored:YES authorizationFailed:authorization])
    {
        [[_cameraViewHandler cameraDevice] startCameraCapture];
    }
    else
    {
        return NO;
    }
    
    [CGESharedGLContext globalSyncProcessingQueue:^{
        [CGESharedGLContext useGlobalGLContext];
        void cgePrintGLInfo(void);
        cgePrintGLInfo();
    }];
    
    [_cameraViewHandler fitViewSizeKeepRatio:YES];
    
    //Set to the max resolution for taking photos.
    [[_cameraViewHandler cameraRecorder] setPictureHighResolution:YES];
    return YES;
}

- (void)setCameraFilterIntensity:(float)value
{
    [_cameraViewHandler setFilterIntensity:value];
}

- (AVCaptureDevicePosition)cameraPosition{
    return [_cameraViewHandler cameraPosition];
}

- (BOOL)switchCamera:(BOOL)isFrontCameraMirrored{
    return [_cameraViewHandler switchCamera:isFrontCameraMirrored];
}

- (UIImage *)takeShot{
    __block UIImage *takePic = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [_cameraViewHandler takeShot:^(UIImage *image) {
        takePic = image;
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return takePic;
}

- (void)takePicture:(NSInteger)index intensity:(CGFloat)intensity completion:(void (^)(UIImage *image))completionHandler{
    DRFTFilterModel *model = self.filterArray[index];
    if (model) {
        [_cameraViewHandler takePicture:^(UIImage *image) {
            completionHandler(image);
        } filterConfig:model.param.UTF8String filterIntensity:intensity isFrontCameraMirrored:YES];
    }
}


- (BOOL)setCameraFilterIndex:(NSInteger)index{
    NSArray *filterArr = self.cameraFilterArray.count?self.cameraFilterArray:self.filterArray;
    if (index <= filterArr) {
        DRFTFilterModel *model = filterArr[index];
        if (model) {
            [_cameraViewHandler setFilterWithConfig:model.param.UTF8String intensity:model.intensity];
            return YES;
        }
    }
    return NO;
}

- (BOOL)captureIsRunning{
    return [[_cameraViewHandler cameraDevice] captureIsRunning];
}

- (void)startCameraCapture:(BOOL)start{
    if (start) {
        [[_cameraViewHandler cameraDevice] startCameraCapture];
    }else{
        [[_cameraViewHandler cameraDevice] stopCameraCapture];
    }
}

- (BOOL)focusPoint:(CGPoint)point {
    return [_cameraViewHandler focusPoint:point];
}

- (void)enableFaceBeautify:(BOOL)enable{
    [_cameraViewHandler enableFaceBeautify:enable];
}

- (BOOL)setTorchMode:(AVCaptureTorchMode)torchMode{
    return [_cameraViewHandler setTorchMode:torchMode];
}

- (BOOL)setCameraFlashMode:(AVCaptureFlashMode)flashMode{
    return [_cameraViewHandler setCameraFlashMode:flashMode];
}

- (BOOL)checkAuthorization{
    return [CGECameraViewHandler checkAuthorization];
}


#pragma mark - 录像相关接口

- (void)startRecording :(NSURL*)videoURL size:(CGSize)videoSize{
    [_cameraViewHandler startRecording:videoURL size:videoSize];
}

- (void)endRecording :(void (^)(void))completionHandler{
    [_cameraViewHandler endRecording:completionHandler];
}
- (void)endRecording :(void (^)(void))completionHandler withCompressionLevel:(int)level{
    [_cameraViewHandler endRecording:completionHandler withCompressionLevel:level];
}//level 取值范围为 [0, 3], 0为不压缩， 1 清晰度较高，

- (void)endRecording:(void (^)(void))completionHandler withQuality:(NSString*)quality shouldOptimizeForNetworkUse:(BOOL)shouldOptimize{
    [_cameraViewHandler endRecording:completionHandler withQuality:quality shouldOptimizeForNetworkUse:shouldOptimize];
} //quality为 AVAssetExportPreset*

- (void)cancelRecording{
    [_cameraViewHandler cancelRecording];
}

- (BOOL)isRecording{
    return [_cameraViewHandler isRecording];
}

- (void)clearCameraHandler{
    [[[_cameraViewHandler cameraRecorder] cameraDevice] stopCameraCapture];
    [_cameraViewHandler clear];
    _cameraViewHandler = nil;
    [CGESharedGLContext clearGlobalGLContext];
}
@end
