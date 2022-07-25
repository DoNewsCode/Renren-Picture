//
//  DRPScoreView.m
//  DNPop
//
//  Created by 李晓越 on 2019/8/15.
//

#import "DRPSetPwdTwoView.h"
#import "UIImage+Pop.h"
#import <YYCategories/YYCategories.h>

typedef void(^IknowBlock)(void);
typedef void(^CloseBlock)(void);


@interface DRPSetPwdTwoView ()

@property(nonatomic,copy) IknowBlock iknowBlock;
@property(nonatomic,copy) CloseBlock closeBlock;

@end

@implementation DRPSetPwdTwoView

- (instancetype)initWithIknowBlock:(void(^)(void))iknowBlock
                        closeBlock:(void(^)(void))closeBlock
{
    self = [super init];
    if (self) {
        
        self.iknowBlock = iknowBlock;
        self.closeBlock = closeBlock;
        
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, kScreenWidth - 66, 0);
        CGFloat imgW = self.width - 80;
        CGFloat imgH = imgW * 0.67;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, imgW, imgH)];
        imageView.image = [UIImage pop_imageWithName:@"pop_setPwd_two"];
        imageView.centerX = self.centerX;
        [self addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom + 10, imgW, 25)];
        titleLabel.centerX = self.centerX;
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLabel.text = @"设置登录密码";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        
        NSString *tipString = @"您可以在“我的”标签页中选择右上角的菜单，选择“设置”-“帐号与安全”来手动设置登录密码。";
        
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        CGFloat width = self.width - 50;
        CGFloat height = [tipString heightForFont:font width:width];
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, titleLabel.bottom + 10, width, height)];
        messageLabel.numberOfLines = 0;
        messageLabel.text = tipString;
        messageLabel.font = font;
        messageLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        [self addSubview:messageLabel];
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 20 - 13, 13, 20, 20)];
        [closeBtn setImage:[UIImage pop_imageWithName:@"pop_goscore_close_btn"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        
        UIButton *feedbackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, messageLabel.bottom + 20, 150, 41)];
        feedbackBtn.centerX = self.centerX;
        feedbackBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        [feedbackBtn setTitle:@"我知道了" forState:UIControlStateNormal];
        [feedbackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [feedbackBtn addTarget:self action:@selector(clickFeedbackBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:feedbackBtn];
        
        feedbackBtn.backgroundColor = [UIColor colorWithHexString:@"#3580F9"];
        feedbackBtn.layer.cornerRadius = 20.5f;
        
        self.height = CGRectGetMaxY(feedbackBtn.frame) + 20;
    }
    
    return self;
}

- (void)clickFeedbackBtn
{
    if (self.iknowBlock) {
        self.iknowBlock();
    }
}

- (void)clickCloseBtn
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

@end
