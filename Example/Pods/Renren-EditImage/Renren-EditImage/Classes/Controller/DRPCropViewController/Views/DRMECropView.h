//
//  DRMECropView.h
//

#import <UIKit/UIKit.h>
#import "DRMECropOverlayView.h"

#import "DRMEStickerLabelView.h"

@class DRMECropView;

@protocol DRMECropViewDelegate <NSObject>

- (void)cropViewDidBecomeResettable:(nonnull DRMECropView *)cropView;
- (void)cropViewDidBecomeNonResettable:(nonnull DRMECropView *)cropView;

@end


typedef NS_ENUM(NSInteger, DRMECropViewOverlayEdge) {
    DRMECropViewOverlayEdgeNone,
    DRMECropViewOverlayEdgeTopLeft,
    DRMECropViewOverlayEdgeTop,
    DRMECropViewOverlayEdgeTopRight,
    DRMECropViewOverlayEdgeRight,
    DRMECropViewOverlayEdgeBottomRight,
    DRMECropViewOverlayEdgeBottom,
    DRMECropViewOverlayEdgeBottomLeft,
    DRMECropViewOverlayEdgeLeft
};

@interface DRMECropView : UIView

- (instancetype _Nullable )initWithFrame:(CGRect)frame image:(UIImage *_Nullable)image;

- (instancetype _Nullable )initWithFrame:(CGRect)frame
                                   image:(UIImage *_Nullable)image
                              labelArray:(NSMutableArray<DRMEStickerLabelView*> *_Nullable)labelArray;

@property (nonatomic, weak) id<DRMECropViewDelegate> delegate;

@property (nonatomic, assign) CGRect imageCropFrame;
@property (nonatomic, assign) NSInteger angle;

@property (nonatomic, assign) BOOL aspectRatioLockEnabled;

- (void)resetLayoutToDefaultAnimated:(BOOL)animated;
- (void)rotateImageNinetyDegreesAnimated:(BOOL)animated;


@property(nonatomic,strong) NSMutableArray<DRMEStickerLabelView*> * _Nullable labelArray;

/// 旋转、裁剪、计算，均使用此属性
@property (nonatomic, strong) UIImage * _Nullable operationImage;

/// 获取某个label距离裁剪框的距离
- (CGSize)getLabelDistance;

@property (nonatomic, assign) CGRect cropBoxFrame;

@end
