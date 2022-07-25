//
//  DRMECameraViewController.h
//  Renren-EditImage
//
//  Created by 陈金铭 on 2019/10/17.
//  相机控制器

#import <UIKit/UIKit.h>

/// 从哪里进入拍照/编辑页面
typedef NS_ENUM(NSUInteger, DRMEFromType) {
    DRMEFromTypeComments = 1,   // 从评论页面进入
    DRMEFromTypeFeedback,       // 从反馈页面进入
    DRMEFromTypeHead,           // 从头像页面进入
    DRMEFromTypeCertification,  // 从认证页面进入
    DRMEFromTypeChat,           // 从聊天页面进入
};

NS_ASSUME_NONNULL_BEGIN

#define NV_TIME_BASE 1000000

@interface DRMECameraViewController : UIViewController

/// 拍照后，编辑拍照页面点击了完成
@property(nonatomic,copy) void(^cameraEditCompleteBlock)(UIImage *editImage);
/// 拍摄后，编辑视频页面点击了完成
@property(nonatomic,copy) void(^editVideoCompleteBlock)(NSString *videoPath);
/// 点击了相册按钮
@property(nonatomic,copy) void(^clickAlbumBlock)(void);
/// 只拍照
@property(nonatomic,assign) BOOL onlyTakePhoto;
/// 只拍摄
@property(nonatomic,assign) BOOL onlyTakeVideo;
/// 是否显示相册按钮
@property(nonatomic,assign,getter=isShowAlbumBtn) BOOL showAlbumBtn;

/** 从哪个页面进入的拍照/编辑页 */
@property(nonatomic,assign) DRMEFromType fromType;

@end

NS_ASSUME_NONNULL_END
