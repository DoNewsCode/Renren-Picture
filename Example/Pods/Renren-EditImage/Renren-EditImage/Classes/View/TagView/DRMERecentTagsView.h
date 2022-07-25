

#import <UIKit/UIKit.h>
@class DRMETagModel;

typedef void(^LabelHeightBlock)(CGFloat height);
typedef void(^ClickRecentTag)(DRMETagModel *model);

@interface DRMERecentTagsView : UIView


- (void)setTagsArray:(NSArray <DRMETagModel *>*)tagsArray labelHeightBlock:(LabelHeightBlock)labelHeightBlock;

@property(nonatomic,copy) ClickRecentTag clickRecentTag;


@end
