//
//  DRPPickerView.m
//  Pods
//
//  Created by 李晓越 on 2019/7/22.
//

#import "DRPPickerView.h"
#import <YYCategories/YYCategories.h>

#define kPickerViewHeight 280
#define kButtonHeight 44

typedef void(^HandlerBlock)(NSInteger index, NSString *title);
typedef void(^CancelBlock)(void);

@interface DRPPickerView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *pickerView;
@property(nonatomic,strong) NSArray *listArray;

@property(nonatomic,copy) NSString *resultTitle;
@property(nonatomic,assign) NSInteger resultIndex;

@property(nonatomic,copy) HandlerBlock handlerBlock;
@property(nonatomic,copy) CancelBlock cancelBlock;

@end

@implementation DRPPickerView

- (UIPickerView *)pickerView {
    
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kPickerViewHeight - kButtonHeight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.tintColor = [UIColor greenColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (instancetype)initWithTitle:(NSString *)title
                  cancelTitle:(NSString *)cancelTitle
                    doneTitle:(NSString *)doneTitle
                    listArray:(NSArray *)listArray
                 handlerBlock:(void (^)(NSInteger index, NSString *title))handlerBlock
                  cancelBlock:(void (^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, kScreenWidth, kPickerViewHeight);
        self.listArray = listArray;
        self.handlerBlock = handlerBlock;
        self.cancelBlock = cancelBlock;
        
        self.resultIndex = 0;
        NSString *title = listArray.firstObject;
        self.resultTitle = title;
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, kButtonHeight, kButtonHeight)];
        [cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#4D8AF6"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        
        UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, kButtonHeight, kButtonHeight)];
        doneBtn.right = self.width - 20;
        [doneBtn setTitle:doneTitle forState:UIControlStateNormal];
        [doneBtn setTitleColor:[UIColor colorWithHexString:@"#4D8AF6"] forState:UIControlStateNormal];
        doneBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [doneBtn addTarget:self action:@selector(clickDoneBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:doneBtn];
        
        [self addSubview:self.pickerView];
        
        
    }
    return self;
}

#pragma mark - 事件
- (void)clickCancelBtn
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)clickDoneBtn
{
    if (self.handlerBlock) {
        self.handlerBlock(self.resultIndex, self.resultTitle);
    }
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.listArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 34;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    //设置分割线的颜色
    for (UIView *singleLine in pickerView.subviews) {
        if (singleLine.height < 1) {
            singleLine.backgroundColor = [UIColor blackColor];
        }
    }
    
    NSString *title = self.listArray[row];
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    label.textColor = [UIColor colorWithHexString:@"#020202"];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *title = self.listArray[row];
    self.resultIndex = row;
    self.resultTitle = title;
}

@end
