//
//  DRMEFilterIntensityView.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2020/3/16.
//

#import "DRMEFilterIntensityView.h"

@interface DRMEFilterIntensityView ()

@property(nonatomic,weak) UILabel *filterNameLabel;
@property(nonatomic,weak) UILabel *valueLabel;

@end

@implementation DRMEFilterIntensityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    
    // 取消
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setImage:[UIImage me_imageWithName:@"me_cancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickCancelBtn)
        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];

    cancelBtn.sd_layout.leftSpaceToView(self, 10)
    .bottomSpaceToView(self, 28)
    .widthIs(44).heightIs(44);
    
    // 确定
    UIButton *sureBtn = [[UIButton alloc] init];
    [sureBtn setImage:[UIImage me_imageWithName:@"me_sure"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(clickSureBtn)
        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sureBtn];
    
    sureBtn.sd_layout.rightSpaceToView(self, 10)
    .bottomSpaceToView(self, 28)
    .widthIs(44).heightIs(44);
    
    
    // 滤镜名称
    UILabel *filterNameLabel = [[UILabel alloc] init];
    filterNameLabel.textColor = UIColor.whiteColor;
    filterNameLabel.font = kFontMediumSize(14);
    filterNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:filterNameLabel];
    self.filterNameLabel = filterNameLabel;
    
    filterNameLabel.sd_layout.leftSpaceToView(cancelBtn, 10)
    .bottomSpaceToView(self, 28)
    .rightSpaceToView(sureBtn, 10)
    .heightIs(44);
    
    //
    UIView *sliderBg = [[UIView alloc] init];
    [self addSubview:sliderBg];
    sliderBg.sd_layout.leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(self, 10)
    .bottomSpaceToView(cancelBtn, 0);
    
    UISlider *slider = [[UISlider alloc] init];
    // minimumValue  : 当值可以改变时，滑块可以滑动到最小位置的值，默认为0.0
    slider.minimumValue = 0.0;
    // maximumValue : 当值可以改变时，滑块可以滑动到最大位置的值，默认为1.0
    // 当前值，这个值是介于滑块的最大值和最小值之间的，如果没有设置边界值，默认为0-1；
//    slider.value = 50;
    [sliderBg addSubview:slider];
    self.slider = slider;
    
    // minimumTrackTintColor : 小于滑块当前值滑块条的颜色，默认为蓝色
    slider.minimumTrackTintColor = [UIColor whiteColor];
    // maximumTrackTintColor: 大于滑块当前值滑块条的颜色，默认为白色
    slider.maximumTrackTintColor = [UIColor colorWithHexString:@"#767676"];
    // thumbTintColor : 当前滑块的颜色，默认为白色
//    slider.thumbTintColor = [UIColor yellowColor];
    
    /// 事件监听
    [slider addTarget:self action:@selector(sliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];

    
    slider.sd_layout.leftSpaceToView(sliderBg, 30)
    .rightSpaceToView(sliderBg, 30)
    .centerYEqualToView(sliderBg)
    .heightIs(20);
    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.font = kFontRegularSize(13);
    valueLabel.textColor = UIColor.whiteColor;
    valueLabel.textAlignment = NSTextAlignmentCenter;
    [sliderBg addSubview:valueLabel];
    self.valueLabel = valueLabel;
    
    valueLabel.sd_layout.bottomSpaceToView(slider, 5)
    .centerXEqualToView(slider)
    .widthIs(50).heightIs(18);
    
    [valueLabel updateLayout];
}

- (void)setFilterName:(NSString *)filterName
{
    _filterName = filterName;
    
    self.filterNameLabel.text = filterName;
}

- (void)setCurrentIntensity:(CGFloat)currentIntensity
{
    CGFloat intensity = currentIntensity;
    _currentIntensity = intensity;
    self.slider.value = intensity;
    
    self.valueLabel.text = [NSString stringWithFormat:@"%ld", (NSInteger)(intensity / self.slider.maximumValue * 100)];
    
//    [self.valueLabel sizeToFit];
//    CGFloat ratioX = currentIntensity * 100;
//    self.valueLabel.left = ratioX;
}

#pragma mark - 事件
- (void)clickCancelBtn
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        if ([self.delegate respondsToSelector:@selector(filterSliderHideComplete:)]) {
            [self.delegate filterSliderHideComplete:self];
        }
    }];
}

- (void)clickSureBtn
{
    [self clickCancelBtn];
}

- (void)sliderValueDidChanged:(UISlider *)slider
{
    CGFloat value = slider.value;
    NSLog(@"slider = %f", value);
    if ([self.delegate respondsToSelector:@selector(filterSliderValueDidChanged:)]) {
        [self.delegate filterSliderValueDidChanged:value];
    }
    
    self.valueLabel.text = [NSString stringWithFormat:@"%ld", (NSInteger)(value / self.slider.maximumValue * 100)];
    // 展示 slider.value
    
//    [self.valueLabel sizeToFit];
//    CGFloat ratioX = value * 100;
//    self.valueLabel.left = ratioX;
}

@end
