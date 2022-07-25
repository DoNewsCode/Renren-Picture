//
//  DRINavTitleView.h
//  RenRen-ImagePicker
//
//  Created by 张健康 on 2019/8/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class DRISureButtonView, DRIImagePickerController;
@interface DRINavTitleView : UIView

@property (strong, nonatomic) UIButton *titleButton;
@property (strong, nonatomic) UIButton *closeButton;

@property (strong, nonatomic) UIButton *originalPhotoButton;

@property (strong, nonatomic) UILabel *originalPhotoLabel;

@property (strong, nonatomic) DRISureButtonView *rightButton;

@property (strong, nonatomic) UILabel  *titleLabel;

@property (nonatomic, weak) DRIImagePickerController *driImagePickVc;

@property (nonatomic, copy) void(^sureAction)(void);
@property (nonatomic, copy) void(^closeAction)(void);
@property (nonatomic, copy) void(^originAction)(BOOL selected);

- (instancetype)initWithImagePickerController:(DRIImagePickerController *)driImagePickVc;

- (void)setTitle:(NSString *)title;

- (void)setTitleLabelText:(NSString *)text;

- (void)setRightTitle:(NSString *)title;

- (void)setRightButtonEnable:(BOOL)enable;

- (void)setCount:(NSInteger)count;
@end

NS_ASSUME_NONNULL_END
