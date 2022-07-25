//
//  DRPICPicturePreviewChannelCollectionViewCell.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/20.
//

#import "DRPICPicturePreviewChannelCollectionViewCell.h"

#import "UIView+CTLayout.h"
#import "UIImage+RenrenPicture.h"
#import "UIColor+CTHex.h"
#import <Photos/Photos.h>

@implementation DRPICPicturePreviewChannelCollectionViewCell
#pragma mark - Override Methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.previewIamgeView.frame = self.contentView.bounds;
}

#pragma mark - Intial Methods
- (void)initialize {
    [self createContent];
}

#pragma mark - Create Methods
- (void)createContent {
    self.contentView.layer.borderColor = [UIColor ct_colorWithHexString:@"#2A73EB"].CGColor;
    [self.contentView addSubview:self.previewIamgeView];
    self.backgroundColor = [UIColor blueColor];
}

- (void)cteateImage {
    CGFloat imageWidth = self.contentView.ct_width * 3;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    //设置为同步, 只会返回1张图片
    options.synchronous = NO;
    __weak typeof(self) weakSelf = self;
    [[PHCachingImageManager defaultManager]requestImageForAsset:self.picture.source.asset targetSize:CGSizeMake(imageWidth, imageWidth) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        weakSelf.previewIamgeView.image = result;
    }];
}

#pragma mark - Process Methods

#pragma mark - Event Methods

#pragma mark - Public Methods

#pragma mark - Setter And Getter Methods
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.contentView.layer.borderWidth = 3;
    } else {
        self.contentView.layer.borderWidth = 0;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (animated == NO) {
        self.selected = selected;
        return;
    }
    [UIView animateWithDuration:0.618 animations:^{
        self.selected = selected;
    }];
}

- (void)setPicture:(DRPICPicture *)picture {
    _picture = picture;
    [self cteateImage];
    
}

- (UIImageView *)previewIamgeView {
    if (!_previewIamgeView) {
        UIImageView *previewIamgeView = [UIImageView new];
        previewIamgeView.contentMode = UIViewContentModeScaleAspectFill;
        previewIamgeView.layer.masksToBounds = YES;
        _previewIamgeView = previewIamgeView;
    }
    return _previewIamgeView;
}

@end
