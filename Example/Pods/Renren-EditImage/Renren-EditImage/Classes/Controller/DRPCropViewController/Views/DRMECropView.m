//
//  DRMECropView.m
//

#import "DRMECropView.h"
#import "DRMECropOverlayView.h"
#import "DRMECropOverlayView.h"


static const CGFloat kDRMECropViewMinimumBoxSize = 130.f;

@interface DRMECropView ()
<UIGestureRecognizerDelegate>

/// 记录最原始的图，还原时需要使用此图
@property (nonatomic, strong) UIImage *originImage;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIView *backgroundContainerView;
@property (nonatomic, strong) UIImageView *foregroundImageView;
@property (nonatomic, strong) UIView *foregroundContainerView;

@property (nonatomic, strong) DRMECropOverlayView *gridOverlayView;
@property (nonatomic, strong) UIPanGestureRecognizer *gridPanGestureRecognizer;

@property (nonatomic, assign) DRMECropViewOverlayEdge tappedEdge;
@property (nonatomic, assign) CGPoint panOriginPoint;

@property (nonatomic, assign) CGRect cropOriginFrame;


@end

@implementation DRMECropView

- (NSMutableArray<DRMEStickerLabelView *> *)labelArray
{
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;
{
    if (self = [super initWithFrame:frame]) {
        //
        self.originImage = image;
        self.operationImage = image;
        [self setup];
    }
    return self;
}


- (instancetype _Nullable )initWithFrame:(CGRect)frame
                                   image:(UIImage *_Nullable)image
                              labelArray:(NSMutableArray<DRMEStickerLabelView*> *)labelArray
{
    if (self = [super initWithFrame:frame]) {
        //
        self.originImage = image;
        self.operationImage = image;
        self.labelArray = labelArray;
        [self setup];
    }
    return self;
}

- (void)setup
{
    // 底层视图
    self.backgroundContainerView = [[UIView alloc] init];
//    self.backgroundContainerView.backgroundColor = UIColor.yellowColor;
    [self addSubview:self.backgroundContainerView];
    
    
    // 底层视图中的图片
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.backgroundContainerView.bounds];
    self.backgroundImageView.image = self.operationImage;
    [self.backgroundContainerView addSubview:self.backgroundImageView];
    
    // 底层视图和顶层视图中的透明遮盖
    UIView *overlayView = [[UIView alloc] initWithFrame:self.bounds];
    overlayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    overlayView.hidden = NO;
    overlayView.userInteractionEnabled = NO;
    [self addSubview:overlayView];
    
    // 顶层视图
    self.foregroundContainerView = [[UIView alloc] init];
//    self.foregroundContainerView.backgroundColor = UIColor.blueColor;
    self.foregroundContainerView.clipsToBounds = YES;
    self.foregroundContainerView.userInteractionEnabled = NO;
    [self addSubview:self.foregroundContainerView];
    
    // 顶层视图中的图片
    self.foregroundImageView = [[UIImageView alloc] initWithFrame:self.foregroundContainerView.bounds];
    self.foregroundImageView.image = self.operationImage;
    [self.foregroundContainerView addSubview:self.foregroundImageView];
    
    // 等比计算 imageview 大小
    [self layoutImageViewSize];
    
    // 网格线
    self.gridOverlayView = [[DRMECropOverlayView alloc] initWithFrame:self.backgroundContainerView.frame];
    self.gridOverlayView.userInteractionEnabled = NO;
    [self addSubview:self.gridOverlayView];
    
    // 拖拽手势
    self.gridPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gridPanGestureRecognized:)];
    self.gridPanGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.gridPanGestureRecognizer];
    
    // 暂定中显示文字了，好嗨
//    UIView *labelsView = [[UIView alloc] initWithFrame:self.foregroundContainerView.frame];
//    labelsView.userInteractionEnabled = NO;
//    [self addSubview:labelsView];
//
//    for (DRMEStickerLabelView *labelView in self.labelArray) {
//        labelView.left -= 5;
//        labelView.top -= 5;
//        [labelsView addSubview:labelView];
//    }
    
}

// 布局imageView后，拿到frame就可以做范围限制了
- (void)layoutImageViewSize
{
    
    CGSize imageSize = self.operationImage.size;
    // 将self.view理解成一个画布
    CGRect bounds = self.bounds;
//    CGSize boundsSize = bounds.size;
    // 留10间距，让拖拽框边缘也完全显示
    CGSize boundsSize = CGSizeMake(bounds.size.width - 10, bounds.size.height - 10);
    
//        CGSize boundsSize = bounds.size;

    // work out the minimum scale of the object
    CGFloat scale = 0.0f;
    
    // Work out the size of the image to fit into the content bounds
    scale = MIN(boundsSize.width/imageSize.width,
                boundsSize.height/imageSize.height);
    CGSize scaledImageSize = CGSizeMake(floorf(imageSize.width * scale),
                                        floorf(imageSize.height * scale));
    
    self.foregroundContainerView.transform = CGAffineTransformIdentity;
    
    self.foregroundContainerView.size = scaledImageSize;
    self.foregroundContainerView.centerX = self.centerX;
    self.foregroundContainerView.centerY = self.height/2;
//    self.foregroundImageView.size = scaledImageSize;
    self.foregroundImageView.frame = self.foregroundContainerView.bounds;
    
    
    self.backgroundContainerView.transform = CGAffineTransformIdentity;
    self.backgroundContainerView.size = scaledImageSize;
    self.backgroundContainerView.centerX = self.centerX;
    self.backgroundContainerView.centerY = self.height/2;
//    self.backgroundImageView.size = scaledImageSize;
    self.backgroundImageView.frame = self.backgroundContainerView.bounds;
    
    self.cropBoxFrame = self.foregroundContainerView.frame;
}

