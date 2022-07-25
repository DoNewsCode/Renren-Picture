//
//  DRIImageTagBottomToolBar.m
//  RenRen-ImagePicker
//
//  Created by 张健康 on 2019/7/2.
//

#import "DRIImageTagBottomToolBar.h"
#import <DNCommonKit/DNBaseMacro.h>
#import "DRIImageTagCommentTextField.h"
#import <DNCommonKit/UIColor+CTHex.h>
#import "SDAutoLayout.h"
#import "DRPPop.h"
#import "DRIImagePickerController.h"
static int const     kDRINameTextMaxLength = 15;
static CGFloat const kDRIButtonWidth = 50;
static CGFloat const kDRITextFieldLeftPadding = 10;

@interface DRIImageTagBottomToolBar () <UITextFieldDelegate>

@property (nonatomic,copy)NSString *toBeString;
@property (nonatomic,copy)NSAttributedString *originString;
@property (nonatomic,strong)UIButton *publishButton;
@end

@implementation DRIImageTagBottomToolBar

- (void)loadTagInputBottomBar
{
    self.userInteractionEnabled = YES;
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kDRIButtonWidth);
    self.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kDRIButtonWidth, 0, kDRIButtonWidth, kDRIButtonWidth)];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button setTitle:@"发布" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor ct_colorWithHexString:@"0x999999"] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor ct_colorWithHexString:@"0x3580F9"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor whiteColor];
    button.enabled = NO;
    self.publishButton = button;
    
    DRIImageTagCommentTextField *textField = [[DRIImageTagCommentTextField alloc] initWithFrame:CGRectMake(kDRITextFieldLeftPadding, (kDRIButtonWidth - 30) / 2, SCREEN_WIDTH - button.width - kDRITextFieldLeftPadding, 30)];
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
       //设置显示模式为永远显示(默认不显示)
       textField.leftViewMode = UITextFieldViewModeAlways;
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = textField.height/2;
    [self addSubview:textField];
    [self addSubview:button];
    self.inputText = textField;
    self.inputText.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)publish:(UIButton *)button
{
    NSString *text = [self.inputText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *clippedString = [self clipString:text maxLength:kDRINameTextMaxLength];
    
    if (clippedString.length == 0) {
        NSArray *windows = [UIApplication sharedApplication].windows;
        UIWindow *window = windows.lastObject;
        [DRPPop showErrorHUDWithMessage:@"标签内容不能为空" completion:nil];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(bottomToolBarPublishAction:)]) {
        [self.delegate bottomToolBarPublishAction:clippedString];
    }
}

- (NSString *)clipString:(NSString *)src maxLength:(NSUInteger)maxLength
{
    NSString *clippedString = src;
    if (clippedString.length > maxLength) {
        clippedString = [clippedString substringToIndex:maxLength];
        clippedString = [self filterString:clippedString];
    }
    return clippedString;
}

- (void)clipTextFieldText:(UITextField *)textField maxLength:(NSUInteger)maxLength
{
    if (textField.text.length > maxLength) {
        UITextRange *selectedRange = textField.selectedTextRange;
        textField.text = [self clipString:textField.text maxLength:maxLength];
        textField.selectedTextRange = selectedRange;
    }
}

- (NSString *)filterString:(NSString *)src
{
    NSData *unicodeData = [src dataUsingEncoding:NSUnicodeStringEncoding];
    UInt16 *unicodes = (UInt16 *)(unicodeData.bytes);
    NSUInteger srcLength = unicodeData.length / sizeof(UInt16);
    if (srcLength <= 0) {
        return src;
    }
    int resultLength = 0;
    UInt16 UInt16s[srcLength];
    UInt16 head = *(UInt16 *)(unicodeData.bytes);
    UInt16s[resultLength++]= head;
    for (int i = (resultLength > 0); i < srcLength; i++) {
        UInt16 unicode = unicodes[i];
//        bool isChar = IS_CHAR((UInt32)unicode);
//        if (isChar) {
            UInt16s[resultLength++] = unicode;
//        } else {
            //non-utf8 char
//        }
    }
    NSData *resultData = [NSData dataWithBytes:UInt16s length:resultLength * sizeof(UInt16)];
    NSString *resultString = [[NSString alloc]initWithData:resultData encoding:NSUnicodeStringEncoding];
    return resultString;
}

- (void)textFieldTextDidChange:(NSNotification *)notification
{
    int                maxLength = kDRINameTextMaxLength;
    self.toBeString = self.inputText.text;
    self.originString = self.inputText.attributedText;
    
    NSString           *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [self.inputText markedTextRange];
        if (!selectedRange) {
            if ([self clipEmoji:@"Apple Color Emoji" maxLength:maxLength]) {
                self.publishButton.enabled = self.inputText.text.length;
                return;
            }
        }
    } else if ([lang isEqualToString:@"emoji"]) {
        if ([self clipEmoji:@".Helvetica Neue" maxLength:maxLength]) {
            self.publishButton.enabled = self.inputText.text.length;
            return;
        }
    } else {
        [self clipTextFieldText:self.inputText maxLength:maxLength];
    }
    
    self.publishButton.enabled = self.inputText.text.length;
}

- (BOOL)clipEmoji:(NSString *)fontFamilyName maxLength:(int)maxLength
{
    __block BOOL hasCliped = NO;
    [self.originString enumerateAttributesInRange:NSMakeRange(0, self.originString.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        NSDictionary *dic = (NSDictionary *)value;
        NSString *fontFamily = [[dic objectForKey:@"NSFont"] familyName];
        
        if ([fontFamily hasPrefix:fontFamilyName]) {
            if ((range.location < maxLength) && ((range.location + range.length) > maxLength)) {
                NSRange emojiRange = NSMakeRange(0, 0);
                
                while (range.location <= maxLength) {
                    emojiRange = [self.toBeString  rangeOfComposedCharacterSequenceAtIndex:range.location];
                    range.location += emojiRange.length;
                }
                
                range.location -= emojiRange.length;
                self.inputText.text = [self.toBeString  substringToIndex:range.location];
                *stop = YES;
                hasCliped = YES;
            }
        }
    }];
    return hasCliped;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self publish:nil];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
