//
//  DRLLogBrowse.h
//  Renren-Log
//
//  Created by 陈金铭 on 2019/12/9.
//

#import <Foundation/Foundation.h>

#import "DRLLogBrowseViewController.h"
#import "DRLLogBrowseNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRLLogBrowse : NSObject

@property(nonatomic, assign) BOOL logBrowseHidden;
@property(nonatomic, strong,readonly) UIWindow *logWindow;
@property(nonatomic, strong,readonly) DRLLogBrowseNavigationController *logBrowseNavigationController;
@property(nonatomic, strong,readonly) DRLLogBrowseViewController *logBrowseViewController;
+ (instancetype)sharedLogBrowse;

- (void)logBrowseHidden:(BOOL)hidden animation:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
