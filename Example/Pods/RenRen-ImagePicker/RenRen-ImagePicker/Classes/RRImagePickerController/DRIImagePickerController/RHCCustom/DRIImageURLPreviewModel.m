//
//  DRIImageURLPreviewModel.m
//  RenRen-ImagePicker
//
//  Created by 张健康 on 2019/8/19.
//

#import "DRIImageURLPreviewModel.h"

@implementation DRIImageURLPreviewModel
- (UIImage *)image{
    if (!_image) {
        return _imageView.image;
    }
    return _image;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.image = _image;
    }
    return _imageView;
}
@end
