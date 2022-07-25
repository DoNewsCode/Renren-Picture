//
//  DRPICPicturePickerAlbumTableHeaderView.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPICPicturePickerAlbumTableHeaderView : UIView

/// 展开
@property (nonatomic, getter=isExpand) BOOL expand;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
