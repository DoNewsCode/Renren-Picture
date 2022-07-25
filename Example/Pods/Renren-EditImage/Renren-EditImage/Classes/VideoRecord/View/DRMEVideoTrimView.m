//
//  DRMEVideoTrimView.m
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/13.
//

#import "DRMEVideoTrimView.h"
#import "DRMEVideoTrimTableViewCell.h"


#define kMaxVideoDuration 60.0
#define kMinVideoDuration 3.0
#define kDefaultImageCount 34.0

@interface DRMEVideoTrimView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, assign) NSInteger     currentCount;
@property (nonatomic, assign) NSInteger     imageCount;
@property (nonatomic, strong) UICollectionView   *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UIImageView   *leftTrimView;
@property (nonatomic, strong) UIImageView   *rightTrimView;
@property (nonatomic, strong) UIView        *playIndicateBar;
@property (nonatomic, strong) UILabel       *leftBeginLabel;
@property (nonatomic, strong) UILabel       *rightEndLabel;
@property (nonatomic, assign) CGFloat       cellHeight;
@property (nonatomic, assign) CGFloat       secondOffset;//多大的距离为1s
@property (nonatomic, assign) CGFloat       videoDuration;
@property (nonatomic, assign) CGFloat       tableWidth;

@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) double duration;

@end

@implementation DRMEVideoTrimView

- (id)initWithFrame:(CGRect)frame videoDuration:(float)duration{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];//RGBACOLOR(0, 0, 0, 0.4)
        self.tableWidth = SCREEN_WIDTH - 40;
        self.userInteractionEnabled = YES;
        self.videoDuration = duration;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        //        layout.rowCount = 2
        //        layout.itemCountPerRow = 3
        layout.itemSize = CGSizeMake(self.tableWidth / kDefaultImageCount,  62);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.layout = layout;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 0, self.tableWidth, 62) collectionViewLayout:layout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.bounces = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
//        self.collectionView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView registerClass:[DRMEVideoTrimTableViewCell class] forCellWithReuseIdentifier:@"DRMEVideoTrimTableViewCell"];
        [self addSubview:self.collectionView];
        self.collectionView.origin = CGPointMake(20,0);

        self.playIndicateBar = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 2, 62)];
        self.playIndicateBar.backgroundColor = [UIColor whiteColor];

        self.maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 167, 62)];
        [self.maskImageView setImage:[UIImage me_imageWithName:@"shortVideo_trim1"] ];
        [self.maskImageView setClipsToBounds:YES];
        [self addSubview:self.maskImageView];
        self.rightEndLabel = [[UILabel alloc] initWithFrame:self.maskImageView.bounds];
        self.rightEndLabel.userInteractionEnabled = YES;
        [self.rightEndLabel setTextColor:[UIColor whiteColor]];
        [self.rightEndLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self.rightEndLabel setTextAlignment:NSTextAlignmentCenter];
        [self.rightEndLabel setBackgroundColor:[UIColor colorWithRGB:0xffffff alpha:0.3]];
        [self.maskImageView addSubview:self.rightEndLabel];
        [self.maskImageView addSubview:self.playIndicateBar];
        
        self.leftTrimView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 0, 33, 81)];
        self.leftTrimView.contentScaleFactor = [[UIScreen mainScreen] scale];
        self.leftTrimView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.leftTrimView];
        self.leftTrimView.centerX = self.collectionView.left;
        self.leftTrimView.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panLeftTrimView = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleLeftPan:)];
        [self.leftTrimView addGestureRecognizer:panLeftTrimView];
        
        self.rightTrimView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - self.leftTrimView.right, self.leftTrimView.top, self.leftTrimView.width, self.leftTrimView.height)];
        self.rightTrimView.contentScaleFactor = [[UIScreen mainScreen] scale];
        self.rightTrimView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.rightTrimView];
        self.rightTrimView.centerX = self.collectionView.right;
        self.rightTrimView.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panRightTrimView = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleRightPan:)];
        [self.rightTrimView addGestureRecognizer:panRightTrimView];
        
        self.duration = duration;
        self.leftBeginLabel.text = @"0.0s";
        self.leftValue = 0.0;
        self.rightValue = duration;
        if (duration <= kMaxVideoDuration) {
            self.rightEndLabel.text = [self getTextFromeFloat:duration];
            self.secondOffset = self.tableWidth/duration;
            if (fabs(self.rightValue - 5.0) < 0.01) {
                self.rightEndLabel.textColor = [UIColor purpleColor];//UIColorFromRGB(0xff2f60);
            }else {
                self.rightEndLabel.textColor = [UIColor whiteColor];
            }
        }else{
            self.rightEndLabel.text = @"60.0s";
            self.rightEndLabel.textColor = [UIColor purpleColor];//UIColorFromRGB(0xff2f60);
            self.secondOffset = self.tableWidth/kMaxVideoDuration;
        }
        [self setMiddleMaskValue];
        self.maxWidth = self.maskImageView.width;
    }
    return self;
}

