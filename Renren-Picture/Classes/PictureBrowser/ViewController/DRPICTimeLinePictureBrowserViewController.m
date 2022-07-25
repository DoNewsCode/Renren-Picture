//
//  DRPICTimeLinePictureBrowserViewController.m
//  Renren-Picture
//
//  Created by 陈金铭 on 2019/9/27.
//

#import "DRPICTimeLinePictureBrowserViewController.h"
#import "UIColor+CTHex.h"

@interface DRPICTimeLinePictureBrowserViewController ()
@property(nonatomic, strong) UILabel *topCountLabel;
@end

@implementation DRPICTimeLinePictureBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.titleView = self.topCountLabel;
//    self.topCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.currentIndex + 1,self.pictures.count];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self createRightBarButtonItem:DRBNavigationBarRightTypeMoreWhite image:nil target:self action:@selector(eventLeftRightBarButtonClick:)];
}

#pragma mark - Override Methods

#pragma mark - Intial Methods

#pragma mark - Event Methods

- (void)eventLeftRightBarButtonClick:(UIButton *)button {
//    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - Public Methods

#pragma mark - Private Methods

#pragma mark - Setter And Getter Methods
- (void)setCurrentPictureView:(DRPICPictureView *)currentPictureView {
    [super setCurrentPictureView:currentPictureView];
    
}

- (void)setCurrentIndex:(NSUInteger)currentIndex {
    [super setCurrentIndex:currentIndex];
    
    self.topCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.currentIndex + 1,self.pictures.count];
}

- (UILabel *)topCountLabel {
    if (!_topCountLabel) {
        UILabel *topCountLabel = [UILabel new];
        topCountLabel.ct_width = 50;
        topCountLabel.textAlignment = NSTextAlignmentCenter;
        topCountLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        topCountLabel.textColor = [UIColor ct_colorWithHexString:@"#999999"];
        _topCountLabel = topCountLabel;
    }
    return _topCountLabel;
}

@end
