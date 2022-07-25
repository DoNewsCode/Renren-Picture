//
//  DRPActionSheetView.m
//  Pods
//
//  Created by 李晓越 on 2019/8/2.
//

#import "DRPActionSheetView.h"
#import <YYCategories/YYCategories.h>


typedef void(^HandleBlock)(NSString *title);

@interface DRPActionSheetView ()

@property(nonatomic,copy) HandleBlock handleBlock;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;


@end


@implementation DRPActionSheetView

- (instancetype)initWithTitleArray:(NSArray<NSString *>*)titleArray
                lastBtnShowRedFont:(BOOL)lastBtnShowRedFont
                       handleBlock:(void(^)(NSString *title))handleBlock
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, kScreenWidth, 0);
        self.handleBlock = handleBlock;
        
        CGFloat btnHeight = 50;
        for (NSInteger i = 0; i < titleArray.count; ++i) {
            NSString *title = [titleArray objectAtIndex:i];
            UIButton *btn = [[UIButton alloc] init];
            [btn setTitle:title forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, i * 50, self.width, btnHeight);
            
            if (i == (titleArray.count - 1)) {
                
                if (lastBtnShowRedFont) {
                    [btn setTitleColor:[UIColor colorWithHexString:@"#FC3B3B"] forState:UIControlStateNormal];
                } else {
                    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
                }
            } else {
                [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, btn.bottom, self.width, 1)];
                lineView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
                [self addSubview:lineView];
            }
            
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            self.height = CGRectGetMaxY(btn.frame);
        }
    }
    return self;
}

- (instancetype)initWithTitleArray:(NSArray<NSString *>*)titleArray
               firstBtnShowRedFont:(BOOL)firstBtnShowRedFont
                       handleBlock:(void(^)(NSString *title))handleBlock
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, kScreenWidth, 0);
        self.handleBlock = handleBlock;
        
        CGFloat btnHeight = 50;
        for (NSInteger i = 0; i < titleArray.count; ++i) {
            NSString *title = [titleArray objectAtIndex:i];
            UIButton *btn = [[UIButton alloc] init];
            [btn setTitle:title forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, i * 50, self.width, btnHeight);
            
            if (i == 0) {
                
                if (firstBtnShowRedFont) {
                    [btn setTitleColor:[UIColor colorWithHexString:@"#FC3B3B"] forState:UIControlStateNormal];
                } else {
                    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
                }
            } else {
                [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            }
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, btn.bottom, self.width, 1)];
            lineView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
            [self addSubview:lineView];
            
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            self.height = CGRectGetMaxY(btn.frame);
        }
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                numberOfLines:(NSInteger)numberOfLines
                   titleArray:(NSArray<NSString *>*)titleArray
           lastBtnShowRedFont:(BOOL)lastBtnShowRedFont
                  handleBlock:(void(^)(NSString *title))handleBlock
{
    self = [super init];
    
    if (self) {
        
        self.frame = CGRectMake(0, 0, kScreenWidth, 0);
        self.handleBlock = handleBlock;
        
        
        CGFloat width = self.width - 50;
        
        UIView *lastView = nil;
        
        if ([title isNotBlank]) {
            
            self.titleLabel.frame = CGRectMake(25, 10, width, 44);
            self.titleLabel.text = title;
            [self addSubview:self.titleLabel];
            lastView = self.titleLabel;
            
        }
       
        
        if ([message isNotBlank]) {

            CGFloat rowHeight = 14.91;
            CGFloat height = [message heightForFont:self.messageLabel.font width:width];
            
            self.messageLabel.numberOfLines = numberOfLines;
            if (numberOfLines > 0) {
                if (height > numberOfLines * rowHeight) {
                    height = numberOfLines * rowHeight;
                }
            }
            
            /// 我都看不懂的骚操作
            CGFloat top = 10;
            if ([title isNotBlank]) {
                top = self.titleLabel.bottom - 20;
            }
            
            self.messageLabel.frame = CGRectMake(25, top, width, height + 20);
            self.messageLabel.text = message;
            [self addSubview:self.messageLabel];
            
            lastView = self.messageLabel;
        }
        
        CGFloat btnHeight = 50;
        for (NSInteger i = 0; i < titleArray.count; ++i) {
            NSString *title = [titleArray objectAtIndex:i];
            UIButton *btn = [[UIButton alloc] init];
            [btn setTitle:title forState:UIControlStateNormal];
//            btn.frame = CGRectMake(0, i * 50, self.width, btnHeight);
            btn.frame = CGRectMake(0, lastView.bottom + 1, self.width, btnHeight);
            
            if (i == (titleArray.count - 1)) {
                
                if (lastBtnShowRedFont) {
                    [btn setTitleColor:[UIColor colorWithHexString:@"#FC3B3B"] forState:UIControlStateNormal];
                } else {
                    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
                }
            } else {
                [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            }
            
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            

            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btn.width, 1)];
            lineView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
            [btn addSubview:lineView];
            
            lastView = btn;
        }
        self.height = CGRectGetMaxY(lastView.frame);
    }
    return self;
}


- (void)clickBtn:(UIButton *)btn
{
    if (self.handleBlock) {
        self.handleBlock(btn.titleLabel.text);
    }
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:16.];
        titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 1;
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        UILabel *messageLabel = [UILabel new];
        messageLabel.font = [UIFont systemFontOfSize:12.5];
        messageLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:messageLabel];
        _messageLabel = messageLabel;
    }
    return _messageLabel;
}

@end
