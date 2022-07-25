//
//  DRPICPicturePreviewViewController.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/17.
//

#import "DRBBaseViewController.h"

#import "DRPICPicturePreviewViewModel.h"

#import "DRPICPicturePIckerSelectButton.h"

NS_ASSUME_NONNULL_BEGIN

@class DRPICPicturePreviewViewController;
@protocol DRPICPicturePreviewViewControllerDelegate <NSObject>

- (void)picturePreviewViewController:(DRPICPicturePreviewViewController *_Nullable)picturePreviewViewController selectForPicture:(DRPICPicture *_Nullable)picture selected:(BOOL)selected;

- (void)picturePreviewViewControllerForEventTouchUpInsideForLevitateViewNextStepButton:(DRPICPicturePreviewViewController *_Nullable)picturePreviewViewController;

@end


@interface DRPICPicturePreviewViewController : DRBBaseViewController

@property (nonatomic, weak) id<DRPICPicturePreviewViewControllerDelegate> delegate;
@property (nonatomic, strong) DRPICPicturePreviewViewModel *viewModel;
@property (nonatomic, strong) DRPICPicturePIckerSelectButton *selectButton;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewFlowLayout;



@end

NS_ASSUME_NONNULL_END
