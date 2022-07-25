//
//  DRMETagView.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/1/2.
//

#import "DRMETagView.h"
#import "DRMETagModel.h"

#define kTagViewHeight 23
#define kMarginWidth 25 // 圆圈+横线的宽度，是固定的

@interface DRMETagView ()

@property(nonatomic,strong,readwrite) DRMETagModel *tagModel;

@property(nonatomic,strong) UIImageView *pointImgView;

@property(nonatomic,strong) UIView *lineView;

@property(nonatomic,assign) CGRect beginFrame;

@end

@implementation DRMETagView

@synthesize zoomScale = _zoomScale;

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColor.whiteColor;
        _lineView.width = 20;
        _lineView.height = 2;
        _lineView.centerY = self.tagLabel.centerY;
    }
    return _lineView;
}

- (UIImageView *)pointImgView
{
    if (!_pointImgView) {
        _pointImgView = [[UIImageView alloc] init];
        _pointImgView.image = [UIImage me_imageWithName:@"me_tag_point"];
        _pointImgView.width = 14;
        _pointImgView.height = 14;
        _pointImgView.centerY = self.lineView.centerY;
        _pointImgView.userInteractionEnabled = YES;
    }
    return _pointImgView;
}

- (UILabel *)tagLabel
{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.text = self.tagModel.text;
        _tagLabel.textColor = UIColor.whiteColor;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _tagLabel.height = kTagViewHeight;
        
        _tagLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        
        _tagLabel.layer.cornerRadius = 11;
        _tagLabel.layer.masksToBounds = YES;
        _tagLabel.layer.borderWidth = 1;
        _tagLabel.layer.borderColor = UIColor.whiteColor.CGColor;
    }
    return _tagLabel;
}

- (instancetype)initWithPoint:(CGPoint)point
                     tagModel:(DRMETagModel*)tagModel

{
    if (self = [super init]) {
        
//        self.backgroundColor = RandomColor;
        
        self.tagModel = tagModel;
        self.tapAbsolutePosition = point;
        
        [self addSubview:self.tagLabel];
        [self addSubview:self.lineView];
        [self addSubview:self.pointImgView];
        
        [self startPointAnimation];
        
        UITapGestureRecognizer *tapPointGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTapPointGesture)];
        [self addGestureRecognizer:tapPointGesture];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)];
        [self addGestureRecognizer:panGesture];
        
        
//        self.left = point.x * self.zoomScale - (self.pointImgView.width / 2);
//        self.top = point.y * self.zoomScale - (self.pointImgView.height / 2);
        
        self.left = point.x * self.zoomScale - (self.pointImgView.width);
        self.top = point.y * self.zoomScale - (self.pointImgView.height);
        
        CGFloat labelW = [tagModel.text widthForFont:self.tagLabel.font];
        // 40 是文字左右间距
        labelW += 40;
        self.tagLabel.width = labelW;
        // 25 圆点 + 横线的距离，是固定的
        self.width = labelW + kMarginWidth;
        self.height = kTagViewHeight;
        
        self.lineView.left = self.pointImgView.right - self.pointImgView.width/2;
        self.tagLabel.left = self.lineView.right;
        
        // 上边是一个 初始的 右朝向布局
        // 如果外界需要 左朝向 的布局，需要调用 layoutLeft
        DRMETagDirection tagDirection = tagModel.tagDirection;
        if (tagDirection == DRMETagDirectionRight) {
//            [self layoutRight];
        } else if (tagDirection == DRMETagDirectionLeft) {
            [self layoutLeft];
        }
    }
    return self;
}

- (void)setTagModel:(DRMETagModel *)tagModel
{
    _tagModel = tagModel;
    self.tagLabel.text = tagModel.text;
}

- (void)setTapAbsolutePosition:(CGPoint)tapAbsolutePosition
{
    _tapAbsolutePosition = tapAbsolutePosition;
    
    self.tagModel.tagPoint = tapAbsolutePosition;
}

- (void)clickTapPointGesture
{
    if (self.tagModel.tagDirection == DRMETagDirectionRight) {
        [self layoutLeft];
    } else if (self.tagModel.tagDirection == DRMETagDirectionLeft) {
        [self layoutRight];
    }
}

- (void)panImage:(UIPanGestureRecognizer *)gesture
{
    if (!gesture) {
        return;
    }
    
    /// 说明是大图进来的，包含tagID，不响应手势
    if (self.tagDict[@"tagID"]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(tagView:panGestureRecognizer:)]) {
        [self.delegate tagView:self panGestureRecognizer:gesture];
    }
    
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        self.beginFrame = self.frame;
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [gesture translationInView:self.superview];
        [self setCenter:(CGPoint){self.center.x + translation.x, self.center.y + translation.y}];
        [gesture setTranslation:CGPointZero inView:self.superview];
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        
        CGRect endFrame = self.frame;
        
        CGFloat moveX = endFrame.origin.x - self.beginFrame.origin.x;
        CGFloat moveY = endFrame.origin.y - self.beginFrame.origin.y;
        
        CGSize moveSize = CGSizeMake(moveX, moveY);
        // 更新 绝对位置  tapAbsolutePosition
        [self movedSuccessUpdate:moveSize];
        
    } else if (gesture.state == UIGestureRecognizerStateCancelled ||
               gesture.state == UIGestureRecognizerStateFailed) {
        // 划出屏幕或失败，恢复原位置
        [self setCenter:(CGPoint){self.center.x, self.center.y}];
        
        
    }
}