- (NSString*)createPreviewImageDir
{
    [self removePreviewImageDir];
    NSString *imageDir = [NSTemporaryDirectory() stringByAppendingPathComponent:@"/Caches/PreviewPictures"];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ){
        [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return imageDir;
}

- (void)removePreviewImageDir
{
    NSString *imageDir = [NSTemporaryDirectory() stringByAppendingPathComponent:@"/Caches/PreviewPictures"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:imageDir error:nil];
}

#pragma mark - methods
- (NSInteger)setImagesWithVideo:(AVAsset *)video
{
    self.imagePath = [self createPreviewImageDir];
    CGFloat duration = CMTimeGetSeconds(video.duration);
    if (duration < kMaxVideoDuration) {
        self.imageCount = kDefaultImageCount;
    }else{
        self.imageCount = ceil(duration/(kMaxVideoDuration/kDefaultImageCount));
    }
    self.cellHeight = self.tableWidth / kDefaultImageCount;
    return self.imageCount;
}

- (void)setImageCount:(NSInteger)count{
    if (count <= 0) {
        return;
    }
    _imageCount = count;
//    self.layout.itemSize = CGSizeMake(self.tableWidth / kDefaultImageCount,  self.tableWidth);
//    self.cellHeight = self.tableWidth / 34;
    [self.collectionView reloadData];
}

- (NSUInteger)getCurrentIndex{
    if (self.currentCount == self.imageCount - 1) {
        return -1;
    }
    return self.currentCount;
}

- (void)reloadImageWithCount:(NSInteger)count
{
    self.currentCount = count;
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:count inSection:0]]];
}

- (NSString *)getMiddleText{
    float time = self.rightValue - self.leftValue;
    NSString *timeString = [NSString stringWithFormat:@"%.1fs",time];
    return timeString;
}

- (NSString *)getTextFromeFloat:(float)time{
    NSInteger minute = time/60;
    CGFloat second = time - minute*60;
    return [NSString stringWithFormat:@"%.1fs",second];
}

- (void)setLabelText
{
    self.leftValue = (self.collectionView.contentOffset.y + self.leftTrimView.centerX - self.collectionView.left)/self.secondOffset;
    self.leftBeginLabel.text = [self getTextFromeFloat:self.leftValue];
    self.rightValue = (self.collectionView.contentOffset.y + self.rightTrimView.centerX - self.collectionView.left)/self.secondOffset;

    CGFloat duration = self.rightValue - self.leftValue;
    UIColor *rightEndLabelColor = (fabs(duration - kMinVideoDuration) < 0.01 || fabs(duration - kMaxVideoDuration) < 0.01) ? [UIColor colorWithRGB:0xff2f60] : [UIColor whiteColor];
    self.rightEndLabel.text = [self getTextFromeFloat:duration];
    self.rightEndLabel.textColor = rightEndLabelColor;
    [self setMiddleMaskValue];
}

- (void)setLeftLabelText{
    self.leftValue = (self.collectionView.contentOffset.y + self.leftTrimView.centerX - self.collectionView.left)/self.secondOffset;
    self.leftBeginLabel.text = [self getTextFromeFloat:self.leftValue];
    [self setMiddleMaskValue];
}

- (void)setMiddleMaskValue{
    self.maskImageView.left = self.leftTrimView.centerX - 2;
    self.maskImageView.width = self.rightTrimView.centerX - self.leftTrimView.centerX + 4;
    self.rightEndLabel.frame = self.maskImageView.bounds;
}

- (CGFloat)maskWidth:(CGFloat)centerX left:(BOOL)left
{
    if (left) {
        return self.rightTrimView.centerX - centerX + 4;
    }
    return centerX - self.leftTrimView.centerX + 4;
}

