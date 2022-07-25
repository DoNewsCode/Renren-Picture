//
//  DRMEPhotoEditViewController.h
//  Renren-EditImage
//
//  Created by 陈金铭 on 2019/10/17.
//  图片编辑

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRMEPhotoEditViewController :  UIViewController

@property(nonatomic,assign) BOOL isFromChat;
@property(nonatomic,strong) UIImage *originImage;

/** 显示从预览进来时，之前添加过的标签 */
@property(nonatomic,strong) NSArray *tagsDict;

/// 这已经有很多地方用了，就不改了，新增一个返回tag数据的block
@property(nonatomic,copy) void(^photoEditCompleteBlock)(UIImage *editImage);
/// 新增一个返回tag数据的block
@property(nonatomic,copy) void(^photoEditTagCompleteBlock)(UIImage *editImage,NSMutableArray *tagsDict);

@end

NS_ASSUME_NONNULL_END
