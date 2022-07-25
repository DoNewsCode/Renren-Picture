//
//  DRPCheckTypeView.m
//  Renren-Pop
//
//  Created by 李晓越 on 2020/3/11.
//

#import "DRPCheckTypeView.h"
#import "YYCategories.h"
#import "NSBundle+Pop.h"
#import "UIImage+Pop.h"

@interface DRPCheckTypeView ()

@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation DRPCheckTypeView

+ (instancetype)checkTypeView
{
    DRPCheckTypeView *view = [[[NSBundle pop_Bundle] loadNibNamed:@"DRPCheckTypeView" owner:nil options:nil] firstObject];
    return view;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
        
    self.button.layer.cornerRadius = 15;
    self.button.layer.masksToBounds = YES;
    
    CGFloat maxY = CGRectGetMaxY(self.descLabel.frame);
    self.selfHeight = maxY + 22;
    
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    self.descLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.descLabel.textColor = [UIColor colorWithHexString:@"#333333"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat maxY = CGRectGetMaxY(self.descLabel.frame);
    self.height = maxY + 22;
}

- (IBAction)clickButton:(id)sender {
    // 去处理
    if (self.clickButton) {
        self.clickButton(self.checkType);
    }
}


- (void)setCompletedUI
{
    self.button.userInteractionEnabled = NO;
    self.button.backgroundColor = [UIColor clearColor];
    [self.button setTitle:@" 已完成" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor colorWithHexString:@"#3EE4AD"] forState:UIControlStateNormal];
    // 还有一张图片
    [self.button setImage:[UIImage pop_imageWithName:@"pop_hasCompleted"] forState:UIControlStateNormal];
    
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.descLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    
    
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    self.descLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    
    self.isCompleteCheck = YES;
}


@end