- (CGSize)getLabelDistance
{
    DRMEStickerLabelView *labelView = self.labelArray.firstObject;
    
    CGRect labelRect = [labelView convertRect:labelView.bounds toView:self];
    CGFloat labelCenterX = CGRectGetMidX(labelRect);
    CGFloat labelCenterY = CGRectGetMidY(labelRect);
    CGFloat centerXDistance = labelCenterX - self.gridOverlayView.centerX;
    CGFloat centerYDistance = labelCenterY - self.gridOverlayView.centerY;
    
    return CGSizeMake(centerXDistance, centerYDistance);
}


- (DRMECropViewOverlayEdge)cropEdgeForPoint:(CGPoint)point
{
    CGRect frame = self.cropBoxFrame;
    
    //account for padding around the box
    frame = CGRectInset(frame, -32.0f, -32.0f);
    
    //Make sure the corners take priority
    CGRect topLeftRect = (CGRect){frame.origin, {64,64}};
    if (CGRectContainsPoint(topLeftRect, point))
        return DRMECropViewOverlayEdgeTopLeft;
    
    CGRect topRightRect = topLeftRect;
    topRightRect.origin.x = CGRectGetMaxX(frame) - 64.0f;
    if (CGRectContainsPoint(topRightRect, point))
        return DRMECropViewOverlayEdgeTopRight;
    
    CGRect bottomLeftRect = topLeftRect;
    bottomLeftRect.origin.y = CGRectGetMaxY(frame) - 64.0f;
    if (CGRectContainsPoint(bottomLeftRect, point))
        return DRMECropViewOverlayEdgeBottomLeft;
    
    CGRect bottomRightRect = topRightRect;
    bottomRightRect.origin.y = bottomLeftRect.origin.y;
    if (CGRectContainsPoint(bottomRightRect, point))
        return DRMECropViewOverlayEdgeBottomRight;
    
    //Check for edges
    CGRect topRect = (CGRect){frame.origin, {CGRectGetWidth(frame), 64.0f}};
    if (CGRectContainsPoint(topRect, point))
        return DRMECropViewOverlayEdgeTop;
    
    CGRect bottomRect = topRect;
    bottomRect.origin.y = CGRectGetMaxY(frame) - 64.0f;
    if (CGRectContainsPoint(bottomRect, point))
        return DRMECropViewOverlayEdgeBottom;
    
    CGRect leftRect = (CGRect){frame.origin, {64.0f, CGRectGetHeight(frame)}};
    if (CGRectContainsPoint(leftRect, point))
        return DRMECropViewOverlayEdgeLeft;
    
    CGRect rightRect = leftRect;
    rightRect.origin.x = CGRectGetMaxX(frame) - 64.0f;
    if (CGRectContainsPoint(rightRect, point))
        return DRMECropViewOverlayEdgeRight;
    
    return DRMECropViewOverlayEdgeNone;
}

#pragma mark - Gesture Recognizer -
- (void)gridPanGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        [self startEditing];
        self.panOriginPoint = point;
        self.cropOriginFrame = self.cropBoxFrame;
        self.tappedEdge = [self cropEdgeForPoint:self.panOriginPoint];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
//         [self startResetTimer];
    }
    
    [self updateCropBoxFrameWithGesturePoint:point];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer != self.gridPanGestureRecognizer)
        return YES;
    
    CGPoint tapPoint = [gestureRecognizer locationInView:self];
    
    /// 响应手势的范围
    CGRect frame = self.gridOverlayView.frame;
    CGRect innerFrame = CGRectInset(frame, 22.0f, 22.0f);
    CGRect outerFrame = CGRectInset(frame, -22.0f, -22.0f);
    
    if (CGRectContainsPoint(innerFrame, tapPoint) || !CGRectContainsPoint(outerFrame, tapPoint))
        return NO;
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.gridPanGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        return NO;
    }
    return YES;
}


