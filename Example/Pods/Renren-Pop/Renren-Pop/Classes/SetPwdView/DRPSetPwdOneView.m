//
//  DRPSetPwdOneView.m
//  DNPop
//
//  Created by 李晓越 on 2019/8/15.
//

#import "DRPSetPwdOneView.h"
#import "UIImage+Pop.h"
#import <YYCategories/YYCategories.h>

typedef void(^ToSetupBlock)(void);
typedef void(^LaterSetupBlock)(void);
typedef void(^CloseBlock)(void);


@interface DRPSetPwdOneView ()

@property(nonatomic,copy) ToSetupBlock toSetupBlock;
@property(nonatomic,copy) LaterSetupBlock laterSetupBlock;
@property(nonatomic,copy) CloseBlock closeBlock;

@end

@implementation DRPSetPwdOneView

- (instancetype)initWithToSetupBlock:(void(^)(void))toSetupBlock
                     laterSetupBlock:(void(^)(void))laterSetupBlock
                          closeBlock:(void(^)(void))closeBlock
{
    self = [super init];
    if (self) {
        
        self.toSetupBlock = toSetupBlock;
        self.laterSetupBlock = laterSetupBlock;
        self.closeBlock = closeBlock;
        
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, kScreenWidth - 66, 0);
        CGFloat imgW = self.width - 68;
        CGFloat imgH = imgW * 0.67;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, imgW, imgH)];
        imageView.image = [UIImage pop_imageWithName:@"pop_setPwd_one"];
        imageView.centerX = self.centerX;
        [self addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom + 10, imgW, 25)];
        titleLabel.centerX = self.centerX;
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLabel.text = @"设置登录密码";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        
        NSString *tipString = @"我们建议您设置一个登录密码，以在手机遗失时找回您的帐号。";
        
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
        
        CGFloat feedbackW = self.width * 0.48;
        UIButton *feedbackBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, messageLabel.bottom + 30, feedbackW, 41)];
        feedbackBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        [feedbackBtn setTitle:@"去设置" forState:UIControlStateNormal];
        [feedbackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [feedbackBtn addTarget:self action:@selector(clickFeedbackBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:feedbackBtn];
        
        
        feedbackBtn.backgroundColor = [UIColor colorWithHexString:@"#3580F9"];
        feedbackBtn.layer.cornerRadius = 20.5f;
        
        CGFloat goScoreBtnW = self.width * 0.33;
        UIButton *goScoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, messageLabel.bottom + 30, goScoreBtnW, 41)];
        goScoreBtn.right = self.right - 25;
        goScoreBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        [goScoreBtn setTitle:@"下次再说" forState:UIControlStateNormal];
        [goScoreBtn setTitleColor:[UIColor colorWithHexString:@"#3580F9"] forState:UIControlStateNormal];
        [goScoreBtn addTarget:self action:@selector(clickGoScoreBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:goScoreBtn];
        
        
        goScoreBtn.layer.borderWidth = 1;
        goScoreBtn.layer.borderColor = [UIColor colorWithHexString:@"#3580F9"].CGColor;
        goScoreBtn.layer.cornerRadius = 20.5f;
        
        self.height = CGRectGetMaxY(goScoreBtn.frame) + 20;
    }
    
    return self;
}

- (void)clickFeedbackBtn
{
    if (self.toSetupBlock) {
        self.toSetupBlock();
    }
}

- (void)clickGoScoreBtn
{
    if (self.laterSetupBlock) {
        self.laterSetupBlock();
    }
}

- (void)clickCloseBtn
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

@end