- (CGFloat)zoomScale{
    if (_zoomScale == 0.f) {
        return 1.f;
    }
    return _zoomScale;
}

- (void)setZoomScale:(CGFloat)zoomScale
{
    _zoomScale = zoomScale;
    [self setNeedsLayout];
    NSLog(@"zoomScale == %f", zoomScale);
}

+ (CGPoint)relativePositionForPoint:(CGPoint)point containerSize:(CGSize)size
{
    return CGPointMake(point.x / size.width, point.y / size.height);
}

+ (CGPoint)absolutePositionForPoint:(CGPoint)point containerSize:(CGSize)size
{
    return CGPointMake(point.x * size.width, point.y * size.height);
}

/// 每次移动结束后，根据移动距离，更新 tapAbsolutePosition
- (void)movedSuccessUpdate:(CGSize)offset
{
    NSLog(@"offset == %@", NSStringFromCGSize(offset));
    self.transform = CGAffineTransformIdentity;

    self.tapAbsolutePosition = CGPointMake(self.tapAbsolutePosition.x + offset.width/self.zoomScale,
                                           self.tapAbsolutePosition.y + offset.height/self.zoomScale);
    
    NSLog(@"self.tapAbsolutePosition = %@", NSStringFromCGPoint(self.tapAbsolutePosition));
    
    CGPoint tapRelativePosition = [DRMETagView relativePositionForPoint:self.tapAbsolutePosition containerSize:self.superview.size];
    self.tapRelativePosition = CGPointMake(tapRelativePosition.x * self.zoomScale, tapRelativePosition.y * self.zoomScale);
    
    NSLog(@"self.tapRelativePosition = %@", NSStringFromCGPoint(self.tapRelativePosition));
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.isFalseView) {
        NSLog(@"假假假假假假假假假假假假假假");
        
        self.tagLabel.width = self.width - kMarginWidth;
        
        return;
    }
    
    DRMETagDirection tagDirection = self.tagModel.tagDirection;
    
    if (tagDirection == DRMETagDirectionLeft) {
        
        self.left = (self.tapAbsolutePosition.x) * self.zoomScale - self.width +  self.pointImgView.width;
        self.top = (self.tapAbsolutePosition.y) * self.zoomScale - self.height/2;

    } else if (tagDirection == DRMETagDirectionRight) {
        
        self.left = self.tapAbsolutePosition.x * self.zoomScale - self.pointImgView.width/2;
        self.top = self.tapAbsolutePosition.y * self.zoomScale - self.height/2;
    }
}

// 文字朝右布局
- (void)layoutRight
{
    self.tagModel.tagDirection = DRMETagDirectionRight;
    self.left += (self.width - self.pointImgView.width);
    self.pointImgView.left = 0;
    self.lineView.left = self.pointImgView.right - self.pointImgView.width/2;
    self.tagLabel.left = self.lineView.right;
}

// 文字朝左布局
- (void)layoutLeft
{
    self.tagModel.tagDirection = DRMETagDirectionLeft;
    self.right -= (self.width - self.pointImgView.width);
    self.pointImgView.right = self.width;
    self.lineView.right = self.pointImgView.left + self.pointImgView.width/2;
    self.tagLabel.right = self.lineView.left;
}

/// 转为服务器需要的上传的格式的数据
- (NSMutableDictionary *)getTagData
{
//    NSMutableDictionary *dic = self.tagData;
//    if (!dic) {
//        dic = [[NSMutableDictionary alloc] init];
//        self.tagData = dic;
//    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:self.tagModel.text forKey:@"target_name"];
    [dic setValue:[NSNumber numberWithInt:self.tapRelativePosition.x * 1000] forKey:@"center_left_to_photo"];
    [dic setValue:[NSNumber numberWithInt:self.tapRelativePosition.y * 1000] forKey:@"center_top_to_photo"];
    [dic setValue:[NSNumber numberWithInteger:self.tagModel.tagDirection] forKey:@"tagDirections"];
    
    if (self.tagDict) {
        NSString *tagID = [self.tagDict objectForKey:@"tagID"];
        [dic setObject:tagID forKey:@"tagID"];
    }
    
    return dic;
}

- (id)copy{
    NSData *tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

- (void)startPointAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animation];
//    animation.keyPath = @"borderWidth";
    animation.keyPath = @"transform.scale";
    animation.repeatCount = FLT_MAX;
    animation.removedOnCompletion = NO;
    animation.duration = 1.0f;
    animation.fromValue = @(1.0f);
    animation.toValue = @(0.5f);
    animation.fillMode = kCAFillModeBackwards;
    animation.autoreverses = YES;
    
    [self.pointImgView.layer addAnimation:animation forKey:@"DRMEPointScaleAnimation"];
}

@end
