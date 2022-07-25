//
//  DRLLogDetailViewController.m
//  Renren-Library
//
//  Created by 陈金铭 on 2019/8/10.
//

#import "DRLLogDetailViewController.h"

#import "UIColor+CTHex.h"
#import "SSZipArchive.h"

@interface DRLLogDetailViewController ()<UITextViewDelegate>

@property(nonatomic, strong) UITextView *textView;
//段落样式
@property(nonatomic, strong) NSMutableParagraphStyle *mainTitleParagraphStyle;

@property(nonatomic, strong) NSMutableParagraphStyle *descriptionParagraphStyle;

@property(nonatomic, strong) NSMutableParagraphStyle *subtitleParagraphStyle;

@property(nonatomic, strong) NSMutableParagraphStyle *textParagraphStyle;

@property(nonatomic, strong) NSMutableAttributedString *logAttributedText;

@property(nonatomic, strong) NSDateFormatter *timeDateFormatter;

@property(nonatomic, copy) UIColor *mainTitleColor;
@property(nonatomic, copy) UIColor *subtitleColor;
@property(nonatomic, copy) UIColor *textColor;
@property(nonatomic, copy) UIColor *descriptionColor;

@property(nonatomic, copy) UIFont *mainTitleFont;
@property(nonatomic, copy) UIFont *subtitleFont;
@property(nonatomic, copy) UIFont *textFont;
@property(nonatomic, copy) UIFont *descriptionFont;

@end

@implementation DRLLogDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createContent];
}

- (void)createContent {
    self.title = @"Log Detail";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *top = nil;
    
    if (@available(iOS 11.0, *)) {
        top = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view.safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    } else {
        top = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    }
    [self.view addConstraint:top];
    
    NSLayoutConstraint *left = nil;
    if (@available(iOS 11.0, *)) {
        left = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view.safeAreaLayoutGuide attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    } else {
        left = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    }
    [self.view addConstraint:left];
    
    NSLayoutConstraint *bottom = nil;
    if (@available(iOS 11.0, *)) {
        bottom = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view.safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    } else {
        bottom = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    }
    [self.view addConstraint:bottom];
    
    NSLayoutConstraint *right = nil;
    if (@available(iOS 11.0, *)) {
        right = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view.safeAreaLayoutGuide attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    } else {
        right = [NSLayoutConstraint constraintWithItem:self.textView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    }
    [self.view addConstraint:right];
    
    [self createTextViewText];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self createNavigation];
}

- (void)createNavigation {
    UIBarButtonItem *actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(eventActionBarButtonItemClick:)];
    self.navigationItem.rightBarButtonItem = actionBarButtonItem;
    
}

- (void)eventActionBarButtonItemClick:(UIButton *)button {
    
    NSURL *url = [NSURL URLWithString:self.message.title];
    
    NSString *path = url.relativePath;
    
    NSDateFormatter *timeDateFormatter = [NSDateFormatter new];
    [timeDateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    timeDateFormatter.timeZone = [NSTimeZone systemTimeZone];
    
    NSString *createTime = [timeDateFormatter stringFromDate:self.message.createTime];
    
    NSString *logFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@+%@.txt",[[path substringWithRange:NSMakeRange(1, path.length-1)]  stringByReplacingOccurrencesOfString:@"/" withString:@"."],createTime]];
    NSError *error;
    [self.textView.text writeToFile:logFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    NSURL *logFilePathURL = [NSURL fileURLWithPath:logFilePath];
    UIActivityViewController *activityController=[[UIActivityViewController alloc]initWithActivityItems:@[logFilePathURL] applicationActivities:nil];
    [self.navigationController presentViewController:activityController animated:YES completion:nil];
}

//创建沙盒文件
- (NSURL *)exportLog:(NSData *)logData fileName:(NSString *)fileName {
 
    NSString *finalPath;
   
        //形成一个完整沙盒路径
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];

        finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:finalPath]){
        [ fileManager removeItemAtPath:finalPath error:NULL];
    }
    
    
    

    
    [fileManager createFileAtPath:finalPath contents:nil attributes:nil];
    
    NSFileHandle * fileHandle = [NSFileHandle fileHandleForWritingAtPath:finalPath];
    [fileHandle seekToEndOfFile];
    
  [fileHandle writeData:logData];
    //写入标题
