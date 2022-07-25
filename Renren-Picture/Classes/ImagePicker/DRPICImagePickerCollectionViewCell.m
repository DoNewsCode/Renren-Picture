//
//  DRPICImagePickerCollectionViewCell.m
//  Renren-Picture
//
//  Created by Luis on 2020/3/2.
//

#import "DRPICImagePickerCollectionViewCell.h"
#import "UIImage+RenrenPicture.h"
#import "DNBaseMacro.h"
#import "DRPICImageManager.h"

@interface DRPICImagePickerCollectionViewCell()

@property(nonatomic, strong)UIImageView *photoImageView;
@property(nonatomic, strong)UIButton *selectButton;
@property(nonatomic, strong)UIView *translucentView;


@end

@implementation DRPICImagePickerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.photoImageView];
        [self.contentView addSubview:self.translucentView];
        [self.contentView addSubview:self.selectButton];
    }
    return self;
}
- (void)layoutSubviews{
    self.photoImageView.frame = CGRectMake(0, 0, (SCREEN_WIDTH - 2 * 3) / 4, (SCREEN_WIDTH - 2 * 3) / 4);

}
- (void)loadImage:(NSIndexPath *)indexPath{
    CGFloat imageWidth = (SCREEN_WIDTH - 2 * 3) / 4;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    //设置为同步, 只会返回1张图片
    options.synchronous = NO;
    [[PHCachingImageManager defaultManager]requestImageForAsset:self.asset targetSize:CGSizeMake(imageWidth, imageWidth) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.photoImageView.image = result;
    }];

}
- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;

    self.translucentView.hidden = !isSelected;
    [self.selectButton setBackgroundImage:isSelected ? [UIImage imageNamed:@"selectImage_select"]:nil forState:UIControlStateNormal];

    if ([DRPICImageManager sharedManager].maxCount == [DRPICImageManager sharedManager].selectedCount) {
        self.translucentView.hidden = NO;
        if (isSelected) {
            self.translucentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        }else{
            self.translucentView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
        }
    }else{
        self.translucentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }



}
- (void)selectPhoto:(UIButton *)sender{
    if (self.selectedActionBlock) {
        self.selectedActionBlock(self.asset);
    }
}
#pragma mark - Get方法
-(UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 2 * 3) / 4, (SCREEN_WIDTH - 2 * 3) / 4)];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.layer.masksToBounds = YES;
    }
    return _photoImageView;
}
- (UIButton *)selectButton{
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
     //   _selectButton.layer.borderColor = [UIColor whiteColor].CGColor;
     //   _selectButton.layer.borderWidth = 1.f;
     //   _selectButton.layer.cornerRadius = 12.5f;
     //   _selectButton.layer.masksToBounds = YES;
     //   [_selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage ct_imageRenrenPictureUIWithNamed:@"btn_image_photo_normal"] forState:UIControlStateNormal];
//        [_selectButton setBackgroundImage:[UIImage ct_imageRenrenPictureUIWithNamed:@"btn_image_photo_normal"] forState:UIControlStateNormal];
        [_selectButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [_selectButton addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
        _selectButton.frame = CGRectMake((SCREEN_WIDTH - 2 * 3) / 4 - 29 - 1, 1, 29, 29);
    }
    return _selectButton;
}
-(UIView *)translucentView {
    if (!_translucentView) {
        _translucentView = [[UIView alloc] init];
        _translucentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _translucentView.frame = CGRectMake(0, 0, (SCREEN_WIDTH - 2 * 3) / 4, (SCREEN_WIDTH - 2 * 3) / 4);
        _translucentView.hidden = YES;
    }
    return _translucentView;
}

@end

#pragma mark 拍照cell

@implementation DRPICAssetCameraCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backgroundImageView];
        [self.backgroundImageView addSubview:self.cameraImageView];

        self.cameraImageView.center = self.contentView.center;

        self.backgroundImageView.image = [UIImage ct_imageRenrenPictureUIWithNamed:@"view_image_camera_background_default"];
        self.cameraImageView.image = [UIImage ct_imageRenrenPictureUIWithNamed:@"view_image_camera_default"];
    }
    return self;
}
- (UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]init];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;

    }
    return _backgroundImageView;
}
- (UIImageView *)cameraImageView{
    if (!_cameraImageView) {
        _cameraImageView = [[UIImageView alloc]init];
        _cameraImageView.contentMode = UIViewContentModeCenter;
    }
    return _cameraImageView;
}

@end
