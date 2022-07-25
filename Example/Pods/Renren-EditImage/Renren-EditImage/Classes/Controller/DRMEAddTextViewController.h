//
//  DRMEAddTextViewController.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickDoneBlock)(NSString *text,
                              UIFont *font,
                              UIColor *textColor,
                              UIColor *textBgColor,
                              UITextView *textView,
                              NSString *currentTextColorStr,
                              BOOL isChooseBackColor);



@interface DRMEAddTextViewController : UIViewController

@property(nonatomic,copy) ClickDoneBlock clickDoneBlock;

@property(nonatomic,copy) NSString *lastText;

@property(nonatomic,weak) UITextView *textView;


/// 当前文字的颜色
@property(nonatomic,copy) NSString *currentTextColorStr;

/// 是否选中了 T 按钮，
@property(nonatomic,assign, getter=isChooseBackColor) BOOL chooseBackColor;

@end

NS_ASSUME_NONNULL_END
