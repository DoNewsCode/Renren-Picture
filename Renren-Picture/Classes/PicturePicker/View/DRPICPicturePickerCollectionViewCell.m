//
//  DRPICPicturePickerCollectionViewCell.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/10.
//

#import "DRPICPicturePickerCollectionViewCell.h"
#import "UIView+CTLayout.h"
#import "UIImage+RenrenPicture.h"
#import "UIColor+CTHex.h"
#import <Photos/Photos.h>

@implementation DRPICPicturePickerCollectionViewCell

#pragma mark - Override Methods

#pragma mark - Intial Methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor ct_colorWithHexString:@"#F1F1F1"];
        [self createContent];
    }
    return self;
}

- (void)createContent {
    [self.contentView addSubview:self.previewIamgeView];
    self.previewIamgeView.frame = self.contentView.bounds;
    self.coverView.frame = self.contentView.bounds;
    self.enabledCoverView.frame = self.contentView.bounds;
    [self.contentView addSubview:self.informationView];
    [self.contentView addSubview:self.coverView];
    [self.contentView addSubview:self.enabledCoverView];
    [self.contentView addSubview:self.selectButton];
    self.enabled = YES;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat selectButtonWidth = self.contentView.ct_width * 0.35;
    self.selectButton.frame = CGRectMake(self.contentView.ct_width - selectButtonWidth, 0, selectButtonWidth, selectButtonWidth);
    CGFloat informationViewWidth = self.contentView.ct_width;
    CGFloat informationViewHeight = self.contentView.ct_height * 0.2;
    self.informationView.frame = CGRectMake(0, self.contentView.ct_height - informationViewHeight, informationViewWidth, informationViewHeight);
    
}

#pragma mark - Create Methods
- (void)cteatePhAssetImage {
    if (self.picture.source.type == DRPICPictureSourceTypeEdited) {
        self.previewIamgeView.image = self.picture.source.editedImage;
        return;
    }
    CGFloat imageWidth = self.contentView.ct_width * 3;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    //设置为同步, 只会返回1张图片
    options.synchronous = NO;
    __weak typeof(self) weakSelf = self;
    [[PHCachingImageManager defaultManager]requestImageForAsset:self.picture.source.asset targetSize:CGSizeMake(imageWidth, imageWidth) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        weakSelf.previewIamgeView.image = result;
//        weakSelf.picture.source.thumbnailImage = result;
    }];
}




#pragma mark - Process Methods

#pragma mark - Event Methods
- (void)eventTouchUpInsideForSelectButton:(DRPICPicturePIckerSelectButton *)selectButton {
    if (self.selectButtonEventBlock) {
        self.selectButtonEventBlock(selectButton, self.picture);
    }
}

- (void)eventForSelectButtonEventBlock:(DRPICPicturePickerCollectionViewCellSelectButtonEventBlock)selectButtonEventBlock {
    self.selectButtonEventBlock = selectButtonEventBlock;
}

#pragma mark - Public Methods

#pragma mark - Setter And Getter Methods
- (void)setEnabled:(BOOL)enabled animated:(BOOL)animated {
    self.enabled = enabled;
    self.userInteractionEnabled = enabled;
    if (animated == NO) {
        self.selectButton.alpha = enabled;
        if (enabled) {
            self.enabledCoverView.backgroundColor = [UIColor clearColor];
        } else {
            self.enabledCoverView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
        }
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.selectButton.alpha = enabled;
        if (enabled) {
            self.enabledCoverView.backgroundColor = [UIColor clearColor];
        } else {
            self.enabledCoverView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
        }
        
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [self setSelected:selected selectedIndex:0 animated:animated];
}

- (void)setSelected:(BOOL)selected selectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    [self setSelected:selected selectedIndex:selectedIndex animated:animated completion:nil];
}

