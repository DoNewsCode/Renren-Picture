//
//  DRPNowExperience.m
//  DNPop
//
//  Created by 李晓越 on 2019/8/15.
//

#import "DRPNowExperience.h"
#import "UIImage+Pop.h"
#import <YYCategories/YYCategories.h>


typedef void(^NowExperienceBlock)(void);
typedef void(^CloseBlock)(void);

@interface DRPNowExperience ()

@property(nonatomic,copy) NowExperienceBlock nowExperienceBlock;
@property(nonatomic,copy) CloseBlock closeBlock;

@end

@implementation DRPNowExperience

- (instancetype)initWithTitle:(NSString *)title
                    tipString:(NSString *)tipString
           nowExperienceBlock:(void(^)(void))nowExperienceBlock
                   closeBlock:(void(^)(void))closeBlock
{
    self = [super init];
    if (self) {
        
        self.nowExperienceBlock = nowExperienceBlock;
        self.closeBlock = closeBlock;
        
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, kScreenWidth - 66, 0);
        CGFloat imgW = self.width - 80;
        CGFloat imgH = imgW * 0.67;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, imgW, imgH)];
        imageView.image = [UIImage pop_imageWithName:@"pop_nowExperience_icon"];
        imageView.centerX = self.centerX;
        [self addSubview:imageView];
        
        CGFloat titleH = [title heightForFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18] width:imgW];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, imageView.bottom + 10, self.width - 50, titleH)];
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        
        CGFloat height = [tipString heightForFont:font width:imgW];
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, titleLabel.bottom + 10, self.width - 50, height)];
        messageLabel.numberOfLines = 0;
        messageLabel.text = tipString;
        messageLabel.font = font;
        messageLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        [self addSubview:messageLabel];
        
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 20 - 13, 13, 20, 20)];
        [closeBtn setImage:[UIImage pop_imageWithName:@"pop_goscore_close_btn"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:closeBtn];
        
        
        UIButton *nowExperienceBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, messageLabel.bottom + 10, self.width - 50, 41)];
        nowExperienceBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        [nowExperienceBtn setTitle:@"立即升级" forState:UIControlStateNormal];
        [nowExperienceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nowExperienceBtn addTarget:self action:@selector(clickNowExperienceBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nowExperienceBtn];
        
        nowExperienceBtn.backgroundColor = [UIColor colorWithHexString:@"#3580F9"];
        nowExperienceBtn.layer.cornerRadius = 20.5f;
        
        self.height = CGRectGetMaxY(nowExperienceBtn.frame) + 20;
        
        
        
        
    }
    return self;
}

- (void)clickNowExperienceBtn
{
    if (self.nowExperienceBlock) {
        self.nowExperienceBlock();
    }
}

- (void)clickCloseBtn
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

@end