- (void)updateCropBoxFrameWithGesturePoint:(CGPoint)point
{
    CGRect frame = self.cropBoxFrame;
    CGRect originFrame = self.cropOriginFrame;
    CGRect contentFrame = self.contentBounds;
    
    point.x = MAX(contentFrame.origin.x, point.x);
    point.y = MAX(contentFrame.origin.y, point.y);
    
    // The delta between where we first tapped, and where our finger is now
    CGFloat xDelta = ceilf(point.x - self.panOriginPoint.x);
    CGFloat yDelta = ceilf(point.y - self.panOriginPoint.y);
    
    //Current aspect ratio of the crop box in case we need to clamp it
    CGFloat aspectRatio = (originFrame.size.width / originFrame.size.height);

    //Note whether we're being aspect transformed horizontally or vertically
    BOOL aspectHorizontal = NO, aspectVertical = NO;
    
//    Depending on which corner we drag from, set the appropriate min flag to
//    ensure we can properly clamp the XY value of the box if it overruns the minimum size
//    (Otherwise the image itself will slide with the drag gesture)
    BOOL clampMinFromTop = NO, clampMinFromLeft = NO;
    
    switch (self.tappedEdge) {
        case DRMECropViewOverlayEdgeLeft:
            if (self.aspectRatioLockEnabled) {
                aspectHorizontal = YES;
                xDelta = MAX(xDelta, 0);
                CGPoint scaleOrigin = (CGPoint){CGRectGetMaxX(originFrame), CGRectGetMidY(originFrame)};
                frame.size.height = frame.size.width / aspectRatio;
                frame.origin.y = scaleOrigin.y - (frame.size.height * 0.5f);
            }
            
            frame.origin.x   = originFrame.origin.x + xDelta;
            frame.size.width = originFrame.size.width - xDelta;
            
            clampMinFromLeft = YES;
            
            break;
        case DRMECropViewOverlayEdgeRight:
            if (self.aspectRatioLockEnabled) {
                aspectHorizontal = YES;
                CGPoint scaleOrigin = (CGPoint){CGRectGetMinX(originFrame), CGRectGetMidY(originFrame)};
                frame.size.height = frame.size.width / aspectRatio;
                frame.origin.y = scaleOrigin.y - (frame.size.height * 0.5f);
                frame.size.width = originFrame.size.width + xDelta;
                frame.size.width = MIN(frame.size.width, contentFrame.size.height * aspectRatio);
            }
            else {
                frame.size.width = originFrame.size.width + xDelta;
            }
            
            break;
        case DRMECropViewOverlayEdgeBottom:
            if (self.aspectRatioLockEnabled) {
                aspectVertical = YES;
                CGPoint scaleOrigin = (CGPoint){CGRectGetMidX(originFrame), CGRectGetMinY(originFrame)};
                frame.size.width = frame.size.height * aspectRatio;
                frame.origin.x = scaleOrigin.x - (frame.size.width * 0.5f);
                frame.size.height = originFrame.size.height + yDelta;
                frame.size.height = MIN(frame.size.height, contentFrame.size.width / aspectRatio);
            }
            else {
                frame.size.height = originFrame.size.height + yDelta;
            }
            break;
        case DRMECropViewOverlayEdgeTop:
            if (self.aspectRatioLockEnabled) {
                aspectVertical = YES;
                yDelta = MAX(0,yDelta);
                CGPoint scaleOrigin = (CGPoint){CGRectGetMidX(originFrame), CGRectGetMaxY(originFrame)};
                frame.size.width = frame.size.height * aspectRatio;
                frame.origin.x = scaleOrigin.x - (frame.size.width * 0.5f);
                frame.origin.y    = originFrame.origin.y + yDelta;
                frame.size.height = originFrame.size.height - yDelta;
            }
            else {
                frame.origin.y    = originFrame.origin.y + yDelta;
                frame.size.height = originFrame.size.height - yDelta;
            }
            
            clampMinFromTop = YES;
            
            break;
        case DRMECropViewOverlayEdgeTopLeft:
            if (self.aspectRatioLockEnabled) {
                xDelta = MAX(xDelta, 0);
                yDelta = MAX(yDelta, 0);
                
                CGPoint distance;
                distance.x = 1.0f - (xDelta / CGRectGetWidth(originFrame));
                distance.y = 1.0f - (yDelta / CGRectGetHeight(originFrame));
                
                CGFloat scale = (distance.x + distance.y) * 0.5f;
                
                frame.size.width = ceilf(CGRectGetWidth(originFrame) * scale);
                frame.size.height = ceilf(CGRectGetHeight(originFrame) * scale);
                frame.origin.x = originFrame.origin.x + (CGRectGetWidth(originFrame) - frame.size.width);
                frame.origin.y = originFrame.origin.y + (CGRectGetHeight(originFrame) - frame.size.height);
                
                aspectVertical = YES;
                aspectHorizontal = YES;
            }
            else {
                frame.origin.x   = originFrame.origin.x + xDelta;
                frame.size.width = originFrame.size.width - xDelta;
                frame.origin.y   = originFrame.origin.y + yDelta;
                frame.size.height = originFrame.size.height - yDelta;
            }
            
            clampMinFromTop = YES;
            clampMinFromLeft = YES;
            
            break;
        case DRMECropViewOverlayEdgeTopRight:
            if (self.aspectRatioLockEnabled) {
                xDelta = MIN(xDelta, 0);
                yDelta = MAX(yDelta, 0);
                
                CGPoint distance;
                distance.x = 1.0f - ((-xDelta) / CGRectGetWidth(originFrame));
                distance.y = 1.0f - ((yDelta) / CGRectGetHeight(originFrame));
                
                CGFloat scale = (distance.x + distance.y) * 0.5f;
                
                frame.size.width = ceilf(CGRectGetWidth(originFrame) * scale);
                frame.size.height = ceilf(CGRectGetHeight(originFrame) * scale);
                frame.origin.y = originFrame.origin.y + (CGRectGetHeight(originFrame) - frame.size.height);
                
                aspectVertical = YES;
                aspectHorizontal = YES;
            }
            else {
                frame.size.width  = originFrame.size.width + xDelta;
                frame.origin.y    = originFrame.origin.y + yDelta;
                frame.size.height = originFrame.size.height - yDelta;
            }
            
            clampMinFromTop = YES;
            
            break;
        case DRMECropViewOverlayEdgeBottomLeft:
            if (self.aspectRatioLockEnabled) {
                CGPoint distance;
                distance.x = 1.0f - (xDelta / CGRectGetWidth(originFrame));
                distance.y = 1.0f - (-yDelta / CGRectGetHeight(originFrame));
                
                CGFloat scale = (distance.x + distance.y) * 0.5f;
                
                frame.size.width = ceilf(CGRectGetWidth(originFrame) * scale);
                frame.size.height = ceilf(CGRectGetHeight(originFrame) * scale);
                frame.origin.x = CGRectGetMaxX(originFrame) - frame.size.width;
                
                aspectVertical = YES;
                aspectHorizontal = YES;
            }
            else {
                frame.size.height = originFrame.size.height + yDelta;
                frame.origin.x    = originFrame.origin.x + xDelta;
                frame.size.width  = originFrame.size.width - xDelta;
            }
            
            clampMinFromLeft = YES;
            
            break;
        case DRMECropViewOverlayEdgeBottomRight:
            if (self.aspectRatioLockEnabled) {
                
                CGPoint distance;
                distance.x = 1.0f - ((-1 * xDelta) / CGRectGetWidth(originFrame));
                distance.y = 1.0f - ((-1 * yDelta) / CGRectGetHeight(originFrame));
                
                CGFloat scale = (distance.x + distance.y) * 0.5f;
                
                frame.size.width = ceilf(CGRectGetWidth(originFrame) * scale);
                frame.size.height = ceilf(CGRectGetHeight(originFrame) * scale);
                
                aspectVertical = YES;
                aspectHorizontal = YES;
            }
            else {
                frame.size.height = originFrame.size.height + yDelta;
                frame.size.width = originFrame.size.width + xDelta;
            }
            break;
        case DRMECropViewOverlayEdgeNone: break;
    }
    
    //The absolute max/min size the box may be in the bounds of the crop view
    /// 最小裁剪框拖拽区域为 130*130
    CGSize minSize = (CGSize){kDRMECropViewMinimumBoxSize, kDRMECropViewMinimumBoxSize};
    CGSize maxSize = (CGSize){CGRectGetWidth(contentFrame), CGRectGetHeight(contentFrame)};
    
    //clamp the box to ensure it doesn't go beyond the bounds we've set
    if (self.aspectRatioLockEnabled && aspectHorizontal) {
        maxSize.height = contentFrame.size.width / aspectRatio;
        minSize.width = kDRMECropViewMinimumBoxSize * aspectRatio;
    }
        
    if (self.aspectRatioLockEnabled && aspectVertical) {
        maxSize.width = contentFrame.size.height * aspectRatio;
        minSize.height = kDRMECropViewMinimumBoxSize / aspectRatio;
    }
    
    //Clamp the minimum size
    frame.size.width  = MAX(frame.size.width, minSize.width);
    frame.size.height = MAX(frame.size.height, minSize.height);
    
    //Clamp the maximum size
    frame.size.width  = MIN(frame.size.width, maxSize.width);
    frame.size.height = MIN(frame.size.height, maxSize.height);
    
    //Clamp the X position of the box to the interior of the cropping bounds
    frame.origin.x = MAX(frame.origin.x, CGRectGetMinX(contentFrame));
    frame.origin.x = MIN(frame.origin.x, CGRectGetMaxX(contentFrame) - minSize.width);

    //Clamp the Y postion of the box to the interior of the cropping bounds
    frame.origin.y = MAX(frame.origin.y, CGRectGetMinY(contentFrame));
    frame.origin.y = MIN(frame.origin.y, CGRectGetMaxY(contentFrame) - minSize.height);
    
    //Once the box is completely shrunk, clamp its ability to move
    if (clampMinFromLeft && frame.size.width <= minSize.width + FLT_EPSILON) {
        frame.origin.x = CGRectGetMaxX(originFrame) - minSize.width;
    }
    
    //Once the box is completely shrunk, clamp its ability to move
    if (clampMinFromTop && frame.size.height <= minSize.height + FLT_EPSILON) {
        frame.origin.y = CGRectGetMaxY(originFrame) - minSize.height;
    }
        
    self.cropBoxFrame = frame;
    NSLog(@"frame === %@", NSStringFromCGRect(frame));
//    [self checkForCanReset];
}

