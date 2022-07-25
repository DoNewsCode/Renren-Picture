//
//  DRPICPicturePreviewCollectionViewCell.m
//  Renren-Picture
//
//  Created by Ming on 2020/3/17.
//

#import "DRPICPicturePreviewCollectionViewCell.h"


#import "UIView+CTLayout.h"
#import "UIImage+RenrenPicture.h"
#import "UIColor+CTHex.h"
#import <Photos/Photos.h>

@implementation DRPICPicturePreviewCollectionViewCell

#pragma mark - Override Methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor ct_colorWithHexString:@"#F1F1F1"];
        [self createContent];
    }
    return self;
}


#pragma mark - Intial Methods

#pragma mark - Create Methods
- (void)createContent {
    [self.contentView addSubview:self.pictureViewModel.pictureView];
    
}
#pragma mark - Process Methods

#pragma mark - Event Methods

#pragma mark - Public Methods

#pragma mark - Setter Methods
- (void)setPicture:(DRPICPicture *)picture {
    _picture = picture;
    self.pictureViewModel.pictureView.frame = CGRectMake(10., 0, self.contentView.bounds.size.width - 20, self.contentView.bounds.size.height);
    self.pictureViewModel.pictureView.scrollView.frame = self.pictureViewModel.pictureView.bounds;
    [self.pictureViewModel processPictureViewWithPicture:picture];
}

#pragma mark - Getter Methods
- (DRPICPictureViewModel *)pictureViewModel {
    if (!_pictureViewModel) {
        DRPICPictureViewModel *pictureViewModel = [[DRPICPictureViewModel alloc] initWithPictureViewFrame:CGRectMake(10., 0, self.contentView.bounds.size.width - 20, self.contentView.bounds.size.height)];
        _pictureViewModel = pictureViewModel;
    }
    return _pictureViewModel;
}
@end
