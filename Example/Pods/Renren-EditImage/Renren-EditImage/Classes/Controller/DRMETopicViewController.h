//
//  DRMETopicViewController.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/11/20.
//

#import <UIKit/UIKit.h>
@class DRMETagModel;

NS_ASSUME_NONNULL_BEGIN

@interface DRMETopicViewController : UIViewController

@property(nonatomic,copy) void(^selectedTopicBlock)(DRMETagModel *tagModel);

@end

NS_ASSUME_NONNULL_END
