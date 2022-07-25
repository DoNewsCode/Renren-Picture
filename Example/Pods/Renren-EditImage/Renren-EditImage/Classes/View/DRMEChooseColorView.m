//
//  DRMEChooseColorView.m
//  Renren-EditImage
//
//  Created by 李晓越 on 2019/11/4.
//

#import "DRMEChooseColorView.h"

@interface DRMEChooseColorView ()

@property(nonatomic,strong) NSArray *colorArray;

@property(nonatomic,weak) UIScrollView *scrollView;
/// 当前选择的颜色按钮
@property(nonatomic,weak) UIButton *currentColorBtn;

@end

@implementation DRMEChooseColorView

- (NSArray *)colorArray
{
    if (!_colorArray) {
        _colorArray = @[@"#FFFFFF",
                        @"#000000",
                        @"#FF0000",
                        @"#FF6400",
                        @"#00B7FF",
                        @"#00FFB2",
                        @"#FFD600"
        ];
    }
    return _colorArray;
}

- (instancetype)initWithIsSelectedT:(BOOL)isSelectedT
                   selectedColorStr:(NSString *)selectedColorStr;
{
    self = [super init];
    
    if (self) {
        
        // T 控制文字背景色按钮
        UIButton *TBtn = [[UIButton alloc] init];
        [TBtn setImage:[UIImage me_imageWithName:@"me_t_normal"]
              forState:UIControlStateNormal];
        [TBtn setImage:[UIImage me_imageWithName:@"me_t_selected"]
              forState:UIControlStateSelected];
        [TBtn addTarget:self action:@selector(clickTBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:TBtn];
        
        TBtn.sd_layout.leftSpaceToView(self, 22)
        .topEqualToView(self)
        .widthIs(28).heightIs(28);
        
        TBtn.selected = isSelectedT;
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        scrollView.sd_layout.leftSpaceToView(TBtn, 22)
        .topEqualToView(self)
        .rightEqualToView(self)
        .heightIs(28);
        
        CGFloat margin = 22;
        CGFloat colorW = 22;
        CGFloat colorH = 22;
        CGFloat border = 3;
        for (NSInteger i = 0;  i < self.colorArray.count; ++i) {
            
            NSString *colorStr = self.colorArray[i];
            UIColor *color = [UIColor colorWithHexString:colorStr];
            UIButton *colorBtn = [[UIButton alloc] init];
            colorBtn.backgroundColor = color;
            colorBtn.tag = 100 + i;
            [colorBtn addTarget:self action:@selector(clickColorBtn:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:colorBtn];
            colorBtn.layer.cornerRadius = colorW/2;
            
            CGFloat colorBtnX = i * colorW + i * margin;
            colorBtn.sd_layout.leftSpaceToView(scrollView, colorBtnX)
            .topSpaceToView(scrollView, 3)
            .widthIs(colorW).heightIs(colorH);
            
            
            /// 多增加了一个间距
            scrollView.contentSize = CGSizeMake(colorBtnX + colorW + margin, 28);
            
            
            if ([selectedColorStr isNotBlank] &&
                [selectedColorStr isEqualToString:colorStr]) {
                
                // 选中对应的颜色按钮
                CGFloat colorWH = colorW + border * 2;
                colorBtn.layer.borderWidth = border;
                colorBtn.layer.borderColor = [UIColor colorWithHexString:@"#C1C1C1"].CGColor;
                colorBtn.layer.cornerRadius = colorWH/2;
                colorBtn.sd_layout.topSpaceToView(scrollView, 0)
                .widthIs(colorWH).heightIs(colorWH);
                
                self.currentColorBtn = colorBtn;
                
            }
            
//            if (i == 0) {
//                CGFloat colorWH = colorW + border * 2;
//                colorBtn.layer.borderWidth = border;
//                colorBtn.layer.borderColor = [UIColor colorWithHexString:@"#C1C1C1"].CGColor;
//                colorBtn.layer.cornerRadius = colorWH/2;
//                colorBtn.sd_layout.topSpaceToView(scrollView, 0)
//                .widthIs(colorWH).heightIs(colorWH);
//
//                self.currentColorBtn = colorBtn;
//            }
            
        }
    }
    return self;
}

#pragma mark - 事件
- (void)clickTBtn:(UIButton *)TBtn
{
    TBtn.selected = !TBtn.isSelected;
    
    if (self.chooseBackColorBlock) {
        self.chooseBackColorBlock(TBtn.isSelected);
    }
}

- (void)clickColorBtn:(UIButton *)btn
{
    
    if (self.currentColorBtn == btn) {
        return;
    }
    
    NSInteger tag = btn.tag - 100;
    NSString *colorStr = self.colorArray[tag];
    
    self.currentColorBtn.sd_layout.topSpaceToView(self.scrollView, 3)
    .widthIs(22).heightIs(22);
    
    self.currentColorBtn.layer.borderWidth = 0;
    self.currentColorBtn.layer.cornerRadius = 22/2;
    
    self.currentColorBtn = btn;
    self.currentColorBtn.sd_layout.topSpaceToView(self.scrollView, 0)
    .widthIs(28).heightIs(28);
    
    self.currentColorBtn.layer.borderWidth = 3;
    self.currentColorBtn.layer.borderColor = [UIColor colorWithHexString:@"#C1C1C1"].CGColor;
    self.currentColorBtn.layer.cornerRadius = 28/2;

    if (self.chooseColorBlock) {
        self.chooseColorBlock(colorStr);
    }
}

- (void)dealloc
{
    NSLog(@"----- 选择颜色的工具条销毁咯");
}

@end
