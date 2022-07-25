//
//  DRINavTitleView.m
//  RenRen-ImagePicker
//
//  Created by 张健康 on 2019/8/20.
//

#import "DRINavTitleView.h"
#import <DNCommonKit/DNBaseMacro.h>
#import <DNCommonKit/UIColor+CTHex.h>
#import "SDAutoLayout.h"
#import "DRIImagePickerController.h"
#import <DNCommonKit/UIButton+CTTitlePlace.h>
#import "NSString+CTHeight.h"
#import <UIView+DRIViewController.h>
#import "DRIImagePickerController.h"
#define IPHONEX_Nav(x) (iPhoneX?ceil(x+24):x)

@interface DRISureButtonView : UIView
@property (assign, nonatomic) BOOL enable;
@property (strong, nonatomic) UIButton *sureButton;
@property (strong, nonatomic) UILabel  *numLabel;
@property (assign, nonatomic) NSInteger count;
@end

@implementation DRISureButtonView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
        self.enable = NO;
    }
    return self;
}

- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}

- (void)setupUI{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 15;
    self.layer.borderWidth = 1.5;
    self.layer.borderColor = [UIColor ct_colorWithHex:(0x2A73EB)].CGColor;
    
    UIButton *button = [UIButton buttonWithType:0];
    [button.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:16]];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [self addSubview:button];
    button.userInteractionEnabled = NO;
    self.sureButton = button;
    
    UILabel *label = [[UILabel alloc] init];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 9;
    label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor ct_colorWithHex:(0x3580F9)];
    label.textAlignment = NSTextAlignmentCenter;
    [button addSubview:label];
    self.numLabel = label;
}

- (void)setEnable:(BOOL)enable{
//    self.sureButton.enabled = enable;
    
    [self.sureButton setTitleColor:[UIColor ct_colorWithHex:enable?(0x2A73EB):(0xBCBCBC)] forState:UIControlStateNormal];
    self.layer.borderColor = [UIColor ct_colorWithHex:enable?(0x2A73EB):(0xBCBCBC)].CGColor;
    self.numLabel.backgroundColor = [UIColor ct_colorWithHex:enable?(0x2A73EB):(0xBCBCBC)];
}

- (void)setCount:(NSInteger)count{
    _count = count;
    [self.numLabel setText:[NSString stringWithFormat:@"%ld",count]];
    self.numLabel.hidden = !count;
    [self layoutSubviews];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.sureButton.frame = CGRectMake( 13.5, 0, self.width - 27, self.height);
    [self.numLabel sizeToFit];
    self.numLabel.frame = CGRectMake(CGRectGetMaxX(self.sureButton.titleLabel.frame) + 6, 6, 18, 18);
//    if (self.numLabel.width < self.numLabel.height) {
//        self.numLabel.width = self.numLabel.height;
//    }
    self.sureButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

- (CGFloat)width{
    CGFloat width = 0;
    width = [self.sureButton.titleLabel.text ct_widthWithFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:16]];
    if (self.count) {
        width += 18;
//        width += 6; //margin
    }
    width += 30; //corner
    return width;
}




@end

