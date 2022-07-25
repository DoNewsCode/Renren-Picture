//
//  DRPICPicturePickerCameraCollectionViewCell.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/10.
//

#import "DRPICPicturePickerCameraCollectionViewCell.h"
#import "UIView+CTLayout.h"
#import "UIImage+RenrenPicture.h"
#import "UIColor+CTHex.h"

@implementation DRPICPicturePickerCameraCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor ct_colorWithHexString:@"#F1F1F1"];
        [self createContent];
    }
    return self;
}

- (void)createContent {
    [self.contentView addSubview:self.cameraImageView];
    self.cameraImageView.center = self.contentView.center;
}

- (UIImageView *)cameraImageView{
    if (!_cameraImageView) {
        _cameraImageView = [[UIImageView alloc] initWithImage:[UIImage ct_imageRenrenPictureUIWithNamed:@"view_image_camera_default"]];
        _cameraImageView.contentMode = UIViewContentModeCenter;
    }
    return _cameraImageView;
}



@end