- (void)setRightLabelText{
    self.rightValue = (self.collectionView.contentOffset.y + self.rightTrimView.centerX - self.collectionView.left)/self.secondOffset;
    self.rightEndLabel.text = [self getTextFromeFloat:self.rightValue];
    [self setMiddleMaskValue];
}

- (void)handleDelegate{
    if (self.delegate && [self.delegate respondsToSelector:@selector(trimControlDidChangeLeftValue:rightValue:)]) {
        [self.delegate trimControlDidChangeLeftValue:self.leftValue rightValue:self.rightValue];
    }
}

- (void)startPlayIndicateBarAnimationWithStartTime:(CGFloat)startTime
{
    [self.playIndicateBar.layer removeAllAnimations];
    CGFloat animationDuration = self.rightValue - startTime;
    CGFloat animationOriginX = 10 + (self.maskImageView.width - 20) * (startTime - self.leftValue)/(self.rightValue - self.leftValue);
    [self.playIndicateBar setLeft:animationOriginX];
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.playIndicateBar setLeft:self.maskImageView.width - 10];
    } completion:nil];
}

- (void)stopPlayIndicateBarAnimation
{
    [self.playIndicateBar.layer removeAllAnimations];
}

#pragma mark - gesture
- (void)handleLeftPan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self];
        CGFloat leftCenterX = self.leftTrimView.centerX;
        if (self.leftTrimView.centerX > self.collectionView.left || (self.leftTrimView.centerX <= self.collectionView.left && translation.x > 0.0)) {
            if ((self.leftValue >= self.rightValue - kMinVideoDuration && translation.x < 0.0) || self.leftValue < self.rightValue - kMinVideoDuration) {
                if (self.leftTrimView.centerX + translation.x < self.collectionView.left) {
                    leftCenterX = self.collectionView.left;
                }else if (self.leftTrimView.centerX + translation.x > self.rightTrimView.centerX - kMinVideoDuration*self.secondOffset){
                    leftCenterX = self.rightTrimView.centerX - kMinVideoDuration*self.secondOffset;
                }else{
                    leftCenterX += translation.x;
                }
                if ([self maskWidth:leftCenterX left:YES] <= self.maxWidth) {
                    self.leftTrimView.centerX = leftCenterX;
                    [self setLabelText];
                }
            }
        }else{
            if ([self maskWidth:leftCenterX left:YES] <= self.maxWidth) {
                self.leftTrimView.centerX = leftCenterX;
                [self setLabelText];
            }
        }
        [gesture setTranslation:CGPointZero inView:self];
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        [self handleDelegate];
        [gesture setTranslation:CGPointZero inView:self];
    }
}

- (void)handleRightPan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self];
        CGFloat rightCenterX = self.rightTrimView.centerX;
        if (self.rightTrimView.centerX < self.collectionView.right || (self.rightTrimView.centerX >= self.collectionView.right && translation.x < 0.0)) {
            if((self.rightValue <= self.leftValue + kMinVideoDuration && translation.x > 0.0) || self.rightValue > self.leftValue + kMinVideoDuration){
                if (self.rightTrimView.centerX + translation.x > self.collectionView.right) {
                    rightCenterX = self.collectionView.right;
                }else if (self.rightTrimView.centerX + translation.x < self.leftTrimView.centerX + kMinVideoDuration*self.secondOffset){
                    rightCenterX = self.leftTrimView.centerX + kMinVideoDuration*self.secondOffset;
                }else{
                    rightCenterX += translation.x;
                }
                if ([self maskWidth:rightCenterX left:NO] <= self.maxWidth) {
                    self.rightTrimView.centerX = rightCenterX;
                    [self setLabelText];
                }
            }
        }else{
            if ([self maskWidth:rightCenterX left:NO] <= self.maxWidth) {
                self.rightTrimView.centerX = rightCenterX;
                [self setLabelText];
            }
        }
        [gesture setTranslation:CGPointZero inView:self];
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        [self handleDelegate];
        [gesture setTranslation:CGPointZero inView:self];
    }
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self setLabelText];
    [self handleDelegate];
}

#pragma mark - UICollection datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DRMEVideoTrimTableViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithUTF8String:class_getName([DRMEVideoTrimTableViewCell class])] forIndexPath:indexPath];
    if (indexPath.row < self.imageCount) {
        [((DRMEVideoTrimTableViewCell *)cell) setImageWithCount:indexPath.row
                                          imagePath:self.imagePath
                                        imageHeight:self.cellHeight];
    }
    return cell;
}
@end
