//
//  DRPNowExperience.m
//  DNPop
//
//  Created by 李晓越 on 2019/8/15.
//

#import "DRPSetUserNameView.h"
#import "UIImage+Pop.h"
#import <YYCategories/YYCategories.h>
#import "DRPPop.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

typedef void(^ClickSureBlock)(NSString *userName);
typedef void(^ClickBackBlock)(void);

@interface DRPSetUserNameView ()<UITextFieldDelegate>

@property(nonatomic,copy) ClickSureBlock clickSureBlock;
@property(nonatomic,copy) ClickBackBlock clickBackBlock;

@property(nonatomic,weak) UITextField *textField;
@property(nonatomic,weak) UILabel *errorLabel;
@property(nonatomic,weak) UIButton *sureBtn;

@end

@implementation DRPSetUserNameView

- (instancetype)initWith:(NSString *)account
          clickSureBlock:(void(^)(NSString *userName))clickSureBlock
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
        titleLabel2.text = @"设置新帐号";
        titleLabel2.textAlignment = NSTextAlignmentLeft;
        [self addSubview:titleLabel2];
        
        NSString *tipString = [NSString stringWithFormat:@"您当前的帐号名称为“%@”。由纯数字构成的帐号名称会增大帐号被窃取的风险。因此，您必须设置一个新的帐号名称才能继续使用。\n修改完成后，您仍可使用手机号进行登录，也可以使用新设置的帐号登录。", account];
        CGFloat tipH = [tipString heightForFont:[UIFont fontWithName:@"PingFangSC-Regular" size:13] width:self.width - 42];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(21, titleLabel2.bottom + 10, self.width - 42, tipH)];
        tipLabel.text = tipString;
        tipLabel.numberOfLines = 0;
        tipLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        tipLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        tipLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:tipLabel];

        NSRange range = [tipString rangeOfString:[NSString stringWithFormat:@"“%@”", account]];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:tipString];
        
        [attr setAttributes:@{NSForegroundColorAttributeName : UIColor.blackColor} range:range];
        tipLabel.attributedText = attr;
        
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(21, tipLabel.bottom + 10, self.width - 42, 36)];
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyDone;
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.placeholder = @"新账号名称";
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
        
        
        NSString *ruleString = @"- 长度为6~30位\n- 由英文、数字和除@、emoji之外的特殊符号组成\n- 必须以英文字母开头\n- 不区分大小写\n- 不能包含中文字符";
        CGFloat ruleH = [ruleString heightForFont:[UIFont fontWithName:@"PingFangSC-Regular" size:13] width:self.width - 42];
        
        UILabel *ruleTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(21, errorLabel.bottom + 15, self.width - 42, ruleH)];
        ruleTipLabel.numberOfLines = 0;
        ruleTipLabel.text = ruleString;
        ruleTipLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        ruleTipLabel.textColor = [UIColor colorWithHexString:@"#666666"];
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
        
        self.height = CGRectGetMaxY(backBtn.frame) + 10;
        
        
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
    
    NSString *text = self.textField.text;
    
    // 6~30位
    if (text.length < 6 || text.length > 30) {
        [self errorLabel:YES text:@"账号必须为6～30位"];
        return;
    }
    
    //判断是否以字母开头
    //全转为大写
    NSString *upperCaseStr = [text uppercaseString];
    //判断第一个字符是否为字母 英文或者中文转拼音后都是字母开头
    if ([upperCaseStr characterAtIndex:0] >= 'A' && [upperCaseStr characterAtIndex:0] <= 'Z') {
        
    } else {
        
        [self errorLabel:YES text:@"必须以英文字母开头"];
        return;
    }
           
    // 不得包含emoji、#和@
    if ([text containsString:@"@"] ||
        [text containsString:@"#"] ||
        [self stringContainsEmoji:text]) {
        [self errorLabel:YES text:@"不能包含emoji、#和@"];
        return;
    }
    
    if (self.clickSureBlock) {
        self.clickSureBlock(self.textField.text);
    }
}

/// 判断是否有emoji
- (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

- (void)clickBackBtn
{
    if (self.clickBackBlock) {
        self.clickBackBlock();
    }
}


- (void)valueChange:(UITextField *)textField {
    
    
    [self checkIsCanSave];
    
//    UITextRange *selectedRange = [textField markedTextRange];
//    //获取高亮部分
//    UITextPosition *pos = [textField positionFromPosition:selectedRange.start offset:0];
//
//    //如果在变化中是高亮部分在变，就不要计算字符了
//    if (selectedRange && pos) {
//        return;
//    }
//
//    NSString  *nsTextContent = textField.text;
//    NSInteger existTextNum = nsTextContent.length;
//
//    if (existTextNum > 30) {
//        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
//        NSRange rangeIndex = [nsTextContent rangeOfComposedCharacterSequenceAtIndex:30];
//        NSString *s = [nsTextContent substringToIndex:(rangeIndex.location)];
//
//        [textField setText:s];
//    }
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
