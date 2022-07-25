//
//  DRBBaseNavigationController.m
//  Pods
//
//  Created by Ming on 2019/4/16.
//

#import "DRBBaseNavigationController.h"

@interface DRBBaseNavigationController ()

@end

@implementation DRBBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //     UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    [button setImage:imageTemp forState:UIControlStateNormal];
    [button setImage:imageTemp forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)createCustomNavigation {
    // Do any additional setup after loading the view.
    self.customNavigationBar.backgroundColor = [UIColor redColor];
    CGFloat viewHeight = self.view.ct_height > 750 ? 98 : 74;
    self.customNavigationBar.frame = (CGRect){0.,0.,self.view.ct_width,viewHeight};
    [self.view addSubview:self.customNavigationBar];
}

- (DRBNavigationBar *)customNavigationBar {
    if (!_customNavigationBar) {
        DRBNavigationBar *customNavigationBar = [DRBNavigationBar new];
        _customNavigationBar = customNavigationBar;
    }
    return _customNavigationBar;
}

@end

