//
//  DRLLogBrowseViewController.h
//  Renren-Library
//
//  Created by 陈金铭 on 2019/8/10.
//  Log浏览控制器

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRLLogBrowseViewController : UIViewController

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, assign) BOOL master;

@end

NS_ASSUME_NONNULL_END
