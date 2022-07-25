//
//  DRPNowExperience.m
//  DNPop
//
//  Created by 李晓越 on 2019/8/15.
//

#import "DRPUpdateSuccessView.h"
#import "UIImage+Pop.h"
#import <YYCategories/YYCategories.h>

typedef void(^ClickSureBlock)(void);

@interface DRPUpdateSuccessView ()

@property(nonatomic,copy) ClickSureBlock clickSureBlock;

@end

@implementation DRPUpdateSuccessView

- (instancetype)initWithClickSureBlock:(void(^)(void))clickSureBlock
{
    self = [super init];
    if (self) {
        
        self.clickSureBlock = clickSureBlock;

        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, kScreenWidth - 66, 0);
        CGFloat imgW = self.width;
        CGFloat imgH = imgW * 0.67;

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgW, imgH)];
        imageView.image = [UIImage pop_imageWithName:@"pop_update_success"];
        imageView.centerX = self.centerX;
        [self addSubview:imageView];
        
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, imageView.bottom + 25, 150, 41)];
        sureBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sureBtn];
        sureBtn.centerX = self.centerX;

        sureBtn.backgroundColor = [UIColor colorWithHexString:@"#3580F9"];
        sureBtn.layer.cornerRadius = 20.5f;

        self.height = CGRectGetMaxY(sureBtn.frame) + 25;
    }
    return self;
}

- (void)clickSureBtn
{
    if (self.clickSureBlock) {
        self.clickSureBlock();
    }
}


@end