- (void)setCropBoxFrame:(CGRect)cropBoxFrame
{
    if (CGRectEqualToRect(cropBoxFrame, _cropBoxFrame)) {
        return;
    }
    
    //Upon init, sometimes the box size is still 0, which can result in CALayer issues
    if (cropBoxFrame.size.width < FLT_EPSILON || cropBoxFrame.size.height < FLT_EPSILON) {
        return;
    }

    //clamp the cropping region to the inset boundaries of the screen
    CGRect contentFrame = self.contentBounds;
    CGFloat xOrigin = ceilf(contentFrame.origin.x);
    CGFloat xDelta = cropBoxFrame.origin.x - xOrigin;
    cropBoxFrame.origin.x = floorf(MAX(cropBoxFrame.origin.x, xOrigin));
    if (xDelta < -FLT_EPSILON) //If we clamp the x value, ensure we compensate for the subsequent delta generated in the width (Or else, the box will keep growing)
        cropBoxFrame.size.width += xDelta;

    CGFloat yOrigin = ceilf(contentFrame.origin.y);
    CGFloat yDelta = cropBoxFrame.origin.y - yOrigin;
    cropBoxFrame.origin.y = floorf(MAX(cropBoxFrame.origin.y, yOrigin));
    if (yDelta < -FLT_EPSILON)
        cropBoxFrame.size.height += yDelta;

    //given the clamped X/Y values, make sure we can't extend the crop box beyond the edge of the screen in the current state
    CGFloat maxWidth = (contentFrame.size.width + contentFrame.origin.x) - cropBoxFrame.origin.x;
    cropBoxFrame.size.width = floorf(MIN(cropBoxFrame.size.width, maxWidth));

    CGFloat maxHeight = (contentFrame.size.height + contentFrame.origin.y) - cropBoxFrame.origin.y;
    cropBoxFrame.size.height = floorf(MIN(cropBoxFrame.size.height, maxHeight));

    //Make sure we can't make the crop box too small
    cropBoxFrame.size.width  = MAX(cropBoxFrame.size.width, kDRMECropViewMinimumBoxSize);
    cropBoxFrame.size.height = MAX(cropBoxFrame.size.height, kDRMECropViewMinimumBoxSize);
    
    _cropBoxFrame = cropBoxFrame;
    
    // 设置选择框的frame
    self.gridOverlayView.frame = _cropBoxFrame;
    
    self.foregroundContainerView.frame = _cropBoxFrame;
    
    [self matchForegroundToBackground];
}

