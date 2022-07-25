//
//  DRMEVideoCompression.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/1/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 视频不能大于100MB
static NSUInteger const MaxVideoSize = 100 * 1024 * 1024;


@interface DRMECompressionModel : NSObject

@property(nonatomic,assign) NSInteger code;
@property(nonatomic,copy) NSString *message;
@property(nonatomic,copy) NSString *outputPath;

@end

@interface DRMEVideoCompression : NSObject

+ (instancetype)sharedVideoCompression;


/// 视频压缩
/// @param originFilePath 视频源文件URL
/// @param outputPath 压缩后的视频路径
/// @param completeBlock 见 DRMECompressionModel
///
- (void)compressVideoWithOriginFilePath:(NSURL *)originFilePath
                              outputUrl:(NSString *)outputPath
                          completeBlock:(void(^)(DRMECompressionModel *model))completeBlock;

- (void)compressVideoWithOriginFilePath:(NSURL *)originFilePath
                          completeBlock:(void(^)(DRMECompressionModel *model))completeBlock;


/// 视频压缩
/// @param originData 视频源数据
/// @param outputPath 压缩后的视频路径
/// @param completeBlock  见 DRMECompressionModel
- (void)compressVideoWithData:(NSData *)originData
                    outputUrl:(NSString *)outputPath
                completeBlock:(void(^)(DRMECompressionModel *model))completeBlock;

- (void)compressVideoWithData:(NSData *)originData
                completeBlock:(void(^)(DRMECompressionModel *model))completeBlock;

/// 需要移除的任务
- (void)removeTask;

@end

NS_ASSUME_NONNULL_END
