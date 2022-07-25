//
//  DRPICImagePickerTopBar.h
//  Renren-Picture
//
//  Created by Luis on 2020/3/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^DRPICAlbumTitleBtnClickBlock)(UIButton *sender);
typedef void(^DRPICFullImageBtnClickBlock)(UIButton *sender);

@interface DRPICImagePickerTopBar : UIView

@property(nonatomic, copy)NSString *albumTitle;
/**相册切换按钮*/
@property(nonatomic, strong)UIButton *albumTitleBtn;
/**是否是原图按钮*/
@property(nonatomic, strong)UIButton *fullImageBtn;
/**相册切换点击事件*/
@property(nonatomic, copy)DRPICAlbumTitleBtnClickBlock albumTitleBtnClickBlock;
/**原图按钮点击事件*/
@property(nonatomic, copy)DRPICFullImageBtnClickBlock fullImageBtnClickBlock;


@end

NS_ASSUME_NONNULL_END
