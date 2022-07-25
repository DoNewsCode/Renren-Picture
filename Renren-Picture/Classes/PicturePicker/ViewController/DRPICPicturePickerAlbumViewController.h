//
//  DRPICPicturePickerAlbumViewController.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/10.
//

#import <UIKit/UIKit.h>

#import "DRPICPicturePickerViewModel.h"

@class DRPICPicturePickerAlbumViewController;
@protocol DRPICPicturePickerAlbumViewControllerDelegate <NSObject>

- (void)albumViewController:(DRPICPicturePickerAlbumViewController *_Nullable)albumViewController didSelectAlbumAtIndex:(NSInteger)index album:(DRPICAlbum *_Nullable)album;

@end

NS_ASSUME_NONNULL_BEGIN

@interface DRPICPicturePickerAlbumViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) DRPICPicturePickerViewModel *viewModel;
@property (nonatomic, weak) id<DRPICPicturePickerAlbumViewControllerDelegate> delegate;
/// 展开
@property (nonatomic, getter=isExpand) BOOL expand;
@property (nonatomic, assign) CGFloat stowedViewHeight;
@property (nonatomic, assign) CGFloat expandViewHeight;

- (void)createContent;
- (void)processViewExpand:(BOOL)expand;

@end

NS_ASSUME_NONNULL_END
