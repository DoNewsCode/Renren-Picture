//
//  DRBTabbar.h
//  Renren-BaseKit
//
//  Created by 陈金铭 on 2019/7/24.
//

#import "DRBBaseView.h"

#import "DRBTabbarItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DRBTabbarDelegate;
@interface DRBTabbar : DRBBaseView

@property(nonatomic, strong) NSMutableArray<DRBTabbarItem *> *tabbarItems;

/** 若不采用默认布局请将此属性置为 YES ；默认：NO； */
@property(nonatomic, assign) BOOL customLayout;

@property(nonatomic, weak) id<DRBTabbarDelegate> delegate;

@end


@protocol DRBTabbarDelegate<NSObject>
@optional

- (void)customTabBar:(DRBTabbar *)tabBar didSelectItem:(DRBTabbarItem *)item; // called when a new view is selected by the user (but not programatically)


@end


NS_ASSUME_NONNULL_END
