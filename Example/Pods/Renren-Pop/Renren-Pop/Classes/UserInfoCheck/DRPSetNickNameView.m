//
//  DRPNowExperience.m
//  DNPop
//
//  Created by 李晓越 on 2019/8/15.
//

#import "DRPSetNickNameView.h"
#import "UIImage+Pop.h"
#import <YYCategories/YYCategories.h>
#import <IQKeyboardManager/IQKeyboardManager.h>


typedef void(^ClickSureBlock)(NSString *nickName);
typedef void(^ClickBackBlock)(void);

@interface DRPSetNickNameView ()<UITextFieldDelegate>

@property(nonatomic,copy) ClickSureBlock clickSureBlock;
@property(nonatomic,copy) ClickBackBlock clickBackBlock;

@property(nonatomic,weak) UITextField *textField;
@property(nonatomic,weak) UILabel *errorLabel;
@property(nonatomic,weak) UIButton *sureBtn;

@end

@implementation DRPSetNickNameView

- (instancetype)initWithClickSureBlock:(void(^)(NSString *nickName))clickSureBlock
                        clickBackBlock:(void(^)(void))clickBackBlock
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, kScreenWidth - 66, 0);
        
        self.clickSureBlock = clickSureBlock;
        self.clickBackBlock = clickBackBlock;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(21, 25, self.width - 42, 16)];
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLabel.text = @"保护您的帐号";
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:titleLabel];
        
        UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(21, titleLabel.bottom + 10, self.width - 42, 16)];
        titleLabel2.font = [UIFont fontWithName:@"PingFangSC-Medium" size:24];
        titleLabel2.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLabel2.text = @"重新设置昵称";
        titleLabel2.textAlignment = NSTextAlignmentLeft;
        [self addSubview:titleLabel2];
        
        NSString *tipString = @"您的昵称包含当前禁止使用的词汇，请重新设置。";
        CGFloat tipH = [tipString heightForFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14] width:self.width - 42];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(21, titleLabel2.bottom + 10, self.width - 42, tipH)];
        tipLabel.text = tipString;
        tipLabel.numberOfLines = 0;
        tipLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        tipLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        tipLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:tipLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(21, tipLabel.bottom + 10, self.width - 42, 36)];
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyDone;
        textField.placeholder = @"新昵称";
        textField.textColor = [UIColor colorWithHexString:@"#333333"];
        textField.textAlignment = NSTextAlignmentLeft;
        textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [self addSubview:textField];
        self.textField = textField;
        

        [textField addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(21, textField.bottom + 1, self.width - 42, 0.5f)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#C6C6C6"];
        [self addSubview:lineView];
        
        UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(21, lineView.bottom + 10, self.width - 42, 20)];
        errorLabel.text = @"";
        errorLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        errorLabel.textColor = [UIColor colorWithHexString:@"#FC3B3B"];
        errorLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:errorLabel];
        self.errorLabel = errorLabel;
        errorLabel.hidden = YES;
        
        
        UILabel *ruleTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(21, errorLabel.bottom + 15, self.width - 42, 20)];
        ruleTipLabel.text = @"- 长度为1~12位";
        ruleTipLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        ruleTipLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        ruleTipLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:ruleTipLabel];
        
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, ruleTipLabel.bottom + 22, 150, 41)];
        sureBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sureBtn];
        self.sureBtn = sureBtn;
        sureBtn.centerX = self.centerX;
        
        sureBtn.enabled = NO;
        sureBtn.backgroundColor = [UIColor colorWithHexString:@"#E8E8E8"];
        sureBtn.layer.cornerRadius = 20.5f;
//
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, sureBtn.bottom + 10, 150, 41)];
        backBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor colorWithHexString:@"#3580F9"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        backBtn.centerX = self.centerX;
        
        backBtn.backgroundColor = [UIColor clearColor];
        
        self.height = CGRectGetMaxY(backBtn.frame) + 20;
        
        
        [IQKeyboardManager sharedManager].enable = YES;
        [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
        [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = self.height * 0.5f;
    }
    return self;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 事件
- (void)clickSureBtn
{
    if (self.clickSureBlock) {
        self.clickSureBlock(self.textField.text);
    }
}

- (void)clickBackBtn
{
    if (self.clickBackBlock) {
        self.clickBackBlock();
    }
}


- (void)valueChange:(UITextField *)textField {
    
    
    [self checkIsCanSave];
    
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textField positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textField.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > 12) {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSRange rangeIndex = [nsTextContent rangeOfComposedCharacterSequenceAtIndex:12];
        NSString *s = [nsTextContent substringToIndex:(rangeIndex.location)];
        
        [textField setText:s];
    }
}

- (void)checkIsCanSave
{
    if ([self.textField.text isNotBlank]) {
        self.sureBtn.enabled = YES;
        self.sureBtn.backgroundColor = [UIColor colorWithHexString:@"#3580F9"];
        
    } else {
        self.sureBtn.enabled = NO;
        self.sureBtn.backgroundColor = [UIColor colorWithHexString:@"#E8E8E8"];
    }
}

- (void)errorLabel:(BOOL)hidden text:(NSString *)text
{
    self.errorLabel.hidden = !hidden;
    self.errorLabel.text = text;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)dealloc
{
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10;
}

@end
