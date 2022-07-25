//
//  DRMEVideoTrimTableViewCell.h
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRMEVideoTrimTableViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *backgroundImageView;


- (void)setImageWithCount:(NSInteger)count imagePath:(NSString *)savePath imageHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
