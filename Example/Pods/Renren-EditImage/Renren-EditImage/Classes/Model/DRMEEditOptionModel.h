//
//  DRMEEditOptionModel.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/10/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DRMEEditOption) {
    DRMEEditOptionTailor = 1,                   // 裁剪
    DRMEEditOptionFilter,                       // 滤镜
    DRMEEditOptionMosaic,                       // 马赛克
    DRMEEditOptionStickers,                     // 贴纸
    DRMEEditOptionBrush,                        // 画笔
    DRMEEditOptionText,                         // 文字
    DRMEEditOptionTag,                          // 标签
    DRMEEditOptionMusic,                        // 音乐
    DRMEEditOptionVideoTailor                   // 剪视频
};

@interface DRMEEditOptionModel : NSObject

@property(nonatomic,assign) DRMEEditOption editOption;

@property(nonatomic,copy) NSString *titleStr;
@property(nonatomic,copy) NSString *imageStr;

@end

NS_ASSUME_NONNULL_END
