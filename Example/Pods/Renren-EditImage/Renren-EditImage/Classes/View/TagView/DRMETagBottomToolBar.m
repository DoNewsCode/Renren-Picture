//
//  DRMETagBottomToolBar.m
//

#import "DRMETagBottomToolBar.h"
#import <DNCommonKit/DNBaseMacro.h>
#import <DNCommonKit/UIColor+CTHex.h>
#import "SDAutoLayout.h"
#import "DRPPop.h"

static int const     kNameTextMaxLength = 15;
static CGFloat const kButtonWidth = 50;
static CGFloat const kTextFieldLeftPadding = 10;

@interface DRMETagBottomToolBar () <UITextFieldDelegate>

@property (nonatomic,copy)NSString *toBeString;
@property (nonatomic,copy)NSAttributedString *originString;
@property (nonatomic,strong)UIButton *publishButton;
@end

@implementation DRMETagBottomToolBar

- (void)loadTagInputBottomBar
{
    self.userInteractionEnabled = YES;
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kButtonWidth);
    self.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kButtonWidth, 0, kButtonWidth, kButtonWidth)];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button setTitle:@"发布" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor ct_colorWithHexString:@"0x999999"] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor ct_colorWithHexString:@"0x3580F9"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickPublish:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor whiteColor];
    button.enabled = NO;
    self.publishButton = button;
    
    DRMETagCommentTextField *textField = [[DRMETagCommentTextField alloc] initWithFrame:CGRectMake(kTextFieldLeftPadding, (kButtonWidth - 30) / 2, SCREEN_WIDTH - button.width - kTextFieldLeftPadding, 30)];
    textField.placeholder = @"请输入小于15个字的的标记内容";
    textField.font = [UIFont systemFontOfSize:14];
    textField.backgroundColor = [UIColor ct_colorWithHexString:@"0xF9F9F9"];
    [textField setTextColor:[UIColor blackColor]];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setKeyboardAppearance:UIKeyboardAppearanceDefault];
    [textField setTextAlignment:NSTextAlignmentLeft];
    [textField setReturnKeyType:UIReturnKeyDone];
    [textField setEnablesReturnKeyAutomatically:YES];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = textField.height/2;
    [self addSubview:textField];
    [self addSubview:button];
    self.inputText = textField;
    self.inputText.delegate = self;
    
    [textField addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 事件
- (void)clickPublish:(UIButton *)button
{
    NSString *text = [self.inputText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (![text isNotBlank]) {
        [DRPPop showErrorHUDWithMessage:@"标签内容不能为空" completion:nil];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(bottomToolBarPublishAction:)]) {
        [self.delegate bottomToolBarPublishAction:text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self clickPublish:nil];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary         *keyboardInfo = [notification userInfo];
    
    if ([self.delegate respondsToSelector:@selector(bottomToolBarKeyboardWillShow:)]) {
        [self.delegate bottomToolBarKeyboardWillShow:keyboardInfo];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary         *keyboardInfo = [notification userInfo];
    
    if ([self.delegate respondsToSelector:@selector(bottomToolBarKeyboardWillHide:)]) {
        [self.delegate bottomToolBarKeyboardWillHide:keyboardInfo];
    }
}


- (void)valueChange:(UITextField *)textField {
        
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textField positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textField.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > kNameTextMaxLength) {
        NSRange rangeIndex = [nsTextContent rangeOfComposedCharacterSequenceAtIndex:kNameTextMaxLength];
        NSString *s = [nsTextContent substringToIndex:(rangeIndex.location)];
        
        [textField setText:s];
    }
    
    self.publishButton.enabled = [textField.text isNotBlank];
}

- (void)dealloc
{
    NSLog(@"-- %s, %d", __func__, __LINE__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
