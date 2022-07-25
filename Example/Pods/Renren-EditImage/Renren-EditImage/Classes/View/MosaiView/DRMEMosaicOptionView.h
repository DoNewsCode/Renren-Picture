//
//  DRMEMosaicOptionView.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickCancelBlock)(void);
typedef void(^ClickSureBlock)(void);
typedef void(^ClickResetBlock)(void);
typedef void(^ClickMosaicBlock)(UIButton *mosaicBtn);

@interface DRMEMosaicOptionView : UIView

+ (instancetype)mosaicOptionView;

@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@property (weak, nonatomic) UIButton *currentMosaicBnt;

@property(nonatomic,copy) ClickCancelBlock clickCancelBlock;
@property(nonatomic,copy) ClickSureBlock clickSureBlock;
@property(nonatomic,copy) ClickMosaicBlock clickMosaicBlock;
@property(nonatomic,copy) ClickResetBlock clickResetBlock;


@end

NS_ASSUME_NONNULL_END
