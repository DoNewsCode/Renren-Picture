//
//  DRPPrivateSetingView.m
//  Renren-Pop
//
//  Created by 李晓越 on 2019/11/5.
//

#import "DRPPrivateSetingView.h"
#import "UIImage+Pop.h"
#import <YYCategories/YYCategories.h>


typedef void(^ToSetUpBlock)(void);
typedef void(^ClickLinkBlock)(NSURL *URL);
typedef void(^CloseBlock)(void);

@interface DRPPrivateSetingView ()<UITextViewDelegate>

@property(nonatomic,copy) ToSetUpBlock toSetUpBlock;
@property(nonatomic,copy) CloseBlock closeBlock;
@property(nonatomic,copy) ClickLinkBlock clickLinkBlock;

@end


@implementation DRPPrivateSetingView

- (instancetype)initWithTitle:(NSString *)title
                   attrString:(NSMutableAttributedString *)attrString
                    btnString:(NSString *)btnString
                 toSetUpBlock:(void(^)(void))toSetUpBlock
               clickLinkBlock:(void(^)(NSURL *URL))clickLinkBlock
                   closeBlock:(void(^)(void))closeBlock
{
    self = [super init];
    if (self) {
       
        self.toSetUpBlock = toSetUpBlock;
        self.clickLinkBlock = clickLinkBlock;
        self.closeBlock = closeBlock;
        
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, kScreenWidth - 66, 0);
        
        CGFloat imgW = self.width - 80;
        CGFloat imgH = imgW * 0.67;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, imgW, imgH)];
        imageView.image = [UIImage pop_imageWithName:@"pop_private_bg"];
        imageView.centerX = self.centerX;
        [self addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, imageView.bottom + 10, self.width - 50, 20)];
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        NSString *messageStr = attrString.string;
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        CGFloat height = [messageStr heightForFont:font width:self.width - 40];
        
        UITextView *messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, titleLabel.bottom+10, self.width - 40, height)];
//        messageTextView.backgroundColor = [UIColor yellowColor];
        messageTextView.contentInset = UIEdgeInsetsZero;
        messageTextView.textContainerInset = UIEdgeInsetsZero;
        messageTextView.editable = NO;
        messageTextView.delegate = self;
//        messageTextView.scrollEnabled = NO;
        messageTextView.textColor = [UIColor colorWithHexString:@"#585858"];
        [self addSubview:messageTextView];

        messageTextView.attributedText = attrString;
        
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 20 - 13, 13, 20, 20)];
        [closeBtn setImage:[UIImage pop_imageWithName:@"pop_goscore_close_btn"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        
        
        UIButton *toSetUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, messageTextView.bottom + 10, self.width - 160, 41)];
        toSetUpBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        [toSetUpBtn setTitle:btnString forState:UIControlStateNormal];
        [toSetUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [toSetUpBtn addTarget:self action:@selector(clickToSetUpBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:toSetUpBtn];
        
        toSetUpBtn.backgroundColor = [UIColor colorWithHexString:@"#3580F9"];
        toSetUpBtn.layer.cornerRadius = 20.5f;
        
        self.height = CGRectGetMaxY(toSetUpBtn.frame) + 20;
    }
    return self;
}

- (void)clickToSetUpBtn
{
    if (self.toSetUpBlock) {
        self.toSetUpBlock();
    }
}

- (void)clickCloseBtn
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    if (self.clickLinkBlock) {
        self.clickLinkBlock(URL);
        return NO;
    }
    
    return YES;
}

@end
