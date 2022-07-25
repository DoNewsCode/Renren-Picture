//
//  DRPICPicture.h
//  Renren-Picture
//
//  Created by 陈金铭 on 2019/9/24.
//  模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DRPICPictureStatus,DRPICPictureSource,DRPICPictureTag;
@interface DRPICPicture : NSObject

/// 资源
@property(nonatomic, strong) DRPICPictureSource *source;
/// 状态
@property(nonatomic, strong) DRPICPictureStatus *status;
/// imageView对象
@property (nonatomic, strong) UIImageView *imageView;
/// 占位图
@property (nonatomic, copy) UIImage *placeholderImage;
/// 标签 
@property(nonatomic, strong) NSMutableArray<DRPICPictureTag *> *tags;

@end

/// 加载状态
typedef NS_ENUM(NSInteger, DRPICPictureLoadStatus) {//加载状态
    DRPICPictureLoadStatusPending,          // 待加载
    DRPICPictureLoadStatusLoading,          // 加载中
    DRPICPictureLoadStatusPause,          // 暂停
    DRPICPictureLoadStatusFailed,          // 失败
    DRPICPictureLoadStatusFinished,          // 加载完成
};


@interface DRPICPictureStatus : NSObject

/// 记录是否已启用（默认YES）
@property (nonatomic, assign,getter=isEnabled) BOOL enabled;
/// 记录是否被选中
@property (nonatomic, assign,getter=isSelectedg) BOOL selected;

/// 选中的序号
@property (nonatomic, assign) NSInteger selectedIndex;

/// 收到的大小
@property (nonatomic, assign) NSInteger receivedSize;
/// 预期大小
@property (nonatomic, assign) NSInteger expectedSize;
/// 加载进度
@property (nonatomic, strong) NSProgress *loadProgress;

/// 加载状态
@property(nonatomic, assign) DRPICPictureLoadStatus loadStatus;
/// 原始链接加载状态
@property(nonatomic, assign) DRPICPictureLoadStatus originLoadStatus;
/// 记录photoView是否缩放
@property (nonatomic, assign,getter=isZooming) BOOL zooming;
/// 记录每个Picture的滑动位置
@property (nonatomic, assign) CGPoint offset;

@property(nonatomic) CGFloat maximumZoomScale;
/// 记录每个Picture的缩放系数
@property(nonatomic) CGFloat zoomScale;

/// 记录每个Picture的缩放系数
@property(nonatomic) CGSize imageViewSize;

@end


/// 来源类型
typedef NS_ENUM(NSInteger, DRPICPictureSourceType) {//来源类型
    DRPICPictureSourceTypeWeb,          // 网络
    DRPICPictureSourceTypeLocal,          // 本地的
    DRPICPictureSourceTypeEdited,          // 编辑过（此时editedImage为编辑过的Image）
};

/// 资源扩展类型
typedef NS_ENUM(NSInteger, DRPICPictureExtension) {//资源扩展类型
    DRPICPictureExtensionNone,          // 初始状态
    DRPICPictureExtensionPNG,          // PNG
    DRPICPictureExtensionJPEG,          // JPEG
    DRPICPictureExtensionGIF,          // GIF
    DRPICPictureExtensionWEBP,          // WEBP
    DRPICPictureExtensionMPEG4,          // MPEG4
    DRPICPictureExtensionUnknown,          // 未知
};

/// 资源媒体类型
typedef NS_ENUM(NSInteger, DRPICPictureMediaType) {//资源媒体类型
    DRPICPictureMediaTypeUnknown = 0,// 未知
    DRPICPictureMediaTypeImage   = 1,// 图片
    DRPICPictureMediaTypeVideo   = 2,// 视频
    DRPICPictureMediaTypeAudio   = 3,// 音频
};

/// 资源媒体子类型
typedef NS_ENUM(NSUInteger, DRPICPictureMediaSubtype) {//资源媒体类型
     DRPICPictureMediaSubtypeNone               = 0,
    
    // Photo subtypes
    DRPICPictureMediaSubtypePhotoPanorama      = (1UL << 0),
    DRPICPictureMediaSubtypePhotoHDR           = (1UL << 1),
    DRPICPictureMediaSubtypePhotoScreenshot API_AVAILABLE(ios(9)) = (1UL << 2),
    DRPICPictureMediaSubtypePhotoLive API_AVAILABLE(ios(9.1)) = (1UL << 3),
    DRPICPictureMediaSubtypePhotoDepthEffect API_AVAILABLE(macos(10.12.2), ios(10.2), tvos(10.1)) = (1UL << 4),
    DRPICPictureMediaSubtypePhotoGIF = (1UL << 6),

    
    // Video subtypes
    DRPICPictureMediaSubtypeVideoStreamed      = (1UL << 16),
    DRPICPictureMediaSubtypeVideoHighFrameRate = (1UL << 17),
    DRPICPictureMediaSubtypeVideoTimelapse     = (1UL << 18),
};

@class PHAsset;
@interface DRPICPictureSource : NSObject

/// 资源媒体类型
@property(nonatomic, assign) DRPICPictureMediaType mediaType;
/// 资源媒体子类型
@property(nonatomic, assign) DRPICPictureMediaSubtype mediaSubtypes;
/// 来源类型
@property(nonatomic, assign) DRPICPictureSourceType type;
/// 资源扩展类型
@property(nonatomic, assign) DRPICPictureExtension extension;

/// Photo资源
@property (nonatomic, strong) PHAsset *__nullable asset;
/// 缩略图链接字符串
@property(nonatomic, copy) NSString *thumbnailUrlString;
/// 原始链接字符串
@property(nonatomic, copy) NSString *originUrlString;
/// 来源imageView
@property (nonatomic, strong) UIImageView *sourceImageView;

/// 展示的图片
@property(nonatomic, copy) UIImage *__nullable showImage;
///  缩略图
@property(nonatomic, copy) UIImage *__nullable thumbnailImage;
/// 原图
@property(nonatomic, copy) UIImage *__nullable originImage;

/// 编辑过的图片
@property(nonatomic, copy) UIImage *__nullable editedImage;

/// 本地图片
@property(nonatomic, copy) UIImage *__nullable localImage;
/// 本地图片文件
@property(nonatomic, copy) NSData *__nullable localImageData;

@end


/// 来源类型
typedef NS_ENUM(NSInteger, DRPICPictureTagType) {//来源类型
    DRPICPictureTagTypeNormal,          // 默认
    DRPICPictureTagTypeLocation,          // 位置
    DRPICPictureTagTypeTopic,          // 话题
    DRPICPictureTagTypeFriend,          // @好友
};

/// 来源类型
typedef NS_ENUM(NSInteger, DRPICPictureTagDirection) {//标签方向
    DRPICPictureTagDirectionTop,          // 上
    DRPICPictureTagDirectionLeft,          // 左
    DRPICPictureTagDirectionBotton,          // 下
    DRPICPictureTagDirectionRight,          // 又
};


@interface DRPICPictureTag : NSObject

/// 位置坐标
@property(nonatomic, assign) CGPoint point;
/// 标签内容
@property(nonatomic, copy) NSString *tagText;
/// 标签ID
@property(nonatomic, copy) NSString *tagid;
/// 标签类型
@property (nonatomic, assign) DRPICPictureTagType type;
/// 标签方向
@property (nonatomic, assign) DRPICPictureTagDirection direction;

/// 标签缩放系数
@property(nonatomic) CGFloat zoomScale;
@property(nonatomic) CGFloat maximumZoomScale;

@end

NS_ASSUME_NONNULL_END
