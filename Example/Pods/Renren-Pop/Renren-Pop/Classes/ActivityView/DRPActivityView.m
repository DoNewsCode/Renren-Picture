//
//  DRPActivityView.m
//  Pods
//

#import "DRPActivityView.h"
#import "UIImage+Pop.h"
#import <YYCategories/YYCategories.h>

typedef void(^HandlerBlock)(void);
typedef void(^CloseBlock)(void);

@interface DRPActivityView()

@property(nonatomic,copy) CloseBlock closeBlock;
@property(nonatomic,copy) HandlerBlock handlerBlock;

@end

@implementation DRPActivityView


- (instancetype)initWithWithImage:(UIImage *)image
                     handlerBlock:(void(^)(void))handlerBlock
                       closeBlock:(void(^)(void))closeBlock
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, kScreenWidth - 37*2, 0);
        
        self.closeBlock = closeBlock;
        self.handlerBlock = handlerBlock;
        
        // 搞一个合适的图片比例
        CGFloat imageW = image.size.width;
        CGFloat imageH = image.size.height;
        
        CGFloat scale = imageH / imageW;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width * scale)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        imageView.centerX = self.centerX;
        imageView.image = image;
        [self addSubview:imageView];
        
        imageView.layer.cornerRadius = 15;
        imageView.layer.masksToBounds = YES;
        
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)]];
        
        UIButton *afterCerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, imageView.bottom + 23, 44, 44)];
        afterCerBtn.centerX = self.centerX;
        [afterCerBtn setImage:[UIImage pop_imageWithName:@"pop_activity_close"] forState:UIControlStateNormal];
        [afterCerBtn addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:afterCerBtn];
        
        self.height = CGRectGetMaxY(afterCerBtn.frame);
    }
    return self;
}

- (void)clickImage
{
    if (self.handlerBlock) {
        self.handlerBlock();
    }
}

- (void)clickClose
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

@end
