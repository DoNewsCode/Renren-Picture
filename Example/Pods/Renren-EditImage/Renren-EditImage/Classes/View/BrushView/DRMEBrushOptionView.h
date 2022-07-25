//
//  DRMEBrushOptionView.h
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/4/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRMEBrushModel : NSObject

@property(nonatomic,strong) UIColor *color;
@property(nonatomic,assign,getter=isSelected) BOOL selected;

@property(nonatomic,assign) BOOL isBlackColor;

@end

@interface DRMEBrushColorCell : UICollectionViewCell


+ (instancetype)brushColorCellWith:(UICollectionView *)collectionView
                         indexPath:(NSIndexPath *)indexPath;
@property(nonatomic,strong) DRMEBrushModel *brushModel;
@property(nonatomic,strong) UIView *colorView;

@end

@class DRMEBrushOptionView;

@protocol DRMEBrushOptionViewDelegate <NSObject>

@optional
- (void)brushOptionView:(DRMEBrushOptionView *)brushOptionView
     didClickBrushModel:(DRMEBrushModel *)brushModel;

@end

@interface DRMEBrushOptionView : UIView

@property (nullable, nonatomic, copy) void (^resetButtonButtonTapped)(void);
@property (nullable, nonatomic, copy) void (^sureButtonButtonTapped)(void);
@property (nullable, nonatomic, copy) void (^cancelButtonButtonTapped)(void);

@property(nonatomic,weak) id<DRMEBrushOptionViewDelegate> delegate;

@property(nonatomic,weak) UIButton *resetBtn;

@end

NS_ASSUME_NONNULL_END
