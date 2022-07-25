//
//  DRPVertionTipView.m
//  DNPop
//
//  Created by 李晓越 on 2019/8/15.
//

#import "DRPVertionTipView.h"
#import "UIImage+Pop.h"
#import <YYCategories/YYCategories.h>

typedef void(^UpgradeNowBlock)(void);
typedef void(^NoUpgradeBlock)(void);

@interface DRPVertionTipView ()

@property(nonatomic,copy) UpgradeNowBlock upgradeNowBlock;
@property(nonatomic,copy) NoUpgradeBlock noUpgradeBlock;

@end

@implementation DRPVertionTipView

- (instancetype)initWithTitle:(NSString *)title
                    tipString:(NSString *)tipString
              upgradeNowBlock:(void(^)(void))upgradeNowBlock
               noUpgradeBlock:(void(^)(void))noUpgradeBlock
{
    self = [super init];
    if (self) {
        
        self.upgradeNowBlock = upgradeNowBlock;
        self.noUpgradeBlock = noUpgradeBlock;
        
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, kScreenWidth - 66, 0);
        CGFloat imgW = self.width - 80;
        CGFloat imgH = imgW * 0.67;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, imgW, imgH)];
        imageView.image = [UIImage pop_imageWithName:@"pop_upgradeNow_icon"];
        imageView.centerX = self.centerX;
        [self addSubview:imageView];
        
        CGFloat titleH = [title heightForFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18] width:imgW];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, imageView.bottom + 10, imgW, titleH)];
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        CGFloat width = self.width - 50;
        CGFloat height = [tipString heightForFont:font width:width];
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, titleLabel.bottom + 10, width, height)];
        messageLabel.numberOfLines = 0;
        messageLabel.text = tipString;
        messageLabel.font = font;
        messageLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        [self addSubview:messageLabel];
        
        CGFloat noBtnW = self.width * 0.33;
        UIButton *noBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, messageLabel.bottom + 10, noBtnW, 41)];
        noBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        [noBtn setTitle:@"暂不" forState:UIControlStateNormal];
        [noBtn setTitleColor:[UIColor colorWithHexString:@"#3580F9"] forState:UIControlStateNormal];
        [noBtn addTarget:self action:@selector(clickNoBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:noBtn];

        noBtn.layer.borderWidth = 1;
        noBtn.layer.borderColor = [UIColor colorWithHexString:@"#3580F9"].CGColor;
        noBtn.layer.cornerRadius = 20.5f;
        
        CGFloat upgradeNowBtnW = self.width * 0.48;
        UIButton *upgradeNowBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, messageLabel.bottom + 10, upgradeNowBtnW, 41)];
        upgradeNowBtn.right = self.right - 25;
        upgradeNowBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        [upgradeNowBtn setTitle:@"立即升级" forState:UIControlStateNormal];
        [upgradeNowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [upgradeNowBtn addTarget:self action:@selector(clickUpgradeNowBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:upgradeNowBtn];
        
        upgradeNowBtn.backgroundColor = [UIColor colorWithHexString:@"#3580F9"];
        upgradeNowBtn.layer.cornerRadius = 20.5f;
        
        self.height = CGRectGetMaxY(upgradeNowBtn.frame) + 20;
        
        
    }
    return self;
}

- (void)clickNoBtn
{
    if (self.noUpgradeBlock) {
        self.noUpgradeBlock();
    }
}

- (void)clickUpgradeNowBtn
{
    if (self.upgradeNowBlock) {
        self.upgradeNowBlock();
    }
}

@end
