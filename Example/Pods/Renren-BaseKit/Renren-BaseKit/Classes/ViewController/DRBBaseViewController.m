//
//  DRBBaseViewController.m
//  Pods-Renren-BaseKit_Example
//
//  Created by Ming on 2019/4/10.
//

#import "DRBBaseViewController.h"

@interface DRBBaseViewController ()

@end

@implementation DRBBaseViewController

-(instancetype)init{
    
    if (self = [super init]) {
        self.haveBack = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createDefaultNavigation];
    [self creatLeftBarButtonItem];
}

-(void)setLargeTitle:(NSString *)largeTitle{
    
    _largeTitle = largeTitle;
    [self createDefaultNavigation];
    [self creatLeftBarButtonItem];
}

- (void)createDefaultNavigation {
    if (_navigationControl == YES) {
        return;
    }
    UIColor *color = nil;
    if (@available(iOS 13.0, *)) {
        color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            switch (traitCollection.userInterfaceStyle) {
                case UIUserInterfaceStyleLight:
                    return [UIColor whiteColor];
                case UIUserInterfaceStyleDark:
                    return [UIColor darkGrayColor];
                default:
                    return [UIColor whiteColor];
            }
            
        }];
        
    } else {
        color = [UIColor whiteColor];
    }
    [self.navigationController.navigationBar ct_setBackgroundColor:color];
    
    //隐藏navi下方分割线
    [self.navigationController.navigationBar setShadowImage:[UIImage ct_imageResourceKitWithNamed:@"un_image_background_clear"]];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)createLeftBar {
    [self createLeftBarButtonItem:DRBNavigationBarLeftTypeNormal image:nil target:self action:@selector(eventLeftLeftBarButtonClick:)];
}

- (void)createLeftBarButtonItem:(DRBNavigationBarLeftType)leftType image:(nullable UIImage *)image target:(nullable id)target action:(nullable SEL)action {
    UIImage *imageTemp = nil;
    switch (leftType) {
        case DRBNavigationBarLeftTypeNormal:
            imageTemp = [UIImage ct_imageResourceKitWithNamed:@"nav_button_back_default"];
            break;
            
        case DRBNavigationBarLeftTypeWhite:
            imageTemp = [UIImage ct_imageResourceKitWithNamed:@"nav_button_back_white"];
            break;
            
        case DRBNavigationBarLeftTypeBlack:
            imageTemp = [UIImage ct_imageResourceKitWithNamed:@"nav_button_back_black"];
            break;
        case DRBNavigationBarLeftTypeCustom:
            imageTemp = image;
            break;
            
        default:
            imageTemp = [UIImage ct_imageResourceKitWithNamed:@"nav_button_back_default"];
            break;
    }
    
    DRBNavigationBarButton *button = [[DRBNavigationBarButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:imageTemp forState:UIControlStateNormal];
    [button setImage:imageTemp forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)createRightBarButtonItem:(DRBNavigationBarRightType)rightType image:(nullable UIImage *)image target:(nullable id)target action:(nullable SEL)action {
    UIImage *imageTemp = nil;
    switch (rightType) {
        case DRBNavigationBarRightTypeMoreNormal:
            imageTemp = [UIImage ct_imageResourceKitWithNamed:@"nav_button_more_default"];
            break;
        case DRBNavigationBarRightTypeMoreWhite:
            imageTemp = [UIImage ct_imageResourceKitWithNamed:@"nav_button_more_white"];
            break;
        case DRBNavigationBarRightTypeMoreBlack:
            imageTemp = [UIImage ct_imageResourceKitWithNamed:@"nav_button_more_black"];
            break;
        case DRBNavigationBarRightTypeCustom:
            imageTemp = image;
            break;
            
        default:
            imageTemp = [UIImage ct_imageResourceKitWithNamed:@"nav_button_more_default"];
            break;
    }
    
    DRBNavigationBarButton *button = [[DRBNavigationBarButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.contentAlignment = DRBNavigationBarButtonContentAlignmentRight;
    [button setImage:imageTemp forState:UIControlStateNormal];
    [button setImage:imageTemp forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}


- (void)eventLeftLeftBarButtonClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatLeftBarButtonItem {
    
    if (self.largeTitle.length == 0) {
        [self createLeftBar];
    }else {
        self.largeTitleButton = [self creartBackButtonWithTitle:self.largeTitle target:self];
        UIBarButtonItem *leftBarBtnItem1 = [[UIBarButtonItem alloc] initWithCustomView:self.largeTitleButton];
        self.navigationItem.leftBarButtonItems = nil;
        self.navigationItem.leftBarButtonItem = leftBarBtnItem1;
    }
}

- (UIButton *)creartBackButtonWithTitle:(NSString *)title target:(nonnull id)target {
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
            
    if (self.haveBack) {
        [button setImage:[UIImage ct_imageResourceKitWithNamed:@"nav_button_back_default"] forState:UIControlStateNormal];
                 
        [button setImage:[UIImage ct_imageResourceKitWithNamed:@"nav_button_back_default"] forState:UIControlStateHighlighted];
    }
  
    [button setTitle:title forState:UIControlStateNormal];
    UIColor *color = nil;
    if (@available(iOS 13.0, *)) {
        color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            switch (traitCollection.userInterfaceStyle) {
                case UIUserInterfaceStyleLight:
                    return [UIColor ct_colorWithHexString:@"#333333"];
                case UIUserInterfaceStyleDark:
                    return [UIColor whiteColor];
                default:
                    return [UIColor ct_colorWithHexString:@"#333333"];
            }
            
        }];
        
    } else {
        color = [UIColor whiteColor];
    }
    [button setTitleColor:[UIColor ct_colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:25.0f];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button addTarget:target action:@selector(eventLeftLeftBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.frame = CGRectMake(0, 0, button.frame.size.width + 20, 44);
    if (button.ct_width > (self.view.ct_width - 120)) {
        button.ct_width = (self.view.ct_width - 120);
    }
    [button layoutSubviews];
    
    if (self.haveBack) {
        
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 16, 0, -10)];
        
    }
    
    return button;
}

@end
