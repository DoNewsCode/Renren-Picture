//
//  DRMEAddTextViewController.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/11/4.
//

#import "DRMEAddTextViewController.h"
#import "DRMEChooseColorView.h"

@interface DRMEAddTextViewController ()<UITextViewDelegate>

@property(nonatomic,weak) DRMEChooseColorView *chooseColorView;


@property(nonatomic,assign) CGFloat textViewMaxHeight;

@end

@implementation DRMEAddTextViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    if (![self.currentTextColorStr isNotBlank]) {
        self.currentTextColorStr = @"#FFFFFF";
    }
    
    // 毛玻璃效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    effectView.frame = self.view.bounds;
    [self.view addSubview:effectView];

    // 返回
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage me_imageWithName:@"me_back_btn"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    backBtn.sd_layout.leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, kStatusBarHeight + 10)
    .widthIs(44)
    .heightIs(44);
    
    // 完成
    UIButton *doneBtn = [[UIButton alloc] init];
    doneBtn.backgroundColor = [UIColor colorWithHexString:@"#2A73EB"];
    doneBtn.titleLabel.font = kFontMediumSize(15);
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(clickDoneBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    doneBtn.layer.cornerRadius = 15.f;
    doneBtn.sd_layout.centerYEqualToView(backBtn)
    .rightSpaceToView(self.view, 15)
    .widthIs(64).heightIs(30);
    
    UITextView *textView = [[UITextView alloc] init];
    textView.delegate = self;
    textView.backgroundColor = [UIColor clearColor];
    textView.textColor = [UIColor whiteColor];
//    textView.font = [UIFont fontWithName:@"PingFangSC-Medium" size:32];
    textView.font = kFontMediumSize(32);
    textView.returnKeyType = UIReturnKeyDone;
    textView.textAlignment = NSTextAlignmentLeft;
    
//    textView.textContainerInset = UIEdgeInsetsMake(20, 10, 10, 10);
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    [textView becomeFirstResponder];
    [self.view addSubview:textView];
    
    textView.layer.cornerRadius = 8.f;
    
    textView.text = self.lastText;
    self.textView = textView;
    
    // 为了计算高度准确
//    CGFloat padding = textView.textContainer.lineFragmentPadding;
//    textView.textContainerInset = UIEdgeInsetsMake(0, -padding, 0, -padding);

    
    textView.sd_layout.leftSpaceToView(self.view, 31)
    .rightSpaceToView(self.view, 31)
    .topSpaceToView(doneBtn, 30)
    .heightIs(49.4);
    
    [textView updateLayout];

    /// 选择颜色的控件
    DRMEChooseColorView *chooseColorView = [[DRMEChooseColorView alloc] initWithIsSelectedT:self.isChooseBackColor selectedColorStr:self.currentTextColorStr];
    [self.view addSubview:chooseColorView];
    self.chooseColorView = chooseColorView;

    chooseColorView.sd_layout.leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view)
    .heightIs(47);
    
    WeakSelf(self)
    // 点击了具体的颜色
    chooseColorView.chooseColorBlock = ^(NSString * _Nonnull colorStr) {
        
        if (weakself.isChooseBackColor) {
            
            if ([colorStr isEqualToString:@"#FFFFFF"]) {
                textView.textColor = [UIColor colorWithHexString:@"#000000"];
            } else if ([colorStr isEqualToString:@"#000000"]) {
                textView.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
            } else {
                textView.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
            }
            
            textView.backgroundColor = [UIColor colorWithHexString:colorStr];
            weakself.currentTextColorStr = colorStr;
            
        } else {
            textView.textColor = [UIColor colorWithHexString:colorStr];
            weakself.currentTextColorStr = colorStr;
        }
    };
    
    // 点击了大T，设置背景颜色
    chooseColorView.chooseBackColorBlock = ^(BOOL isSelected) {
        
        weakself.chooseBackColor = isSelected;
        
        if (isSelected) {
            
            if ([weakself.currentTextColorStr isEqualToString:@"#FFFFFF"]) {
                textView.textColor = [UIColor colorWithHexString:@"#000000"];
            } else if ([weakself.currentTextColorStr isEqualToString:@"#000000"]) {
                textView.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
            } else {
                textView.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
            }
            textView.backgroundColor = [UIColor colorWithHexString:weakself.currentTextColorStr];
            
        } else {
            
            textView.backgroundColor = [UIColor clearColor];
            textView.textColor = [UIColor colorWithHexString:weakself.currentTextColorStr];
        }
    };
    
    
    [kNotificationCenter addObserver:self
                            selector:@selector(keyboardWillShowNotification:)
                                name:UIKeyboardWillShowNotification object:nil];
    
    
    // 处理再次编辑某个文字的逻辑
    if (self.isChooseBackColor) {
        if ([weakself.currentTextColorStr isEqualToString:@"#FFFFFF"]) {
            textView.textColor = [UIColor colorWithHexString:@"#000000"];
        } else if ([weakself.currentTextColorStr isEqualToString:@"#000000"]) {
            textView.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        } else {
            textView.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        }
        textView.backgroundColor = [UIColor colorWithHexString:weakself.currentTextColorStr];
    }
    
    
    
}

