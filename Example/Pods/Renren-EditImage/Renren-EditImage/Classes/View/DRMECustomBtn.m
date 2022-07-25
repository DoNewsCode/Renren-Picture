
#import "DRMECustomBtn.h"

@interface DRMECustomBtn ()



@property (nonatomic, copy) NSString *normalString;

@property (nonatomic, copy) NSString *selectedString;

@property (nonatomic, copy) NSString *disabledString;

@end

@implementation DRMECustomBtn

+ (instancetype)buttonWithType:(UIButtonType)buttonType
                     withTitle:(NSString *)title
               withImageNormal:(NSString *)normal
             withImageSelected:(NSString *)selected
              withImageDisable:(NSString *)disabled
{
    
    DRMECustomBtn *btn = [self buttonWithType:buttonType withTitle:title withImageNormal:normal withImageSelected:selected];
    btn.disabledString = disabled;
    return btn;
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType
                     withTitle:(NSString *)title
               withImageNormal:(NSString *)normal
             withImageSelected:(NSString *)selected
{
    
    DRMECustomBtn *btn = [DRMECustomBtn buttonWithType:buttonType];
    if (btn) {
        btn.normalString = normal;
        btn.selectedString = selected;
        btn.btnImageView = [[UIButton alloc] init];
        btn.btnImageView.userInteractionEnabled = NO;
        [btn.btnImageView setImage:[UIImage me_imageWithName:normal] forState:UIControlStateNormal];
        [btn addSubview:btn.btnImageView];
        
        btn.btnImageView.sd_layout.topEqualToView(btn)
        .centerXEqualToView(btn)
        .widthIs(30)
        .heightIs(30);
        
        btn.btnLabel = [[UILabel alloc]init];
        btn.btnLabel.text = title;
        btn.btnLabel.textAlignment = NSTextAlignmentCenter;
        btn.btnLabel.font = kFontRegularSize(13);
        btn.btnLabel.textColor = UIColor.whiteColor;
        [btn addSubview:btn.btnLabel];
        
        btn.btnLabel.sd_layout.topSpaceToView(btn.btnImageView, 0)
        .leftEqualToView(btn).rightEqualToView(btn)
        .bottomEqualToView(btn);
        
    }
    return btn;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (self.selectedString) {
        if (selected) {
            [self.btnImageView setImage:[UIImage me_imageWithName:self.selectedString] forState:UIControlStateNormal];
        } else {
            [self.btnImageView setImage:[UIImage me_imageWithName:self.normalString] forState:UIControlStateNormal];
        }
    }
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    if (enabled) {
        self.btnLabel.textColor = [UIColor whiteColor];
        self.selected = self.isSelected;
    } else {
        self.btnLabel.textColor = [UIColor colorWithHexString:@"#929292"];
        [self.btnImageView setImage:[UIImage me_imageWithName:self.disabledString] forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.btnImageView.sd_layout.topEqualToView(self)
    .centerXEqualToView(self)
    .widthIs(30)
    .heightIs(30);
    
    self.btnLabel.sd_layout.topSpaceToView(self.btnImageView, 0)
    .leftEqualToView(self).rightEqualToView(self)
    .bottomEqualToView(self);
}

@end
