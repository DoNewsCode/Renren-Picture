//
//  DNPopItem.m
//  DNPop
//
//  Created by 陈金铭 on 2019/7/3.
//

#import "DNPopItem.h"

@interface DNPopItem ()

@property (nonatomic, strong) NSArray<UIButton *> *buttons;

@end

@implementation DNPopItem
#pragma mark - Override Methods
- (instancetype)initWithFrame:(CGRect)frame
{
    CGRect windowFrame = [UIScreen mainScreen].bounds;
    CGRect currentFrame = (CGRect){0.,0.,windowFrame.size.width - 30.,50.};
    self = [super initWithFrame:currentFrame];
    if (self) {
        [self createContent];
    }
    return self;
}

#pragma mark - Intial Methods

#pragma mark - Event Methods
- (void)eventBackgrondClick:(id)sender{
    if (self.handler) {
        self.handler();
    }
}

#pragma mark - Public Methods
- (void)returnHandler:(void (^ __nullable)(void))handler {
    self.handler = handler;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eventBackgrondClick:)];
    [self addGestureRecognizer:tapGesture];
}

#pragma mark - Private Methods
- (void)createContent {
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark - Setter
- (void)setTitle:(NSString *)title {
    _title = title;
    if (title) {
        self.titleLabel.text = title;
        [self addSubview:self.titleLabel];
        self.titleLabel.frame = self.frame;
    }
}

#pragma mark - Getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:16.];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.userInteractionEnabled = YES;
        titleLabel.numberOfLines = 0;
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

#pragma mark - NSCopying

#pragma mark - NSObject  Methods

@end
