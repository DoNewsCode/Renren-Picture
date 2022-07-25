//
//  DRPICPicturePreviewChannelViewController.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/17.
//

#import <UIKit/UIKit.h>

#import "DRPICPicturePreviewChannelViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class DRPICPicturePreviewChannelViewController;
@protocol DRPICPicturePreviewChannelViewControllerDelegate <NSObject>

- (void)channelViewController:(DRPICPicturePreviewChannelViewController *_Nullable)channelViewController didSelectChannelAtIndex:(NSInteger)index picture:(DRPICPicture *_Nullable)picture;

@end

@interface DRPICPicturePreviewChannelViewController : UIViewController

@property (nonatomic, weak) id<DRPICPicturePreviewChannelViewControllerDelegate> delegate;
@property (nonatomic, strong) UIBlurEffect *blurEffect;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (nonatomic, strong) DRPICPicturePreviewChannelViewModel *viewModel;

@property (nonatomic, strong) NSIndexPath *currentIndexPath;

- (void)processChannelItemSelectedWithIndexPath:(NSIndexPath *)indexPath selected:(BOOL)selected;


- (void)processChannelItemSelectedWithPicture:(DRPICPicture *)picture selected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
