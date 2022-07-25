//
//  DRBTabbarItem.m
//  Renren-BaseKit
//
//  Created by 陈金铭 on 2019/7/24.
//

#import "DRBTabbarItem.h"

#import "UIFont+DRBFont.h"

@implementation DRBTabbarTipBadgeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor ct_colorWithHexString:@"#F45950"];
        self.textColor = [UIColor ct_colorWithHexString:@"#FFFFFF"];
        self.font = [UIFont fontWithFontName:@"PingFangSC-Regular" size:8];
        self.type = DRBTabbarTipBadgeTypeDetailedValue;
        self.lineBreakMode = NSLineBreakByClipping;
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
- (void)setType:(DRBTabbarTipBadgeType)type {
    _type = type;
    if (type == DRBTabbarTipBadgeTypeDetailedValue) {
        self.frame = (CGRect){self.frame.origin,13,13};
        self.clipsToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.cornerRadius = self.ct_height * 0.5;
    } else if (type == DRBTabbarTipBadgeTypeFuzzyValue) {
        
        self.frame = (CGRect){self.frame.origin,8,8};
        self.layer.borderWidth = 1;
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.layer.cornerRadius = self.ct_height * 0.5;
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];

    CGSize textSize = [text boundingRectWithSize:CGSizeMake(25, 13) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;
    
    if (textSize.width < 8 ) {
        self.ct_width = self.ct_height;
    } else {
        textSize.width += (4 * 2);
        self.ct_width = textSize.width;
    }
    
}

@end

@implementation DRBTabbarItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createAnimationView];
        DRBTabbarTipBadgeView *tipBadge = [DRBTabbarTipBadgeView new];
        tipBadge.hidden = YES;
        self.tipBadge = tipBadge;
        [self addSubview:tipBadge];
    }
    return self;
}

- (void)createAnimationView {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_animationView.ct_width == 0) {
        _animationView.frame = self.bounds;
    }
    
    if (_imageView.ct_width == 0) {
        _imageView.frame = self.bounds;
    }
}

- (void)setStatus:(DRBTabbarItemStatus)status {
    _status = status;
    
    [self procaseAnimation];
    [self procaseImage];
}

- (void)setNormalAnimationName:(NSString *)normalAnimationName {
    _normalAnimationName = normalAnimationName;
}

- (void)setSelectedAnimationName:(NSString *)selectedAnimationName {
    _selectedAnimationName = selectedAnimationName;
}

    
    
- (void)procaseAnimation {

    switch (self.status) {
        case DRBTabbarItemStatusNormal:
        if (_animationView && _normalAnimationName) {
            [_animationView setAnimationNamed:_normalAnimationName];
            [_animationView play];
        }
        break;
        case DRBTabbarItemStatusSelected:
        if (_animationView && _selectedAnimationName) {
            [_animationView setAnimationNamed:_selectedAnimationName];
            [_animationView play];
            
        }
        break;
        
        default:
        break;
    }
}
 
- (void)procaseImage {
    switch (self.status) {
        case DRBTabbarItemStatusNormal:
        if (_imageView && _normalImage) {
            _imageView.image = _normalImage;
        }
        break;
        case DRBTabbarItemStatusSelected:
        if (_animationView && _selectedImage) {
            _imageView.image = _selectedImage;
        }
        break;
        
        default:
        break;
    }
}
    
    
- (LOTAnimationView *)animationView {
    if (!_animationView) {
        LOTAnimationView *animationView = [LOTAnimationView new];
        animationView.contentMode = UIViewContentModeScaleAspectFit;
        animationView.backgroundColor = [UIColor clearColor];
        [self addSubview:animationView];
        _animationView = animationView;
    }
    return _animationView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

@end
