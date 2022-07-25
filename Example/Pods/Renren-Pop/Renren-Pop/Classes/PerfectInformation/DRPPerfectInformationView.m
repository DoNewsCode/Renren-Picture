//
//  DRPPerfectInformationView.m
//  Pods
//

#import "DRPPerfectInformationView.h"
#import "UIImage+Pop.h"
#import <YYCategories/YYCategories.h>

typedef void(^HandlerBlock)(void);
typedef void(^CloseBlock)(void);

@interface DRPPerfectInformationView()

@property(nonatomic,copy) CloseBlock closeBlock;
@property(nonatomic,copy) HandlerBlock handlerBlock;

@end

@implementation DRPPerfectInformationView


- (instancetype)initWithHandlerBlock:(void(^)(void))handlerBlock
                          closeBlock:(void(^)(void))closeBlock
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, kScreenWidth - 66, 0);
        
        
        self.closeBlock = closeBlock;
        self.handlerBlock = handlerBlock;
        
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        bgView.layer.cornerRadius = 15.f;
        
        CGFloat imgW = self.width + 2;
        CGFloat imgH = imgW * 0.67;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgW, imgH)];
        imageView.image = [UIImage pop_imageWithName:@"pop_infoHeader"];
        imageView.centerX = self.centerX;
        [bgView addSubview:imageView];
        
        
        NSString *tipString = @"在人人，您即能够找到那些失联已久的老朋友，也能够结识趣味相投的新朋友。\n\n完善您的资料，能让更多的朋友认识您，也可以让人人更准确的为您找到那些您可能认识的人。";
        
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        CGFloat width = self.width - 50;
        CGFloat height = [tipString heightForFont:font width:width];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, imageView.bottom + 20, width, height)];
        tipLabel.numberOfLines = 0;
        tipLabel.text = tipString;
        tipLabel.font = font;
        tipLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        [bgView addSubview:tipLabel];
        
        
        UIButton *toSetUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, tipLabel.bottom + 20, 151, 50)];
        toSetUpBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        [toSetUpBtn setTitle:@"前往完善资料" forState:UIControlStateNormal];
        [toSetUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [toSetUpBtn addTarget:self action:@selector(clickToSetUpBtn) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:toSetUpBtn];
        toSetUpBtn.centerX = self.centerX;
        
        toSetUpBtn.backgroundColor = [UIColor colorWithHexString:@"#3580F9"];
        toSetUpBtn.layer.cornerRadius = 25.f;
        
        
        bgView.height = CGRectGetMaxY(toSetUpBtn.frame) + 20;
        
        UIButton *afterCerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, bgView.bottom + 30, 44, 44)];
        afterCerBtn.centerX = self.centerX;
        [afterCerBtn setImage:[UIImage pop_imageWithName:@"pop_activity_close"] forState:UIControlStateNormal];
        [afterCerBtn addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:afterCerBtn];
        
        self.height = CGRectGetMaxY(afterCerBtn.frame);
        
    }
    return self;
}

- (void)clickToSetUpBtn
{
    if (self.handlerBlock) {
        self.handlerBlock();
    }
}

- (void)clickClose
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

@end
