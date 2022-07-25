//
//  DRIPhototPreviewToolsView.h
//  RenRen-ImagePicker
//
//  Created by leejiaolong on 2020/3/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DRIAssetModel;

typedef void(^PreviewToolsViewBloack)(NSInteger tapItemIndex,DRIAssetModel* tapModel);

@interface DRIPhototPreviewToolsView : UIView
@property(nonatomic,copy)PreviewToolsViewBloack myBlock;
-(void)updateWithModels:(NSMutableArray<DRIAssetModel *> *)selectedModels currentIndex:(NSInteger)currentInde;
-(void)didTapItemAtIndex:(PreviewToolsViewBloack)block;
@end

@interface DRIPhototPreviewToolsItemView : UIView
@property(nonatomic,strong)UIButton *actionButton;
+(id)creatWithDRIAssetModel:(DRIAssetModel*)model;
@property (nonatomic, strong) DRIAssetModel *model;
-(void)setSelectedStyle;
@end


NS_ASSUME_NONNULL_END
