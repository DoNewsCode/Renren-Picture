//
//  DNPopViewController.m
//  DNPop
//
//  Created by 陈金铭 on 2019/7/3.
//

#import "DNPopViewController.h"

#import "DNPopActionSheetPresentAnimator.h"
#import "DNPopActionSheetDismissAnimator.h"

#import "DNPopActionSheetView.h"
#import "DNPopAlertView.h"

@interface DNPopViewController ()<UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, assign) DNPopViewControllerStyle preferredStyle;

/** AlertActionArray */
@property (nonatomic, strong) NSMutableArray<DNPopAction *> *alertActions;
@property (nonatomic, strong) NSArray<DNPopAction *> *actions;
@property(nonatomic, strong) UITapGestureRecognizer *backgroundTapGestureRecognizer;
@property(nonatomic, copy) NSString *customTitle;
@property(nonatomic, copy) NSString *customMessage;
@end

@implementation DNPopViewController
#pragma mark - Intial Methods
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(DNPopViewControllerStyle)preferredStyle {
    DNPopViewController *customAlertController = [self alertControllerWithPreferredStyle:preferredStyle];
    customAlertController.customTitle = title;
    customAlertController.customMessage = message;
    if (preferredStyle == DNPopViewControllerStyleActionSheet) {
        
        customAlertController.presentStyle = DNPopPresentStyleSlideUp;
        customAlertController.dismissStyle = DNPopDismissStyleSlideDown;
    } else if (preferredStyle == DNPopViewControllerStyleAlert) {
        
        customAlertController.presentStyle = DNPopPresentStyleSystem;
        customAlertController.dismissStyle = DNPopDismissStyleFadeOut;
    }
    return customAlertController;
}

+ (instancetype)alertControllerWithPreferredStyle:(DNPopViewControllerStyle )preferredStyle {
    DNPopViewController *customAlertController = [[DNPopViewController alloc] init];
    customAlertController.preferredStyle = preferredStyle;
    return customAlertController;
}

#pragma mark - Override Methods
- (instancetype)init {
    if (self = [super init]) {
        self.transitioningDelegate = self;                          // 设置自己为转场代理
        self.modalPresentationStyle = UIModalPresentationCustom;    // 自定义转场模式
        
        self.backgroundCancel = YES;
//        self.backgroundUserInteractionEnabled = NO;
        
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view != self.backgroundView) {
        return NO;
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:_backgroundView];
    self.backgroundView.frame = self.view.bounds;
    
    self.view.backgroundColor = [UIColor clearColor];
    
    if (self.preferredStyle == DNPopViewControllerStyleActionSheet) {
        
        self.alertView = [[DNPopActionSheetView alloc] initWithTitle:self.customTitle message:self.customMessage style:self.alertStyle alertActions:self.actions];
    } else if (self.preferredStyle == DNPopViewControllerStyleAlert) {
        
        self.alertView = [[DNPopAlertView alloc] initWithTitle:self.customTitle message:self.customMessage style:self.alertStyle alertActions:self.actions];
    }
    [self.view addSubview:self.alertView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Public Methods
- (void)addAction:(DNPopAction *)action {
    [self.alertActions addObject:action];
    self.actions = self.alertActions.copy;
}

- (void)addActions:(NSArray<DNPopAction *> *)actions {
    [self.alertActions addObjectsFromArray:actions];
    self.actions = self.alertActions.copy;
}

- (void)returnHandler:(void (^ __nullable)(DNPopViewController *alertController))handler {
    self.handler = handler;
}

#pragma mark - Private Methods
- (void)eventBackgroundClick:(UIGestureRecognizer*)gestureRecognizer {
    self.handler(self);
}

#pragma mark - UIViewControllerTransitioningDelegate Methods
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if (self.preferredStyle == DNPopViewControllerStyleActionSheet) {
        DNPopActionSheetPresentAnimator *customAlertActionSheetPresentAnimator = [DNPopActionSheetPresentAnimator new];
        customAlertActionSheetPresentAnimator.style = self.presentStyle;
        return customAlertActionSheetPresentAnimator;
    } else if (self.preferredStyle == DNPopViewControllerStyleAlert) {
        
    }
    DNPopAlertPresentAnimator *customAlertPresentAnimator = [DNPopAlertPresentAnimator new];
    customAlertPresentAnimator.style = self.presentStyle;
    return customAlertPresentAnimator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if (self.preferredStyle == DNPopViewControllerStyleActionSheet) {
        DNPopActionSheetDismissAnimator *customAlertActionSheetDismissAnimator = [DNPopActionSheetDismissAnimator new];
        customAlertActionSheetDismissAnimator.style = self.dismissStyle;
        return customAlertActionSheetDismissAnimator;
    } else if (self.preferredStyle == DNPopViewControllerStyleAlert) {
        
    }
    
    DNPopAlertDismissAnimator *customAlertDismissAnimator = [DNPopAlertDismissAnimator new];
    customAlertDismissAnimator.style = self.dismissStyle;
    return customAlertDismissAnimator;
    
}

#pragma mark - Setter
-(void)setBackgroundCancel:(BOOL)backgroundCancel {
    _backgroundCancel = backgroundCancel;
    if (backgroundCancel) {
        [self.backgroundView addGestureRecognizer:self.backgroundTapGestureRecognizer];
    } else {
        [self.backgroundView removeGestureRecognizer:self.backgroundTapGestureRecognizer];
    }
}

//- (void)setBackgroundUserInteractionEnabled:(BOOL)backgroundUserInteractionEnabled {
//    _backgroundUserInteractionEnabled = backgroundUserInteractionEnabled;
//    self.backgroundView.userInteractionEnabled = !backgroundUserInteractionEnabled;
//    self.view.userInteractionEnabled = !backgroundUserInteractionEnabled;
//}
#pragma mark - Getter
- (UIView *)backgroundView {
    if (!_backgroundView) {
        // 灰色半透明背景
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.3;
        _backgroundView = backgroundView;
    }
    return _backgroundView;
}
- (NSMutableArray<DNPopAction *> *)alertActions {
    if (!_alertActions) {
        NSMutableArray<DNPopAction *> *alertActions = [NSMutableArray<DNPopAction *> new];
        _alertActions = alertActions;
    }
    return _alertActions;
}

- (DNPopStyle *)alertStyle {
    if (!_alertStyle) {
        DNPopStyle *alertStyle = [DNPopStyle new];
        _alertStyle = alertStyle;
    }
    return _alertStyle;
}

-(UITapGestureRecognizer *)backgroundTapGestureRecognizer {
    if (!_backgroundTapGestureRecognizer) {
        UITapGestureRecognizer *backgroundTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(eventBackgroundClick:)];
        _backgroundTapGestureRecognizer = backgroundTapGestureRecognizer;
    }
    return _backgroundTapGestureRecognizer;
}

@end

