//
//  DRPRealNameView.m
//  Pods
//
//  Created by 李晓越 on 2019/8/2.
//

#import "DRPRealNameView.h"
#import "UIImage+Pop.h"
#import <YYCategories/YYCategories.h>




typedef void(^DoneBlock)(void);
typedef void(^AfterCerBlock)(void);

@interface DRPRealNameView()

@property(nonatomic,copy) DoneBlock doneBlock;
@property(nonatomic,copy) AfterCerBlock afterCerBlock;

@end

@implementation DRPRealNameView


- (instancetype)initWithTipString:(NSString *)tipString doneBlock:(void(^)(void))doneBlock afterBlock:(void(^)(void))afterBlock
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, 266, 339);
        
        self.doneBlock = doneBlock;
        self.afterCerBlock = afterBlock;
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.frame];
        bgView.image = [UIImage pop_imageWithName:@"real_name_auth_bg"];
        [self addSubview:bgView];
        
        UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 129, 124)];
        logoImgView.centerX = self.centerX;
        logoImgView.image = [UIImage pop_imageWithName:@"real_name_auth_logo"];
        [self addSubview:logoImgView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, logoImgView.bottom, self.width - 46, 25)];
        titleLabel.text = @"实名认证";
        titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, titleLabel.bottom, self.width - 40, 60)];
        tipLabel.numberOfLines = 0;
        tipLabel.text = tipString;
        tipLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        tipLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        [self addSubview:tipLabel];

        UIButton *goCerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, tipLabel.bottom + 10, 137, 35)];
        goCerBtn.centerX = self.centerX;
        goCerBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [goCerBtn setTitle:@"去认证" forState:UIControlStateNormal];
        [goCerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:goCerBtn];
        [goCerBtn addTarget:self action:@selector(clickGoCerBtn) forControlEvents:UIControlEventTouchUpInside];
        goCerBtn.layer.cornerRadius = 15;
        goCerBtn.backgroundColor = [UIColor colorWithRed:55/255.0f green:125/255.0f blue:245/255.0f alpha:1];
        
        UIButton *afterCerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, goCerBtn.bottom + 10, 137, 35)];
        afterCerBtn.centerX = self.centerX;
        afterCerBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [afterCerBtn setTitle:@"稍后认证" forState:UIControlStateNormal];
        [afterCerBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        
        [afterCerBtn addTarget:self action:@selector(clickAfterCerBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:afterCerBtn];
        
    }
    return self;
}

- (void)clickGoCerBtn
{
    
    if (self.doneBlock) {
        self.doneBlock();
    }
    
}

- (void)clickAfterCerBtn
{
    if (self.afterCerBlock) {
        self.afterCerBlock();
    }
}

@end
