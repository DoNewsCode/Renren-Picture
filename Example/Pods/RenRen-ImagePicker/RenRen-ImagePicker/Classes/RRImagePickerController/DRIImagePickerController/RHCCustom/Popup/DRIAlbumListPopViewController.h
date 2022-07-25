//
//  DRIAlbumListPopViewController.h
//  RenrenOfficial-iOS-Concept
//
//  Created by 张健康 on 2019/3/16.
//  Copyright © 2019 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    kNoneVisible = -2, //没有下发状态
    kSelfVisible = -1, //仅自己可见
    kFriendVisible = 0, //好友可见
    kFriendVisibleWhenCreate = 1,//photos.createAlbum时的好友可见
    kCityVisible = 3, //同城可见
    kPassWordVisible = 4, //密码可见
    kCustomVisible = 7, //自定义隐私
    kAllVisible = 99 //所有人可见
}kAlbumVisibleState;

@class DRIAlbumModel;
@protocol DRIAlbumListPopViewDelegate <NSObject>
- (void)albumListDismissed;
- (void)didSelectAlbum:(DRIAlbumModel *)album;
@end

@interface DRIAlbumListPopViewController: UIViewController

@property (nonatomic, strong) DRIAlbumModel *model;
@property (nonatomic, weak) id<DRIAlbumListPopViewDelegate> delegate;

- (void)showAlbumListInView:(UIView *)view fromRect:(CGRect)fromRect animated:(BOOL)animated;
- (void)dismissAlbumList:(BOOL)animated;
- (void)loadData;
- (void)loadLocalData;

@end