- (void)matchForegroundToBackground
{
    self.foregroundImageView.frame = [self convertRect:self.backgroundContainerView.frame toView:self.foregroundContainerView];
}

#pragma mark - Convienience Methods -
/// 决定了裁剪区域的拖拽区域
- (CGRect)contentBounds
{
    return self.backgroundContainerView.frame;
}

- (CGSize)imageSize
{
    if (self.angle == -90 || self.angle == -270 || self.angle == 90 || self.angle == 270) {
        return (CGSize){self.operationImage.size.height, self.operationImage.size.width};
    }

    return (CGSize){self.operationImage.size.width, self.operationImage.size.height};
}

- (CGRect)imageCropFrame
{
//    return self.gridOverlayView.frame;
    
    CGSize imageSize = self.imageSize;
    CGSize imageViewSize = self.foregroundImageView.size;
    CGRect cropBoxFrame = self.cropBoxFrame;
    
    // 计算裁剪框的起点
    CGRect originRect = [self.gridOverlayView.superview convertRect:self.gridOverlayView.frame toView:self.foregroundImageView];
    
    CGPoint overlayPoint = originRect.origin;
    
    CGRect frame = CGRectZero;
        
    frame.origin.x = floorf(overlayPoint.x * (imageSize.width / imageViewSize.width));
    frame.origin.x = MAX(0, frame.origin.x);
    
    frame.origin.y = floorf(overlayPoint.y * (imageSize.height / imageViewSize.height));
    frame.origin.y = MAX(0, frame.origin.y);
    
    // 宽高已经没有问题了
    frame.size.width = ceilf(cropBoxFrame.size.width * (imageSize.width / imageViewSize.width));
    frame.size.width = MIN(imageSize.width, frame.size.width);
    
    frame.size.height = ceilf(cropBoxFrame.size.height * (imageSize.height / imageViewSize.height));
    frame.size.height = MIN(imageSize.height, frame.size.height);
    
    return frame;
}

- (void)resetLayoutToDefaultAnimated:(BOOL)animated
{
    // If resetting the crop view includes resetting the aspect ratio,
    // reset it to zero here. But set the ivar directly since there's no point
    // in performing the relayout calculations right before a reset.
//    if (self.hasAspectRatio && self.resetAspectRatioEnabled) {
//        _aspectRatio = CGSizeZero;
//    }

    //Reset all of the rotation transforms
    _angle = 0;
    
    //Set the scroll to 1.0f to reset the transform scale
    //        self.scrollView.zoomScale = 1.0f;
    
    /// 原始还原
//    {
//        CGRect imageRect = (CGRect){CGPointZero, self.originImage.size};
//
//        //Reset everything about the background container and image views
//        self.backgroundImageView.transform = CGAffineTransformIdentity;
//        self.backgroundContainerView.transform = CGAffineTransformIdentity;
//        self.backgroundImageView.frame = imageRect;
//        self.backgroundContainerView.frame = imageRect;
//
//        //Reset the transform ans size of just the foreground image
//        self.foregroundImageView.transform = CGAffineTransformIdentity;
//        self.foregroundImageView.frame = imageRect;
//
//        //Reset the layout
//        [self layoutImageViewSize];
//
//    }

//        //Enable / Disable the reset button
//        [self checkForCanReset];

    
    {
        /// 以原图进行重置
        self.operationImage = self.originImage;
        self.backgroundImageView.image = self.operationImage;
        self.foregroundImageView.image = self.operationImage;
        [self layoutImageViewSize];
    }
    
}

- (void)rotateImageNinetyDegreesAnimated:(BOOL)animated
{
    [self rotateImageNinetyDegreesAnimated:animated clockwise:NO];
}