- (void)setSelected:(BOOL)selected selectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated completion:(void (^ _Nullable)(BOOL))completion {
    self.selected = selected;
    if (selectedIndex == 0) {
        self.selectButton.index = self.picture.status.selectedIndex;
    }
    
    self.selectButton.index = selectedIndex;
    [self.selectButton setSelected:selected animated:animated];
    if (animated == NO) {
        if (selected) {
            self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        } else {
            self.coverView.backgroundColor = [UIColor clearColor];
        }
        
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        if (selected) {
            self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        } else {
            self.coverView.backgroundColor = [UIColor clearColor];
        }
    }completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)setPicture:(DRPICPicture *)picture {
    _picture = picture;
    if (picture == nil) {
        return;
    }
    self.selectButton.index = picture.status.selectedIndex;
    [self setSelected:picture.status.selected selectedIndex:self.selectButton.index animated:NO];
    [self setEnabled:picture.status.enabled animated:!picture.status.selected];
    self.previewIamgeView.image = nil;
    
    [self cteatePhAssetImage];
    switch (picture.source.mediaType) {
        case DRPICPictureMediaTypeUnknown:
            self.informationView.type = DRPICPicturePickerInformationTypeNone;
            break;
        case DRPICPictureMediaTypeImage:
            if (picture.source.mediaSubtypes & DRPICPictureMediaSubtypePhotoGIF) {
                self.informationView.type = DRPICPicturePickerInformationTypeGif;
                
            } else {
                self.informationView.type = DRPICPicturePickerInformationTypeNone;
            }
            
            break;
        case DRPICPictureMediaTypeVideo:
        {
            NSInteger duration = picture.source.asset.duration;
            NSString *timeStr = @"00:00";
            NSInteger hour =  duration / 3600;
            NSInteger minice = (duration % 3600) / 60;
            NSInteger second =  duration % 60;
            
            if (hour > 0) {
                timeStr = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hour,(long)minice,(long)second];
            } else {
                
                timeStr = [NSString stringWithFormat:@"%02ld:%02ld",(long)minice,(long)second];
            }
            
            self.informationView.titleLabel.text = timeStr;
            self.informationView.type = DRPICPicturePickerInformationTypeVideo;
        }
            break;
        case DRPICPictureMediaTypeAudio:
            self.informationView.type = DRPICPicturePickerInformationTypeAudio;
            break;
            
        default:
            self.informationView.type = DRPICPicturePickerInformationTypeNone;
            break;
    }
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

- (DRPICPicturePIckerSelectButton *)selectButton {
    if (!_selectButton) {
        CGFloat selectButtonWidth = self.contentView.ct_width * 0.35;
        DRPICPicturePIckerSelectButton *selectButton = [[DRPICPicturePIckerSelectButton alloc] initWithFrame:(CGRect){0.,0.,selectButtonWidth,selectButtonWidth}];
        [selectButton addTarget:self action:@selector(eventTouchUpInsideForSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        _selectButton = selectButton;
    }
    return _selectButton;
}

- (DRPICPicturePickerInformationView *)informationView {
    if (!_informationView) {

        CGFloat informationViewWidth = self.contentView.ct_width;
        CGFloat informationViewHeight = self.contentView.ct_height * 0.2;
        DRPICPicturePickerInformationView *informationView = [[DRPICPicturePickerInformationView alloc] initWithFrame:(CGRect){0.,0.,informationViewWidth,informationViewHeight}];
        _informationView = informationView;
    }
    return _informationView;
}

- (UIView *)coverView {
    if (!_coverView) {
        UIView *coverView = [UIView new];
        coverView.backgroundColor = [UIColor clearColor];
        _coverView = coverView;
    }
    return _coverView;
}

- (UIView *)enabledCoverView {
    if (!_enabledCoverView) {
        UIView *enabledCoverView = [UIView new];
        enabledCoverView.backgroundColor = [UIColor clearColor];
        _enabledCoverView = enabledCoverView;
    }
    return _enabledCoverView;
}

@end

@implementation DRPICPicturePickerPhotoCollectionViewCell

@end


@implementation DRPICPicturePickerVideoCollectionViewCell

@end

@implementation DRPICPicturePickerAudioCollectionViewCell

@end

@implementation DRPICPicturePickerOtherCollectionViewCell

@end

