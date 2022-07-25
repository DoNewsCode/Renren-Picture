//
//  DRPICPicturePIckerSelectButton.h
//  Renren-Picture
//
//  Created by Ming on 2020/3/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRPICPicturePIckerSelectButton : UIControl

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