- (void)rotateImageNinetyDegreesAnimated:(BOOL)animated clockwise:(BOOL)clockwise
{
    // Only allow one rotation animation at a time
//    if (self.rotateAnimationInProgress)
//        return;
//
//    //Cancel any pending resizing timers
//    if (self.resetTimer) {
//        [self cancelResetTimer];
//        [self setEditing:NO animated:NO];
//
//        self.cropBoxLastEditedAngle = self.angle;
//        [self captureStateForImageRotation];
//    }
    
    // 记录旋转前，gridOverlayView 相对于 imageView 的各种比例，旋转后按此比例更新位置
//    CGFloat scaleX = self.gridOverlayView.left / self.foregroundContainerView.left;
//    CGFloat scaleY = self.gridOverlayView.top / self.foregroundContainerView.top;
//    CGFloat scaleWidth = self.gridOverlayView.width / self.foregroundContainerView.width;
//    CGFloat scaleHeight = self.gridOverlayView.height / self.foregroundContainerView.height;
    
    /// 记录旋转前， gridOverlayView 四个点，相对于 imageView 的各种比例， 旋转后按此比例更新裁剪框位置
//    CGFloat scaleX = 1.0 - (self.gridOverlayView.top / self.backgroundContainerView.top);
//    CGFloat scaleY = 1.0 - (self.gridOverlayView.right / self.backgroundContainerView.right);
    
//    CGFloat scaleX = self.gridOverlayView.right / self.backgroundContainerView.width;
//    CGFloat scaleY = self.gridOverlayView.top / self.backgroundContainerView.height;
//
//    CGFloat scaleWidth = (self.gridOverlayView.height / self.backgroundContainerView.height);
//    CGFloat scaleHeight = (self.gridOverlayView.width / self.backgroundContainerView.width);
    
    {
        // 这是将图片本身旋转的旋转方式
        UIImage *image = [self getRotationImage:self.operationImage rotation:-90.f];
        self.operationImage = image;

        self.backgroundImageView.image = image;
        self.foregroundImageView.image = image;

        // 根据旋转后的图片，重新布局
        [self layoutImageViewSize];

    }
    
    // 以下是计算旋转后，网格的重新布局
//    CGFloat newX = self.backgroundContainerView.width * scaleX;
//    CGFloat newY = self.backgroundContainerView.height * scaleY;
//    CGFloat newWidth = floorf(self.backgroundContainerView.width * scaleWidth);
//    CGFloat newHeight = floorf(self.backgroundContainerView.height * scaleHeight);
//
//    CGRect newCropBoxFrame = CGRectMake(newX, newY, newWidth, newHeight);
////    self.gridOverlayView.frame = newCropBoxFrame;
//    self.cropBoxFrame = newCropBoxFrame;
//
//    NSLog(@"newCropBoxFrame = %@", NSStringFromCGRect(newCropBoxFrame));


    // Work out the new angle, and wrap around once we exceed 360s
    // 原始旋转
//    {
//        NSInteger newAngle = self.angle;
//        newAngle = clockwise ? newAngle + 90 : newAngle - 90;
//        if (newAngle <= -360 || newAngle >= 360)
//            newAngle = 0;
//
//        _angle = newAngle;
//
//        // Convert the new angle to radians
//        CGFloat angleInRadians = 0.0f;
//        switch (newAngle) {
//            case 90:    angleInRadians = M_PI_2;            break;
//            case -90:   angleInRadians = -M_PI_2;           break;
//            case 180:   angleInRadians = M_PI;              break;
//            case -180:  angleInRadians = -M_PI;             break;
//            case 270:   angleInRadians = (M_PI + M_PI_2);   break;
//            case -270:  angleInRadians = -(M_PI + M_PI_2);  break;
//            default:                                        break;
//        }
//        // Set up the transformation matrix for the rotation
//        CGAffineTransform rotation = CGAffineTransformRotate(CGAffineTransformIdentity, angleInRadians);
//
//        //Work out how much we'll need to scale everything to fit to the new rotation
//        CGRect contentBounds = self.contentBounds;
//        CGRect cropBoxFrame = self.cropBoxFrame;
//        CGFloat scale = MIN(contentBounds.size.width / cropBoxFrame.size.height,
//                            contentBounds.size.height / cropBoxFrame.size.width);
//
//        //Work out which section of the image we're currently focusing at
//        CGPoint cropMidPoint = (CGPoint){CGRectGetMidX(cropBoxFrame), CGRectGetMidY(cropBoxFrame)};
//        //    CGPoint cropTargetPoint = (CGPoint){cropMidPoint.x + self.scrollView.contentOffset.x, cropMidPoint.y + self.scrollView.contentOffset.y};
//        CGPoint cropTargetPoint = (CGPoint){cropMidPoint.x, cropMidPoint.y};
//
//        //Work out the dimensions of the crop box when rotated
//        CGRect newCropFrame = CGRectZero;
//        //    if (labs(self.angle) == labs(self.cropBoxLastEditedAngle) || (labs(self.angle)*-1) == ((labs(self.cropBoxLastEditedAngle) - 180) % 360)) {
//        //        newCropFrame.size = self.cropBoxLastEditedSize;
//        //
//        //        self.scrollView.minimumZoomScale = self.cropBoxLastEditedMinZoomScale;
//        //        self.scrollView.zoomScale = self.cropBoxLastEditedZoomScale;
//        //    } else {
//        //        newCropFrame.size = (CGSize){floorf(self.cropBoxFrame.size.height * scale), floorf(self.cropBoxFrame.size.width * scale)};
//        //
//        //        //Re-adjust the scrolling dimensions of the scroll view to match the new size
//        //        self.scrollView.minimumZoomScale *= scale;
//        //        self.scrollView.zoomScale *= scale;
//        //    }
//        newCropFrame.size = (CGSize){floorf(self.cropBoxFrame.size.height * scale), floorf(self.cropBoxFrame.size.width * scale)};
//
//        newCropFrame.origin.x = floorf((CGRectGetWidth(self.bounds) - newCropFrame.size.width) * 0.5f);
//        newCropFrame.origin.y = floorf((CGRectGetHeight(self.bounds) - newCropFrame.size.height) * 0.5f);
//
//        //If we're animated, generate a snapshot view that we'll animate in place of the real view
//        UIView *snapshotView = nil;
//        if (animated) {
//            snapshotView = [self.foregroundContainerView snapshotViewAfterScreenUpdates:NO];
//            //        self.rotateAnimationInProgress = YES;
//        }
//
//        //Rotate the background image view, inside its container view
//        self.backgroundImageView.transform = rotation;
//
//        //Flip the width/height of the container view so it matches the rotated image view's size
//        CGSize containerSize = self.backgroundContainerView.frame.size;
//        self.backgroundContainerView.frame = (CGRect){CGPointZero, {containerSize.height, containerSize.width}};
//        self.backgroundImageView.frame = (CGRect){CGPointZero, self.backgroundImageView.frame.size};
//
//        //Rotate the foreground image view to match
//        self.foregroundContainerView.transform = CGAffineTransformIdentity;
//        self.foregroundImageView.transform = rotation;
//
//        //Flip the content size of the scroll view to match the rotated bounds
//        //    self.scrollView.contentSize = self.backgroundContainerView.frame.size;
//
//        //assign the new crop box frame and re-adjust the content to fill it
//        self.cropBoxFrame = newCropFrame;
//        [self moveCroppedContentToCenterAnimated:NO];
//        newCropFrame = self.cropBoxFrame;
//
//        //work out how to line up out point of interest into the middle of the crop box
//        cropTargetPoint.x *= scale;
//        cropTargetPoint.y *= scale;
//
//        //swap the target dimensions to match a 90 degree rotation (clockwise or counterclockwise)
//        CGFloat swap = cropTargetPoint.x;
//        //    if (clockwise) {
//        //        cropTargetPoint.x = self.scrollView.contentSize.width - cropTargetPoint.y;
//        //        cropTargetPoint.y = swap;
//        //    } else {
//        //        cropTargetPoint.x = cropTargetPoint.y;
//        //        cropTargetPoint.y = self.scrollView.contentSize.height - swap;
//        //    }
//        // 逆时针旋转
//        cropTargetPoint.x = cropTargetPoint.y;
//        cropTargetPoint.y = self.backgroundContainerView.height - swap;
//
//        //reapply the translated scroll offset to the scroll view
//        CGPoint midPoint = {CGRectGetMidX(newCropFrame), CGRectGetMidY(newCropFrame)};
//        CGPoint offset = CGPointZero;
//        offset.x = floorf(-midPoint.x + cropTargetPoint.x);
//        offset.y = floorf(-midPoint.y + cropTargetPoint.y);
//        //    offset.x = MAX(-self.scrollView.contentInset.left, offset.x);
//        //    offset.y = MAX(-self.scrollView.contentInset.top, offset.y);
//
//        //if the scroll view's new scale is 1 and the new offset is equal to the old, will not trigger the delegate 'scrollViewDidScroll:'
//        //so we should call the method manually to update the foregroundImageView's frame
//        //    if (offset.x == self.scrollView.contentOffset.x && offset.y == self.scrollView.contentOffset.y && scale == 1) {
//        //        [self matchForegroundToBackground];
//        //    }
//        //    self.scrollView.contentOffset = offset;
//        [self matchForegroundToBackground];
//
//        //If we're animated, play an animation of the snapshot view rotating,
//        //then fade it out over the live content
//        if (animated) {
//            //        snapshotView.center = self.scrollView.center;
//            snapshotView.center = self.backgroundContainerView.center;
//            [self addSubview:snapshotView];
//
//            self.backgroundContainerView.hidden = YES;
//            self.foregroundContainerView.hidden = YES;
//            self.gridOverlayView.hidden = YES;
//
//            [UIView animateWithDuration:0.45f delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:0.8f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//                CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, clockwise ? M_PI_2 : -M_PI_2);
//                transform = CGAffineTransformScale(transform, scale, scale);
//                snapshotView.transform = transform;
//            } completion:^(BOOL complete) {
//                self.backgroundContainerView.hidden = NO;
//                self.foregroundContainerView.hidden = NO;
//                self.gridOverlayView.hidden = NO;
//
//                self.backgroundContainerView.alpha = 0.0f;
//                self.gridOverlayView.alpha = 0.0f;
//
//                [UIView animateWithDuration:0.45f animations:^{
//                    snapshotView.alpha = 0.0f;
//                    self.backgroundContainerView.alpha = 1.0f;
//                    self.gridOverlayView.alpha = 1.0f;
//                } completion:^(BOOL complete) {
//                    //                self.rotateAnimationInProgress = NO;
//                    [snapshotView removeFromSuperview];
//                }];
//            }];
//        }
//      }
    
}

