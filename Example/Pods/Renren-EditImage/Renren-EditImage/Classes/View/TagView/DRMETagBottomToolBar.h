//
//  DRMETagBottomToolBar.h
//

#import <UIKit/UIKit.h>
#import "DRMETagCommentTextField.h"

@protocol DRMETagBottomToolBarDelegate <NSObject>

@optional
- (void)bottomToolBarPublishAction:(NSString *)text;
- (void)bottomToolBarKeyboardWillShow:(NSDictionary *)keyboardInfo;
- (void)bottomToolBarKeyboardWillHide:(NSDictionary *)keyboardInfo;

@end
@interface DRMETagBottomToolBar : UIView

- (void)loadTagInputBottomBar;
@property (nonatomic, strong) DRMETagCommentTextField         *inputText;
@property (nonatomic, weak) id <DRMETagBottomToolBarDelegate> delegate;

@end