@implementation DRINavTitleView
- (instancetype)initWithImagePickerController:(DRIImagePickerController *)driImagePickVc
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, IPHONEX_Nav(110));
        self.driImagePickVc = driImagePickVc;
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    self.backgroundColor = UIColor.whiteColor;
    
    UIView *statusBar = [[UIView alloc] init];
    statusBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, DNStatuBarHeight);
    [self addSubview:statusBar];
    
    UIView *navBar = [[UIView alloc] init];
    navBar.frame = CGRectMake(0, DNStatuBarHeight, SCREEN_WIDTH, 44);
    [self addSubview:navBar];
    
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton setImage:[UIImage dri_imageNamedFromMyBundle:@"nav_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:closeButton];
    self.closeButton = closeButton;
    
    DRISureButtonView *rightButton = [[DRISureButtonView alloc] init];
    [rightButton addTarget:self action:@selector(rightButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:rightButton];
    [rightButton setCount:0];
    self.rightButton = rightButton;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [titleLabel setTextColor:[UIColor ct_colorWithHex:(0x999999)]];
    [navBar addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, DNStatuBarHeight + 44, SCREEN_WIDTH, self.height - DNStatuBarHeight - 44);
    [self addSubview:titleView];
    
    UIButton *titleButton = [[UIButton alloc] init];
    [titleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:25]];
    [titleButton setTitleColor:[UIColor ct_colorWithHex:(0x323232)] forState:UIControlStateNormal];
    [titleView addSubview:titleButton];
    self.titleButton = titleButton;
    
    self.rightButton.layer.borderColor = [UIColor ct_colorWithHex:(0x2A73EB)].CGColor;

    _originalPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _originalPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, [DRICommonTools dri_isRightToLeftLayout] ? 10 : -10, 0, 0);
    [_originalPhotoButton addTarget:self action:@selector(originalPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _originalPhotoButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_originalPhotoButton setTitle:_driImagePickVc.fullImageBtnTitleStr forState:UIControlStateNormal];
    [_originalPhotoButton setTitle:_driImagePickVc.fullImageBtnTitleStr forState:UIControlStateSelected];
    [_originalPhotoButton setTitleColor:[UIColor ct_colorWithHex:0x333333] forState:UIControlStateNormal];
    [_originalPhotoButton setTitleColor:[UIColor ct_colorWithHex:0x333333] forState:UIControlStateSelected];
    [_originalPhotoButton setImage:_driImagePickVc.photoOriginDefImage forState:UIControlStateNormal];
    [_originalPhotoButton setImage:_driImagePickVc.photoOriginSelImage forState:UIControlStateSelected];
    _originalPhotoButton.imageView.clipsToBounds = YES;
    _originalPhotoButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _originalPhotoButton.enabled = _driImagePickVc.selectedModels.count > 0;
    
    _originalPhotoLabel = [[UILabel alloc] init];
    _originalPhotoLabel.textAlignment = NSTextAlignmentLeft;
    _originalPhotoLabel.font = [UIFont systemFontOfSize:16];
    _originalPhotoLabel.textColor = [UIColor ct_colorWithHex:0x333333];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(originalPhotoButtonClick)];
    [_originalPhotoLabel addGestureRecognizer:tap];
    
    [titleView addSubview:_originalPhotoButton];
    [titleView addSubview:_originalPhotoLabel];
}

- (void)setTitle:(NSString *)title{
    [self.titleButton setTitle:title forState:UIControlStateNormal];
    [self setNeedsLayout];
}

- (void)setRightTitle:(NSString *)title{
    if (!title || !title.length) {
        self.rightButton.hidden = YES;
    }else{
//        [self.rightButton setTitle:title forState:UIControlStateNormal];
    }
    [self setNeedsLayout];
}

- (void)setTitleLabelText:(NSString *)text{
    [self.titleLabel setText:text];
    [self setNeedsLayout];
}

- (void)setCount:(NSInteger)count{
    self.rightButton.count = count;
}

- (void)setRightButtonEnable:(BOOL)enable{
    self.rightButton.enable = enable;
    if (enable) {
        self.rightButton.layer.borderColor = [UIColor ct_colorWithHex:(0x2A73EB)].CGColor;
    }else{
        self.rightButton.layer.borderColor = [UIColor ct_colorWithHex:(0xBCBCBC)].CGColor;
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleButton sizeToFit];
    self.titleButton.frame = CGRectMake(12, 0, self.titleButton.width, self.titleButton.height);
    
    [self.titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -
                                                          self.titleButton.imageView.frame.size.width, 0, self.titleButton.imageView.frame.size.width)];
    [self.titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleButton.titleLabel.bounds.size.width, 0, - self.titleButton.titleLabel.bounds.size.width)];
    
    [self.closeButton sizeToFit];
    self.closeButton.frame = CGRectMake(10, (44-20)/2, 20, 20);
    [self.closeButton ct_setEnlargeEdge:24.f];
    [self.rightButton sizeToFit];
    self.rightButton.frame = CGRectMake(SCREEN_WIDTH - self.rightButton.width - 15, (44-30)/2, self.rightButton.width, 30);
    
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = self.centerX;
    self.titleLabel.centerY = self.rightButton.centerY;
    
    [_originalPhotoLabel sizeToFit];
    _originalPhotoLabel.origin = CGPointMake(SCREEN_WIDTH - _originalPhotoLabel.width - 15, 0);
    _originalPhotoLabel.centerY = _titleButton.centerY;
    
    [_originalPhotoButton sizeToFit];
    if (_originalPhotoLabel.text.length && !_originalPhotoLabel.hidden) {
        _originalPhotoButton.origin = CGPointMake(CGRectGetMinX(_originalPhotoLabel.frame) - 5 - _originalPhotoButton.width,0);
    }else{
        _originalPhotoButton.origin = CGPointMake(SCREEN_WIDTH - _originalPhotoButton.width - 15,0);
    }
    _originalPhotoButton.centerY = _titleButton.centerY;
    
}

- (void)closeButtonDidClick:(id)sender{
    if (self.closeAction) self.closeAction();
}

- (void)rightButtonDidClick:(id)sender{
    if (self.sureAction) self.sureAction();
}
- (void)originalPhotoButtonClick{
    if (self.originAction) {
        self.originAction(self.originalPhotoButton.selected);
    }
    [self layoutSubviews];
}
@end