- (void)moveCroppedContentToCenterAnimated:(BOOL)animated
{
//    if (self.simpleRenderMode)
//        return;
    
    CGRect contentRect = self.contentBounds;
    CGRect cropFrame = self.cropBoxFrame;
    
    // Ensure we only proceed after the crop frame has been setup for the first time
    if (cropFrame.size.width < FLT_EPSILON || cropFrame.size.height < FLT_EPSILON) {
        return;
    }
    
    //The scale we need to scale up the crop box to fit full screen
    CGFloat scale = MIN(CGRectGetWidth(contentRect)/CGRectGetWidth(cropFrame), CGRectGetHeight(contentRect)/CGRectGetHeight(cropFrame));
    
    CGPoint focusPoint = (CGPoint){CGRectGetMidX(cropFrame), CGRectGetMidY(cropFrame)};
    CGPoint midPoint = (CGPoint){CGRectGetMidX(contentRect), CGRectGetMidY(contentRect)};
    
    cropFrame.size.width = ceilf(cropFrame.size.width * scale);
    cropFrame.size.height = ceilf(cropFrame.size.height * scale);
    cropFrame.origin.x = contentRect.origin.x + ceilf((contentRect.size.width - cropFrame.size.width) * 0.5f);
    cropFrame.origin.y = contentRect.origin.y + ceilf((contentRect.size.height - cropFrame.size.height) * 0.5f);
    
    //Work out the point on the scroll content that the focusPoint is aiming at
    CGPoint contentTargetPoint = CGPointZero;
//    contentTargetPoint.x = ((focusPoint.x + self.scrollView.contentOffset.x) * scale);
//    contentTargetPoint.y = ((focusPoint.y + self.scrollView.contentOffset.y) * scale);
    contentTargetPoint.x = (focusPoint.x * scale);
    contentTargetPoint.y = (focusPoint.y * scale);
    
    //Work out where the crop box is focusing, so we can re-align to center that point
    __block CGPoint offset = CGPointZero;
    offset.x = -midPoint.x + contentTargetPoint.x;
    offset.y = -midPoint.y + contentTargetPoint.y;
    
    //clamp the content so it doesn't create any seams around the grid
    offset.x = MAX(-cropFrame.origin.x, offset.x);
    offset.y = MAX(-cropFrame.origin.y, offset.y);
    
    __weak typeof(self) weakSelf = self;
    void (^translateBlock)(void) = ^{
        typeof(self) strongSelf = weakSelf;
        
        // Setting these scroll view properties will trigger
        // the foreground matching method via their delegates,
        // multiple times inside the same animation block, resulting
        // in glitchy animations.
        //
        // Disable matching for now, and explicitly update at the end.
//        strongSelf.disableForgroundMatching = YES;
        {
            // Slight hack. This method needs to be called during `[UIViewController viewDidLayoutSubviews]`
            // in order for the crop view to resize itself during iPad split screen events.
            // On the first run, even though scale is exactly 1.0f, performing this multiplication introduces
            // a floating point noise that zooms the image in by about 5 pixels. This fixes that issue.
//            if (scale < 1.0f - FLT_EPSILON || scale > 1.0f + FLT_EPSILON) {
//                strongSelf.scrollView.zoomScale *= scale;
//            }
            
            offset.x = MIN(-CGRectGetMaxX(cropFrame)+strongSelf.backgroundContainerView.width, offset.x);
            offset.y = MIN(-CGRectGetMaxY(cropFrame)+strongSelf.backgroundContainerView.height, offset.y);
//            strongSelf.scrollView.contentOffset = offset;
            
            strongSelf.cropBoxFrame = cropFrame;
        }
//        strongSelf.disableForgroundMatching = NO;
        
        //Explicitly update the matching at the end of the calculations
        [strongSelf matchForegroundToBackground];
    };
    
    if (!animated) {
        translateBlock();
        return;
    }

    [self matchForegroundToBackground];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5f
                              delay:0.0f
             usingSpringWithDamping:1.0f
              initialSpringVelocity:1.0f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:translateBlock
                         completion:nil];
    });
}

