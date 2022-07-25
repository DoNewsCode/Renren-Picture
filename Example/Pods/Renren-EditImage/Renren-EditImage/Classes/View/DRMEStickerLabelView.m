//
//  DRMEStickerLabelView.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/11/8.
//

#import "DRMEStickerLabelView.h"

@interface DRMEStickerLabelView()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGSize labelSize;
@property(nonatomic,strong) NSTimer *timer;

@end

@implementation DRMEStickerLabelView


- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _contentLabel;
}

- (instancetype)initWithLabelSize:(CGSize)labelSize
{
    self = [super init];
    if (self) {
        self.labelSize = labelSize;
        [self addSubview:self.contentLabel];
        
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImage:)];
        pinchGesture.delegate = self;
        [self addGestureRecognizer:pinchGesture];
        
        UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateImage:)];
        rotationGesture.delegate = self;
        [self addGestureRecognizer:rotationGesture];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)];
        [self addGestureRecognizer:panGesture];
        
          
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
        singleTapGesture.numberOfTapsRequired =1;
        singleTapGesture.numberOfTouchesRequired  =1;
        [self addGestureRecognizer:singleTapGesture];
                   
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTapGesture.numberOfTapsRequired =2;
        doubleTapGesture.numberOfTouchesRequired =1;
        [self addGestureRecognizer:doubleTapGesture];
        //只有当doubleTapGesture识别失败的时候(即识别出这不是双击操作)，singleTapGesture才能开始识别
        [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
        
        self.contentLabel.frame = CGRectMake(15, 15, self.labelSize.width, self.labelSize.height);
//        self.contentLabel.backgroundColor = UIColor.redColor;
        
        self.contentLabel.layer.cornerRadius = 10;
        self.contentLabel.layer.masksToBounds = YES;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

//    self.contentLabel.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
}

#pragma mark -
#pragma mark - Private method

- (void)pinchImage:(UIPinchGestureRecognizer *)gesture{
    
    if (!gesture) {
        return;
    }
    if (gesture.state == UIGestureRecognizerStateChanged) {
        self.transform = CGAffineTransformScale(self.transform, gesture.scale, gesture.scale);
        gesture.scale = 1;
    }
}

- (void)rotateImage:(UIRotationGestureRecognizer *)gesture{
    if (!gesture) {
        return;
    }
    if (gesture.state == UIGestureRecognizerStateChanged) {
        self.transform = CGAffineTransformRotate(self.transform, gesture.rotation);
        [gesture setRotation:0];
    }
}

- (void)panImage:(UIPanGestureRecognizer *)gesture
{
    if (!gesture) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(stickerLabelView:panGestureRecognizer:)]) {
        [self.delegate stickerLabelView:self panGestureRecognizer:gesture];
    }
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [gesture translationInView:self.superview];
        [self setCenter:(CGPoint){self.center.x + translation.x, self.center.y + translation.y}];
        [gesture setTranslation:CGPointZero inView:self.superview];
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        
    } else if (gesture.state == UIGestureRecognizerStateCancelled ||
               gesture.state == UIGestureRecognizerStateFailed) {
        // 划出屏幕或失败，恢复原位置
        [self setCenter:(CGPoint){self.center.x, self.center.y}];
        
    }
}

//两个手势分别响应的方法
-(void)handleSingleTap:(UIGestureRecognizer *)sender
{
    NSLog(@"处理单击文字时的逻辑，加选框啥啥啥的");
    if (self.singleTapBlock) {
        self.singleTapBlock();
    }
}

-(void)handleDoubleTap:(UIGestureRecognizer *)sender
{
    NSLog(@"处理双击文字时的逻辑，再次进入输入文字页面");
    if (self.doubleTapBlock) {
        self.doubleTapBlock();
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

/** 当点击label时，显示边框 */
- (void)showBorderWhenClicked
{
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = UIColor.whiteColor.CGColor;
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }

    [self startCountDown];
}

/** 当拖拽label时，显示边框 */
- (void)showBorderWhenDragging
{
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = UIColor.whiteColor.CGColor;
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

/** 隐藏边框 */
- (void)hideBorder
{
    self.layer.borderWidth = 0;
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

/** 开始倒计时，2秒后，删除边框 */
- (void)startCountDown
{
    WeakSelf(self)
    self.timer = [NSTimer timerWithTimeInterval:2 block:^(NSTimer * _Nonnull timer) {
        NSLog(@"-- %s, %d", __func__, __LINE__);
        [weakself hideBorder];
    } repeats:NO];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

- (id)copy{
    NSData *tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

- (void)dealloc
{
    NSLog(@"文字视图 dealloc");
}


@end
