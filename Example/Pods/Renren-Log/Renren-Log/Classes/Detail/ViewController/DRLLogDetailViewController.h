//
//  DRLLogDetailViewController.h
//  Renren-Library
//
//  Created by 陈金铭 on 2019/8/10.
//

#import <UIKit/UIKit.h>

#import "DRLLogMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRLLogDetailViewController : UIViewController

@property(nonatomic, strong) DRLLogMessage *message;
@end

NS_ASSUME_NONNULL_END
