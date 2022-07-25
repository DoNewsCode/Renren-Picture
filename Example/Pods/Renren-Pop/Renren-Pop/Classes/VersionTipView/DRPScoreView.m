//
//  DRPScoreView.m
//  DNPop
//
//  Created by 李晓越 on 2019/8/15.
//

#import "DRPScoreView.h"
#import "UIImage+Pop.h"
#import <YYCategories/YYCategories.h>

typedef void(^GoScoreBlock)(void);
typedef void(^FeedbackBlock)(void);
typedef void(^CloseBlock)(void);


@interface DRPScoreView ()

@property(nonatomic,copy) GoScoreBlock goScoreBlock;
@property(nonatomic,copy) FeedbackBlock feedbackBlock;
@property(nonatomic,copy) CloseBlock closeBlock;

@end

@implementation DRPScoreView

- (instancetype)initWithGoScoreBlock:(void(^)(void))goScoreBlock
                       feedbackBlock:(void(^)(void))feedbackBlock
                          closeBlock:(void(^)(void))closeBlock
{
    self = [super init];
    if (self) {
        
        self.goScoreBlock = goScoreBlock;
        self.feedbackBlock = feedbackBlock;
        self.closeBlock = closeBlock;
        
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, kScreenWidth - 66, 0);
        CGFloat imgW = self.width - 80;
        CGFloat imgH = imgW * 0.67;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, imgW, imgH)];
        imageView.image = [UIImage pop_imageWithName:@"pop_goscore_icon"];
        imageView.centerX = self.centerX;
        [self addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom + 10, imgW, 25)];
        titleLabel.centerX = self.centerX;
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLabel.text = @"评分鼓励";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        
        NSString *tipString = @"用的还顺手吗，评个分或留个言，告诉我们你的想法，按钮反馈问题和";
        
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
        
        CGFloat feedbackW = self.width * 0.33;
        UIButton *feedbackBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, messageLabel.bottom + 10, feedbackW, 41)];
        feedbackBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        [feedbackBtn setTitle:@"反馈问题" forState:UIControlStateNormal];
        [feedbackBtn setTitleColor:[UIColor colorWithHexString:@"#3580F9"] forState:UIControlStateNormal];
        [feedbackBtn addTarget:self action:@selector(clickFeedbackBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:feedbackBtn];
        
        feedbackBtn.layer.borderWidth = 1;
        feedbackBtn.layer.borderColor = [UIColor colorWithHexString:@"#3580F9"].CGColor;
        feedbackBtn.layer.cornerRadius = 20.5f;
        
        CGFloat goScoreBtnW = self.width * 0.48;
        UIButton *goScoreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, messageLabel.bottom + 10, goScoreBtnW, 41)];
        goScoreBtn.right = self.right - 25;
        goScoreBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        [goScoreBtn setTitle:@"去评分" forState:UIControlStateNormal];
        [goScoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [goScoreBtn addTarget:self action:@selector(clickGoScoreBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:goScoreBtn];
        
        goScoreBtn.backgroundColor = [UIColor colorWithHexString:@"#3580F9"];
        goScoreBtn.layer.cornerRadius = 20.5f;
        
        self.height = CGRectGetMaxY(goScoreBtn.frame) + 20;
    }
    
    return self;
}

- (void)clickFeedbackBtn
{
    if (self.feedbackBlock) {
        self.feedbackBlock();
    }
}

- (void)clickGoScoreBtn
{
    if (self.goScoreBlock) {
        self.goScoreBlock();
    }
}

- (void)clickCloseBtn
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

@end
