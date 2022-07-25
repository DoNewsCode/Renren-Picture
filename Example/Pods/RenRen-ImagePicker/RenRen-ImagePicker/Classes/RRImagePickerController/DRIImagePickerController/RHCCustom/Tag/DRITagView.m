//
//  DRITagView.m
//  RenrenOfficial-iOS-Concept
//
//  Created by 张健康 on 2019/3/18.
//  Copyright © 2019 renren. All rights reserved.
//

#import "DRITagView.h"
#import "SDAutoLayout.h"
#import "DRIImagePickerController.h"
@interface DRITagView(){
    CGFloat _zoomScale;
}
@end

@implementation DRITagView
- (instancetype)initWithPoint:(CGPoint)point
                    direction:(DRITagViewDirection)direction{
    if (self = [super init]) {
        self.direction = direction;
        self.tapAbsolutePosition = point;
        
        self.frame = CGRectMake(point.x - (self.pointView.width / 2),
                                point.y - (self.pointView.height / 2), self.pointView.width, self.pointView.height);
        [self setupUI];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                    direction:(DRITagViewDirection)direction{
    if (self = [super initWithFrame:frame])
    {
        self.direction = direction;
        self.originFrame = frame;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    [self addSubview:self.lineView];

    [self addSubview:self.pointView];
    
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagViewDidClick:)];
    [self addGestureRecognizer:tap];
}

- (void)tagViewDidClick:(UITapGestureRecognizer *)sender{
    if (self.clickBlock) self.clickBlock(self);
}



- (void)setTitle:(NSString *)title{
    _title = title;
    [self.titleLabel setText:title];
    [self setNeedsLayout];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.beganRect = self.frame;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.canMove) {
        self.frame = self.beganRect;
        return;
    }
    if (self.tagData[@"tagID"]) {
        self.frame = self.beganRect;
        return;
    }
    UITouch *touch=[touches anyObject];
    UIView *view = touch.view;
    CGPoint curP = [touch locationInView:self];
    //    CGPoint prep=[touch preciseLocationInView:self]; 9.0之前
    CGPoint preP=[touch precisePreviousLocationInView:self];//9.0之后
    CGFloat offsetX=curP.x-preP.x;
    CGFloat offsetY=curP.y-preP.y;
    //    self.tapRelativePosition = CGPointMake(self.tapRelativePosition.x - offsetX, self.tapRelativePosition.y - offsetY);
    //NSLog(@"%f,%f",offsetX ,offsetY);
    self.transform=CGAffineTransformTranslate(self.transform, offsetX, offsetY);
    if (self.tagViewMovedBlock) {
        self.tagViewMovedBlock(self, self.frame);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch *touch=[touches anyObject];
//    UIView *view = touch.view;
//    CGPoint curP = [touch locationInView:self.superview];
//    //    CGPoint prep=[touch preciseLocationInView:self]; 9.0之前
//    CGPoint preP=[touch precisePreviousLocationInView:self.superview];//9.0之后
//    CGFloat offsetX=curP.x-preP.x;
//    CGFloat offsetY=curP.y-preP.y;
//    //    self.tapRelativePosition = CGPointMake(self.tapRelativePosition.x - offsetX, self.tapRelativePosition.y - offsetY);
//    //NSLog(@"%f,%f",offsetX ,offsetY);
//    self.transform=CGAffineTransformTranslate(self.transform, offsetX, offsetY);
    if (self.tagViewMoveEndBlock) {
        self.tagViewMoveEndBlock(self,CGSizeMake(self.transform.tx, self.transform.ty));
    }
}
- (void)movedSuccess:(CGSize)offset{
    self.transform = CGAffineTransformIdentity;
    self.tapAbsolutePosition = CGPointMake(self.tapAbsolutePosition.x + offset.width/self.zoomScale, self.tapAbsolutePosition.y + offset.height/self.zoomScale);
    CGPoint tapRelativePosition = [DRITagView relativePositionForPoint:self.tapAbsolutePosition containerSize:self.superview.size];
    self.tapRelativePosition = CGPointMake(tapRelativePosition.x * self.zoomScale, tapRelativePosition.y * self.zoomScale);
    [self layoutSubviews];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat pading = 14.0f;

    
    [self.titleLabel sizeToFit];
    if (self.direction == DRITagViewDirectionLeft) {
        
        self.titleLabel.frame = CGRectMake(pading, 0, self.titleLabel.width, self.imageView.height);
        self.imageView.frame = CGRectMake(0, 0, self.titleLabel.width + 2*pading, self.imageView.height);
        
        self.lineView.left = self.imageView.right-0.5;
        self.lineView.centerY = self.imageView.centerY;
        
        self.pointView.frame = CGRectMake(self.imageView.width+self.lineView.width-0.5-self.pointView.width/2, (self.imageView.height - self.pointView.height)/2, self.pointView.frame.size.width, self.pointView.frame.size.height);

        
        self.top = (self.tapAbsolutePosition.y) * self.zoomScale  - self.imageView.height/2;
        
        self.left = (self.tapAbsolutePosition.x) * self.zoomScale  - self.lineView.width - self.imageView.width;
        self.size = CGSizeMake(self.imageView.width + self.pointView.width/2 + self.lineView.width, self.imageView.height);

        
        //        ((self.tapAbsolutePosition.x - self.pointView.width/2 - self.imageView.width) * self.zoomScale, (self.tapAbsolutePosition.y - self.imageView.height/2) * self.zoomScale, self.imageView.width + self.pointView.width, self.imageView.height);
    }else
    {
        self.pointView.frame = CGRectMake(0, (self.imageView.height - self.pointView.height)/2, self.pointView.width, self.pointView.height);
        
        
        self.lineView.left = self.pointView.width/2;
        self.lineView.centerY = self.pointView.centerY;
        
        self.imageView.frame = CGRectMake(self.lineView.right, 0, self.titleLabel.width + 2*pading, self.imageView.height);
        self.titleLabel.frame = CGRectMake(self.imageView.frame.origin.x + pading, 0, self.titleLabel.width, self.imageView.height);
        self.frame = CGRectMake((self.tapAbsolutePosition.x) * self.zoomScale  - self.pointView.width/2, (self.tapAbsolutePosition.y ) * self.zoomScale - self.imageView.height/2, self.imageView.width + self.pointView.width/2+self.lineView.width, self.imageView.height);

        
    }
}

- (void)setTapAbsolutePosition:(CGPoint)tapAbsolutePosition{
    _tapAbsolutePosition = tapAbsolutePosition;
}

- (void)cancelMoved{
    self.transform = CGAffineTransformIdentity;
    self.frame = self.beganRect;
}

- (UIImageView *)imageView{
    if (!_imageView) {
                UIImage *tagBackgroundImage = [UIImage dri_imageNamedFromMyBundle:@"publish_view_image_tagBackground_default"];
        
        tagBackgroundImage = [tagBackgroundImage stretchableImageWithLeftCapWidth:tagBackgroundImage.size.width * 0.5 topCapHeight:tagBackgroundImage.size.height * 0.5];
        UIImage *image = (self.direction==DRITagViewDirectionLeft)?tagBackgroundImage:tagBackgroundImage;

        _imageView = [[UIImageView alloc] initWithImage:image];
        [_imageView sizeToFit];
    }
    return _imageView;
}

- (UIImageView *)pointView{
    if (!_pointView) {
        _pointView = [[UIImageView alloc] initWithImage:[UIImage dri_imageNamedFromMyBundle:@"publish_view_image_tagPoint_default"]];

        [_pointView sizeToFit];
        [_pointView setFrame:CGRectMake(0, 0, 13, 13)];

    }
    return _pointView;
}

- (UIView *)lineView {
    
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 19, 1)];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    
    return _lineView;
}



- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];

        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

+ (CGPoint)relativePositionForPoint:(CGPoint)point containerSize:(CGSize)size
{
    return CGPointMake(point.x / size.width, point.y / size.height);
}

+ (CGPoint)absolutePositionForPoint:(CGPoint)point containerSize:(CGSize)size
{
    return CGPointMake(point.x * size.width, point.y * size.height);
}

- (CGFloat)zoomScale{
    if (_zoomScale == 0.f) {
        return 1.f;
    }
    return _zoomScale;
}

- (void)setZoomScale:(CGFloat)zoomScale{
    _zoomScale = zoomScale;
    [self layoutSubviews];
}

- (NSMutableDictionary *)getTagData{
    NSMutableDictionary *dic = self.tagData;
    if (!dic) {
        dic = [[NSMutableDictionary alloc] init];
        self.tagData = dic;
    }
    [dic setValue:self.title forKey:@"target_name"];
    [dic setValue:[NSNumber numberWithInt:self.tapRelativePosition.x * 1000] forKey:@"center_left_to_photo"];
    [dic setValue:[NSNumber numberWithInt:self.tapRelativePosition.y * 1000] forKey:@"center_top_to_photo"];
    [dic setValue:[NSNumber numberWithInt:self.direction] forKey:@"tagDirections"];
    
    return dic;
}
@end