//    [fileHandle writeData:[self.title dataUsingEncoding:NSUTF8StringEncoding]];
    
        
    [fileHandle closeFile];
    
   
 
    return [ NSURL fileURLWithPath:finalPath];
}

- (void)createTextViewText {
    
    self.mainTitleColor = [UIColor ct_colorWithHexString:@"#333333"];
    self.subtitleColor = [UIColor ct_colorWithHexString:@"#323333"];
    self.textColor = [UIColor ct_colorWithHexString:@"#323333"];
    self.descriptionColor = [UIColor ct_colorWithHexString:@"#8F8F8F"];
    
    self.mainTitleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:25];
    self.subtitleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    self.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    self.descriptionFont = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    
    [self processMainTitle];
    [self processTextSubtitle];
    [self processTextDescription];
    [self processTextContent];
    [self processTextRemark];
    [self.textView setAttributedText:self.logAttributedText];
    self.textView.contentOffset = CGPointMake(0, 0);
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)] ;
    
    self.navigationItem.rightBarButtonItem = done;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    self.navigationItem.rightBarButtonItem = nil;
    
}

- (void)leaveEditMode {
    
    [self.textView resignFirstResponder];
    
}

- (void)processMainTitle {
    
    //主标题
    NSMutableAttributedString *tipText = [[NSMutableAttributedString alloc] initWithString:@"Log Detail\n"];
    NSRange tipTextRange = NSMakeRange(0, tipText.length);
    [tipText addAttribute:NSParagraphStyleAttributeName value:self.mainTitleParagraphStyle range:tipTextRange];
    [tipText addAttribute:NSForegroundColorAttributeName value:self.mainTitleColor range:tipTextRange];
    [tipText addAttribute:NSFontAttributeName value:self.mainTitleFont range:tipTextRange];
    [self.logAttributedText appendAttributedString:tipText];
    
    NSString *typeText = [NSString stringWithFormat:@"Log Type:%3ld\n",(long)self.message.type];
    NSMutableAttributedString *text7 = [[NSMutableAttributedString alloc] initWithString:typeText];
    NSRange text7Range = NSMakeRange(0, text7.length);
    [text7 addAttribute:NSParagraphStyleAttributeName value:self.descriptionParagraphStyle range:text7Range];
    [text7 addAttribute:NSForegroundColorAttributeName value:self.descriptionColor range:text7Range];
    [text7 addAttribute:NSFontAttributeName value:self.descriptionFont range:text7Range];
    [self.logAttributedText appendAttributedString:text7];
    
    NSString *createTimeText = [NSString stringWithFormat:@"CreateTime:%@\n",[self.timeDateFormatter stringFromDate:self.message.createTime]];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:createTimeText];
    NSRange textRange = NSMakeRange(0, text.length);
    [text addAttribute:NSParagraphStyleAttributeName value:self.descriptionParagraphStyle range:textRange];
    [text addAttribute:NSForegroundColorAttributeName value:self.descriptionColor range:textRange];
    [text addAttribute:NSFontAttributeName value:self.descriptionFont range:textRange];
    [self.logAttributedText appendAttributedString:text];
    
    NSString *modifiedTimeText = [NSString stringWithFormat:@"ModifiedTime:%@\n",[self.timeDateFormatter stringFromDate:self.message.modifiedTime]];
    NSMutableAttributedString *text2 = [[NSMutableAttributedString alloc] initWithString:modifiedTimeText];
    NSRange text2Range = NSMakeRange(0, text2.length);
    [text2 addAttribute:NSParagraphStyleAttributeName value:self.descriptionParagraphStyle range:text2Range];
    [text2 addAttribute:NSForegroundColorAttributeName value:self.descriptionColor range:text2Range];
    [text2 addAttribute:NSFontAttributeName value:self.descriptionFont range:text2Range];
    [self.logAttributedText appendAttributedString:text2];
    
    NSTimeInterval duration = [self.message.modifiedTime timeIntervalSinceDate:self.message.createTime];
    NSString *durationText = [NSString stringWithFormat:@"Duration:%.0fs（参考值）\n",duration];
    NSMutableAttributedString *durationAttributedString = [[NSMutableAttributedString alloc] initWithString:durationText];
    NSRange durationAttributedStringRange = NSMakeRange(0, durationAttributedString.length);
    [durationAttributedString addAttribute:NSParagraphStyleAttributeName value:self.descriptionParagraphStyle range:durationAttributedStringRange];
    [durationAttributedString addAttribute:NSForegroundColorAttributeName value:self.descriptionColor range:durationAttributedStringRange];
    [durationAttributedString addAttribute:NSFontAttributeName value:self.descriptionFont range:durationAttributedStringRange];
    [self.logAttributedText appendAttributedString:durationAttributedString];
    
    // app版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *appVersionText = [NSString stringWithFormat:@"Current App Version:%@\n",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    NSMutableAttributedString *text3 = [[NSMutableAttributedString alloc] initWithString:appVersionText];
    NSRange text3Range = NSMakeRange(0, text3.length);
    [text3 addAttribute:NSParagraphStyleAttributeName value:self.descriptionParagraphStyle range:text3Range];
    [text3 addAttribute:NSForegroundColorAttributeName value:self.descriptionColor range:text3Range];
    [text3 addAttribute:NSFontAttributeName value:self.descriptionFont range:text3Range];
    [self.logAttributedText appendAttributedString:text3];
    
    NSString *appBuildText = [NSString stringWithFormat:@"Current App Build:%@\n",[infoDictionary objectForKey:@"CFBundleVersion"]];
    NSMutableAttributedString *text4 = [[NSMutableAttributedString alloc] initWithString:appBuildText];
    NSRange text4Range = NSMakeRange(0, text4.length);
    [text4 addAttribute:NSParagraphStyleAttributeName value:self.descriptionParagraphStyle range:text4Range];
    [text4 addAttribute:NSForegroundColorAttributeName value:self.descriptionColor range:text4Range];
    [text4 addAttribute:NSFontAttributeName value:self.descriptionFont range:text4Range];
    [self.logAttributedText appendAttributedString:text4];
    
    NSString *logAppVersionText = [NSString stringWithFormat:@"Log App Version:%@\n",self.message.appVersion];
    NSMutableAttributedString *text5 = [[NSMutableAttributedString alloc] initWithString:logAppVersionText];
    NSRange text5Range = NSMakeRange(0, text5.length);
    [text5 addAttribute:NSParagraphStyleAttributeName value:self.descriptionParagraphStyle range:text5Range];
    [text5 addAttribute:NSForegroundColorAttributeName value:self.descriptionColor range:text5Range];
    [text5 addAttribute:NSFontAttributeName value:self.descriptionFont range:text5Range];
    [self.logAttributedText appendAttributedString:text5];
    
    NSString *logAppBuildText = [NSString stringWithFormat:@"Log App Build:%@\n",self.message.appBuild];
    NSMutableAttributedString *text6 = [[NSMutableAttributedString alloc] initWithString:logAppBuildText];
    NSRange text6Range = NSMakeRange(0, text6.length);
    [text6 addAttribute:NSParagraphStyleAttributeName value:self.descriptionParagraphStyle range:text6Range];
    [text6 addAttribute:NSForegroundColorAttributeName value:self.descriptionColor range:text6Range];
    [text6 addAttribute:NSFontAttributeName value:self.descriptionFont range:text6Range];
    [self.logAttributedText appendAttributedString:text6];
    
    
}

