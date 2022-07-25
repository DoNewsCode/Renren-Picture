//
//  DNVertifyAlertView.m
//  MinePage
//
//  Created by donews on 2019/4/4.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DNVertifyAlertView.h"
#import "YYText/YYTextView.h"
#import "YYTextContainerView.h"
#import <YYCategories/UIView+YYAdd.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kHPercentage(a) (kScreenWidth*((a)/667.00))
#define kWPercentage(a) (kScreenHeight *((a)/375.00))


@interface DNVertifyAlertView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *titleLabel; // 提示的标题
@property (nonatomic, strong) UILabel *descLabel; // 描述文字
@property (nonatomic, strong) YYTextView *textView; // 输入框
@property (nonatomic, strong) UIButton *sendButton; // 发送
@property (nonatomic, strong) UIButton *cancleButton; // 取消
@property (nonatomic, strong) UIView *lineView; // 取消上面的线
@property (nonatomic, strong) UIView *marginView; // 间距的view

@end



@implementation DNVertifyAlertView

- (instancetype)initWithTitle:(NSString *)title desc:(NSString *)desc placeholder:(NSString *)placeholder {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, 0);
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.descLabel];
        [self addSubview:self.textView];
        [self addSubview:self.marginView];
        [self addSubview:self.sendButton];
        [self addSubview:self.lineView];
//        [self addSubview:self.cancleButton];
        
        [self.cancleButton addTarget:self action:@selector(s_tapEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.sendButton addTarget:self action:@selector(s_sendEvent) forControlEvents:UIControlEventTouchUpInside];
        
        self.titleLabel.text = @"好友验证";
        self.descLabel.text = @"由于对方设置了隐私，您无法直接发起对话。说点什么，并等待对方验证通过吧。";
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(s_keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(s_keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        CGFloat height = CGRectGetMaxY(self.cancleButton.frame);
        self.height = height;
        self.top = kScreenHeight - height;
        
    }
    return self;
}

- (void)s_keyboardWillShow:(NSNotification *)noti {
    
    //获取键盘的高度
    NSDictionary *userInfo = [noti userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    NSInteger height = keyboardRect.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.superview.transform = CGAffineTransformMakeTranslation(0, -height);
    }];
}

- (void)s_keyboardWillHide:(NSNotification *)noti {
    [UIView animateWithDuration:0.25 animations:^{
        self.superview.transform = CGAffineTransformIdentity;
    }];
}

- (void)s_sendEvent {

    if (self.clickSendEventBlock) {
        self.clickSendEventBlock(self.textView.text);
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isMemberOfClass:[YYTextContainerView class]] || [touch.view isMemberOfClass:[YYTextView class]]) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - Getters & Setters
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        CGRect frame = CGRectMake(0, 0, self.bounds.size.width, 55);
        _titleLabel = [[UILabel alloc] initWithFrame:frame];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
        _titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)descLabel {
    if (_descLabel == nil) {
        CGRect frame = CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame), self.bounds.size.width - 20 * 2, 42);
        _descLabel = [[UILabel alloc] initWithFrame:frame];
        _descLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
        _descLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.numberOfLines = 0;
        _descLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _descLabel;
}

- (YYTextView *)textView {
    if (_textView == nil) {
        CGRect frame = CGRectMake(20, CGRectGetMaxY(self.descLabel.frame) + 15, self.bounds.size.width - 40, 65);
        _textView = [[YYTextView alloc] initWithFrame:frame];
        _textView.layer.borderWidth = 1;
        _textView.layer.borderColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0].CGColor;
        _textView.layer.cornerRadius = 3;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"附加消息，我是..."attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Light" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1.0]}];
        _textView.placeholderAttributedText = string;
        _textView.contentInset = UIEdgeInsetsMake(5,8, 0,0);
    }
    return _textView;
}

- (UIView *)marginView {
    if (_marginView == nil) {
        CGRect frame = CGRectMake(0, CGRectGetMaxY(self.textView.frame) + 25, self.bounds.size.width, 5);
        _marginView = [[UIView alloc] initWithFrame:frame];
        _marginView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    }
    return _marginView;
}

- (UIButton *)sendButton{
    if (_sendButton == nil) {
        CGRect frame = CGRectMake(0, CGRectGetMaxY(self.marginView.frame), self.bounds.size.width,60);
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = frame;
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
    }
    return _sendButton;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        CGRect frame = CGRectMake(0, CGRectGetMinY(self.sendButton.frame), self.bounds.size.width, 0.5);
        _lineView = [[UIView alloc] initWithFrame:frame];
        _lineView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    }
    return _lineView;
}

- (UIButton *)cancleButton {
    if (_cancleButton == nil) {
        CGRect frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), self.bounds.size.width, 60);
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleButton.frame = frame;
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[UIColor colorWithRed:16/255.0 green:93/255.0 blue:251/255.0 alpha:1.0] forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
    }
    return _cancleButton;
}


@end
