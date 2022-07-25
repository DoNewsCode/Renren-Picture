//
//  DRMEPictureCompression.m
//  Renren-MaterialEditor
//
//  Created by 陈金铭 on 2019/11/29.
//  图片视频压缩处理

#import "DRMEPictureCompression.h"

@interface DRMEPictureCompression ()

@property(nonatomic, strong) NSOperationQueue *compressionOperationQueue;

@end

@implementation DRMEPictureCompression

static DRMEPictureCompression *_instance = nil;
//单例
+ (instancetype)sharedPictureCompression
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    NSOperationQueue *compressionOperationQueue = [NSOperationQueue new];
    compressionOperationQueue.name = @"PictureCompressionOperationQueue";
    compressionOperationQueue.maxConcurrentOperationCount = 1; // 串行队列
    _compressionOperationQueue = compressionOperationQueue;
}

- (void)processCompressData:(NSData *)data complete:(DRMECompressCompleteBlock)complete {
    UIImage *image = [UIImage imageWithData:data];
    [self processCompressImage:image complete:complete];
}

- (void)processCompressImage:(UIImage *)image complete:(DRMECompressCompleteBlock)complete {
    if (complete == nil) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UIImage *compressionImage = [strongSelf processCompressImage:image];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            complete(compressionImage);
            
        }];
    }];
    [self.compressionOperationQueue addOperation:operation];
}


- (void)processCompressImages:(NSArray<UIImage *> *)images complete:(DRMECompressImagesCompleteBlock)complete {
    if (complete == nil || images == nil) {
        return;
    }
    __block NSMutableArray<UIImage *> *tempArray = [NSMutableArray arrayWithCapacity:images.count];
    __weak typeof(self) weakSelf = self;
    for (UIImage *image in images) {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            UIImage *compressionImage = [strongSelf processCompressImage:image];
            [tempArray addObject:compressionImage];
        }];
        [self.compressionOperationQueue addOperation:operation];
    }
    // 插入Block返回操作
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            complete(tempArray.copy);

        }];
    }];
    [self.compressionOperationQueue addOperation:operation];
}

- (UIImage *)processCompressImage:(UIImage *)image {
    
    NSData *data = UIImageJPEGRepresentation(image, 1);
//    //压缩10MB以上图片
//    if (data.length <= 10000 * 1000) {
//           return image;
//       }
//       UIImage *tepmImage = [self tempCompressImage:data toByte:8000 * 1000];
//       return tepmImage;
    // 压缩300KB以上图片
    if (data.length <= MaxImageSize) {
        return image;
    }
    UIImage *tepmImage = [self compressImage:data toByte:MaxImageSize];
    return tepmImage;
}

- (UIImage *)tempCompressImage:(NSData *)data toByte:(NSUInteger)maxLength {
    UIImage *resultImage = [UIImage imageWithData:data];
    
    return resultImage;
}

- (UIImage *)compressImage:(NSData *)data toByte:(NSUInteger)maxLength {
    
    CGFloat compression = 1;
    
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length <= maxLength) return resultImage;
    
    /// 静图像素窄边 >1080  宽高进行等比例缩放到 1080。窄边<=1080 不进行缩放处理。 缩放后长边取4的整数倍值。
    CGFloat minLength = fminf(resultImage.size.width, resultImage.size.height);
     if (minLength > 1080) {
         CGSize size = resultImage.size;
         if (minLength == size.width) {
             int mutiply = floorf(1080 * size.height / size.width) / 4;
             CGFloat maxLength = mutiply * 4;
             size = CGSizeMake(1080, maxLength);
         } else {
             int mutiply = floorf(1080 * size.width / size.height) / 4;
             CGFloat maxLength = mutiply * 4;
             size = CGSizeMake(maxLength, 1080);
         }
         UIGraphicsBeginImageContext(size);
         [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
         resultImage = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
     }
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(resultImage, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    resultImage = [UIImage imageWithData:data];
    
    return resultImage;
}


@end

//
//@interface DRMEPictureCompressionOperation : NSInvocationOperation
//
//@end
//
//@implementation DRMEPictureCompressionOperation
//
//- usein
//
//@end
