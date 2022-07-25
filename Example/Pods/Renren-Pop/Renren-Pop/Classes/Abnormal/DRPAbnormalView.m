//
//  DRPAbnormalView.m
//  Renren-Pop
//
//  Created by 李晓越 on 2019/11/15.
//

#import "DRPAbnormalView.h"
#import <YYCategories/YYCategories.h>

typedef void(^ClickBtnBlock)(void);
typedef void(^CloseBlock)(void);

@interface DRPAbnormalView ()

@property(nonatomic,copy) ClickBtnBlock clickBtnBlock;
@property(nonatomic,copy) CloseBlock closeBlock;

@end

@implementation DRPAbnormalView

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                    btnString:(NSString *)btnString
                  showBackBtn:(BOOL)showBackBtn
                clickBtnBlock:(void (^)(void))clickBtnBlock
                   closeBlock:(void(^)(void))closeBlock
{
    self = [super init];
    if (self) {
       
        self.clickBtnBlock = clickBtnBlock;
        self.closeBlock = closeBlock;
        
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, kScreenWidth - 66, 0);
        
        CGFloat imgW = self.width - 80;
        CGFloat titleH = [title heightForFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18] width:imgW];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 20, self.width - 50, titleH)];
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
               
        CGFloat height = [message heightForFont:font width:imgW];
       
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, titleLabel.bottom + 10, self.width - 50, height)];
        messageLabel.numberOfLines = 0;
        messageLabel.text = message;
        messageLabel.font = font;
        messageLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        [self addSubview:messageLabel];
        
        if (showBackBtn) {
            
            CGFloat btnW = self.width/2;
            
            UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, messageLabel.bottom + 10, btnW, 44)];
            [backBtn setTitle:@"返回" forState:UIControlStateNormal];
            backBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [backBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:backBtn];
            
            UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(backBtn.right, messageLabel.bottom + 10, btnW, 44)];
            [rightBtn setTitle:btnString forState:UIControlStateNormal];
            rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:rightBtn];
            
            self.height = CGRectGetMaxY(rightBtn.frame) + 10;
            
        } else {
            
            UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, messageLabel.bottom + 10, self.width, 44)];
            [rightBtn setTitle:btnString forState:UIControlStateNormal];
            rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:rightBtn];
            
            self.height = CGRectGetMaxY(rightBtn.frame) + 10;

        }
    }
    return self;
}

- (void)clickBack
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)clickRightBtn
{
    if (self.clickBtnBlock) {
        self.clickBtnBlock();
    }
}

@end
