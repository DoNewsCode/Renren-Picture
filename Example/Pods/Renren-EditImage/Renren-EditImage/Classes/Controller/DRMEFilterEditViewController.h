//
//  DRMEFilterEditViewController.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/3/16.
//

#import <UIKit/UIKit.h>
#import "DRMEPhotoEditAnimation.h"

#import "DRMETagView.h"
#import "DRMEStickerLabelView.h"


NS_ASSUME_NONNULL_BEGIN

@interface DRMEFilterEditViewController : UIViewController<UINavigationControllerDelegate>

@property(nonatomic,strong) UIImage *originImage;

/// 如果之前添加过滤镜，将滤镜的index传回来
@property(nonatomic,assign) NSInteger filterIndex;

@property(nonatomic,copy) void(^filterEditSuccess)(UIImage *filterImage, NSInteger filterIndex);
@property(nonatomic,copy) void(^filterEditClickCancle)(void);

@property(nonatomic,strong) DRMEPhotoEditAnimation *animation;


// 根据需求，需要展示添加过的文字和标签
@property(nonatomic,strong) NSMutableArray<DRMETagView*> *tagsArray;
@property(nonatomic,strong) NSMutableArray<DRMEStickerLabelView*> *labelArray;

@end

NS_ASSUME_NONNULL_END