#pragma mark - 通知
- (void)keyboardWillShowNotification:(NSNotification *)noitfi
{
    
    CGRect kbFrame = [[noitfi userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat kbHeight = kbFrame.size.height;
    
    // 64 间距     47 选色工具条高度
//    self.textView.sd_layout.bottomSpaceToView(self.view, kbHeight + 64 + 47);
    
    // 计算 textView 最大高度
    CGFloat maxHeight = kScreenHeight - (kbHeight + 64 + 47) - self.textView.top;
    self.textViewMaxHeight = maxHeight;
    
    // 第一次搞出键盘的时候也算一下高度
    CGFloat maxW = self.textView.width - self.textView.textContainer.lineFragmentPadding * 2;
    CGFloat height = [self.textView.text heightForFont:self.textView.font width:maxW];
    
    if (height > self.textViewMaxHeight) {
        height = self.textViewMaxHeight;
    }
    
    if (height == 0) {
        height = 49.4f;
    }
    self.textView.sd_layout.heightIs(height);
    
    [UIView animateWithDuration:0.25f animations:^{
        self.chooseColorView.sd_layout.bottomSpaceToView(self.view, kbHeight);
    }];
}

#pragma mark - 事件

- (void)clickBackBtn
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickDoneBtn
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.clickDoneBlock) {
        self.clickDoneBlock(self.textView.text, self.textView.font,
                            self.textView.textColor, self.textView.backgroundColor,
                            self.textView,
                            self.currentTextColorStr,
                            self.isChooseBackColor);
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
                                                replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        // 在这里做你响应return键的代码
        [self clickDoneBtn];
        return NO;
    }
 
    return YES;
}

- (void)addAttributedText:(UITextView *)textView
{
//    if (设置了背景色) {
//        <#statements#>
//    }
    
    NSMutableAttributedString *attrM = [[NSMutableAttributedString alloc] initWithString:textView.text];
    NSRange range = NSMakeRange(0, textView.text.length);
    [attrM addAttributes:@{NSFontAttributeName : textView.font} range:range];
    [attrM addAttributes:@{NSBackgroundColorAttributeName : [UIColor colorWithHexString:self.currentTextColorStr]} range:range];
    
//    textView.attributedText = attrM;
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    // 简体中文输入，包括简体拼音，简体五笔，简体手写
    UITextRange *selectedRange = [self.textView markedTextRange];
    // 获取高亮部分
    UITextPosition *position = [self.textView positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    
    NSString *toBeString = self.textView.text;
    
    
    // 富文本处理效果
    // 只有选择了 T 的时候会有
//    if (self.chooseBackColor) {
//        [self addAttributedText:textView];
//    }
    
    if (!position) {
        
        if (toBeString.length > 100) {
            self.textView.text = [toBeString substringToIndex:100];
        }
        
    } else {
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
    }
    
    CGFloat maxW = self.textView.width - self.textView.textContainer.lineFragmentPadding * 2;
    
    CGFloat height = [self.textView.text heightForFont:self.textView.font width:maxW];
    
    if (height > self.textViewMaxHeight) {
        height = self.textViewMaxHeight;
    }
    self.textView.sd_layout.heightIs(height);
    
}

- (void)dealloc
{
    NSLog(@"--- 添加文字页面销毁");
    [kNotificationCenter removeObserver:self];
}

@end
