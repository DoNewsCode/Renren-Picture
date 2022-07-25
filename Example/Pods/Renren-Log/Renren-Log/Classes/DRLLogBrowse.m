//
//  DRLLogBrowse.m
//  Renren-Log
//
//  Created by 陈金铭 on 2019/12/9.
//

#import "DRLLogBrowse.h"
#import "DRLPanGestureRecognizer.h"
#import "UIColor+CTHex.h"

@interface DRLLogBrowse ()

@property(nonatomic, strong,readwrite) UIWindow *logWindow;
@property(nonatomic, strong,readwrite) DRLLogBrowseNavigationController *logBrowseNavigationController;
@property(nonatomic, strong,readwrite) DRLLogBrowseViewController *logBrowseViewController;

@property(nonatomic, strong) DRLPanGestureRecognizer *windowPanGestureRecognizer;

@property(nonatomic, strong) UIButton *closeButton;
@property (nonatomic, assign) CGRect startFrame;
@property (nonatomic, assign) CGPoint startLocation;
@end

@implementation DRLLogBrowse

static DRLLogBrowse *_instance = nil;

#pragma mark - Intial Methods

//单例
+ (instancetype)sharedLogBrowse {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization {
    _logBrowseHidden = YES;
}

- (void)logBrowseHidden:(BOOL)hidden animation:(BOOL)animation {
    self.logBrowseHidden = hidden;
    
}

- (void)setLogBrowseHidden:(BOOL)logBrowseHidden {
    _logBrowseHidden = logBrowseHidden;
    self.logWindow.hidden = logBrowseHidden;
    if (logBrowseHidden == NO) {
        self.logWindow.rootViewController = self.logBrowseNavigationController;
        [self.logWindow addSubview:self.closeButton];
    } else {
        [self.closeButton removeFromSuperview];
    }
    
    
}

/// 拖拽手势
- (void)eventHandlePanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint location    = [panGestureRecognizer locationInView:[UIApplication sharedApplication].keyWindow];
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.startFrame = self.logWindow.frame;
            self.startLocation = location;
            break;
        case UIGestureRecognizerStateChanged: {
            if (self.logWindow.frame.size.height == 0) return;
            if (self.startFrame.size.width == 0 || self.startFrame.size.height == 0) return;
            
            CGFloat width = self.startFrame.size.width;
            CGFloat height = self.startFrame.size.height;
            
            CGFloat rateX = (self.startLocation.x - self.startFrame.origin.x) / self.startFrame.size.width;
            CGFloat x = location.x - width * rateX;
            
            CGFloat rateY = (self.startLocation.y - self.startFrame.origin.y) / self.startFrame.size.height;
            CGFloat y = location.y - height * rateY;
            
            self.logWindow.frame = CGRectMake(x, y, width, height);
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{
        }
            break;
        default:
            break;
    }
}

- (void)eventCloseButtonEventTouchUpInside:(UIButton *)button {
    if (self.logBrowseHidden == NO) {
        self.logBrowseHidden = YES;
    }
}

- (UIWindow *)logWindow {
    if (!_logWindow) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        CGFloat windowWidth = keyWindow.frame.size.width * 0.5;
        CGFloat windowHeight = keyWindow.frame.size.height * 0.5;
        UIWindow *logWindow = [[UIWindow alloc] initWithFrame:(CGRect){keyWindow.frame.size.width - 50 - windowWidth,keyWindow.frame.size.height - windowHeight - 50,windowWidth,windowHeight}];
        logWindow.windowLevel = UIWindowLevelAlert + 10;
//        logWindow.clipsToBounds = YES;
//        logWindow.layer.borderWidth = 1;
        logWindow.layer.cornerRadius = 10;
        // 阴影颜色
        logWindow.layer.shadowColor = [UIColor blackColor].CGColor;
        // 阴影偏移量 默认为(0,3)
        logWindow.layer.shadowOffset = CGSizeMake(4, 4);
        // 阴影透明度
        logWindow.layer.shadowOpacity = 0.4;
        logWindow.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        [logWindow addGestureRecognizer:self.windowPanGestureRecognizer];
        [logWindow makeKeyAndVisible];
        logWindow.hidden = YES;
        _logWindow = logWindow;
    }
    return _logWindow;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
           UIButtonType buttonType = UIButtonTypeSystem;
         if (@available(iOS 13.0, *)) {
             buttonType = UIButtonTypeClose;
         }
         UIButton *closseButton = [UIButton buttonWithType:buttonType];
        closseButton.frame = (CGRect){(self.logWindow.frame.size.width - 44.) * 0.5,5,44.,44.};
        [closseButton addTarget:self action:@selector(eventCloseButtonEventTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
//         [self.logWindow addSubview:closseButton];
        _closeButton = closseButton;
    }
    return _closeButton;
}

- (DRLPanGestureRecognizer *)windowPanGestureRecognizer {
    if (!_windowPanGestureRecognizer) {
        DRLPanGestureRecognizer *windowPanGestureRecognizer = [[DRLPanGestureRecognizer alloc] initWithTarget:self action:@selector(eventHandlePanGestureRecognizer:)];
        windowPanGestureRecognizer.direction = DRLPanGestureRecognizerDirectionVertical;
        
        _windowPanGestureRecognizer = windowPanGestureRecognizer;
    }
    return _windowPanGestureRecognizer;
}

- (DRLLogBrowseViewController *)logBrowseViewController {
    if (!_logBrowseViewController) {
        DRLLogBrowseViewController *logBrowseViewController = [DRLLogBrowseViewController new];
        logBrowseViewController.master = YES;
        _logBrowseViewController = logBrowseViewController;
    }
    return _logBrowseViewController;
}



- (DRLLogBrowseNavigationController *)logBrowseNavigationController {
    if (!_logBrowseNavigationController) {
        DRLLogBrowseNavigationController *logBrowseNavigationController = [DRLLogBrowseNavigationController new];
        [logBrowseNavigationController addChildViewController:self.logBrowseViewController];
        _logBrowseNavigationController = logBrowseNavigationController;
    }
    return _logBrowseNavigationController;
}

@end
