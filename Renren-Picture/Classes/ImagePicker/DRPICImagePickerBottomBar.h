//
//  DRPICImagePickerBottomBar.h
//  Renren-Picture
//
//  Created by Luis on 2020/3/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^DRPICPreviewBtnClickBlock)(UIButton *sender);
typedef void(^DRPICNextBtnClickBlock)(UIButton *sender);

@interface DRPICImagePickerBottomBar : UIView

/**预览按钮*/
@property(nonatomic, strong)UIButton *previewBtn;
/**下一步按钮*/
@property(nonatomic, strong)UIButton *nextBtn;
/**预览按钮点击事件*/
@property(nonatomic, copy)DRPICPreviewBtnClickBlock previewBtnClickBlock;
/**下一步按钮点击事件*/
@property(nonatomic, copy)DRPICNextBtnClickBlock nextBtnClickBlock;

@end

NS_ASSUME_NONNULL_END
