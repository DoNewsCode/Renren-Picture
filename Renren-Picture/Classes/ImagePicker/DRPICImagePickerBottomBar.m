//
//  DRPICImagePickerBottomBar.m
//  Renren-Picture
//
//  Created by Luis on 2020/3/5.
//

#import "DRPICImagePickerBottomBar.h"
#import "DNBaseMacro.h"

@implementation DRPICImagePickerBottomBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height);
        [self addSubview:effectview];

        [self setup];
    }
    return self;
}
- (void)setup{
    [self addSubview:self.previewBtn];
    [self addSubview:self.nextBtn];
    self.previewBtn.frame = CGRectMake(20, 30, 50, 20);
    self.nextBtn.frame = CGRectMake(SCREEN_WIDTH - 60 - 20, 30, 60, 20);
}
- (UIButton *)previewBtn{
    if (!_previewBtn) {
        _previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        _previewBtn.backgroundColor = [UIColor redColor];
        [_previewBtn addTarget:self action:@selector(previewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previewBtn;
}
- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _nextBtn.backgroundColor = [UIColor redColor];
    }
    return _nextBtn;
}
- (void)previewBtnAction:(UIButton *)sender{
    if (self.previewBtnClickBlock) {
        self.previewBtnClickBlock(sender);
    }
}
- (void)nextBtnAction:(UIButton *)sender{
    if (self.nextBtnClickBlock) {
        self.nextBtnClickBlock(sender);
    }
}
@end