- (void)processTextSubtitle {
    //标题
    NSMutableAttributedString *tipText = [[NSMutableAttributedString alloc] initWithString:@"Subtitle\n"];
    NSRange tipTextRange = NSMakeRange(0, tipText.length);
    [tipText addAttribute:NSParagraphStyleAttributeName value:self.subtitleParagraphStyle range:tipTextRange];
    [tipText addAttribute:NSForegroundColorAttributeName value:self.subtitleColor range:tipTextRange];
    [tipText addAttribute:NSFontAttributeName value:self.subtitleFont range:tipTextRange];
    [self.logAttributedText appendAttributedString:tipText];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",self.message.title]];
    NSRange textRange = NSMakeRange(0, text.length);
    [text addAttribute:NSParagraphStyleAttributeName value:self.mainTitleParagraphStyle range:textRange];
    [text addAttribute:NSForegroundColorAttributeName value:self.subtitleColor range:textRange];
    [text addAttribute:NSFontAttributeName value:self.subtitleFont range:textRange];
    [self.logAttributedText appendAttributedString:text];
}

- (void)processTextDescription {
    //描述
    NSMutableAttributedString *tipText = [[NSMutableAttributedString alloc] initWithString:@"Description\n"];
    NSRange tipTextRange = NSMakeRange(0, tipText.length);
    [tipText addAttribute:NSParagraphStyleAttributeName value:self.subtitleParagraphStyle range:tipTextRange];
    [tipText addAttribute:NSForegroundColorAttributeName value:self.subtitleColor range:tipTextRange];
    [tipText addAttribute:NSFontAttributeName value:self.subtitleFont range:tipTextRange];
    [self.logAttributedText appendAttributedString:tipText];
    NSMutableString *responseString = [NSMutableString string];
    if (self.message.desc) {
        [responseString setString:self.message.desc];
        NSString *character = nil;
        for (int i = 0; i < responseString.length; i ++) {
            character = [responseString substringWithRange:NSMakeRange(i, 1)];
            if ([character isEqualToString:@"\\"])
                [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
        }
    }
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",responseString]];
    NSRange textRange = NSMakeRange(0, text.length);
    [text addAttribute:NSParagraphStyleAttributeName value:self.textParagraphStyle range:textRange];
    [text addAttribute:NSForegroundColorAttributeName value:self.descriptionColor range:textRange];
    [text addAttribute:NSFontAttributeName value:self.descriptionFont range:textRange];
    [self.logAttributedText appendAttributedString:text];
}

- (void)processTextContent {
    //内容
    NSMutableAttributedString *tipText = [[NSMutableAttributedString alloc] initWithString:@"Content\n"];
    NSRange tipTextRange = NSMakeRange(0, tipText.length);
    [tipText addAttribute:NSParagraphStyleAttributeName value:self.subtitleParagraphStyle range:tipTextRange];
    [tipText addAttribute:NSForegroundColorAttributeName value:self.subtitleColor range:tipTextRange];
    [tipText addAttribute:NSFontAttributeName value:self.subtitleFont range:tipTextRange];
    [self.logAttributedText appendAttributedString:tipText];
    
    NSMutableString *responseString = [NSMutableString string];
    if (self.message.content) {
        [responseString setString:self.message.content];
        NSString *character = nil;
        for (int i = 0; i < responseString.length; i ++) {
            character = [responseString substringWithRange:NSMakeRange(i, 1)];
            if ([character isEqualToString:@"\\"])
                [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
        }
    }
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",responseString]];
    NSRange textRange = NSMakeRange(0, text.length);
    [text addAttribute:NSParagraphStyleAttributeName value:self.textParagraphStyle range:textRange];
    [text addAttribute:NSForegroundColorAttributeName value:self.textColor range:textRange];
    [text addAttribute:NSFontAttributeName value:self.textFont range:textRange];
    [self.logAttributedText appendAttributedString:text];
}

- (void)processTextRemark {
    //备注
    NSMutableAttributedString *tipText = [[NSMutableAttributedString alloc] initWithString:@"Remark\n"];
    NSRange tipTextRange = NSMakeRange(0, tipText.length);
    [tipText addAttribute:NSParagraphStyleAttributeName value:self.subtitleParagraphStyle range:tipTextRange];
    [tipText addAttribute:NSForegroundColorAttributeName value:self.subtitleColor range:tipTextRange];
    [tipText addAttribute:NSFontAttributeName value:self.subtitleFont range:tipTextRange];
    [self.logAttributedText appendAttributedString:tipText];
    
    NSMutableString *responseString = [NSMutableString string];
    if (self.message.remark) {
        [responseString setString:self.message.remark];
        NSString *character = nil;
        for (int i = 0; i < responseString.length; i ++) {
            character = [responseString substringWithRange:NSMakeRange(i, 1)];
            if ([character isEqualToString:@"\\"])
                [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
        }
    }
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",self.message.remark]];
    NSRange textRange = NSMakeRange(0, text.length);
    [text addAttribute:NSParagraphStyleAttributeName value:self.textParagraphStyle range:textRange];
    [text addAttribute:NSForegroundColorAttributeName value:self.descriptionColor range:textRange];
    [text addAttribute:NSFontAttributeName value:self.descriptionFont range:textRange];
    [self.logAttributedText appendAttributedString:text];
}

- (NSMutableParagraphStyle *)mainTitleParagraphStyle {
    if (!_mainTitleParagraphStyle) {
        NSMutableParagraphStyle *mainTitleParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        mainTitleParagraphStyle.lineSpacing = 6;
        mainTitleParagraphStyle.alignment = NSTextAlignmentCenter;
        _mainTitleParagraphStyle = mainTitleParagraphStyle;
    }
    return _mainTitleParagraphStyle;
}

- (NSMutableParagraphStyle *)descriptionParagraphStyle {
    if (!_descriptionParagraphStyle) {
        NSMutableParagraphStyle *descriptionParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        descriptionParagraphStyle.paragraphSpacing = 2;
        descriptionParagraphStyle.lineSpacing = 6;
        descriptionParagraphStyle.alignment = NSTextAlignmentRight;
        descriptionParagraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        _descriptionParagraphStyle = descriptionParagraphStyle;
    }
    return _descriptionParagraphStyle;
}


- (NSMutableParagraphStyle *)subtitleParagraphStyle {
    if (!_subtitleParagraphStyle) {
        NSMutableParagraphStyle *subtitleParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        subtitleParagraphStyle.lineSpacing = 6;
        _subtitleParagraphStyle = subtitleParagraphStyle;
    }
    return _subtitleParagraphStyle;
}

- (NSMutableParagraphStyle *)textParagraphStyle {
    if (!_textParagraphStyle) {
        NSMutableParagraphStyle *textParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        textParagraphStyle.firstLineHeadIndent = 20;
        textParagraphStyle.paragraphSpacing = 2;
        textParagraphStyle.lineSpacing = 1;
        textParagraphStyle.alignment = NSTextAlignmentLeft;
        textParagraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        _textParagraphStyle = textParagraphStyle;
    }
    return _textParagraphStyle;
}

- (NSMutableAttributedString *)logAttributedText {
    if (!_logAttributedText) {
        NSMutableAttributedString *logAttributedText = [[NSMutableAttributedString alloc] init];
        _logAttributedText = logAttributedText;
    }
    return _logAttributedText;
}

- (NSDateFormatter *)timeDateFormatter {
    if (!_timeDateFormatter) {
        NSDateFormatter *timeDateFormatter = [NSDateFormatter new];
        [timeDateFormatter setDateFormat:@"YYYY-MM-dd EEEE HH:mm:ss.sss z"];
        timeDateFormatter.timeZone = [NSTimeZone systemTimeZone];
        _timeDateFormatter = timeDateFormatter;
    }
    return _timeDateFormatter;
}


- (UITextView *)textView {
    if (!_textView) {
        UITextView *textView = [UITextView new];
        textView.translatesAutoresizingMaskIntoConstraints = NO;
        textView.delegate = self;
        textView.editable = NO;
        textView.contentInset = UIEdgeInsetsMake(0, 15., 0, 15.);
        _textView = textView;
    }
    return _textView;
}

@end
