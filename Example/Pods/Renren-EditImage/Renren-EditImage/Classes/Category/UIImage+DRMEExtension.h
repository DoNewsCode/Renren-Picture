//
//  UIImage+DNExtension.h
//  Pods
//
//  Created by lixiaoyue on 2019/2/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DRMEExtension)

/**
 从 bundle 加载图片
 */
+ (instancetype)me_imageWithName:(NSString *)name;

/// 生成原图马赛克
+ (UIImage *)me_mosaicImage:(UIImage *)sourceImage mosaicLevel:(NSUInteger)level;

/// 生成第二种马赛克效果
+ (UIImage *)me_two_mosaicImage:(UIImage *)sourceImage mosaicLevel:(NSUInteger)level;

/// 相机页面拍摄完成后，返回的标签数据
@property(nonatomic,strong) NSArray<NSDictionary *> *tagsDict;

/// 相机页面和编辑页面， 回调时，标识图片是否进行过编辑操作
@property(nonatomic,assign) BOOL isEdited;

@end

NS_ASSUME_NONNULL_END
