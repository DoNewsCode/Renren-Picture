//
//  DRIImageTagBottomToolBar.h
//  RenRen-ImagePicker
//
//  Created by 张健康 on 2019/7/2.
//

#import <UIKit/UIKit.h>
@class DRIImageTagCommentTextField;
@protocol DRIImageTagBottomToolBarDelegate <NSObject>

- (void)bottomToolBarPublishAction:(NSString *)text;
- (void)bottomToolBarKeyboardWillShow:(NSDictionary *)keyboardInfo;
- (void)bottomToolBarKeyboardWillHide:(NSDictionary *)keyboardInfo;

@end
@interface DRIImageTagBottomToolBar : UIView
- (void)loadTagInputBottomBar;
@property (nonatomic, strong) DRIImageTagCommentTextField         *inputText;
@property (nonatomic, weak) id <DRIImageTagBottomToolBarDelegate> delegate;
@end
