


@class DRMEStickerLabelView;

@class DRMECropViewController;

@protocol DRMECropViewControllerDelegate <NSObject>

@optional
- (void)cropViewController:(nonnull DRMECropViewController *)cropViewController
            didCropToImage:(nonnull UIImage *)image
                  withRect:(CGRect)cropRect
                     angle:(NSInteger)angle;

/// centerXDistance
/// centerYDistance
- (void)cropViewController:(nonnull DRMECropViewController *)cropViewController
            didCropToImage:(nonnull UIImage *)image
           centerXDistance:(CGFloat)centerXDistance
           centerYDistance:(CGFloat)centerYDistance
                  cropSize:(CGSize)cropSize;

- (void)cropViewControllerDidCancelCrop:(nonnull DRMECropViewController *)cropViewController;

@end


@interface DRMECropViewController : UIViewController


- (nonnull instancetype)initWithImage:(nonnull UIImage *)image;

@property (nullable, nonatomic, weak) id<DRMECropViewControllerDelegate> delegate;


@property(nonatomic,strong) NSMutableArray<DRMEStickerLabelView*> * _Nullable labelArray;

/// 4.14 不需要记录上次裁剪的效果了，图片越裁剪越小
//@property (nonatomic, assign) CGRect imageCropFrame;
//@property (nonatomic, assign) NSInteger angle;

@end
