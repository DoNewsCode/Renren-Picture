

#import "DRMECropToolbar.h"
#import "DNBaseMacro.h"
#import "UIImage+DRMEExtension.h"
#import "DRMECustomBtn.h"
#import <YYCategories/UIView+YYAdd.h>

@interface DRMECropToolbar()

@property(nonatomic,weak) DRMECustomBtn *resetBtn;

@end

@implementation DRMECropToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *tailorToolBar = [[UIView alloc] init];
    tailorToolBar.backgroundColor = [UIColor blackColor];
    [self addSubview:tailorToolBar];
    
    tailorToolBar.sd_layout.leftEqualToView(self)
    .rightEqualToView(self)
    .bottomEqualToView(self)
    .heightIs(180);
    
    // 取消
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setImage:[UIImage me_imageWithName:@"me_cancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickCancelBtn)
        forControlEvents:UIControlEventTouchUpInside];
    [tailorToolBar addSubview:cancelBtn];

    cancelBtn.sd_layout.leftSpaceToView(tailorToolBar, 10)
    .bottomSpaceToView(tailorToolBar, 28)
    .widthIs(44).heightIs(44);
    
    // 确定
    UIButton *sureBtn = [[UIButton alloc] init];
    [sureBtn setImage:[UIImage me_imageWithName:@"me_sure"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(clickSureBtn)
        forControlEvents:UIControlEventTouchUpInside];
    [tailorToolBar addSubview:sureBtn];
    
    sureBtn.sd_layout.rightSpaceToView(tailorToolBar, 10)
    .bottomSpaceToView(tailorToolBar, 28)
    .widthIs(44).heightIs(44);
    
    UIView *btnsView = [[UIView alloc] init];
    [tailorToolBar addSubview:btnsView];
    
    btnsView.sd_layout.topSpaceToView(tailorToolBar, 32)
    .centerXEqualToView(tailorToolBar)
    .widthIs(165).heightIs(70);
    
    
    // 旋转
    DRMECustomBtn *rotateBtn = [DRMECustomBtn buttonWithType:UIButtonTypeCustom
                                                    withTitle:@"旋转"
                                              withImageNormal:@"me_rotate_btn"
                                            withImageSelected:@""];
    [btnsView addSubview:rotateBtn];
    [rotateBtn addTarget:self action:@selector(clickRotateBtn) forControlEvents:UIControlEventTouchUpInside];

    rotateBtn.sd_layout.topEqualToView(btnsView)
    .leftEqualToView(btnsView)
    .widthIs(45).heightIs(70);
    
    // 还原 - 重置
    DRMECustomBtn *resetBtn = [DRMECustomBtn buttonWithType:UIButtonTypeCustom
                                                    withTitle:@"还原"
                                              withImageNormal:@"me_reduction_off_btn"
                                            withImageSelected:@"me_reduction_on_btn"];
    [btnsView addSubview:resetBtn];
    self.resetBtn = resetBtn;
    [resetBtn addTarget:self action:@selector(clickResetBtn) forControlEvents:UIControlEventTouchUpInside];

    resetBtn.sd_layout.topEqualToView(btnsView)
    .rightEqualToView(btnsView)
    .widthIs(45).heightIs(70);
}

- (void)setResetButtonEnabled:(BOOL)resetButtonEnabled
{
    _resetButtonEnabled = resetButtonEnabled;
    self.resetBtn.selected = resetButtonEnabled;
}

- (void)clickRotateBtn
{
    if (self.rotateButtonButtonTapped) {
        self.rotateButtonButtonTapped();
    }
}

- (void)clickResetBtn
{
    if (self.resetButtonButtonTapped) {
        self.resetButtonButtonTapped();
    }
}

- (void)clickSureBtn
{
    if (self.sureButtonButtonTapped) {
        self.sureButtonButtonTapped();
    }
}

- (void)clickCancelBtn
{
    if (self.cancelButtonButtonTapped) {
        self.cancelButtonButtonTapped();
    }
}

@end
