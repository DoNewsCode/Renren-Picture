

#import "UIImage+Pop.h"
#import "DRPPop.h"

@implementation UIImage (DNExtension)

+ (instancetype)pop_imageWithName:(NSString *)name
{
    // 获取 NSBundle 真实路径
    NSBundle *curB = [NSBundle bundleForClass:[DRPPop class]];
    NSURL *url = [curB URLForResource:@"Renren-Pop" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    
    UIImage *image = [self imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    
    if (!image) {
        image = [UIImage imageNamed:name];
    }
    
    return image;
}


@end
