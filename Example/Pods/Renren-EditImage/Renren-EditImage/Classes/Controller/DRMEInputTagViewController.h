//
//  DRMEInputTagViewController.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/11/12.
//  打标签首页

#import <UIKit/UIKit.h>
#import "DRMESearchTopicModel.h"
#import "DRMETagModel.h"
#import "DRMETagView.h"
#import "DRMEBaseViewController.h"
#import "DRMEStickerLabelView.h"


NS_ASSUME_NONNULL_BEGIN

/// 这是是从拍照或相册选择，进来打标签的回调
typedef void(^InputTagCompleteBlock)(NSMutableArray<DRMETagView*> *tagsArray,
                                     NSMutableArray<DRMEStickerLabelView*> *labelArray);
/// 这是浏览大图，点标记，进来打标签的回调
typedef void(^EditTagCompleteBlock)(NSMutableArray<NSDictionary*> *tagsDictArray);

@interface DRMEInputTagViewController : DRMEBaseViewController

@property(nonatomic,strong) UIImage *originImage;

@property(nonatomic,copy) InputTagCompleteBlock inputTagCompleteBlock;
@property(nonatomic,copy) EditTagCompleteBlock editTagCompleteBlock;


/// 从大图浏览进来要添加标签，或显示标签
@property(nonatomic,strong) NSMutableArray<NSDictionary*> *tagsDictArray;

/// 从编辑页面过来，要显示添加过的标签
@property(nonatomic,strong) NSMutableArray<DRMETagView*> *tagsArray;
/// 从编辑页面过来，要显示添加过的文字 —————— 唉，心塞
@property(nonatomic,strong) NSMutableArray<DRMEStickerLabelView*> *labelArray;

@end

NS_ASSUME_NONNULL_END