#pragma mark - 优化 - 新增图片旋转方法
- (UIImage *)getRotationImage:(UIImage *)image rotation:(CGFloat)rotation {

    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIAffineTransform" keysAndValues:kCIInputImageKey, ciImage, nil];

    [filter setDefaults];
    CGAffineTransform transform = CATransform3DGetAffineTransform([self rotateTransform:CATransform3DIdentity clockwise:NO angle:rotation]);
    [filter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];

    //根据滤镜设置图片
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];

    UIImage *result = [UIImage imageWithCGImage:cgImage];

    CGImageRelease(cgImage);

    return result;
}

- (CATransform3D)rotateTransform:(CATransform3D)initialTransform clockwise:(BOOL)clockwise angle:(CGFloat)angle {
   
    CGFloat arg = angle*M_PI / 180.0f;
    if(!clockwise){
        arg *= -1;
    }
    //进行形变
    CATransform3D transform = initialTransform;
    transform = CATransform3DRotate(transform, arg, 0, 0, 1);
    CGFloat _flipState1 = 0;
    CGFloat _flipState2 = 0;
    transform = CATransform3DRotate(transform, _flipState1*M_PI, 0, 1, 0);
    transform = CATransform3DRotate(transform, _flipState2*M_PI, 1, 0, 0);

    return transform;
}

@end

