//
//  DRPICImagePickerTopBar.m
//  Renren-Picture
//
//  Created by Luis on 2020/3/5.
//

#import "DRPICImagePickerTopBar.h"
#import "DNBaseMacro.h"
#import "UIColor+CTHex.h"
#import "UIImage+RenrenPicture.h"

@implementation DRPICImagePickerTopBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}
- (void)setup{
    [self addSubview:self.albumTitleBtn];
    [self addSubview:self.fullImageBtn];
    self.albumTitleBtn.frame = CGRectMake(0, 0, 180, 53);
    self.fullImageBtn.frame = CGRectMake(SCREEN_WIDTH - 60 - 20, 10, 90, 20);
}
- (void)setAlbumTitle:(NSString *)albumTitle{
    _albumTitle = albumTitle;
    [self.albumTitleBtn setTitle:albumTitle forState:UIControlStateNormal];
}
- (UIButton *)albumTitleBtn{
    if (!_albumTitleBtn) {
        _albumTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_albumTitleBtn setTitleColor:[UIColor ct_colorWithHexString:@"#323232"] forState:UIControlStateNormal];
        [_albumTitleBtn setImage:[UIImage ct_imageRenrenPictureUIWithNamed:@"view_image_photo_select_down"] forState:UIControlStateNormal];
        [_albumTitleBtn setImage:[UIImage ct_imageRenrenPictureUIWithNamed:@"view_image_photo_select_up"] forState:UIControlStateSelected];
        _albumTitleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:27.6];
        _albumTitleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10.f);
        [_albumTitleBtn addTarget:self action:@selector(showAlbumAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _albumTitleBtn;
}
- (UIButton *)fullImageBtn{
    if (!_fullImageBtn) {
        _fullImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullImageBtn setTitle:@"原图" forState:UIControlStateNormal];
        [_fullImageBtn setTitle:@"已选原图" forState:UIControlStateSelected];
        [_fullImageBtn setSelected:NO];
        [_fullImageBtn addTarget:self action:@selector(fullImageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _fullImageBtn.backgroundColor = [UIColor redColor];
    }
    return _fullImageBtn;
}
- (void)showAlbumAction:(UIButton *)sender{
    if (self.albumTitleBtnClickBlock) {
        self.albumTitleBtnClickBlock(sender);
    }
}
- (void)fullImageBtnAction:(UIButton *)sender{
    if (self.fullImageBtnClickBlock) {
        self.fullImageBtnClickBlock(sender);
    }
}

@end
