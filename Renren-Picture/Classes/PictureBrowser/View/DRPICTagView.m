//
//  DRPICTagView.m
//  Renren-Picture
//
//  Created by 陈金铭 on 2019/9/24.
//

#import "DRPICTagView.h"
#import "UIImage+RenrenPicture.h"
#import "UIColor+CTHex.h"
#import "UIView+CTLayout.h"

@interface DRPICTagView ()

@property (nonatomic, strong) UIImageView *tagBackgroundImageView;

@property (nonatomic, strong) UIView *tagLineView;
@property (nonatomic, strong) UIImageView *tagTypeImageView;
@property (nonatomic, strong) UILabel *tagTextLabel;

@end

@implementation DRPICTagView

#pragma mark - Override Methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - Intial Methods
- (void)initialize {
    [self createContent];
}

#pragma mark - Create Methods
- (void)createContent {
    self.frame = (CGRect){0.,0.,0.,};
    UIImageView *tagBackgroundImageView = [UIImageView new];
    self.tagBackgroundImageView = tagBackgroundImageView;
    UIImage *tagBackgroundImage = [UIImage ct_imageRenrenPictureUIWithNamed:@"view_image_tagBackground_default"];
    self.tagBackgroundImageView.image = [tagBackgroundImage stretchableImageWithLeftCapWidth:tagBackgroundImage.size.width * 0.5 topCapHeight:tagBackgroundImage.size.height * 0.5];
    [self addSubview:tagBackgroundImageView];
    
    UIImageView *tagTypeImageView = [UIImageView new];
    self.tagTypeImageView = tagTypeImageView;
    if (self.pictureTag.type == DRPICPictureTagTypeTopic) {
        self.tagTypeImageView.image = [UIImage ct_imageRenrenPictureUIWithNamed:@"view_image_tagTopic_default"];
    } else if (self.pictureTag.type == DRPICPictureTagTypeFriend) {
        self.tagTypeImageView.image = [UIImage ct_imageRenrenPictureUIWithNamed:@"view_image_tagFriend_default"];
    } else if (self.pictureTag.type == DRPICPictureTagTypeLocation) {
        self.tagTypeImageView.image = [UIImage ct_imageRenrenPictureUIWithNamed:@"view_image_tagLocation_default"];
    } else {
        self.tagTypeImageView.image = [UIImage ct_imageRenrenPictureUIWithNamed:@"view_image_tagLocation_default"];
    }
    [self addSubview:tagTypeImageView];
    
    UIImageView *tagPositionImageView = [[UIImageView alloc] initWithImage:[UIImage ct_imageRenrenPictureUIWithNamed:@"view_image_tagPoint_default"]];
    self.tagPositionImageView = tagPositionImageView;
    [self addSubview:tagPositionImageView];
    
    UIView *tagLineView = [UIView new];
    tagLineView.backgroundColor = [UIColor ct_colorWithHexString:@"#FFFFFF"];
    self.tagLineView = tagLineView;
    [self addSubview:tagLineView];
    
    UILabel *tagTextLabel = [UILabel new];
    tagTextLabel.textColor = [UIColor ct_colorWithHexString:@"#FFFFFF"];
    tagTextLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    tagTextLabel.text = self.pictureTag.tagText;
    self.tagTextLabel = tagTextLabel;
    [self addSubview:tagTextLabel];
    
    CGFloat height = 21.;
    CGFloat tagPositionImageViewWidth = 13;
    CGFloat tagLineViewWidth = 19;
    CGFloat tagLineViewHeight = 1;
    CGFloat tagPositionImageViewHeight = 13;
    CGFloat tagTextLabelFrontMargin = 14.;
    CGFloat tagTextLabelTailMargin = 14.;
    CGSize tagTextSize = [self.pictureTag.tagText boundingRectWithSize:CGSizeMake(self.frame.size.width, 30.) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.tagTextLabel.font} context:nil].size;
    
    
    CGFloat tagPositionImageViewY = (height - tagPositionImageViewWidth) * 0.5;
    self.tagPositionImageView.frame = (CGRect){0.,tagPositionImageViewY,tagPositionImageViewWidth,tagPositionImageViewHeight};
    
    CGFloat tagLineViewX = tagPositionImageViewWidth * 0.5;
    CGFloat tagLineViewY = (height - tagLineViewHeight) * 0.5;
    self.tagLineView.frame = (CGRect){tagLineViewX,tagLineViewY,tagLineViewWidth,tagLineViewHeight};
    
    CGFloat tagBackgroundImageViewWidth = tagTextLabelFrontMargin + tagTextSize.width + tagTextLabelTailMargin;
    CGFloat tagBackgroundImageViewX = CGRectGetMaxX(self.tagLineView.frame) - 1;
    self.tagBackgroundImageView.frame = (CGRect){tagBackgroundImageViewX,0.,tagBackgroundImageViewWidth,height};
    CGFloat tagTextLabelX = CGRectGetMaxX(self.tagLineView.frame) + tagTextLabelFrontMargin;
    CGFloat tagTextLabelY = (height - tagTextSize.height) * 0.5;
    self.tagTextLabel.frame = (CGRect){tagTextLabelX,tagTextLabelY,tagTextSize};
    
    CGFloat width = CGRectGetMaxX(self.tagBackgroundImageView.frame);
    
    if (self.pictureTag.direction == DRPICPictureTagDirectionLeft) {
        
        self.tagBackgroundImageView.frame = (CGRect){0.0f,0.,tagBackgroundImageViewWidth,height};
        self.tagTextLabel.frame = (CGRect){self.tagBackgroundImageView.ct_left+tagTextLabelFrontMargin,tagTextLabelY,tagTextSize};
        self.tagLineView.frame = (CGRect){self.tagBackgroundImageView.ct_right-0.5,tagLineViewY,tagLineViewWidth,tagLineViewHeight};
        self.tagPositionImageView.frame = (CGRect){self.tagLineView.ct_right-tagPositionImageViewWidth * 0.5,tagPositionImageViewY,tagPositionImageViewWidth,tagPositionImageViewHeight};
    }
    
    self.ct_size = (CGSize){width,height};
    
}

#pragma mark - Process Methods

#pragma mark - Event Methods

#pragma mark - Public Methods
- (instancetype)initWithPictureTag:(DRPICPictureTag *)pictureTag {
    self = [self initWithFrame:(CGRect){0.,0.,0.,0.}];
       if (self) {
           self.pictureTag = pictureTag;
           [self initialize];
       }
       return self;
}

#pragma mark - LazyLoad Methods

@end
