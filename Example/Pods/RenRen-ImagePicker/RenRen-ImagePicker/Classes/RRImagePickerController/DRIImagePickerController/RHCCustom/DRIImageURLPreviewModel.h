//
//  DRIImageURLPreviewModel.h
//  RenRen-ImagePicker
//
//  Created by 张健康 on 2019/8/19.
//

#import <Foundation/Foundation.h>
#import "UIImage+Tags.h"
NS_ASSUME_NONNULL_BEGIN

@interface DRIImageURLPreviewModel : NSObject
@property (copy, nonatomic) NSString *urlStr;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;
@end

NS_ASSUME_NONNULL_END
