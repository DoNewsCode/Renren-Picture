//
//  DRMEVideoTrimTableViewCell.m
//  Renren-EditImage
//
//  Created by Madjensen on 2019/11/13.
//

#import "DRMEVideoTrimTableViewCell.h"

@implementation DRMEVideoTrimTableViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
     if (self) {
            // Initialization code
            self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    //        self.backgroundImageView.contentMode = UIViewContentModeCenter;
            self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.contentView addSubview:self.backgroundImageView];
            self.backgroundColor = [UIColor clearColor];
        }
        return self;
}

- (void)setImageWithCount:(NSInteger)count imagePath:(NSString *)savePath imageHeight:(CGFloat)height{
    NSString *imagePath = [NSString stringWithFormat:@"%@/IMG%ld.jpg",savePath,(long)count];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    self.backgroundImageView.image = image;
}

@end
